import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  final String? Function(String?)? requiredValidator = (value) =>
      (value != null && value.length <= 0) ? 'This field is required' : null;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _barangayController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future signUp() async {
    Utilities.showLoadingIndicator(context);
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      Navigator.of(context).pop();
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String userId = userCredential.user?.uid ?? '';

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'full_name': _nameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'address1': _address1Controller.text.trim(),
        'barangay': _barangayController.text.trim(),
        'city': _cityController.text.trim(),
        'province': _provinceController.text.trim(),
        'email_address': _emailController.text.trim(),
        'shopping_cart': [],
        'user_type': 'Customer',
      });

      context.goNamed("Login");
      Utilities.showSnackBar(
          "Successfully created account. You may now login.", Colors.green);
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'email-already-in-use') {
        Utilities.showSnackBar(
            "This email address is already in use by another account.",
            Colors.red);
      } else {
        Utilities.showSnackBar("Unexpected error", Colors.red);
        print(ex.message);
      }
      print("Error during signup $ex");
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _barangayController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Getting Started",
                    style: TextStyle(
                        fontSize: 24,
                        color: majorText,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Create your account by providing your information below.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: minorText,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InputField(
                    label: "Full Name",
                    placeholder: 'First Middle Last',
                    inputType: 'text',
                    controller: _nameController,
                    validator: InputValidator.requiredValidator,
                  ),
                  InputField(
                    label: "Phone Number",
                    placeholder: 'Please enter your phone number',
                    inputType: 'phone',
                    controller: _phoneController,
                    validator: InputValidator.phoneValidator,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          label: "Address 1",
                          placeholder: 'House/Unit No. Street',
                          inputType: 'text',
                          controller: _address1Controller,
                          validator: requiredValidator,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: InputField(
                          label: "Barangay",
                          placeholder: 'Barangay',
                          inputType: 'text',
                          controller: _barangayController,
                          validator: requiredValidator,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          label: "City",
                          placeholder: 'City',
                          inputType: 'text',
                          controller: _cityController,
                          validator: requiredValidator,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: InputField(
                          label: "State/Province",
                          placeholder: 'State/Province',
                          inputType: 'text',
                          controller: _provinceController,
                          validator: requiredValidator,
                        ),
                      ),
                    ],
                  ),
                  InputField(
                    label: "Email Address",
                    placeholder: 'Please enter your email address',
                    inputType: 'email',
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
                    label: "Password",
                    placeholder: 'Min. 8 character password',
                    inputType: 'password',
                    controller: _passwordController,
                    validator: (value) => value != null && value.length < 8
                        ? 'Enter min. 8 characters'
                        : null,
                  ),
                  InputField(
                    label: "Confirm Password",
                    placeholder: 'Min. 8 character password',
                    inputType: 'password',
                    controller: _confirmPasswordController,
                    validator: (value) => value != null &&
                            value != _passwordController.text.trim()
                        ? 'Both passwords must match'
                        : null,
                  ),
                  InputButton(
                      label: "Create Account",
                      function: () {
                        signUp();
                      },
                      large: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          context.goNamed("Login");
                        },
                        child: Text("Login here."),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
