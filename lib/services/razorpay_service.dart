import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'api_service.dart';

class RazorpayService {
  late Razorpay _razorpay;

  // =========================================
  // INIT RAZORPAY
  // =========================================

  void initRazorpay({
    required Function(
      PaymentSuccessResponse,
    ) onSuccess,
    required Function(
      PaymentFailureResponse,
    ) onFailure,
    required Function(
      ExternalWalletResponse,
    ) onExternalWallet,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      onSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      onFailure,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      onExternalWallet,
    );
  }

  // =========================================
  // OPEN CHECKOUT
  // =========================================

  Future<void> openCheckout({
    required int amount,
    required String name,
    required String description,
    required int planId,
    required String token,
    required String email,
    required String contact,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${ApiService.baseUrl}/create-order",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "amount": amount,
          "plan_id": planId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(
          data["message"] ?? "Order creation failed",
        );
      }

      var options = {
        "key": "rzp_test_T8xN45A49XxhmQ",
        "amount": data["amount"],
        "name": name,
        "description": description,
        "order_id": data["order_id"],
        "prefill": {
          "contact": contact,
          "email": email,
        },
        "theme": {
          "color": "#42A5F5",
        },
      };

      _razorpay.open(options);
    } catch (e) {
      rethrow;
    }
  }

  // =========================================
  // DISPOSE
  // =========================================

  void dispose() {
    _razorpay.clear();
  }
}
