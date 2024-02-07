import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _dropdownValue = "Issue a return or refund";

  final _orderNoController = TextEditingController();
  final _detailsController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _emailAddressController = TextEditingController();

  @override
  void dispose() {
    _orderNoController.dispose();
    _detailsController.dispose();
    _phoneNoController.dispose();
    _emailAddressController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
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
                        value: "Order Problem",
                        label: "Order Problem",
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
                  TextField(
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
                    onPressed: () {},
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
                  InputField(
                    placeholder: '',
                    inputType: 'phone',
                    label: 'Contact No.',
                    controller: _phoneNoController,
                  ),
                  InputField(
                    placeholder: '',
                    inputType: 'email',
                    label: 'Email Address',
                    controller: _emailAddressController,
                  ),
                  InputButton(label: "SUBMIT", function: () {}, large: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
