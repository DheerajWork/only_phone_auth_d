import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_phone_auth_d/phone_auth/home_screen.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key, this.phone}) : super(key: key);

  final String? phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey _scaffoldKey = GlobalKey();
  final _codeController = TextEditingController();

  otpFunc() async {
    print("000000000000");
    try {
      await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: _verificationCode, smsCode: _codeController.text)).then((value) async {
        if (value.user != null) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
          print("Go To HomeScreen");
        }
      });
    } catch (e) {
      FocusScope.of(context).unfocus();
      // _scaffoldKey.currentState!.showSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong OTP")));
    }
  }

  late String _verificationCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(widget.phone.toString()),
            TextFormField(
              controller: _codeController,
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  print(widget.phone);
                  _verifyPhone(widget.phone);
                },
                child: const Text("Resend")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                  otpFunc();
                  setState(() {});
                },
                child: const Text("Verify OTP"))
          ],
        ),
      ),
    );
  }

  _verifyPhone(phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              print("User Login..............");
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          print("-------------------");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationCode = verificationId;
          });
          print("*******************************");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationCode = verificationId;
          });
          print(".........................");
        },
        timeout: const Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone(widget.phone);
  }
}
