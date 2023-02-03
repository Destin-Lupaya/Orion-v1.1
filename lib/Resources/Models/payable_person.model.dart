class PayablePersonModel {
  final int? id;
  final String names;
  final String relation;
  final String address, telephone;
  final int payableStatus, users_id;
  final String? email;
  final String? dob;
  final String? acountNumber, nameAcount;
  PayablePersonModel(
      {this.id,
      required this.names,
      required this.relation,
      required this.address,
      required this.telephone,
      this.email,
      this.dob,
      this.nameAcount,
      this.acountNumber,
      required this.users_id,
      required this.payableStatus});

  static fromJson(json) {
    return PayablePersonModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      names: json['names'].toString(),
      relation: json['relation'].toString(),
      address: json['address'].toString(),
      telephone: json['telephone'].toString(),
      email: json['email'].toString(),
      dob: json['dob'].toString(),
      nameAcount: json['nameAcount'].toString(),
      acountNumber: json['acountNumber'].toString(),
      users_id: int.parse(json['users_id'].toString()),
      payableStatus: int.parse(json['payableStatus'].toString()),
    );
  }

  toJson() {
    return {
      "id": id.toString(),
      "names": names.toString(),
      "relation": relation.toString(),
      "address": address.toString().trim(),
      "telephone": telephone.toString().trim(),
      "email": email.toString(),
      "dob": dob.toString().trim(),
      "nameAcount": nameAcount.toString().trim(),
      "acountNumber": acountNumber.toString().trim(),
      "users_id": users_id.toString().trim(),
      "payableStatus": payableStatus.toString().trim(),
    };
  }
}
