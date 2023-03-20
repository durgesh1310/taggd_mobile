import './message.dart';

class PromoValidModel {
  bool? success;
  List<Message>? message;
  String? code;
  PromoValidData? data;

  PromoValidModel({this.success, this.message, this.code, this.data});

  PromoValidModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    if(json['data'] == null || json['data'] == 0.0){
      data = null;
    }
    else{
      data = new PromoValidData.fromJson(json['data']);
    }
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


class PromoValidData {
  String? discountType;
  int? promoDiscount;

  PromoValidData({this.discountType, this.promoDiscount});

  PromoValidData.fromJson(Map<String, dynamic> json) {
    discountType = json['discount_type'] ?? "";
    promoDiscount = json['promo_discount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount_type'] = this.discountType;
    data['promo_discount'] = this.promoDiscount;
    return data;
  }
}

