class Bank {
  List<Data>? data;

  Bank({this.data});

  Bank.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? shortName;
  String? bankName;
  String? address;
  String? phoneLandLine;
  String? emailAddress;
  String? logo;

  Data(
      {this.id,
        this.shortName,
        this.bankName,
        this.address,
        this.phoneLandLine,
        this.emailAddress,
        this.logo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortName = json['short_name'];
    bankName = json['bank_name'];
    address = json['address'];
    phoneLandLine = json['phone_land_line'];
    emailAddress = json['email_address'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['short_name'] = this.shortName;
    data['bank_name'] = this.bankName;
    data['address'] = this.address;
    data['phone_land_line'] = this.phoneLandLine;
    data['email_address'] = this.emailAddress;
    data['logo'] = this.logo;
    return data;
  }
}
