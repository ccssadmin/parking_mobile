import "package:flutter/material.dart";
import "package:par/homes/home_page.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:par/screens/login_screen.dart";
// Import your home screen

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // Check login state before navigating
    Future.delayed(const Duration(seconds: 2), () {
      _checkLoginState();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Check login state and navigate accordingly
  Future<void> _checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? ParkingHomePage() : const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(187, 221, 236, 1),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Semantics(
            button: true,
            label: 'Tap to proceed',
            child: GestureDetector(
              onTap: _checkLoginState, // Navigate based on login state
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Parking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
