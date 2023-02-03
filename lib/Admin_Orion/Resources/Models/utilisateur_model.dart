class ClientModel {
  int? id;
  final String? password;
  final String? telephone;
  final String? email;
  final String username;
  final String role;
  final String names;
  final String code;
  final String? pin;
  final String statusActive;
  final String? avatar;

  ClientModel({
    this.id,
    this.password,
    required this.names,
    this.telephone,
    this.email,
    required this.username,
    required this.role,
    required this.code,
    this.pin,
    required this.statusActive,
    this.avatar,
  });
  static fromJson(json) {
    // print(json);
    return ClientModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      password: json['psw'],
      names: json['names'],
      telephone: json['telephone'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      code: json['code'],
      pin: json['pin'].toString(),
      statusActive: json['statusActive'].toString(),
      avatar: json['avatar'],
    );
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      if (password != null && password != 'null')
        "psw": password.toString().trim(),
      "names": names.toString().trim(),
      "telephone": telephone.toString().trim(),
      "username": username.toString().trim(),
      "email": email.toString().trim(),
      "role": role.toString().trim(),
      "code": code.toString().trim(),
      "statusActive": statusActive.toString().trim(),
    };
  }
}
