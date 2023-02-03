class BankModel {
  final String institution, address, accountName, accountNumber;
  final int? id;
  final int users_id;
  BankModel(
      {required this.institution,
      required this.address,
      required this.accountName,
      required this.accountNumber,
      this.id,
      required this.users_id});

  static fromJson(json) {
    return BankModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      users_id: int.parse(json['users_id'].toString()),
      address: json['address'].toString(),
      institution: json['institution'].toString(),
      accountName: json['accountName'].toString(),
      accountNumber: json['accountNumber'].toString(),
    );
  }

  toJson() {
    return {
      "id": id.toString(),
      "users_id": users_id.toString(),
      "address": address.toString(),
      "institution": institution.toString(),
      "accountName": accountName.toString(),
      "accountNumber": accountNumber.toString(),
    };
  }
}
