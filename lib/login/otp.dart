import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpTakerPage extends StatefulWidget {
  final String verificationId;

  OtpTakerPage({required this.verificationId});

  @override
  _OtpTakerPageState createState() => _OtpTakerPageState();
}

class _OtpTakerPageState extends State<OtpTakerPage> {
  void _showOtpDialog(String verificationCode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Verification Code"),
          content: Text('Code entered is $verificationCode'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'ConnectChat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                // Handle any validation logic as the code changes.
              },
              onSubmit: (String verificationCode) {
                _showOtpDialog(verificationCode);
              },

              textStyle: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // You can add additional button logic if needed.
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: Colors.blue,
                ),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
