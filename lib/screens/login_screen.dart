import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:par/screens/otp_screen.dart';
import 'package:par/server/login_back.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Function to validate phone number
  bool _isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.length == 10 && int.tryParse(phoneNumber) != null;
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Function to show SnackBar at the top
  void _showTopSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 110,
          left: 20,
          right: 20,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    final GraphQLService graphQLService = GraphQLService(client);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Top Section - Illustration
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: const Color.fromRGBO(187, 221, 236, 1),
                child: Center(
                  child: Image.asset(
                    'assets/images/bike.png',
                    fit: BoxFit.contain,
                    width: 600,
                  ),
                ),
              ),
            ),
            // Bottom Section - Login Form
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(
                      color: const Color.fromARGB(255, 159, 194, 247),
                      width: 3.0,
                    ),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Small Button (Placeholder)
                    SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Instruction Text
                    const Text(
                      "Find your spot, park with ease—your parking journey starts here",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Phone Number Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // OTP Button
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          String phoneNumber = _phoneController.text.trim();

                          // Validate phone number
                          if (!_isValidPhoneNumber(phoneNumber)) {
                            _showTopSnackBar(
                              "Please enter a valid 10-digit phone number",
                              Colors.red,
                            );
                            return;
                          }

                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          try {
                            // GraphQL call to register/login user
                            QueryResult result = await graphQLService
                                .registerOrLoginUser(phoneNumber);

                            // Hide loading indicator
                            Navigator.pop(context);

                            if (result.hasException) {
                              String errorMessage =
                                  "An error occurred. Please try again.";

                              if (result.exception!.graphqlErrors.isNotEmpty) {
                                errorMessage = result
                                    .exception!.graphqlErrors.first.message;
                              } else if (result.exception!.linkException !=
                                  null) {
                                errorMessage =
                                    "Network error. Please check your connection.";
                              }

                              _showErrorDialog(errorMessage);
                            } else {
                              // Save login state
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', true);

                              // Show success message
                              _showTopSnackBar("OTP sent!", Colors.green);

                              // Navigate to OTP screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpScreen(
                                    phoneNumber: phoneNumber,
                                    graphQLService: graphQLService,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            // Hide loading indicator
                            Navigator.pop(context);

                            _showErrorDialog(
                                "Something went wrong: ${e.toString()}");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Get OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
