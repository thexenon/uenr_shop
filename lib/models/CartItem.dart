import 'package:uenr_shop/models/Model.dart';

class CartItem extends Model {
  static const String PRODUCT_ID_KEY = "product_id";
  static const String ITEM_COUNT_KEY = "item_count";
  static const String ITEM_OWNER_KEY = "owner";

  int itemCount;
  String owner;
  CartItem({
    String id,
    this.itemCount = 0,
    this.owner,
  }) : super(id);

  factory CartItem.fromMap(Map<String, dynamic> map, {String id}) {
    return CartItem(
      id: id,
      itemCount: map[ITEM_COUNT_KEY],
      owner: map[ITEM_OWNER_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      ITEM_COUNT_KEY: itemCount,
      ITEM_OWNER_KEY: owner
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (itemCount != null) map[ITEM_COUNT_KEY] = itemCount;
    if (owner != null) map[ITEM_OWNER_KEY] = owner;
    return map;
  }
}
