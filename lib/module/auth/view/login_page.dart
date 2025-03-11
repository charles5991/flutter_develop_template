import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // NOT 'package:shared_preferences.dart'
import 'package:flutter_develop_template/router/navigator_util.dart';
import 'package:flutter_develop_template/router/routers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_develop_template/module/auth/service/auth_service.dart';
import 'package:flutter_develop_template/module/auth/view/forgot_password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));
    
    if (_phoneController.text == '1234522112' && 
        _passwordController.text == '123456') {
      // Store login session
      await AuthService.login(_phoneController.text);
      
      // Check if user has seen onboarding
      bool hasSeenOnboarding = await AuthService.hasSeenOnboarding();
      
      if (!hasSeenOnboarding) {
        // First time login -> go to onboarding
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routers.onboarding,
          (route) => false,
        );
      } else {
        // Returning user -> go to main app
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routers.root,
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials'))
      );
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4338CA), // Deep purple color
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and app name
              Icon(
                Icons.account_balance_wallet,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'Umoney',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 48),
              
              // Phone input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '+91',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 8), // Space between prefix and input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your phone number',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          counterText: "",
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              // Password input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter password',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              
              // Forgot password
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                  'Forgot password',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 