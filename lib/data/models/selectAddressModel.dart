class SelectAddressModel {
  bool? success;
  String? code;
  List<SelectAddressData>? data;

  SelectAddressModel({this.success, this.code, this.data});

  SelectAddressModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new SelectAddressData.fromJson(v));
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

class SelectAddressData {
  String? fullName;
  int? pincode;
  String? address;
  String? landmark;
  String? city;
  String? state;
  String? mobile;
  int? addressId;
  bool? isSelected;

  SelectAddressData(
      {this.fullName,
        this.pincode,
        this.address,
        this.landmark,
        this.city,
        this.state,
        this.mobile,
        this.addressId,
        this.isSelected
      });

  SelectAddressData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'] ?? "";
    pincode = json['pincode'] ?? 0;
    address = json['address'] ?? "";
    landmark = json['landmark'] ?? "";
    city = json['city'] ?? "";
    state = json['state'] ?? "";
    mobile = json['mobile'] ?? "";
    addressId = json['address_id'] ?? 0;
    isSelected = json['is_selected'] == null ? false : json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['state'] = this.state;
    data['mobile'] = this.mobile;
    data['address_id'] = this.addressId;
    data['is_selected'] = this.isSelected;
    return data;
  }
}