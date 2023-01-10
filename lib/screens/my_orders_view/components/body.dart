import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uenr_shop/components/async_progress_dialog.dart';
import 'package:uenr_shop/components/nothingtoshow_container.dart';
import 'package:uenr_shop/components/ordered_products_detail_card.dart';
import 'package:uenr_shop/constants.dart';
import 'package:uenr_shop/models/OrderedProduct.dart';
import 'package:uenr_shop/screens/my_orders_view/components/my_orders.dart';
import 'package:uenr_shop/screens/product_details/product_details_screen.dart';
import 'package:uenr_shop/services/authentification/authentification_service.dart';
import 'package:uenr_shop/services/data_streams/ordered_products_stream.dart';
import 'package:uenr_shop/services/data_streams/my_orders_stream.dart';
import 'package:uenr_shop/services/database/orders_database_helper.dart';
import 'package:uenr_shop/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:uenr_shop/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:logger/logger.dart';

import '../../../utils.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final MyOrderedProductsStream orderedProductStream =
      MyOrderedProductsStream();

  @override
  void initState() {
    super.initState();
    orderedProductStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    orderedProductStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text("Your Product Orders", style: headingStyle),
                  Text(
                    "Swipe LEFT to Complete, Swipe RIGHT to Cancel",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.7,
                    child: StreamBuilder(
                      stream: orderedProductStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final productsIds = snapshot.data;
                          print(productsIds);
                          if (snapshot.data == 0) {
                            return Center(
                              child: NothingToShowContainer(
                                secondaryMessage:
                                    "Sorry, no orders yet. Add your first Product to Sell",
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: productsIds,
                            itemBuilder: (context, index) {
                              return buildProductsCard(productsIds[index]);
                            },
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          final error = snapshot.error;
                          Logger().w(error.toString());
                        }
                        return Center(
                          child: NothingToShowContainer(
                            iconPath: "assets/icons/network_error.svg",
                            primaryMessage: "Something went wrong",
                            secondaryMessage: "Unable to connect to Database",
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(60)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    orderedProductStream.reload();
    return Future<void>.value();
  }

  Widget buildProductsCard(Map products) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FutureBuilder<OrderedProduct>(
        future: MyOrdersDatabaseHelper().myOrdersProductsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            return buildProductDismissible(product);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e(error);
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

  Widget buildProductDismissible(OrderedProduct product) {
    return Dismissible(
      key: Key(product.id),
      direction: DismissDirection.horizontal,
      background: buildDismissibleSecondaryBackground(),
      secondaryBackground: buildDismissiblePrimaryBackground(),
      dismissThresholds: {
        DismissDirection.endToStart: 0.65,
        DismissDirection.startToEnd: 0.65,
      },
      child: OrederedProductsDetailCard(
        orderID: product.id,
        orderPhone: product.phone,
        orderStatus: product.status,
        orderDate: product.orderDate,
        orderOwner: product.owner,
        orderNumber: product.number,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                productId: product.id,
              ),
            ),
          );
        },
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
              context, "Are you sure you want to Cancel order?");
          if (confirmation) {}
          await refreshPage();
          return confirmation;
        } else if (direction == DismissDirection.endToStart) {
          final confirmation = await showConfirmationDialog(
              context, "Are you sure you want to Complete order ?");
          if (confirmation) {}
          await refreshPage();
          return false;
        }
        return false;
      },
      onDismissed: (direction) async {
        await refreshPage();
      },
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Complete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
