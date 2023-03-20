import 'message.dart';

class ScratchCardsModel {
  bool? success;
  List<Message>? message;
  String? code;
  Data? data;

  ScratchCardsModel({this.success, this.message, this.code, this.data});

  ScratchCardsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? activeCard;
  List<CustomerPromo>? customerPromo;

  Data({this.activeCard, this.customerPromo});

  Data.fromJson(Map<String, dynamic> json) {
    if(json['active_card'] != null){
      activeCard = json['active_card'];
    }
    else{
      activeCard = 0;
    }
    if (json['customer_promo'] != null) {
      customerPromo = <CustomerPromo>[];
      json['customer_promo'].forEach((v) {
        customerPromo!.add(new CustomerPromo.fromJson(v));
      });
    }
    else{
      customerPromo = <CustomerPromo>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active_card'] = this.activeCard;
    if (this.customerPromo != null) {
      data['customer_promo'] =
          this.customerPromo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerPromo {
  String? code;
  String? title;

  CustomerPromo({this.code, this.title});

  CustomerPromo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['title'] = this.title;
    return data;
  }
}