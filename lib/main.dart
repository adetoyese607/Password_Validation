import 'dart:async';

import 'package:flutter/material.dart';
import 'package:verification_code/verification_code.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  String _code = '';
  // ignore: unused_field
  late Timer _timer;
  int _start = 60;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  void verify() {
    setState(() {
      _isLoading = true;
    });
    const oneSec = Duration(milliseconds: 10000);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 190,
                height: 190,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                // decoration: ,
                child: Transform.rotate(
                  angle: 38,
                  child: Icon(
                    Icons.mark_email_read_rounded,
                    size: 200,
                    color: Colors.orange[300],
                  ),
                ),
              ),
              SizedBox(height: 60),
              Text(
                'Verification',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Text(
                'Please Enter the 6 digit code sent to \n 08154703668',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30),
              VerificationCode(
                maxLength: 6,
                // borderWidth: 1,
                borderColor: Colors.blueAccent,

                onCompleted: (value) {
                  setState(() {
                    _code = value;
                  });
                },
                onChanged: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t receive the OTP',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  // SizedBox(width: 2,),
                  TextButton(
                    onPressed: () {
                      if (_isResendAgain) return;
                      resend();
                    },
                    child: Text(
                      _isResendAgain
                          ? 'Try again in ' + _start.toString()
                          : 'Resend',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),

              MaterialButton(
                disabledColor: Colors.grey.shade300,
                onPressed: _code.length < 6
                    ? null
                    : () {
                        verify();
                      },
                color: Colors.black,
                minWidth: double.infinity,
                height: 50,
                child: _isLoading
                    ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black,
                          strokeWidth: 3,
                          color: Colors.white ,
                        ),
                      )
                    : _isVerified ? Icon(Icons.check_circle, color: Colors.white,size: 30,) : Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
