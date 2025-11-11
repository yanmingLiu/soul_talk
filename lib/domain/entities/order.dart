import "dart:convert";

class Order {
  final int? id;
  final String? orderNo;

  Order({this.id, this.orderNo});

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) =>
      Order(id: json["id"], orderNo: json["order_no"]);

  Map<String, dynamic> toJson() => {"id": id, "order_no": orderNo};
}
