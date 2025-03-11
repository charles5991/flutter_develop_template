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
  
  // Add validation error states
  String? _phoneError;
  String? _passwordError;

  Future<void> _handleLogin() async {
    // Reset previous errors
    setState(() {
      _phoneError = null;
      _passwordError = null;
    });

    // Validate fields
    bool isValid = true;

    if (_phoneController.text.isEmpty) {
      setState(() {
        _phoneError = 'Phone number is required';
      });
      isValid = false;
    } else if (_phoneController.text.length != 10) {
      setState(() {
        _phoneError = 'Please enter a valid 10-digit phone number';
      });
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      isValid = false;
    }

    if (!isValid) return;

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
              
              // Phone input with error
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _phoneError != null ? Colors.red : Colors.transparent,
                        width: 1,
                      ),
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
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            onChanged: (value) {
                              if (_phoneError != null) {
                                setState(() {
                                  _phoneError = null;
                                });
                              }
                            },
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
                  if (_phoneError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        _phoneError!,
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: _phoneError != null ? 8 : 16),
              
              // Password input with error
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _passwordError != null ? Colors.red : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      onChanged: (value) {
                        if (_passwordError != null) {
                          setState(() {
                            _passwordError = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter password',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        _passwordError!,
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: _passwordError != null ? 16 : 24),
              
              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6366F1), // Lighter purple color
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