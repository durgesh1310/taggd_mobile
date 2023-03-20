import './message.dart';

class SuggestionModel {
  bool success = false;
  List<Message>? message;
  String? code;
  List<SugestionData>? data;

  SuggestionModel({
    required this.success,
    this.message,
    this.code,
    this.data});

  SuggestionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['message'] != null) {
      message = [];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    code = json['code'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new SugestionData.fromJson(v));
      });
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
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SugestionData {
  String? id;
  String? suggest;
  String? thumbNail;

  SugestionData({this.id, this.suggest, this.thumbNail});

  SugestionData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    suggest = json['suggest'] ?? "";
    thumbNail = json['thumb_nail'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['suggest'] = this.suggest;
    data['thumb_nail'] = this.thumbNail;
    return data;
  }
}