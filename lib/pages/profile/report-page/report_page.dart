import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/models/user_model.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class ReportPage extends StatefulWidget {
  final String? orderNo;
  const ReportPage({Key? key, this.orderNo}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _dropdownValue = "Issue a return or refund";

  final _orderNoController = TextEditingController();
  final _detailsController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _emailAddressController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  File? selectedImage;

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.orderNo != null) {
      _orderNoController.text = widget.orderNo!;
    }
    fetchContact();
  }

  void fetchContact() async {
    UserModel model = UserModel();
    if (model.uId != null) {
      Map<String, dynamic>? userDetails =
          await UserModel.getUserById(model.uId);
      if (userDetails != null) {
        _phoneNoController.text = userDetails['phone_number'];
        _emailAddressController.text = userDetails['email_address'];
      }
    }
  }

  @override
  void dispose() {
    _orderNoController.dispose();
    _detailsController.dispose();
    _phoneNoController.dispose();
    _emailAddressController.dispose();
    super.dispose();
  }

  void submitReport() async {
    InputValidator.checkFormValidity(formKey, context);

    if (selectedImage == null) {
      Utilities.showSnackBar("Please attach a photo", Colors.red);
      return;
    }
    BuildContext dialogContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              color: accentColor,
            ),
          ),
        );
      },
    );

    try {
      final path = 'reports/${selectedImage!.path.split('/').last}';

      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask? uploadTask = ref.putFile(selectedImage!);

      final snapshot = await uploadTask!.whenComplete(() => null);

      final urlDownload = await snapshot.ref.getDownloadURL();

      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('reports');

      DocumentReference documentReference = await collectionReference.add({
        'order_number': _orderNoController.text.trim(),
        'concern': _dropdownValue,
        'details': _detailsController.text.trim(),
        'attached_image': urlDownload,
        'contact_number': _phoneNoController.text.trim(),
        'email_address': _emailAddressController.text.trim(),
        'placed_at': FieldValue.serverTimestamp(),
        'reported_by': UserModel().uId,
        'status': 'Unresolved',
      });

      print("Successfully placed report");
      Utilities.showSnackBar(
          "Success! Your report number is ${documentReference.id}",
          Colors.green);
    } catch (e) {
      print(e);
      Utilities.showSnackBar("An unexpected error has occured", Colors.red);
    }
    Navigator.pop(dialogContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report a Problem"),
        leading: TextButton(
          child: Icon(Icons.chevron_left),
          onPressed: () {
            context.goNamed("Main Profile");
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Experienced an issue? We're here to assist! Kindly share your problem, order details, and any helpful details. Our team will swiftly address it to ensure a seamless experience for you.",
                  style: TextStyle(
                    fontSize: 16,
                    color: minorText,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type of Issue",
                      style: TextStyle(
                        color: majorText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    DropdownMenu(
                      width: 361,
                      onSelected: (value) {
                        setState(() {
                          if (value is String) {
                            _dropdownValue = value;
                          }
                        });
                      },
                      dropdownMenuEntries: <DropdownMenuEntry<String>>[
                        DropdownMenuEntry(
                          value: "Issue a return or refund",
                          label: "Issue a return or refund",
                        ),
                        DropdownMenuEntry(
                          value: "Order not received",
                          label: "Order not received",
                        ),
                        DropdownMenuEntry(
                          value: "Missing item from order",
                          label: "Missing item from order",
                        ),
                        DropdownMenuEntry(
                          value: "Incorrect item received",
                          label: "Incorrect item received",
                        ),
                        DropdownMenuEntry(
                          value: "Payment issue",
                          label: "Payment issue",
                        ),
                        DropdownMenuEntry(
                          value: "In-app error/bug",
                          label: "In-app error/bug",
                        ),
                        DropdownMenuEntry(
                          value: "Other/Not Listed",
                          label: "Other/Not Listed",
                        ),
                      ],
                      initialSelection: _dropdownValue,
                      menuStyle: MenuStyle(),
                    ),
                  ],
                ),
                InputField(
                  placeholder: '',
                  inputType: 'text',
                  label: 'Order No.',
                  controller: _orderNoController,
                  validator: InputValidator.requiredValidator,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Describe your problem",
                      style: TextStyle(color: minorText),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: InputValidator.requiredValidator,
                      controller: _detailsController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: majorText,
                      ),
                      cursorHeight: 16,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFEBEBEB),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: accentColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      cursorColor: accentColor,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _pickImageFromGallery();
                      },
                      child: IntrinsicWidth(
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            Text("Attach a File"),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(
                          EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 16,
                            right: 16,
                          ),
                        ),
                        side: MaterialStatePropertyAll(
                          BorderSide(color: accentColor, width: 1),
                        ),
                      ),
                    ),
                    (selectedImage != null)
                        ? Container(
                            width: 393,
                            height: 150,
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : SizedBox(),
                    InputField(
                      placeholder: '',
                      inputType: 'phone',
                      label: 'Contact No.',
                      controller: _phoneNoController,
                      validator: InputValidator.phoneValidator,
                    ),
                    InputField(
                      placeholder: '',
                      inputType: 'email',
                      label: 'Email Address',
                      controller: _emailAddressController,
                      validator: InputValidator.emailValidator,
                    ),
                    InputButton(
                        label: "SUBMIT",
                        function: () {
                          submitReport();
                        },
                        large: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
