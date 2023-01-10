import 'package:uenr_shop/models/OrderedProduct.dart';
import 'package:uenr_shop/services/data_streams/data_stream.dart';
import 'package:uenr_shop/services/database/orders_database_helper.dart';

class MyOrderedProductsStream extends DataStream<OrderedProduct> {
  @override
  void reload() {
    final myOrderedProductsFuture = MyOrdersDatabaseHelper().myOrdersProductsList;
    myOrderedProductsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
