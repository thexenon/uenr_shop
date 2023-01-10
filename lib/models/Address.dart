import 'Model.dart';

class Address extends Model {
  static const String TITLE_KEY = "title";
  static const String CITY_KEY = "city";
  static const String STATE_KEY = "state";
  static const String RECEIVER_KEY = "receiver";
  static const String PHONE_KEY = "phone";

  String title;
  String receiver;
  String city;
  String state;
  String phone;

  Address({
    String id,
    this.title,
    this.receiver,
    this.city,
    this.state,
    this.phone,
  }) : super(id);

  factory Address.fromMap(Map<String, dynamic> map, {String id}) {
    return Address(
      id: id,
      title: map[TITLE_KEY],
      receiver: map[RECEIVER_KEY],
      city: map[CITY_KEY],
      state: map[STATE_KEY],
      phone: map[PHONE_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      TITLE_KEY: title,
      RECEIVER_KEY: receiver,
      CITY_KEY: city,
      STATE_KEY: state,
      PHONE_KEY: phone,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (title != null) map[TITLE_KEY] = title;
    if (receiver != null) map[RECEIVER_KEY] = receiver;
    if (city != null) map[CITY_KEY] = city;
    if (state != null) map[STATE_KEY] = state;
    if (phone != null) map[PHONE_KEY] = phone;
    return map;
  }
}
