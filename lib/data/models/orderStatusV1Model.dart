class OrderStatusV1Model {
  bool? success;
  List? message;
  String? code;
  String? data;

  OrderStatusV1Model({this.success, this.message, this.code, this.data});

  OrderStatusV1Model.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
    data = json['data'] ?? "";
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