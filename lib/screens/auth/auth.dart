import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//widgets
import 'package:mothers_kitchen/widgets/decorations.dart';
import 'package:mothers_kitchen/widgets/validators.dart';

final _firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _firstTime = true;
  String _phoneNumber = '';
  String _countryCode = '+91';
  String? _authState = null;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    setState(() {
      _authState = 'Signing In...';
    });
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '${_countryCode + _phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          setState(() {
            _authState = "Signed In!!!";
          });
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _authState = "Error Occured!!!";
          });
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The provided phone number is not valid.'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something went wrong. Try again.'),
              ),
            );
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          String smsCode = '';
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Enter the OTP'),
              content: TextFormField(
                onChanged: (value) {
                  smsCode = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsCode);
                    await _firebaseAuth.signInWithCredential(credential);
                    setState(() {
                      _authState = "Signed In!!!";
                    });
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _authState = "Error Occured!!!";
      });
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password. Try again.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Add a sized box of size 20
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/startup_logo.png',
              width: 300,
            ),
            const SizedBox(height: 10),
            Text(
              'Mother\'s',
              style: GoogleFonts.neonderthaw(
                fontSize: 68,
                // fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            // const SizedBox(height: 10),
            Text(
              'Kitchen',
              style: GoogleFonts.neonderthaw(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            // const SizedBox(height: 40),
            _authState == null
                ? const SizedBox(height: 30)
                : SizedBox(
                    height: 30,
                    child: Center(
                      child: Text(
                        _authState!,
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextFormField(
                // obscureText: true,
                controller: _numberController,
                validator: (value) => Validators.validatePhoneNumber(
                    value: value, firstTime: _firstTime),
                onEditingComplete: () => (),
                // onChanged: (_) => _formKey.currentState!.validate(),
                onSaved: (newValue) {
                  setState(() {
                    _phoneNumber = newValue!;
                  });
                },
                keyboardType: TextInputType.phone,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                decoration: Decorations.textFieldDecoration(
                    context: context, labelText: 'Phone Number'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _firstTime = false;
                });
                _submit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Sign In'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/signin');
            //   },
            //   child: const Text('Sign In'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Theme.of(context).colorScheme.primary,
            //     foregroundColor: Theme.of(context).colorScheme.onPrimary,
            //     minimumSize: const Size(150, 50),
            //   ),
            // ),
            // const SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/signup');
            //   },
            //   child: const Text('Sign Up'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Theme.of(context).colorScheme.secondary,
            //     foregroundColor: Theme.of(context).colorScheme.onSecondary,
            //     minimumSize: const Size(150, 50),
            //   ),
            // ),
            // Expanded(
            //   flex: 2,
            //   child: Container(),
            // ),
          ],
        ),
      ),
    );
  }
}

/*
Fonts for chatterly: 
- italianno - 78
- neonderthaw - 58

*/