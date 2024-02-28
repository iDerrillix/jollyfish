import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/models/shopping_cart_model.dart';
import 'package:jollyfish/models/user_model.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/checkout_details.dart';
import 'package:jollyfish/widgets/checkout_item.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';
import 'package:provider/provider.dart';

TextStyle orderSumStyle =
    TextStyle(color: minorText, fontSize: 16, fontWeight: FontWeight.w500);

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  UserModel model = new UserModel();
  double totalPrice = 0;
  double delivery_fee = 30;

  String full_name = "";
  String contact_no = "";

  String address1 = "";
  String barangay = "";
  String city = "";
  String province = "";

  String payment_method = "Not Selected";
  String payment_details = "Choose payment method first";

  String gcash_no = "";
  late File proof;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateTotalPrice();
    fetchAddress();
  }

  void fetchAddress() async {
    Map<String, dynamic>? details = await UserModel.getUserById(model.uId);

    if (details != null) {
      setState(() {
        full_name = details['full_name'] ?? '';
        contact_no = details['phone_number'] ?? '';
        address1 = details['address1'] ?? '';
        barangay = details['barangay'] ?? '';
        city = details['city'] ?? '';
        province = details['province'] ?? '';
      });
    }
  }

  void _updateTotalPrice() {
    final cart = context.read<ShoppingCartModel>();
    setState(() {
      totalPrice = cart.getTotalPrice();
    });
    print("this happened");
  }

  bool isCityCovered(String city) {
    switch (city) {
      case 'Baliuag':
        delivery_fee = delivery_fee;
        return true;
      case 'San Rafael':
        delivery_fee = delivery_fee * 2;
        return true;
      case 'San Ildefonso':
        delivery_fee = delivery_fee * 3;
        return true;
      case 'San Miguel':
        delivery_fee = delivery_fee * 4;
        return true;
      case 'Bustos':
        delivery_fee = delivery_fee * 2;
        return true;
      case 'Pulilan':
        delivery_fee = delivery_fee * 3;
        return true;
      case 'Plaridel':
        delivery_fee = delivery_fee * 4;
        return true;
      case 'Guguinto':
        delivery_fee = delivery_fee * 5;
        return true;
      case 'Malolos':
        delivery_fee = delivery_fee * 6;
        return true;
      default:
        return false;
    }
  }

  void placeOrder() async {
    if (full_name.isEmpty ||
        contact_no.isEmpty ||
        address1.isEmpty ||
        barangay.isEmpty ||
        city.isEmpty ||
        province.isEmpty) {
      Utilities.showSnackBar("Some fields are missing.", Colors.red);
      return;
    }

    if (payment_method == "Not Selected") {
      Utilities.showSnackBar("Must choose a payment method first", Colors.red);
      return;
    }

    if (proof == null) {
      Utilities.showSnackBar("You have not provided a photo proof", Colors.red);
      return;
    }

    final path = 'proofs/${proof!.path.split('/').last}';

    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(proof!);

    final snapshot = await uploadTask!.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();

    final cart = context.read<ShoppingCartModel>();

    Map<String, dynamic> orderData = {
      'address1': address1,
      'barangay': barangay,
      'city': city,
      'ordered_by': model.uId,
      'payment_method': payment_method,
      'payment_details': payment_details,
      'proof_path': urlDownload,
      'province': province,
      'recipient_contact': contact_no,
      'recipient_name': full_name,
      'total': (totalPrice),
      'ordered_at': FieldValue.serverTimestamp(),
      'status': "Verifying",
    };

    await cart.placeOrder(orderData);
    context.go("/cart/checkout/orderplaced");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        leading: IconButton(
          color: accentColor,
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<ShoppingCartModel>(
        builder: (context, cartModel, child) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text(
                "Your Order",
                style: TextStyle(
                    fontSize: 18,
                    color: majorText,
                    fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cartModel.cart.length,
                itemBuilder: (context, index) {
                  final item = cartModel.cart[index];
                  double totalPrice =
                      item['price'].toDouble() * item['quantity'];
                  return CheckoutItem(
                    imagePath: item['imagePath'],
                    name: item['name'],
                    price: totalPrice,
                    quantity: item['quantity'],
                  );
                },
              ),
              Text(
                "Recipient Information",
                style: TextStyle(
                  fontSize: 18,
                  color: majorText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckoutDetails(
                  heading: full_name,
                  body: contact_no,
                  iconBgColor: accentColor,
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  action: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return InfoSheet(
                          name: full_name,
                          contact_no: contact_no,
                          action: (name, phone_number) {
                            setState(() {
                              full_name = name;
                              contact_no = phone_number;
                            });
                            model.users.doc(model.uId).update({
                              'full_name': full_name,
                              'phone_number': contact_no,
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  }),
              Text(
                "Delivery Location",
                style: TextStyle(
                  fontSize: 18,
                  color: majorText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckoutDetails(
                heading: address1,
                body: "${barangay}, ${city}, ${province}",
                icon: Icon(
                  Icons.location_city,
                  color: Colors.white,
                ),
                iconBgColor: accentColor,
                action: () => {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ShippingSheet(
                      address1: address1,
                      barangay: barangay,
                      city: city,
                      province: province,
                      action: (newAddress1, newBarangay, newCity, newProvince) {
                        setState(() {
                          address1 = newAddress1;
                          barangay = newBarangay;
                          city = newCity;
                          province = newProvince;
                        });

                        model.users.doc(model.uId).update({
                          'address1': address1,
                          'barangay': barangay,
                          'city': city,
                          'province': province,
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                },
              ),
              Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  color: majorText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckoutDetails(
                heading: payment_method,
                body: payment_details,
                iconBgColor: Colors.blue.shade300,
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                ),
                action: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return PaymentSheet(
                      contact_no: contact_no,
                      gcash_action: (newGcash, newProof) {
                        setState(() {
                          gcash_no = newGcash;
                          proof = newProof;
                          payment_method = "GCash";
                          payment_details = gcash_no;
                        });
                        print("this is new");
                        print(gcash_no);
                        print(proof.path);
                        Navigator.of(context).pop();
                      },
                      cod_action: (newProof) {
                        setState(() {
                          proof = newProof;
                          payment_method = "COD";
                          payment_details = "Please prepare exact amount";
                        });

                        print("cod proof");
                        print(proof.path);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              Text(
                "Order Summary",
                style: TextStyle(
                    fontSize: 18,
                    color: majorText,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 239, 242, 242),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: orderSumStyle,
                          ),
                          Text(
                            "P${(totalPrice / 1.12).toStringAsFixed(2)}",
                            style: orderSumStyle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "VAT (12%)",
                            style: orderSumStyle,
                          ),
                          Text(
                            "P${((totalPrice) - ((totalPrice / (1 + 0.12)))).toStringAsFixed(2)}",
                            style: orderSumStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            color: majorText,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      Text(
                        "P${(totalPrice)}",
                        style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8), // Adjust the radius as needed
                    ),
                    elevation: 0,
                    height: 44,
                    onPressed: () {
                      placeOrder();
                    },
                    color: accentColor,
                    textColor: Colors.white,
                    child: Text(
                      "Place Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ShippingSheet extends StatefulWidget {
  final String address1;
  final String barangay;
  final String city;
  final String province;
  final Function(String address1, String barangay, String city, String province)
      action;
  const ShippingSheet({
    Key? key,
    required this.address1,
    required this.barangay,
    required this.city,
    required this.province,
    required this.action,
  }) : super(key: key);

  @override
  State<ShippingSheet> createState() => _ShippingSheetState();
}

class _ShippingSheetState extends State<ShippingSheet> {
  final _address1Controller = TextEditingController();
  final _barangayController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _address1Controller.text = widget.address1;
    _barangayController.text = widget.barangay;
    _cityController.text = widget.city;
    _provinceController.text = widget.province;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: "Address 1",
                    placeholder: "Adress 1",
                    inputType: "text",
                    controller: _address1Controller,
                    validator: InputValidator.requiredValidator,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: InputField(
                    label: "Barangay",
                    placeholder: "Barangay",
                    inputType: "text",
                    controller: _barangayController,
                    validator: InputValidator.requiredValidator,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: "City",
                    placeholder: "City",
                    inputType: "text",
                    controller: _cityController,
                    validator: InputValidator.requiredValidator,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: InputField(
                    placeholder: "Province",
                    inputType: "text",
                    controller: _provinceController,
                    validator: InputValidator.requiredValidator,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InputButton(
                      label: "Cancel",
                      function: () {
                        Navigator.of(context).pop();
                      },
                      large: false),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InputButton(
                    label: "SUBMIT",
                    function: () {
                      widget.action(
                          _address1Controller.text,
                          _barangayController.text,
                          _cityController.text,
                          _provinceController.text);
                    },
                    large: false,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PaymentSheet extends StatefulWidget {
  final String contact_no;
  final Function(String gcash_no, File proof) gcash_action;
  final Function(File proof) cod_action;
  const PaymentSheet({
    Key? key,
    required this.contact_no,
    required this.gcash_action,
    required this.cod_action,
  }) : super(key: key);

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            Text(
              "Payment Methods",
              style: TextStyle(
                  color: majorText, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // payment_method = "Cash on Delivery";
                  // payment_details =
                  //     "Please prepare exact amount";
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => CODPage(
                      action: (proof) {
                        widget.cod_action(proof);
                      },
                    ),
                  );
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/54/a8/1e/54a81e3a-3782-6986-1493-56f7e2843a27/AppIcon-0-0-1x_U007emarketing-0-0-0-5-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/512x512bb.jpg",
                            fit: BoxFit.cover,
                            height: 48,
                            width: 48,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "Cash on Delivery",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: majorText,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // payment_method = "GCash";
                  // payment_details = "update number";
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => GCashPage(
                      gcash_no: widget.contact_no,
                      action: (newGcash, newProof) {
                        widget.gcash_action(newGcash, newProof);
                      },
                    ),
                  );
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://is1-ssl.mzstatic.com/image/thumb/Purple116/v4/54/a8/1e/54a81e3a-3782-6986-1493-56f7e2843a27/AppIcon-0-0-1x_U007emarketing-0-0-0-5-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/512x512bb.jpg",
                            fit: BoxFit.cover,
                            height: 48,
                            width: 48,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          "GCash",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: majorText,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CODPage extends StatefulWidget {
  final Function(File proof) action;
  const CODPage({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  State<CODPage> createState() => _CODPageState();
}

class _CODPageState extends State<CODPage> {
  File? selectedImage;

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "In order to verify that this order is not a fake transaction, please provide an ID where the address matches the address you provided for this order.",
            style: TextStyle(
                fontWeight: FontWeight.w500, color: minorText, fontSize: 16),
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
                  width: 150,
                  height: 150,
                  child: Image.file(selectedImage!, fit: BoxFit.contain),
                )
              : SizedBox(),
          Row(
            children: [
              Expanded(
                child: InputButton(
                    label: "Cancel",
                    function: () {
                      Navigator.of(context).pop();
                    },
                    large: false),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: InputButton(
                  label: "SUBMIT",
                  function: () {
                    if (selectedImage != null) {
                      widget.action(selectedImage!);
                      Navigator.of(context).pop();
                    } else {
                      Utilities.showSnackBar(
                          "Please attach a photo", Colors.red);
                    }
                  },
                  large: false,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class GCashPage extends StatefulWidget {
  final String gcash_no;
  final Function(String gcash_no, File proof) action;
  const GCashPage({Key? key, required this.gcash_no, required this.action})
      : super(key: key);

  @override
  State<GCashPage> createState() => _GCashPageState();
}

class _GCashPageState extends State<GCashPage> {
  final _phoneNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? selectedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNoController.text = widget.gcash_no;
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 210,
                    child: Text(
                      "Send your payment to this GCash Number\n+63 918-463-9221 or scan the QR code and attach your proof of payment",
                      softWrap: true,
                      style: TextStyle(
                        color: minorText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                label: "GCash Phone Number",
                placeholder: "GCash Phone Number",
                inputType: "phone",
                controller: _phoneNoController,
                validator: InputValidator.phoneValidator,
              ),
              Text(
                "Proof of Payment",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: majorText),
              ),
              (selectedImage != null)
                  ? Container(
                      width: 150,
                      height: 150,
                      child: Image.file(selectedImage!, fit: BoxFit.contain),
                    )
                  : SizedBox(),
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
              Row(
                children: [
                  Expanded(
                    child: InputButton(
                        label: "Cancel",
                        function: () {
                          Navigator.of(context).pop();
                        },
                        large: false),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputButton(
                      label: "SUBMIT",
                      function: () {
                        final isValid = formKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        }

                        if (selectedImage != null) {
                          widget.action(
                            _phoneNoController.text,
                            selectedImage!,
                          );
                          Navigator.of(context).pop();
                        } else {
                          Utilities.showSnackBar(
                              "Please attach a photo", Colors.red);
                        }
                      },
                      large: false,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoSheet extends StatefulWidget {
  final String name;
  final String contact_no;
  final Function(String name, String phone_number) action;
  const InfoSheet(
      {Key? key,
      required this.name,
      required this.contact_no,
      required this.action})
      : super(key: key);

  @override
  State<InfoSheet> createState() => _InfoSheetState();
}

class _InfoSheetState extends State<InfoSheet> {
  final _fullNameController = TextEditingController();
  final _contactNoController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fullNameController.text = widget.name;
    _contactNoController.text = widget.contact_no;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          InputField(
            label: "Full Name",
            placeholder: "Full Name",
            inputType: "text",
            controller: _fullNameController,
          ),
          InputField(
            label: "Contact Number",
            placeholder: "Contact Number",
            inputType: "phone",
            controller: _contactNoController,
          ),
          Row(
            children: [
              Expanded(
                child: InputButton(
                    label: "Cancel",
                    function: () {
                      Navigator.of(context).pop();
                    },
                    large: false),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: InputButton(
                  label: "SUBMIT",
                  function: () {
                    widget.action(
                        _fullNameController.text, _contactNoController.text);
                  },
                  large: false,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
