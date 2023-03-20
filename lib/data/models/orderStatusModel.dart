class OrderStatusModel {
  bool? success;
  List? message;
  String? code;
  int? data = 0;

  OrderStatusModel({this.success, this.message, this.code, this.data});

  OrderStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
    data = json['data'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['code'] = this.code;
    data['data'] = this.data ;
    return data;
  }
}