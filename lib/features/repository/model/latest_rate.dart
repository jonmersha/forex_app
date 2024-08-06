class LatestRate {
  List<Data>? data;

  LatestRate({this.data});

  LatestRate.fromJson(Map<String, dynamic> json) {
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
  int? rateId;
  String? rateDate;
  int? buyingCash;
  int? buyingTransaction;
  int? sellingCash;
  int? sellingTransaction;
  int? bankId;
  String? shortName;
  String? bankName;
  String? bankEmail;
  int? currencyId;
  String? currencyName;

  Data(
      {this.rateId,
        this.rateDate,
        this.buyingCash,
        this.buyingTransaction,
        this.sellingCash,
        this.sellingTransaction,
        this.bankId,
        this.shortName,
        this.bankName,
        this.bankEmail,
        this.currencyId,
        this.currencyName});

  Data.fromJson(Map<String, dynamic> json) {
    rateId = json['rate_id'];
    rateDate = json['rate_date'];
    buyingCash = json['buying_cash'];
    buyingTransaction = json['buying_transaction'];
    sellingCash = json['selling_cash'];
    sellingTransaction = json['selling_transaction'];
    bankId = json['bank_id'];
    shortName = json['short_name'];
    bankName = json['bank_name'];
    bankEmail = json['bank_email'];
    currencyId = json['currency_id'];
    currencyName = json['currency_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate_id'] = this.rateId;
    data['rate_date'] = this.rateDate;
    data['buying_cash'] = this.buyingCash;
    data['buying_transaction'] = this.buyingTransaction;
    data['selling_cash'] = this.sellingCash;
    data['selling_transaction'] = this.sellingTransaction;
    data['bank_id'] = this.bankId;
    data['short_name'] = this.shortName;
    data['bank_name'] = this.bankName;
    data['bank_email'] = this.bankEmail;
    data['currency_id'] = this.currencyId;
    data['currency_name'] = this.currencyName;
    return data;
  }
}
