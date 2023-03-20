import 'dart:convert';
import 'message.dart';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(jsonDecode(str));

String categoryModelToJson(CategoryModel categoryModel) => jsonEncode(categoryModel.toJson());

class CategoryModel {
  bool? success;
  List<Message>? message;
  String? code;
  Data? data;

  CategoryModel({this.success, this.message, this.code, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? categoryName;
  List<RootParentChildResponse>? rootParentChildResponse;

  Data({this.id, this.categoryName, this.rootParentChildResponse});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    categoryName = json['category_name'] == null ? "" : json['category_name'];
    if (json['root_parent_child_response'] != null) {
      rootParentChildResponse = [];
      json['root_parent_child_response'].forEach((v) {
        rootParentChildResponse!.add(new RootParentChildResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    if (this.rootParentChildResponse != null) {
      data['root_parent_child_response'] =
          this.rootParentChildResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RootParentChildResponse {
  int? id;
  String? nodeTitle;
  String? icon;
  List<ParentChildResponse>? parentChildResponse;
  bool? leaf;
  String? action;
  String? type;

  RootParentChildResponse(
      {this.id,
        this.nodeTitle,
        this.icon,
        this.parentChildResponse,
        this.leaf,
        this.action,
        this.type});

  RootParentChildResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    nodeTitle = json['node_title'] == null ? "" : json['node_title'];
    icon = json['icon'] == null ? "" : json['icon'];
    if (json['parent_child_response'] != null) {
      parentChildResponse = [];
      json['parent_child_response'].forEach((v) {
        parentChildResponse!.add(new ParentChildResponse.fromJson(v));
      });
    }
    leaf = json['leaf'] == null ? true : json['leaf'];
    action = json['action'] == null ? "" : json['action'];
    type = json['type'] == null ? "" : json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['node_title'] = this.nodeTitle;
    data['icon'] = this.icon;
    if (this.parentChildResponse != null) {
      data['parent_child_response'] =
          this.parentChildResponse!.map((v) => v.toJson()).toList();
    }
    data['leaf'] = this.leaf;
    data['action'] = this.action;
    data['type'] = this.type;
    return data;
  }
}

class ParentChildResponse {
  int? id;
  int? rootId;
  String? nodeTitle;
  String? icon;
  List<ChildLevelDetail>? childLevelDetail;
  bool? leaf;
  String? action;
  String? type;

  ParentChildResponse(
      {this.id, this.rootId, this.nodeTitle, this.icon, this.childLevelDetail, this.leaf, this.action,
        this.type});

  ParentChildResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    rootId = json['root_id'] == null ? 0 : json['root_id'];
    nodeTitle = json['node_title'] == null ? "" : json['node_title'];
    icon = json['icon'] == null ? "" : json['icon'];
    if (json['child_level_detail'] != null) {
      childLevelDetail = [];
      json['child_level_detail'].forEach((v) {
        childLevelDetail!.add(new ChildLevelDetail.fromJson(v));
      });
    }
    leaf = json['leaf'] == null ? true : json['leaf'];
    action = json['action'] == null ? "" : json['action'];
    type = json['type'] == null ? "" : json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['root_id'] = this.rootId;
    data['node_title'] = this.nodeTitle;
    data['icon'] = this.icon;
    if (this.childLevelDetail != null) {
      data['child_level_detail'] =
          this.childLevelDetail!.map((v) => v.toJson()).toList();
    }
    data['leaf'] = this.leaf;
    data['action'] = this.action;
    data['type'] = this.type;
    return data;
  }
}

class ChildLevelDetail {
  int? id;
  int? rootId;
  int? parentId;
  String? nodeTitle;
  String? action;
  String? type;
  bool? leaf;

  ChildLevelDetail(
      {this.id,
        this.rootId,
        this.parentId,
        this.nodeTitle,
        this.action,
        this.type,
        this.leaf});

  ChildLevelDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    rootId = json['root_id'] == null ? 0 : json['root_id'];
    parentId = json['parent_id'] == null ? 0 : json['parent_id'];
    nodeTitle = json['node_title'] == null ? "" : json['node_title'];
    action = json['action'] == null ? "" : json['action'];
    type = json['type'] == null ? "" : json['type'];
    leaf = json['leaf'] == null ? true : json['leaf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['root_id'] = this.rootId;
    data['parent_id'] = this.parentId;
    data['node_title'] = this.nodeTitle;
    data['action'] = this.action;
    data['type'] = this.type;
    data['leaf'] = this.leaf;
    return data;
  }
}