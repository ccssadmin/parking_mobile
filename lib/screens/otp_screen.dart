import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:par/homes/home_page.dart';
import 'package:par/server/login_back.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final GraphQLService graphQLService;

  const OtpScreen({
    required this.phoneNumber,
    required this.graphQLService,
    super.key,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());

  // Function to validate OTP
  bool _isValidOtp(String otp) {
    return otp.length == 6 && int.tryParse(otp) != null;
  }

  // Function to handle OTP input and move focus
  void _handleOtpInput(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
    }
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset(
                        'assets/images/bike.png',
                        fit: BoxFit.contain,
                        width: 600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Section - OTP Form
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
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 40,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _handleOtpInput(index, value);
                              } else if (value.isEmpty && index > 0) {
                                _handleOtpInput(index, value);
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // Verify OTP Button
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Combine OTP fields into a single string
                          String otp = _otpControllers
                              .map((controller) => controller.text)
                              .join();

                          // Validate the OTP
                          if (!_isValidOtp(otp)) {
                            _showTopSnackBar("Invalid OTP", Colors.red);
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
                            // Perform GraphQL mutation
                            QueryResult result = await widget.graphQLService
                                .verifyWebOtp(otp, widget.phoneNumber);

                            // Hide loading indicator
                            Navigator.pop(context);

                            if (result.hasException) {
                              // Handle GraphQL errors
                              String errorMessage =
                                  result.exception!.graphqlErrors.isNotEmpty
                                      ? result.exception!.graphqlErrors.first
                                          .message
                                      : "An error occurred. Please try again.";
                              _showTopSnackBar(errorMessage, Colors.red);
                            } else {
                              // ✅ Save login state
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('isLoggedIn', true);
                              await prefs.setString(
                                  'phoneNumber', widget.phoneNumber);

                              // ✅ Show success message
                              _showTopSnackBar(
                                  "OTP verified successfully!", Colors.green);

                              // ✅ Navigate to Home Screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ParkingHomePage(),
                                ),
                              );
                            }
                          } catch (e) {
                            // Hide loading indicator
                            Navigator.pop(context);

                            // Handle unexpected errors
                            _showTopSnackBar(
                                "Error: ${e.toString()}", Colors.red);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Verify OTP",
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
