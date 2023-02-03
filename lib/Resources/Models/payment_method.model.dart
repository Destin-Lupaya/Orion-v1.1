class PaymentMethodModel {
  final int? id;
  final String name, number, type;
  final String? cvv, expirationData, billsAddress;
  final int users_id, isDefault;

  PaymentMethodModel(
      {required this.name,
      required this.number,
      this.cvv,
      this.expirationData,
      this.billsAddress,
      required this.type,
      required this.users_id,
      required this.isDefault,
      this.id});
  static fromJson(json) {
    return PaymentMethodModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      name: json['name'].toString(),
      number: json['number'].toString(),
      cvv: json['cvv'],
      expirationData: json['expirationData'],
      billsAddress: json['billsAddress'],
      type: json['type'].toString(),
      users_id: int.parse(json['users_id'].toString()),
      isDefault: int.parse(json['isDefault'].toString()),
    );
  }

  toJson() {
    return {
      "id": id.toString(),
      "name": name.toString(),
      "number": number.toString(),
      "cvv": cvv.toString(),
      "expirationData": expirationData.toString(),
      "billsAddress": billsAddress.toString(),
      "type": type.toString(),
      "users_id": users_id.toString(),
      "isDefault": isDefault.toString(),
    };
  }
}
