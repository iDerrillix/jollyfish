import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void changePassword() async {
    InputValidator.checkFormValidity(formKey, context);
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var credential = EmailAuthProvider.credential(
          email: user.email!, password: _currentPasswordController.text.trim());
      await user.reauthenticateWithCredential(credential).then((value) {
        user.updatePassword(_newPasswordController.text.trim());
        print("success before snackbar");
        Utilities.showSnackBar("Successfully changed password", Colors.green);
        print("success after snackbar");
        Navigator.of(context).pop();
      }).catchError((error) {
        print(error);
        Utilities.showSnackBar("${error}", Colors.red);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        leading: TextButton(
          child: Icon(Icons.chevron_left),
          onPressed: () {
            context.goNamed("Main Profile");
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              InputField(
                label: "Current Password",
                inputType: 'password',
                placeholder: '',
                controller: _currentPasswordController,
                validator: InputValidator.requiredValidator,
              ),
              InputField(
                label: "New Password",
                inputType: 'password',
                placeholder: '',
                controller: _newPasswordController,
                validator: InputValidator.passwordValidator,
              ),
              InputField(
                label: "Confirm New Password",
                inputType: 'password',
                placeholder: '',
                controller: _confirmPasswordController,
                validator: (p0) =>
                    (p0 != null && p0 != _newPasswordController.text.trim())
                        ? 'Passwords must match'
                        : '',
              ),
              InputButton(
                  label: "UPDATE PASSWORD",
                  function: () {
                    changePassword();
                  },
                  large: true),
            ],
          ),
        ),
      ),
    );
  }
}
