class CaisseModel {
  int? id, branch_id;
  final int created_users_id;
  final String caissier;
  final String caissierName;
  final double solde_cash_CDF;
  final double solde_cash_USD;
  final double stock;
  final double? solde_pret_cdf;
  final double? solde_pret_usd;
  final double? solde_emprunt_cdf;
  final double? solde_emprunt_usd;
  final String? active;
  List activities;

  CaisseModel(
      {this.id,
      required this.caissier,
      required this.caissierName,
      required this.solde_cash_CDF,
      required this.solde_cash_USD,
      required this.stock,
      this.solde_pret_cdf,
      this.solde_pret_usd,
      this.solde_emprunt_cdf,
      this.solde_emprunt_usd,
      this.branch_id,
      required this.activities,
      required this.active,
      required this.created_users_id});

  static fromJson(json) {
    return CaisseModel(
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
        caissier: json['users_id'].toString().trim(),
        caissierName: json['names'].toString().trim(),
        solde_cash_CDF: double.tryParse(json['sold_cash_cdf'].toString()) ?? 0,
        solde_cash_USD: double.tryParse(json['sold_cash_usd'].toString()) ?? 0,
        stock: double.tryParse(json['stock'].toString()) ?? 0,
        solde_pret_usd: json['sold_pret_usd'] != null
            ? double.parse(json['sold_pret_usd'].toString())
            : 0,
        solde_pret_cdf: json['sold_pret_cdf'] != null
            ? double.parse(json['sold_pret_cdf'].toString())
            : 0,
        solde_emprunt_cdf: json['sold_emprunt_cdf'] != null
            ? double.parse(json['sold_emprunt_cdf'].toString())
            : 0,
        solde_emprunt_usd: json['sold_emprunt_usd'] != null
            ? double.parse(json['sold_emprunt_usd'].toString())
            : 0,
        branch_id: json['branch_id'] != null
            ? int.parse(json['branch_id'].toString())
            : 0,
        activities: json['activities'] ?? [],
        active: json['statusActive'].toString(),
        created_users_id: int.parse(json['created_users_id'].toString()));
  }

  toJson() {
    return {
      "id": id.toString().trim(),
      "users_id": caissier.toString().trim(),
      "names": caissierName.toString().trim(),
      "sold_cash_cdf": solde_cash_CDF.toString(),
      "sold_cash_usd": solde_cash_USD.toString(),
      "stock": stock.toString(),
      "sold_pret_usd": solde_pret_usd.toString(),
      "sold_pret_cdf": solde_pret_cdf.toString(),
      "sold_emprunt_usd": solde_emprunt_usd.toString(),
      "sold_emprunt_cdf": solde_emprunt_cdf.toString(),
      "branch_id": branch_id.toString(),
      "created_users_id": created_users_id.toString(),
      "activities": activities,
      "statusActive": active,
    };
  }
}
