import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../services/api_service.dart';
import '../../../services/razorpay_service.dart';

class PlansScreen extends StatefulWidget {
  final String userEmail;

  const PlansScreen({
    super.key,
    required this.userEmail,
  });

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final RazorpayService razorpayService = RazorpayService();

  List plans = [];

  bool isLoading = true;

  int? selectedPlanId;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    fetchPlans();

    razorpayService.initRazorpay(
      onSuccess: handlePaymentSuccess,
      onFailure: handlePaymentFailure,
      onExternalWallet: handleExternalWallet,
    );
  }

  // ============================================================
  // GET TOKEN
  // ============================================================

  Future<String?> getToken() async {
    final token = await storage.read(key: "token");

    debugPrint("========== PLANS TOKEN CHECK ==========");
    debugPrint("TOKEN EXISTS: ${token != null && token.isNotEmpty}");
    debugPrint("TOKEN: $token");
    debugPrint("EMAIL: ${await storage.read(key: "email")}");
    debugPrint("ROLE: ${await storage.read(key: "role")}");
    debugPrint("=======================================");

    return token;
  }

  // ============================================================
  // FETCH PLANS
  // ============================================================

  Future<void> fetchPlans() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiService.baseUrl}/get-plans",
        ),
      );

      debugPrint("GET PLANS STATUS: ${response.statusCode}");
      debugPrint("GET PLANS RESPONSE: ${response.body}");

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          plans = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("FETCH PLANS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ============================================================
  // PAYMENT SUCCESS
  // ============================================================

  Future<void> handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    try {
      debugPrint("========== PAYMENT SUCCESS ==========");
      debugPrint("ORDER ID: ${response.orderId}");
      debugPrint("PAYMENT ID: ${response.paymentId}");
      debugPrint("SIGNATURE: ${response.signature}");
      debugPrint("PLAN ID: $selectedPlanId");
      debugPrint("=====================================");

      final token = await getToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Session expired. Please login again.",
            ),
          ),
        );

        return;
      }

      final res = await http.post(
        Uri.parse(
          "${ApiService.baseUrl}/verify-payment",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "plan_id": selectedPlanId,
          "razorpay_order_id": response.orderId,
          "razorpay_payment_id": response.paymentId,
          "razorpay_signature": response.signature,
        }),
      );

      debugPrint("VERIFY PAYMENT STATUS: ${res.statusCode}");
      debugPrint("VERIFY PAYMENT RESPONSE: ${res.body}");

      if (!mounted) return;

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Subscription Activated!",
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"]?.toString() ??
                  "Payment verification failed.",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("PAYMENT SUCCESS ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Payment verification error: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // PAYMENT FAILURE
  // ============================================================

  void handlePaymentFailure(
    PaymentFailureResponse response,
  ) {
    debugPrint("========== PAYMENT FAILED ==========");
    debugPrint("CODE: ${response.code}");
    debugPrint("MESSAGE: ${response.message}");
    debugPrint("====================================");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Payment Failed\n${response.message}",
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  // ============================================================
  // EXTERNAL WALLET
  // ============================================================

  void handleExternalWallet(
    ExternalWalletResponse response,
  ) {
    debugPrint(
      "EXTERNAL WALLET: ${response.walletName}",
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "External Wallet: ${response.walletName}",
        ),
      ),
    );
  }

  // ============================================================
  // BUY PLAN
  // ============================================================

  Future<void> buyPlan(
    Map plan,
  ) async {
    try {
      selectedPlanId = plan["id"];

      debugPrint("========== BUY PLAN ==========");
      debugPrint("PLAN ID: ${plan["id"]}");
      debugPrint("PLAN NAME: ${plan["plan_name"]}");
      debugPrint("PRICE: ${plan["price"]}");
      debugPrint("USER EMAIL: ${widget.userEmail}");
      debugPrint("==============================");

      // IMPORTANT:
      // Read token from FlutterSecureStorage,
      // NOT SharedPreferences.
      final token = await getToken();

      if (token == null || token.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Session expired. Please login again.",
            ),
          ),
        );

        return;
      }

      await razorpayService.openCheckout(
        amount: plan["price"],
        name: plan["plan_name"],
        description: plan["description"],
        planId: plan["id"],
        token: token,
        email: widget.userEmail,
        contact: "9999999999",
      );
    } catch (e) {
      debugPrint("BUY PLAN ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    razorpayService.dispose();

    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Subscription Plans",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF42A5F5),
              ),
            )
          : plans.isEmpty
              ? const Center(
                  child: Text(
                    "No subscription plans available.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(
                              alpha: 0.08,
                            ),
                            Colors.white.withValues(
                              alpha: 0.03,
                            ),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.08,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          // PLAN NAME

                          Text(
                            plan["plan_name"]?.toString() ??
                                "Premium Plan",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // DESCRIPTION

                          Text(
                            plan["description"]?.toString() ??
                                "",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // SUBJECTS

                          Text(
                            "Subjects:\n${plan["subjects"]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // DURATION

                          Text(
                            "Duration: "
                            "${plan["duration_days"]} Days",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // PRICE

                          Text(
                            "₹ ${plan["price"]}",
                            style: const TextStyle(
                              color: Color(0xFF42A5F5),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // BUY BUTTON

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                buyPlan(plan);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF42A5F5),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "BUY NOW",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}