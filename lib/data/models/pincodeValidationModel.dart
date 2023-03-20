import './message.dart';

class PincodeValidationModel {
  bool? success;
  dynamic message;
  String? code;
  PincodeValidationData? data;

  PincodeValidationModel({this.success, this.message, this.code, this.data});

  PincodeValidationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if(json['message'] != null){
      if (json['message'].runtimeType == String) {
        message = json['message'];
      }
      else{
        message = [];
        json['message'].forEach((v) {
          message!.add(new Message.fromJson(v));
        });
      }
    }
    code = json['code'];
    data = json['data'] != null ? new PincodeValidationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.message != null) {
      if(this.message.runtimeType == String){
        data['message'] = this.message;
      }
      else{
        data['message'] = this.message!.map((v) => v.toJson()).toList();
      }
    }
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}


class PincodeValidationData {
  String? city;
  String? state;

  PincodeValidationData({this.city, this.state});

  PincodeValidationData.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['state'] = this.state;
    return data;
  }
}