import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/app_router.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isMounted = false;
  String errorMessage = "";
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Future signIn() async {
    Utilities.showLoadingIndicator(context);
    setState(() {
      errorMessage = "";
    });
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      Navigator.of(context).pop();
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      FirebaseAuth.instance.userChanges().listen((User? user) async {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get();

          if (documentSnapshot.exists) {
            Map<String, dynamic> userDetails =
                documentSnapshot.data() as Map<String, dynamic>;

            if (_isMounted) {
              if (userDetails['user_type'] == 'Customer') {
                AppRouter.initR = "/home";
                context.goNamed("Home");
              } else {
                AppRouter.initR = "/dashboard";
                context.goNamed("Dashboard");
              }
            }
          } else {
            Utilities.showSnackBar("User not in collection", Colors.red);
          }
        }
      });
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'INVALID_LOGIN_CREDENTIALS') {
        setState(() {
          errorMessage = "Invalid Login Credentials";
        });
      } else if (ex.code == 'too-many-requests') {
        setState(() {
          errorMessage = 'Too many login attempts. Try again later.';
        });
      } else {
        setState(() {
          errorMessage = 'Unexpected Error';
        });
      }
      print(ex.code);
      Utilities.showSnackBar(errorMessage, Colors.red);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: Image.asset("assets/images/logo.jpeg", width: 150),
              ),
              SizedBox(
                height: 64,
              ),
              Text(
                "Sign In to your Account",
                style: TextStyle(
                    fontSize: 24,
                    color: majorText,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              InputField(
                placeholder: "Email Address",
                inputType: 'email',
                label: 'Email Address',
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!EmailValidator.validate(value)) {
                    return 'Enter a valid email address';
                  }
                  return null; // Return null if validation succeeds
                },
              ),
              InputField(
                placeholder: "Password",
                inputType: "password",
                label: "Password",
                controller: _passwordController,
                validator: (value) => value != null && value.length < 8
                    ? 'Enter min. 8 characters'
                    : null,
              ),
              TextButton(
                onPressed: () {
                  context.goNamed("Forgot Password");
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                  ),
                ),
              ),
              InputButton(
                label: "LOGIN",
                function: () {
                  signIn();
                },
                large: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account yet?"),
                  TextButton(
                    onPressed: () {
                      context.goNamed("Signup");
                    },
                    child: Text("Create one here."),
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
