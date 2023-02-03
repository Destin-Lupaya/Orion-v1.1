class EmployerModel {
  final int? id;
  final String names;
  final String domain;
  final String startContract;
  final String? EndContract;
  final String address, email, telephone;
  final int users_id;
  EmployerModel(
      {this.id,
      required this.names,
      required this.domain,
      required this.startContract,
      required this.EndContract,
      required this.address,
      required this.telephone,
      required this.email,
      required this.users_id});

  static fromJson(json) {
    return EmployerModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      names: json['names'].toString(),
      domain: json['domain'].toString(),
      startContract: json['startContract'].toString(),
      EndContract: json['EndContract'].toString(),
      address: json['address'].toString(),
      telephone: json['telephone'].toString(),
      email: json['email'].toString(),
      users_id: int.parse(json['users_id'].toString()),
    );
  }

  toJson() {
    return {
      "id": id.toString(),
      "names": names.toString(),
      "domain": domain.toString(),
      "startContract": startContract.toString(),
      "EndContract": EndContract.toString(),
      "address": address.toString(),
      "telephone": telephone.toString(),
      "email": email.toString(),
      "users_id": users_id.toString(),
    };
  }
}
