import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Icon(
            Icons.chevron_left,
            color: accentColor,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text('Product Page'),
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://www.aquariadise.com/wp-content/uploads/2022/07/Most-Beautiful-Fish.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              height: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Product Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.favorite_outline,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  "P999.99",
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  "69 available",
                  style: TextStyle(
                    fontSize: 14,
                    color: minorText,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(color: minorText, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: accentColor,
                              ),
                              Text(
                                "4.8",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "420 reviews",
                        style: TextStyle(
                          color: minorText,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce in tempus leo. Proin vel feugiat dui. Pellentesque lacus justo, luctus suscipit euismod a, sodales vulputate dolor. Aliquam erat volutpat.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accentColor, width: 1),
                          fixedSize: Size(0, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Adjust the radius as needed
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Buy Now",
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust the radius as needed
                        ),
                        elevation: 0,
                        height: 44,
                        onPressed: () {},
                        color: accentColor,
                        textColor: Colors.white,
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.lineTo(0, size.height);
    path_0.quadraticBezierTo(size.width * 0.0028244, size.height * 0.8578857,
        size.width * 0.1276336, size.height * 0.8571429);
    path_0.cubicTo(
        size.width * 0.3183715,
        size.height * 0.8571429,
        size.width * 0.6997455,
        size.height * 0.8571429,
        size.width * 0.8905852,
        size.height * 0.8571429);
    path_0.quadraticBezierTo(size.width * 0.9997710, size.height * 0.8599429,
        size.width, size.height);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(0, 0);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
