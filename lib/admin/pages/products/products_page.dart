import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      color: majorText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final _categoryNameController =
                              TextEditingController();

                          final formKey = GlobalKey<FormState>();

                          void addCategory() async {
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
                              CollectionReference collectionReference =
                                  FirebaseFirestore.instance
                                      .collection('categories');
                              DocumentReference documentReference =
                                  await collectionReference.add({
                                'name': _categoryNameController.text.trim(),
                                'items': [],
                              });
                              Utilities.showSnackBar(
                                  "Successfully added category. ID: ${documentReference.id}",
                                  Colors.green);
                            } catch (ex) {
                              print(ex);
                              Utilities.showSnackBar(
                                  "An error occured while adding category",
                                  Colors.red);
                            }
                            Navigator.pop(dialogContext);
                            Navigator.of(context).pop();
                          }

                          return Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  InputField(
                                    placeholder: "Category Name",
                                    inputType: "text",
                                    controller: _categoryNameController,
                                    validator: InputValidator.requiredValidator,
                                    label: "Category Name",
                                  ),
                                  InputButton(
                                    label: "Add Category",
                                    function: () {
                                      addCategory();
                                    },
                                    large: false,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Widget> categoryList = [];

                  if (snapshot.hasData) {
                    final categories = snapshot.data?.docs.toList();

                    for (var category in categories!) {
                      int itemCount = category['items'].length;
                      final categoryWidget = GestureDetector(
                        onTap: () =>
                            context.go('/products/category/${category.id}'),
                        child: CategoryContainer(
                          name: category['name'],
                          quantity: itemCount,
                        ),
                      );

                      categoryList.add(categoryWidget);
                    }
                  }
                  return Column(
                    children: categoryList,
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Products",
                    style: TextStyle(
                      color: majorText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          var dialogContext = context;
                          final _productNameController =
                              TextEditingController();
                          final _priceController = TextEditingController();
                          final _stockController = TextEditingController();
                          final _detailsController = TextEditingController();

                          File? selectedImage;

                          Future _pickImageFromGallery() async {
                            final returnedImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);

                            if (returnedImage == null) return;
                            setState(() {
                              selectedImage = File(returnedImage!.path);
                            });
                          }

                          final formKey = GlobalKey<FormState>();

                          void addProduct() async {
                            InputValidator.checkFormValidity(formKey, context);

                            if (selectedImage == null) {
                              Utilities.showSnackBar(
                                  "Please attach a photo", Colors.red);
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
                              final path =
                                  'product_images/${selectedImage!.path.split('/').last}';

                              final ref =
                                  FirebaseStorage.instance.ref().child(path);
                              UploadTask? uploadTask =
                                  ref.putFile(selectedImage!);

                              final snapshot =
                                  await uploadTask!.whenComplete(() => null);

                              final urlDownload =
                                  await snapshot.ref.getDownloadURL();
                              CollectionReference collectionReference =
                                  FirebaseFirestore.instance
                                      .collection('products');
                              DocumentReference documentReference =
                                  await collectionReference.add({
                                'name': _productNameController.text.trim(),
                                'price': double.parse(_priceController.text),
                                'stock': int.parse(_stockController.text),
                                'details': _detailsController.text.trim(),
                                'imagePath': urlDownload,
                              });
                              Utilities.showSnackBar(
                                  "Successfully added product. ID: ${documentReference.id}",
                                  Colors.green);
                            } catch (ex) {
                              Utilities.showSnackBar(
                                  "An unexpected error has occured",
                                  Colors.red);
                            }
                            Navigator.pop(dialogContext);
                            Navigator.of(context).pop();
                          }

                          return Form(
                            key: formKey,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InputField(
                                            placeholder: "Product Name",
                                            inputType: "text",
                                            controller: _productNameController,
                                            label: "Product Name",
                                            validator: InputValidator
                                                .requiredValidator,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: InputField(
                                            placeholder: "Stock",
                                            inputType: "number",
                                            controller: _stockController,
                                            label: "Stock",
                                            validator: InputValidator
                                                .requiredValidator,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InputField(
                                      placeholder: "Price per piece",
                                      inputType: "number",
                                      controller: _priceController,
                                      label: "Price",
                                      validator:
                                          InputValidator.requiredValidator,
                                    ),
                                    TextFormField(
                                      validator:
                                          InputValidator.requiredValidator,
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: accentColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                            Text("Attach Photo"),
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
                                          BorderSide(
                                              color: accentColor, width: 1),
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
                                    InputButton(
                                        label: "Add Product",
                                        function: () {
                                          addProduct();
                                        },
                                        large: false),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Widget> productList = [];

                  if (snapshot.hasData) {
                    final products = snapshot.data?.docs.toList();

                    for (var product in products!) {
                      final productWidget = GestureDetector(
                        onTap: () => context.go('/products/edit/${product.id}'),
                        child: ProductsContainer(
                          product_id: product.id,
                          name: product['name'],
                          stock: product['stock'].toInt(),
                          rating: 4.6,
                          imagePath: product['imagePath'],
                        ),
                      );

                      productList.add(productWidget);
                    }
                  }
                  return Column(
                    children: productList,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String name;
  final int quantity;
  const CategoryContainer(
      {Key? key, required this.name, required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        height: 63,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 234, 240, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: majorText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${quantity} products",
                style: TextStyle(
                  color: minorText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsContainer extends StatefulWidget {
  final String product_id;
  final String name;
  final int stock;
  final double rating;
  final String imagePath;
  const ProductsContainer(
      {Key? key,
      required this.name,
      required this.stock,
      required this.rating,
      required this.imagePath,
      required this.product_id})
      : super(key: key);

  @override
  State<ProductsContainer> createState() => _ProductsContainerState();
}

class _ProductsContainerState extends State<ProductsContainer> {
  Future<double> getAverageRating(String productId) async {
    try {
      QuerySnapshot ratingsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .doc(productId)
          .collection('ratings')
          .get();

      if (ratingsSnapshot.size == 0) {
        return 0.0;
      }

      int totalRatings = ratingsSnapshot.size;
      int totalRatingSum = 0;

      for (var doc in ratingsSnapshot.docs) {
        totalRatingSum += doc['rating'] as int;
      }

      double averageRating = totalRatingSum / totalRatings;
      return averageRating;
    } catch (error) {
      print('Error getting average rating: $error');
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        height: 63,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 234, 240, 249),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    color: Colors.green,
                    child: Image.network(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: majorText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                "${widget.stock} left",
                style: TextStyle(
                  color: minorText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: accentColor,
                  ),
                  FutureBuilder(
                    future: getAverageRating(widget.product_id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("error");
                        }

                        // Assuming your getAverageRating function returns a double value
                        double averageRating = snapshot.data as double;

                        // Display the average rating
                        return Text(
                          averageRating.toStringAsFixed(
                              1), // Displaying with one decimal point
                          style: TextStyle(
                            color: minorText,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
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
