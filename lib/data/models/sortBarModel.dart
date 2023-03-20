class SortBarModel {
   bool? success = false;
  String? code = "";
  List<SortBarData>? data = [];

  SortBarModel({
    this.success,
     this.code,
     this.data
  });

  SortBarModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new SortBarData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SortBarData {
  int? id;
  int? sortBarId;
  String? name;
  String? icon;
  String? action;
  String? type;
  String? createdBy;
  int? createdDate;
  String? updatedBy;
  int? updatedDate;

  SortBarData({
        required this.id,
        required this.sortBarId,
        required this.name,
        required this.icon,
        required this.action,
        required this.type,
        required this.createdBy,
        required this.createdDate,
        required this.updatedBy,
        required this.updatedDate});

  SortBarData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    sortBarId = json['sortBarId'] ?? 0;
    name = json['name'] ?? "";
    icon = json['icon'] ?? "";
    action = json['action'] ?? "";
    type = json['type'] ?? "";
    createdBy = json['createdBy'] ?? "";
    createdDate = json['createdDate'] ?? 0;
    updatedBy = json['updatedBy'] ?? "";
    updatedDate = json['updatedDate'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sortBarId'] = this.sortBarId;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['action'] = this.action;
    data['type'] = this.type;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['updatedBy'] = this.updatedBy;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}