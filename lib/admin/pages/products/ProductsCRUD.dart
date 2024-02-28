import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class ProductsCRUD extends StatefulWidget {
  final String product_id;
  const ProductsCRUD({Key? key, required this.product_id}) : super(key: key);

  @override
  _ProductsCRUDState createState() => _ProductsCRUDState();
}

class _ProductsCRUDState extends State<ProductsCRUD> {
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _detailsController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String imagePath =
      "https://i.pinimg.com/originals/2e/60/07/2e60079f1e36b5c7681f0996a79e8af4.jpg";
  String name = "";
  double price = 0;
  int stock = 0;
  String details = "";

  File? selectedImage;

  Image imageShown = Image.network(
    "https://i.pinimg.com/originals/2e/60/07/2e60079f1e36b5c7681f0996a79e8af4.jpg",
    fit: BoxFit.contain,
  );

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage!.path);
      imageShown = Image.file(
        selectedImage!,
        fit: BoxFit.cover,
      );
    });
  }

  void fetchDetails() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product_id)
          .get();
      if (productSnapshot.exists) {
        Map<String, dynamic> productDetails =
            productSnapshot.data() as Map<String, dynamic>;

        setState(() {
          imagePath = productDetails['imagePath'];
          name = productDetails['name'];
          price = productDetails['price'].toDouble();
          stock = productDetails['stock'].toInt();
          details = productDetails['details'];

          _productNameController.text = name;
          _priceController.text = price.toString();
          _stockController.text = stock.toString();
          _detailsController.text = details;
          imageShown = Image.network(
            imagePath,
            fit: BoxFit.cover,
          );
        });
      }
    } catch (ex) {
      print(ex);
      Utilities.showSnackBar("Error loading product detials", Colors.red);
    }

    print("this happened");
  }

  void updateProduct() async {
    InputValidator.checkFormValidity(formKey, context);

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
      var urlDownload = imagePath;

      if (selectedImage != null) {
        final path = 'product_images/${selectedImage!.path.split('/').last}';

        final ref = FirebaseStorage.instance.ref().child(path);
        UploadTask? uploadTask = ref.putFile(selectedImage!);

        final snapshot = await uploadTask!.whenComplete(() => null);

        urlDownload = await snapshot.ref.getDownloadURL();
      }

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product_id);
      await documentReference.update({
        'name': _productNameController.text.trim(),
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'details': _detailsController.text.trim(),
        'imagePath': urlDownload,
      });

      print('Document updated successfully');
      Utilities.showSnackBar("Successfully Updated", Colors.green);
    } catch (ex) {
      print(ex);
      Utilities.showSnackBar(
          "Error occured upon updating product", Colors.green);
    }
    Navigator.pop(dialogContext);
  }

  void deleteProduct() async {
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
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product_id);

      // Delete the document
      await documentReference.delete();

      print('Document deleted successfully');
      Utilities.showSnackBar("Product deleted", Colors.green);
    } catch (ex) {
      print(ex);
      Utilities.showSnackBar(
          "Error occured upon deleting product", Colors.green);
    }
    Navigator.pop(dialogContext);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _productNameController.dispose();
    _detailsController.dispose();
    _priceController.dispose();
    _stockController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.chevron_left),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: imageShown,
                    ),
                    IconButton(
                      onPressed: () {
                        _pickImageFromGallery();
                      },
                      icon: Icon(
                        Icons.photo,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              InputField(
                label: "Product Name",
                placeholder: "Product Name",
                inputType: "text",
                controller: _productNameController,
                validator: InputValidator.requiredValidator,
              ),
              InputField(
                placeholder: "Price",
                inputType: "number",
                controller: _priceController,
                label: "Price",
                validator: InputValidator.requiredValidator,
              ),
              InputField(
                placeholder: "Stock",
                label: "Stock",
                inputType: "number",
                controller: _stockController,
                validator: InputValidator.requiredValidator,
              ),
              InputField(
                placeholder: "Details",
                label: "Details",
                inputType: "text",
                controller: _detailsController,
                validator: InputValidator.requiredValidator,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputButton(
                        label: "DELETE",
                        function: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete product"),
                                content: Text(
                                    "Are you sure you want to delete this product?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("No")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deleteProduct();
                                      },
                                      child: Text("Yes")),
                                ],
                              );
                            },
                          );
                        },
                        large: false),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputButton(
                        label: "UPDATE",
                        function: () {
                          updateProduct();
                        },
                        large: false),
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
