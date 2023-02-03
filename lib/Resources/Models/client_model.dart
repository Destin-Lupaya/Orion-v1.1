class ClientModel {
  final int? id;
  final String? password;
  final String? fname;
  final String code;
  final String? lname;
  final String? pname;
  final String? names;
  final String? dob;
  final String? genre;
  final String? marriagestatus;
  final String? country;
  final String? address;
  final String? telephone;
  final String? email;
  final String? username;
  final String role;
  final String status;

  ClientModel(
      {this.id,
      required this.code,
      this.password,
      this.fname,
      this.lname,
      this.names,
      required this.pname,
      this.dob,
      this.genre,
      this.marriagestatus,
      this.country,
      this.address,
      this.telephone,
      this.email,
      this.username,
      required this.role, required this.status});
  static fromJson(json) {
    // print(json);
    return ClientModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      code: json['code'],
      password: json['psw'],
      fname: json['fname'],
      lname: json['lname'],
      pname: json['pname'],
      names: json['names'],
      genre: json['genre'],
      dob: json['dob'],
      marriagestatus: json['marriagestatus'],
      country: json['country'],
      address: json['address'],
      telephone: json['telephone'],
      email: json['email'],
      role: json['role'],
      username: json['username'],
      status: json['statusActive']==1?"Oui":"Non",
    );
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      if (password != null && password != 'null')
        "code": code.toString().trim(),
        "psw": password.toString().trim(),
      "fname": fname.toString().trim(),
      "lname": lname.toString().trim(),
      "pname": pname.toString().trim(),
      "names": names.toString().trim(),
      if (dob != null) "dob": dob.toString().trim(),
      "genre": genre.toString().trim(),
      "marriagestatus": marriagestatus.toString().trim(),
      "country": country.toString().trim(),
      "address": address.toString().trim(),
      "telephone": telephone.toString().trim(),
      "email": email.toString().trim(),
      "role": role.toString().trim(),
      "username": username.toString().trim(),
      "statusActive": status.toString().trim()
    };
  }
}
