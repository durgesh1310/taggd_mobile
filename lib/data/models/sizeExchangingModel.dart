import './message.dart';

class SizeExchangingModel {
  bool? success;
  List<Message>? message;
  String? code;
  Data? data;

  SizeExchangingModel({this.success, this.message, this.code, this.data});

  SizeExchangingModel.fromJson(Map<String, dynamic> json) {
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
  int? productId;
  String? name;
  String? imageUrl;
  List<SkuResponseDetails>? skuResponse;

  Data({this.productId, this.name, this.imageUrl, this.skuResponse});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    imageUrl = json['image_url'];
    if (json['sku_response'] != null) {
      skuResponse = <SkuResponseDetails>[];
      json['sku_response'].forEach((v) {
        skuResponse!.add(new SkuResponseDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    if (this.skuResponse != null) {
      data['sku_response'] = this.skuResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkuResponseDetails {
  String? sku;
  int? inventory;
  String? skuSize;
  String? infoMsg;

  SkuResponseDetails({this.sku, this.inventory, this.skuSize, this.infoMsg});

  SkuResponseDetails.fromJson(Map<String, dynamic> json) {
    sku = json['sku'];
    inventory = json['inventory'];
    skuSize = json['sku_size'];
    infoMsg = json['info_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sku'] = this.sku;
    data['inventory'] = this.inventory;
    data['sku_size'] = this.skuSize;
    data['info_msg'] = this.infoMsg;
    return data;
  }
}