import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jollyfish/constants.dart';
import 'package:jollyfish/core/input_validator.dart';
import 'package:jollyfish/utilities.dart';
import 'package:jollyfish/widgets/input_button.dart';
import 'package:jollyfish/widgets/input_field.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String category_id;
  const CategoryDetailsPage({Key? key, required this.category_id})
      : super(key: key);

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  final _categoryNameController = TextEditingController();
  late Future<Map<String, Map<String, dynamic>>> productList;

  String _dropdownValue = "";

  List<dynamic> product_ids = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchCategory();
    productList = fetchProducts();
    print(productList);
  }

  void fetchCategory() async {
    try {
      DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category_id)
          .get();
      if (categorySnapshot.exists) {
        Map<String, dynamic> categoryDetails =
            categorySnapshot.data() as Map<String, dynamic>;

        setState(() {
          // imagePath = productDetails['imagePath'];
          // name = productDetails['name'];
          // price = productDetails['price'].toDouble();
          // stock = productDetails['stock'].toInt();
          // details = productDetails['details'];

          // _productNameController.text = name;
          // _priceController.text = price.toString();
          // _stockController.text = stock.toString();
          // _detailsController.text = details;
          // imageShown = Image.network(
          //   imagePath,
          //   fit: BoxFit.cover,
          // );

          _categoryNameController.text = categoryDetails['name'];
          product_ids = categoryDetails['items'];
        });
      }
    } catch (ex) {
      print(ex);
      Utilities.showSnackBar("Error loading product detials", Colors.red);
    }

    print("this happened");
  }

  Future<Map<String, Map<String, dynamic>>> fetchProducts() async {
    Map<String, Map<String, dynamic>> products = {};

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      querySnapshot.docs.forEach((doc) {
        String documentId = doc.id;
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          products[documentId] = {
            'name': data['name'],
            'imagePath': data['imagePath'],
          };
        }
      });
    } catch (error) {
      print('Error fetching products: $error');
      // Handle error
    }

    return products;
  }

  void removeProduct(String product_id) async {
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
      // 1. Retrieve the document containing the array
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(
              'categories') // Replace 'your_collection' with the actual collection name
          .doc(widget.category_id)
          .get();

      if (!documentSnapshot.exists) {
        // Document does not exist
        return;
      }

      // Get the existing array from the document data
      // Get the existing array from the document data
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('items')) {
        // Handle the case where the 'items' field does not exist or is null
        return;
      }

      List<dynamic> items = List.from(data['items']);

      // 2. Modify the array locally (remove the item to be deleted)
      items.remove(product_id);

      // 3. Update the document in Firestore with the modified array
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category_id)
          .update({'items': items});

      print('Item deleted successfully from the array in Firestore.');
    } catch (error) {
      print('Error deleting item from the array: $error');
      // Handle error
    }
    Navigator.pop(dialogContext);
  }

  void addProduct(String product_id) async {
    if (product_id.isEmpty) {
      Utilities.showSnackBar("Select a product first", Colors.red);
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
      // 1. Retrieve the document containing the array
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category_id)
          .get();

      if (!documentSnapshot.exists) {
        // Document does not exist
        return;
      }

      // Get the existing array from the document data
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('items')) {
        // Handle the case where the 'items' field does not exist or is null
        return;
      }

      List<dynamic> items = List.from(data['items']);

      // 2. Modify the array locally to add the new item
      items.add(product_id);

      // 3. Update the document in Firestore with the modified array
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category_id)
          .update({'items': items});

      print('Item added successfully to the array in Firestore.');
      Utilities.showSnackBar(
          "Product successfully added to category", Colors.green);
    } catch (error) {
      print('Error adding item to the array: $error');
      // Handle error
    }
    Navigator.pop(dialogContext);
  }

  void updateCategoryName(String newName) async {
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
      // Get the reference to the document
      DocumentReference categoryRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category_id);

      // Use the update() method to update the document with the new name
      await categoryRef.update({'name': newName});

      print('Category name updated successfully in Firestore.');
      Utilities.showSnackBar(
          "Successfully updated category name", Colors.green);
    } catch (error) {
      print('Error updating category name: $error');
      // Handle error
    }
    Navigator.pop(dialogContext);
  }

  void removeCategory() async {
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
      // Get the reference to the document
      DocumentReference categoryRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.category_id);

      // Use the delete() method to remove the document from the collection
      await categoryRef.delete();

      print('Category removed successfully from Firestore.');
      Utilities.showSnackBar("Removed category", Colors.green);
    } catch (error) {
      print('Error removing category: $error');
      // Handle error
    }
    Navigator.pop(dialogContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category Details"),
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(Icons.chevron_left),
        ),
      ),
      body: FutureBuilder(
        future: productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Map<String, Map<String, dynamic>> products = snapshot.data!;
              List<DropdownMenuEntry> dropdownItems = [];

              products.forEach((productId, productDetails) {
                // Add a DropdownMenuEntry for each product
                dropdownItems.add(
                  DropdownMenuEntry(
                    value: productId,
                    label: productDetails[
                        'name'], // Assuming 'name' is the key for product name
                  ),
                );
              });

              dropdownItems.removeWhere(
                  (dropdownItem) => product_ids.contains(dropdownItem.value));

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .doc(widget.category_id)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Widget> categoryItems = [];

                  if (snapshot.hasData) {
                    var data = snapshot.data?.data();
                    var items = data?['items'] ?? [];

                    for (var item in items) {
                      categoryItems.add(
                        CategoryItemContainer(
                          name: products[item]?['name'],
                          imagePath: products[item]?['imagePath'],
                          action: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Remove product"),
                                  content: Text(
                                      "Are you sure you want to remove this product?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("No")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          removeProduct(item);
                                        },
                                        child: Text("Yes")),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    }

                    print(categoryItems);
                  }

                  try {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: InputField(
                                    placeholder: "Category Name",
                                    inputType: "text",
                                    controller: _categoryNameController,
                                    label: "Category Name",
                                    validator: InputValidator.requiredValidator,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: InputButton(
                                      label: "SAVE",
                                      function: () {
                                        if (_categoryNameController
                                            .text.isEmpty) {
                                          Utilities.showSnackBar(
                                              "Enter name first", Colors.red);
                                        }
                                        updateCategoryName(
                                            _categoryNameController.text
                                                .trim());
                                      },
                                      large: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Add Product",
                                style: TextStyle(
                                  color: majorText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
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
                              dropdownMenuEntries: dropdownItems,
                              initialSelection: _dropdownValue,
                              menuStyle: MenuStyle(),
                            ),
                            InputButton(
                              function: () {
                                addProduct(_dropdownValue);
                              },
                              label: "Add",
                              large: false,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Products Included",
                                style: TextStyle(
                                  color: majorText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Column(
                              children: categoryItems,
                            ),
                            FilledButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.redAccent.shade100),
                                padding: MaterialStatePropertyAll(
                                  EdgeInsets.all(8),
                                ),
                                minimumSize: MaterialStatePropertyAll(
                                  Size.fromHeight(43),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Remove product"),
                                      content: Text(
                                          "Are you sure you want to remove this product?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("No")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              removeCategory();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Yes")),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "REMOVE CATEGORY",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } catch (ex) {
                    print(ex);
                    return SizedBox();
                  }
                },
              );
            }

            return Text("${snapshot.error}");
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class CategoryItemContainer extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback action;
  const CategoryItemContainer(
      {Key? key,
      required this.name,
      required this.imagePath,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              height: 63,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 234, 240, 249),
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
                          child: Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(name),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: action,
              child: Container(
                height: 63,
                width: 20,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(8)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
