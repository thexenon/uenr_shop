import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uenr_shop/models/Product.dart';
import 'package:uenr_shop/models/OrderedProduct.dart';
import 'package:uenr_shop/models/Review.dart';
import 'package:uenr_shop/services/authentification/authentification_service.dart';
import 'package:enum_to_string/enum_to_string.dart';

class MyOrdersDatabaseHelper {
  static const String PRODUCTS_COLLECTION_NAME = "products";
  static const String REVIEWS_COLLECTOIN_NAME = "reviews";
  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";

  MyOrdersDatabaseHelper._privateConstructor();
  static MyOrdersDatabaseHelper _instance =
      MyOrdersDatabaseHelper._privateConstructor();
  factory MyOrdersDatabaseHelper() {
    return _instance;
  }
  FirebaseFirestore _firebaseFirestore;
  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<OrderedProduct> get myOrdersProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final orderCollectionReference = await firestore
        .collection(USERS_COLLECTION_NAME)
        .doc()
        .collection(ORDERED_PRODUCTS_COLLECTION_NAME)
        .where('owner', isEqualTo: uid)
        .orderBy('status', descending: true)
        .get();

    Map orderedProductsMap = HashMap();
    print(orderCollectionReference.docs);
    for (final doc in orderCollectionReference.docs) {
      final docData = doc.data();
      print(docData);
      orderedProductsMap.addAll({
        "productUid": docData['product_uid'],
        "owner": docData['owner'],
        "phone": docData['phone'],
        "status": docData['status'],
        "number": docData['number'],
        "order_date": docData['order_date'],
      });
    }
    return OrderedProduct.fromMap(orderedProductsMap);
  }

  String getPathForProductImage(String id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }
}
