import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            InputField(
              label: "Current Password",
              inputType: 'password',
              placeholder: '',
              controller: _currentPasswordController,
            ),
            InputField(
              label: "New Password",
              inputType: 'password',
              placeholder: '',
              controller: _newPasswordController,
            ),
            InputField(
              label: "Confirm New Password",
              inputType: 'password',
              placeholder: '',
              controller: _confirmPasswordController,
            ),
            InputButton(label: "UPDATE PASSWORD", function: () {}, large: true),
          ],
        ),
      ),
    );
  }
}
