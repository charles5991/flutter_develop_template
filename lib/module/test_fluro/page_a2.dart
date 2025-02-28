import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/main/app.dart';

import '../../../../res/string/str_common.dart';
import '../../../../router/navigator_util.dart';

class PageA2View extends BaseStatefulPage {
  PageA2View({super.key, this.name, this.acc, this.upi});

  final String? name;
  final String? acc;
  final String? upi;

  @override
  PageA2ViewState createState() => PageA2ViewState();
}

class PageA2ViewState extends BaseStatefulPageState<PageA2View, PageA2ViewModel> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Tool',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Steps
                Row(
                  children: [
                    _buildStepCircle(1, true),
                    Expanded(child: Divider(color: Colors.grey[300])),
                    _buildStepCircle(2, false),
                    Expanded(child: Divider(color: Colors.grey[300])),
                    _buildStepCircle(3, false),
                  ],
                ),
                SizedBox(height: 8),
                // Step Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Phone', style: TextStyle(color: Colors.grey)),
                    Text('Authorize', style: TextStyle(color: Colors.grey)),
                    Text('Finish', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 32),
                // Title
                Text(
                  'Authorize ${widget.name}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Subtitle
                Text(
                  'Let us enjoy the work',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Enter your PhonePe number',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '2. Click the "Next" button to proceed',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 32),
                // Phone Input
                Text(
                  'Phone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          '+91',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintText: 'Enter phone number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.length < 10) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // PIN Input
                Text(
                  'Pin',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: 'Enter 4-digit PIN',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter PIN';
                      }
                      if (value.length < 4) {
                        return 'PIN must be 4 digits';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                Spacer(),
                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Navigate to OTP screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                              phoneNumber: phoneController.text,
                              name: widget.name ?? '',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[700],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(int step, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.indigo[700] : Colors.grey[300],
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  PageA2ViewModel viewBindingViewModel() {
    return PageA2ViewModel()..viewState = this;
  }
}

class PageA2ViewModel extends PageViewModel<PageA2ViewState> {

  @override
  onCreate() {

  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }
}

// Create new OTP Screen
class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;

  const OtpScreen({
    Key? key,
    required this.phoneNumber,
    required this.name,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  int _countdown = 60;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Tool',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Steps
              Row(
                children: [
                  _buildProgressLine(true),
                  _buildStepCircle(2, true),
                  _buildProgressLine(false),
                ],
              ),
              SizedBox(height: 8),
              // Step Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phone', style: TextStyle(color: Colors.grey)),
                  Text('Authorize', style: TextStyle(color: Colors.indigo[700])),
                  Text('Finish', style: TextStyle(color: Colors.grey)),
                ],
              ),
              SizedBox(height: 32),
              Text(
                'Please Enter Your OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. Please click the \'Send OTP\' button to receive your OTP.',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '2. We\'ve sent you a One-Time Password (OTP).',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Please check your messages and enter the OTP below to proceed. If you have any questions, we\'re here to help!',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '3. Click the \'Next\' button to proceed.',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 32),
              // Phone display with Send button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text('+91'),
                    ),
                    Text(widget.phoneNumber),
                    Spacer(),
                    TextButton(
                      onPressed: _canResend ? () {
                        setState(() {
                          _countdown = 60;
                          _canResend = false;
                        });
                        startTimer();
                      } : null,
                      child: Text(_canResend ? 'Send' : '$_countdown s'),
                    ),
                  ],
                ),
              ),
              
              // Add OTP Input field
              SizedBox(height: 24),
              Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: 'Enter 6-digit OTP',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),

              Spacer(),
              // Previous/Next buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text('Previous'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // In dev mode, allow any 6-digit OTP
                        if (otpController.text.length == 6) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SuccessScreen(
                                upiId: '${widget.phoneNumber}@ikwik',
                                name: widget.name,
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[700],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.indigo[700] : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepCircle(int step, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.indigo[700] : Colors.grey[300],
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  final String upiId;
  final String name;

  const SuccessScreen({
    Key? key,
    required this.upiId,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Tool',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Steps
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.indigo[700],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.indigo[700],
                    ),
                    child: Center(
                      child: Text(
                        "3",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Step Labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phone', style: TextStyle(color: Colors.grey)),
                  Text('Authorize', style: TextStyle(color: Colors.grey)),
                  Text('Finish', style: TextStyle(color: Colors.indigo[700])),
                ],
              ),
              SizedBox(height: 24),
              // Success Title
              Center(
                child: Text(
                  'You\'re Doing Great!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Success Icons
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Phone with checkmark
                    Container(
                      width: 120,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.indigo[700],
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Celebration icons
                    Container(
                      width: 120,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration,
                            size: 40,
                            color: Colors.indigo[700],
                          ),
                          SizedBox(height: 16),
                          Icon(
                            Icons.emoji_emotions,
                            size: 40,
                            color: Colors.indigo[700],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Instructions
              Text(
                '1. Please select your preferred UPI.',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'For added security, we suggest avoiding UPIs named after your mobile number.',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                '2. Just one more step! Click the \'Finish\' button to wrap up your addition.',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'You\'re all set!',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 16),
              // UPI ID Display
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  upiId,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              // Navigation Buttons
              Row(
                children: [
                  // Previous Button
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Finish Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[700],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
