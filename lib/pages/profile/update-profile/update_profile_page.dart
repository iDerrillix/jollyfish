import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/models/user_model.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  UserModel model = new UserModel();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _barangayController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void fetchUserDetails() async {
    // Fetch user details from Firestore using getUserById

    Map<String, dynamic>? userDetails = await UserModel.getUserById(model.uId);

    if (userDetails != null) {
      // Update text controllers with user details
      setState(() {
        _nameController.text = userDetails['full_name'] ?? '';
        _phoneController.text = userDetails['phone_number'] ?? '';
        _address1Controller.text = userDetails['address1'] ?? '';
        _barangayController.text = userDetails['barangay'] ?? '';
        _cityController.text = userDetails['city'] ?? '';
        _provinceController.text = userDetails['province'] ?? '';
      });
    } else {
      print('User details not found');
    }
  }

  void updateDetails() {
    try {
      InputValidator.checkFormValidity(formKey, context);

      model.updateUserDetails(
        model.uId,
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _address1Controller.text.trim(),
        _barangayController.text.trim(),
        _cityController.text.trim(),
        _provinceController.text.trim(),
      );

      Utilities.showSnackBar("Successfully updated details", Colors.green);
    } catch (ex) {
      print("$ex");
      Utilities.showSnackBar("Unexpected error has occured", Colors.red);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _barangayController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        leading: TextButton(
          onPressed: () {
            context.goNamed('Main Profile');
          },
          child: Icon(Icons.chevron_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      "https://pbs.twimg.com/media/EuNNxftXcAE1CyG.jpg"),
                ),
                SizedBox(
                  height: 24,
                ),
                InputField(
                  label: "Full Name",
                  inputType: 'text',
                  placeholder: '',
                  controller: _nameController,
                  validator: InputValidator.requiredValidator,
                ),
                InputField(
                  label: "Phone Number",
                  inputType: 'phone',
                  placeholder: '',
                  controller: _phoneController,
                  validator: InputValidator.phoneValidator,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InputField(
                        label: "Address 1",
                        inputType: 'text',
                        placeholder: '',
                        controller: _address1Controller,
                        validator: InputValidator.requiredValidator,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: InputField(
                        label: "Barangay",
                        inputType: 'text',
                        placeholder: '',
                        controller: _barangayController,
                        validator: InputValidator.requiredValidator,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InputField(
                        label: "City",
                        inputType: 'text',
                        placeholder: '',
                        controller: _cityController,
                        validator: InputValidator.requiredValidator,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: InputField(
                        label: "State/Province",
                        inputType: 'text',
                        placeholder: '',
                        controller: _provinceController,
                        validator: InputValidator.requiredValidator,
                      ),
                    ),
                  ],
                ),
                InputButton(
                    label: "UPDATE",
                    function: () {
                      updateDetails();
                    },
                    large: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
