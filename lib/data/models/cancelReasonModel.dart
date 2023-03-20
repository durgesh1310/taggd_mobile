import 'message.dart';

class CancelReasonModel {
  bool? success;
  List<Message>? message;
  String? code;
  Data? data;

  CancelReasonModel({this.success, this.message, this.code, this.data});

  CancelReasonModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isPopupRequired;
  List<Reasons>? reasons;

  Data({this.isPopupRequired, this.reasons});

  Data.fromJson(Map<String, dynamic> json) {
    isPopupRequired = json['is_popup_required'];
    if (json['reasons'] != null) {
      reasons = <Reasons>[];
      json['reasons'].forEach((v) {
        reasons!.add(new Reasons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_popup_required'] = this.isPopupRequired;
    if (this.reasons != null) {
      data['reasons'] = this.reasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reasons {
  int? reasonId;
  String? reason;

  Reasons({this.reasonId, this.reason});

  Reasons.fromJson(Map<String, dynamic> json) {
    reasonId = json['reason_id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason_id'] = this.reasonId;
    data['reason'] = this.reason;
    return data;
  }
}