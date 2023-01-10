import 'package:uenr_shop/models/OrderedProduct.dart';
import 'package:uenr_shop/services/database/orders_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import '../size_config.dart';

class OrederedProductsDetailCard extends StatelessWidget {
  final String orderID;
  final String orderOwner;
  final String orderPhone;
  final String orderStatus;
  final String orderNumber;
  final String orderDate;
  final VoidCallback onPressed;
  const OrederedProductsDetailCard({
    Key key,
    @required this.orderID,
    @required this.orderPhone,
    @required this.orderOwner,
    @required this.orderStatus,
    @required this.orderNumber,
    @required this.orderDate,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<OrderedProduct>(
        future: MyOrdersDatabaseHelper().myOrdersProductsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            return Row(
              children: [
                // SizedBox(
                //   width: getProportionateScreenWidth(88),
                //   child: AspectRatio(
                //     aspectRatio: 0.88,
                //     child: Padding(
                //       padding: EdgeInsets.all(10),
                //       child: product.images.length > 0
                //           ? Image.network(
                //               product.images[0],
                //               fit: BoxFit.contain,
                //             )
                //           : Text("No Image"),
                //     ),
                //   ),
                // ),
                SizedBox(width: getProportionateScreenWidth(20)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\Ordered Date: ${product.orderDate}",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        "\Order Status: ${product.orderDate}",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text.rich(
                        TextSpan(
                          text: "\Phone: ${product.phone}",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "\Product Number: ${product.number}",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
          }
          return Center(
            child: Icon(
              Icons.error,
              color: kTextColor,
              size: 60,
            ),
          );
        },
      ),
    );
  }
}
