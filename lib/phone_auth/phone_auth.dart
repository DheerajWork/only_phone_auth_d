import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:only_phone_auth_d/Global.dart';
import 'package:only_phone_auth_d/phone_auth/home_screen.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  String? phoneNo, _verificationId;

  Future<void> loginUser(String phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        Navigator.of(context).pop();

        UserCredential result = await auth.signInWithCredential(credential);

        var user = result.user;

        if (user != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          print("Error");
        }
      },
      verificationFailed: (FirebaseAuthException exception) {
        print(exception);
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Give the code"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _codeController,
                    )
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        print("111111111111111111");
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _codeController.text);
                        UserCredential user = await auth.signInWithCredential(credential);
                        Global.uid = user.user!.uid;

                        print(user.user!.uid);

                        if (user.user != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                        }

                        _verificationId = verificationId;
                        print("00000000000000000000000");
                      },
                      child: const Text("Confirm"))
                ],
              );
            },
            barrierDismissible: false);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("verification code: $verificationId");
        _verificationId = verificationId;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: () {
                  loginUser(_phoneController.text);
                  print("SEND");
                  print(_phoneController.text);
                },
                child: const Text("Send"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
