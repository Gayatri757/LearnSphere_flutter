import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../../features/auth/ui/login_screen.dart';
import '../../services/api_service.dart';
import '../../services/theme_manager.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FlutterSecureStorage storage =
      const FlutterSecureStorage();

  String email = "";
  String role = "";
  String name = "";

  bool isLoading = true;

  bool subscriptionActive = false;

  String planName = "--";
  String expiryDate = "--";
  String subjects = "--";

  // =========================================
  // INIT
  // =========================================

  @override
  void initState() {
    super.initState();

    loadUser();
    fetchSubscription();
  }

  // =========================================
  // LOAD USER
  // =========================================

  Future<void> loadUser() async {
    final savedEmail = await storage.read(
      key: "email",
    );

    final savedRole = await storage.read(
      key: "role",
    );

    if (!mounted) return;

    setState(() {
      email = savedEmail ?? "";
      role = savedRole ?? "";

      if (email.isNotEmpty) {
        name = email.split("@").first;
      } else {
        name = "Student";
      }
    });
  }

  // =========================================
  // FETCH SUBSCRIPTION
  // =========================================

  // =========================================
// FETCH SUBSCRIPTION
// =========================================

Future<void> fetchSubscription() async {
  try {
    final response = await ApiService.authenticatedGet(
      "/subscription-status",
    );

    debugPrint(
      "SUBSCRIPTION STATUS: ${response.statusCode}",
    );

    debugPrint(
      "SUBSCRIPTION RESPONSE: ${response.body}",
    );

    if (response.statusCode != 200) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      return;
    }

    final data = jsonDecode(response.body);

    if (!mounted) return;

    setState(() {
      subscriptionActive =
          data["active"] == true;

      planName =
          data["plan_name"]?.toString() ?? "--";

      subjects =
          data["subjects"]?.toString() ?? "--";

      if (data["expiry_date"] != null) {
        expiryDate = formatDate(
          data["expiry_date"].toString(),
        );
      } else {
        expiryDate = "--";
      }

      isLoading = false;
    });
  } catch (e) {
    debugPrint(
      "SUBSCRIPTION ERROR: $e",
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }
}

  // =========================================
  // FORMAT DATE
  // =========================================

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);

      return "${parsedDate.day.toString().padLeft(2, '0')}/"
          "${parsedDate.month.toString().padLeft(2, '0')}/"
          "${parsedDate.year}";
    } catch (e) {
      return date;
    }
  }

  // =========================================
  // LOGOUT
  // =========================================

  Future<void> logout() async {
    await ApiService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // =========================================
  // THEME TILE
  // =========================================

  Widget buildThemeTile() {
    final themeManager =
        ThemeManager.instance;

    return Card(
      color: Theme.of(context).cardColor,

      margin: const EdgeInsets.only(
        bottom: 14,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: ListTile(
        leading: Icon(
          themeManager.isDark
              ? Icons.dark_mode
              : Icons.light_mode,
          color: Colors.blue,
        ),

        title: Text(
          themeManager.isDark
              ? "Dark Mode"
              : "Light Mode",

          style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.color,

            fontWeight:
                FontWeight.w500,
          ),
        ),

        trailing: Switch(
          value: themeManager.isDark,

          activeThumbColor:
              Colors.blue,

          onChanged: (value) async {
            await themeManager.toggleTheme();
          },
        ),
      ),
    );
  }

  // =========================================
  // BUILD
  // =========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,

      // =======================================
      // APP BAR
      // =======================================

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: Text(
          "Profile",

          style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .titleLarge
                ?.color,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      // =======================================
      // BODY
      // =======================================

      body: RefreshIndicator(
        onRefresh:
            fetchSubscription,

        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),

          padding:
              const EdgeInsets.all(20),

          child: Column(
            children: [

              // =================================
              // PROFILE CARD
              // =================================

              Container(
                width:
                    double.infinity,

                padding:
                    const EdgeInsets.all(24),

                decoration:
                    BoxDecoration(
                  color:
                      Theme.of(context)
                          .cardColor,

                  borderRadius:
                      BorderRadius.circular(
                    25,
                  ),
                ),

                child: Column(
                  children: [

                    // PROFILE ICON

                    const CircleAvatar(
                      radius: 45,

                      backgroundColor:
                          Color(0xFF1565C0),

                      child: Icon(
                        Icons.person,

                        size: 50,

                        color:
                            Colors.white,
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    // NAME

                    Text(
                      name,

                      style: TextStyle(
                        color:
                            Theme.of(
                          context,
                        )
                                .textTheme
                                .headlineSmall
                                ?.color,

                        fontSize: 22,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    // EMAIL

                    Text(
                      email,

                      style: TextStyle(
                        color:
                            Theme.of(
                          context,
                        )
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withValues(
                                  alpha: 0.7,
                                ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // ROLE

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.blue
                                .withValues(
                          alpha: 0.15,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(
                        role.toUpperCase(),

                        style:
                            const TextStyle(
                          color:
                              Colors.blue,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // =================================
              // PREMIUM SUBSCRIPTION
              // =================================

              Container(
                width:
                    double.infinity,

                padding:
                    const EdgeInsets.all(20),

                decoration:
                    BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),

                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),

                child: isLoading

                    ? const Center(
                        child: Padding(
                          padding:
                              EdgeInsets.all(
                            20,
                          ),

                          child:
                              CircularProgressIndicator(
                            color:
                                Colors.white,
                          ),
                        ),
                      )

                    : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          // SUBSCRIPTION TITLE

                          Row(
                            children: [

                              const Icon(
                                Icons
                                    .workspace_premium,

                                color:
                                    Colors.amber,

                                size: 28,
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              const Text(
                                "Premium Subscription",

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight.bold,

                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // STATUS

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              const Text(
                                "Status",

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      subscriptionActive
                                          ? Colors.green
                                              .withValues(
                                              alpha: 0.2,
                                            )
                                          : Colors.red
                                              .withValues(
                                              alpha: 0.2,
                                            ),

                                  borderRadius:
                                      BorderRadius.circular(
                                    15,
                                  ),
                                ),

                                child: Text(
                                  subscriptionActive
                                      ? "ACTIVE"
                                      : "INACTIVE",

                                  style:
                                      TextStyle(
                                    color:
                                        subscriptionActive
                                            ? Colors.greenAccent
                                            : Colors.redAccent,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          // PLAN

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              const Text(
                                "Plan",

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),

                              Flexible(
                                child: Text(
                                  planName,

                                  textAlign:
                                      TextAlign.right,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          // EXPIRY

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              const Text(
                                "Expiry",

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),

                              Text(
                                expiryDate,

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          // SUBJECTS

                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              const Text(
                                "Subjects",

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),

                              const SizedBox(
                                width: 20,
                              ),

                              Expanded(
                                child: Text(
                                  subjects,

                                  textAlign:
                                      TextAlign.right,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),

              const SizedBox(
                height: 25,
              ),

              // =================================
              // THEME
              // =================================

              buildThemeTile(),

              // =================================
              // OTHER SETTINGS
              // =================================

              buildTile(
                Icons.lock_reset,
                "Forgot Password",
              ),

              buildTile(
                Icons.privacy_tip,
                "Privacy Policy",
              ),

              buildTile(
                Icons.info_outline,
                "About App",
              ),

              buildTile(
                Icons.logout,
                "Logout",
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================
  // PROFILE TILE
  // =========================================

  Widget buildTile(
    IconData icon,
    String title, {
    bool isLogout = false,
  }) {
    final textColor =
        Theme.of(context)
            .textTheme
            .bodyLarge
            ?.color;

    final secondaryColor =
        Theme.of(context)
            .textTheme
            .bodyMedium
            ?.color
            ?.withValues(
              alpha: 0.5,
            );

    return Card(
      color:
          Theme.of(context).cardColor,

      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: ListTile(
        leading: Icon(
          icon,

          color: isLogout
              ? Colors.red
              : Colors.blue,
        ),

        title: Text(
          title,

          style: TextStyle(
            color: isLogout
                ? Colors.red
                : textColor,

            fontWeight:
                FontWeight.w500,
          ),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios,

          color:
              secondaryColor,

          size: 16,
        ),

        onTap: () async {

          // =================================
          // LOGOUT
          // =================================

          if (title == "Logout") {

            final confirm =
                await showDialog<bool>(
              context: context,

              builder:
                  (dialogContext) =>
                      AlertDialog(

                title:
                    const Text(
                  "Logout",
                ),

                content:
                    const Text(
                  "Are you sure you want to logout?",
                ),

                actions: [

                  TextButton(
                    onPressed: () =>
                        Navigator.pop(
                      dialogContext,
                      false,
                    ),

                    child:
                        const Text(
                      "Cancel",
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pop(
                      dialogContext,
                      true,
                    ),

                    child:
                        const Text(
                      "Logout",
                    ),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await logout();
            }
          }
        },
      ),
    );
  }
}