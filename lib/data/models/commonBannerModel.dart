import 'message.dart';

class CommonBannerModel {
  bool? success;
  List<Message>? message;
  String? code;
  CommonBannerData? data;

  CommonBannerModel({this.success, this.message, this.code, this.data});

  CommonBannerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    data = json['data'] != null ? new CommonBannerData.fromJson(json['data']) : null;
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

class CommonBannerData {
  String? imageWeb;
  String? imageMobile;
  String? url;
  String? action;
  String? type;
  int? mobileBannerId;

  CommonBannerData({
    this.imageWeb,
    this.imageMobile,
    this.url,
    this.action,
    this.type,
    this.mobileBannerId});

  CommonBannerData.fromJson(Map<String, dynamic> json) {
    imageWeb = json['image_web'];
    imageMobile = json['image_mobile'] == "" ? null : json['image_mobile'];
    url = json['url'];
    action = json['action'];
    type = json['type'];
    mobileBannerId = json['mobile_banner_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_web'] = this.imageWeb;
    data['image_mobile'] = this.imageMobile;
    data['url'] = this.url;
    data['action'] = this.action;
    data['type'] = this.type;
    data['mobile_banner_id'] = this.mobileBannerId;
    return data;
  }
}