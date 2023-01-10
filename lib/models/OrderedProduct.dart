import 'Model.dart';

class OrderedProduct extends Model {
  static const String PRODUCT_UID_KEY = "product_uid";
  static const String ORDER_DATE_KEY = "order_date";
  static const String ORDER_STATUS = "status";
  static const String ORDER_OWNER = "owner";
  static const String ORDER_NUMBER = "number";
  static const String ORDER_PHONE = "phone";

  String productUid;
  String orderDate;
  String status;
  String owner;
  String number;
  String phone;
  OrderedProduct(
    String id, {
    this.productUid,
    this.orderDate,
    this.status,
    this.owner,
    this.number,
    this.phone,
  }) : super(id);

  factory OrderedProduct.fromMap(Map<dynamic, dynamic> map, {String id}) {
    return OrderedProduct(
      id,
      productUid: map[PRODUCT_UID_KEY],
      orderDate: map[ORDER_DATE_KEY],
      status: map[ORDER_STATUS],
      owner: map[ORDER_OWNER],
      number: map[ORDER_NUMBER],
      phone: map[ORDER_PHONE],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRODUCT_UID_KEY: productUid,
      ORDER_DATE_KEY: orderDate,
      ORDER_STATUS: status,
      ORDER_OWNER: owner,
      ORDER_NUMBER: number,
      ORDER_PHONE: phone,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (productUid != null) map[PRODUCT_UID_KEY] = productUid;
    if (orderDate != null) map[ORDER_DATE_KEY] = orderDate;
    if (status != null) map[ORDER_STATUS] = status;
    if (owner != null) map[ORDER_OWNER] = owner;
    if (number != null) map[ORDER_NUMBER] = number;
    if (phone != null) map[ORDER_PHONE] = phone;
    return map;
  }
}
