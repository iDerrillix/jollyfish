import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:jollyfish/models/user_model.dart";
import "package:jollyfish/navigation_menu.dart";
import "package:jollyfish/pages/home/product_page.dart";
import "package:jollyfish/widgets/product_tile.dart";
import 'package:jollyfish/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "JollyFish",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFA800)),
        ),
        centerTitle: false,
      ),
      backgroundColor: scaffoldBg,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Our',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              const Text(
                'Products',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search, color: accentColor),
                    label: Text(
                      "Search Products",
                      style: TextStyle(color: minorText),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Color(0xFFEBEBEB),
                      ), // Change the border color for the enabled state
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color:
                              accentColor), // Change the border color for the focused state
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8,
                      ),
                      child: Container(
                        width: 360,
                        height: 180,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFA800),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                      ),
                    ),
                    Container(
                      width: 360,
                      height: 180,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFA800),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: FilledButton(
                        onPressed: () {},
                        child: Text("Category"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFFFFA800),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: FilledButton(
                        onPressed: () {},
                        child: Text("Category"),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFFFA800),
                          backgroundColor: Colors.transparent,
                          side: BorderSide(
                            color:
                                Color(0xFFFFA800), // Specify the border color
                            width: 2.0, // Specify the border width
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: FilledButton(
                        onPressed: () {},
                        child: Text("Category"),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFFFA800),
                          backgroundColor: Colors.transparent,
                          side: BorderSide(
                            color:
                                Color(0xFFFFA800), // Specify the border color
                            width: 2.0, // Specify the border width
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: FilledButton(
                        onPressed: () {},
                        child: Text("Category"),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFFFFA800),
                          backgroundColor: Colors.transparent,
                          side: BorderSide(
                            color:
                                Color(0xFFFFA800), // Specify the border color
                            width: 2.0, // Specify the border width
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: ProductTile(
                      imgPath:
                          "https://petessentialswhangarei.co.nz/portals/27/fish1.jpg",
                      name: "Clownfish",
                      stock: 120,
                      price: 666.66,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ProductTile(
                      imgPath:
                          "https://files.worldwildlife.org/wwfcmsprod/images/Whale_Shark_Homepage_Image/story_full_width/7a2odg1xq_Whale_Shark_Homepage.jpg",
                      name: "Whale Shark",
                      stock: 1,
                      price: 9999999.99,
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
