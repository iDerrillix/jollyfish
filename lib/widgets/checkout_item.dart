import "package:flutter/material.dart";
import "package:jollyfish/constants.dart";

class CheckoutItem extends StatelessWidget {
  const CheckoutItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                    fit: BoxFit.cover,
                    height: 64,
                    width: 64,
                    "https://www.thesprucepets.com/thmb/b6ck4PC5poXK75uwtOCUF8Z5UG0=/3008x0/filters:no_upscale():strip_icc()/GettyImages-165355962-7529444d03544186ba8ff1b635692407.jpg"),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Name",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: majorText),
                  ),
                  Text(
                    "P999.99",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: majorText),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "QTY: 99",
            style: TextStyle(
              color: minorText,
            ),
          ),
        ],
      ),
    );
  }
}
