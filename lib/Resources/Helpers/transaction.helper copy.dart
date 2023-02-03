import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Helpers/cash.helper.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class TransactionHelper {
  static TransactionsStateProvider? _transactionProvider;

  static TransactionsStateProvider getProvider({required bool listen}) {
    _transactionProvider = Provider.of<TransactionsStateProvider>(
        navKey.currentContext!,
        listen: listen);
    return _transactionProvider!;
  }

  static updateData(
      {required String typeOperation,
      required String typePayment,
      required String devise,
      required String montant,
      required String quantity}) {
    bool hasNegativeSold =
        getProvider(listen: false).targetedActivity['hasNegativeSold'] == 1
            ? true
            : false;
    double? cashUSD,
        cashCDF,
        virtuelUSD,
        virtuelCDF,
        pretCDF,
        pretUSD,
        empruntCDF,
        empruntUSD,
        stock;
    if (getProvider(listen: false).targetedActivity['hasStock'] == 1) {
      if (double.tryParse(quantity) == null || double.parse(quantity) == 0) {
        Message.showToast(msg: "Quantité invalide");
        return null;
      }
      if (double.parse(quantity) >
          getProvider(listen: false).accountActivity['stock']) {
        Message.showToast(msg: "Le stock de cette activité est insuffisant");
        return null;
      }
      if (typePayment.toLowerCase().contains('pret') ||
          typePayment.toLowerCase().contains('emprunt')) {
        Message.showToast(msg: "Ce type d'operation n'est pas disponible");
        return null;
      }
      Map? cash = CashUpdateHelper.updateCashHelper(
          montant: montant,
          paymentType: typePayment,
          operationType: typeOperation,
          devise: devise);
      if (getProvider(listen: false)
          .targetedActivity['cashOut']
          .toString()
          .trim()
          .toLowerCase()
          .contains(typeOperation.toLowerCase())) {
        stock = double.parse(getProvider(listen: false)
                .accountActivity['stock']
                .toString()
                .trim()) +
            double.parse(quantity);
      } else {}
      if (devise.toLowerCase() == 'cdf') {
        if (getProvider(listen: false)
            .targetedActivity['cashOut']
            .toString()
            .trim()
            .toLowerCase()
            .contains(typeOperation.toLowerCase())) {
          if (typePayment.toString().toLowerCase() == 'cash') {
            cashCDF = double.parse(getProvider(listen: false)
                    .accountData['sold_cash_cdf']
                    .toString()
                    .trim()) -
                double.parse(montant);
          }
          stock = double.parse(getProvider(listen: false)
                  .accountActivity['stock']
                  .toString()
                  .trim()) +
              double.parse(quantity);
        }
        if (getProvider(listen: false)
            .targetedActivity['cashIn']
            .toString()
            .trim()
            .toLowerCase()
            .contains(typeOperation.toLowerCase())) {
          if (typePayment.toString().toLowerCase() == 'cash') {
            cashCDF = double.parse(getProvider(listen: false)
                    .accountData['sold_cash_cdf']
                    .toString()
                    .trim()) +
                double.parse(montant);
          }
          stock = double.parse(getProvider(listen: false)
                  .accountActivity['stock']
                  .toString()
                  .trim()) -
              double.parse(quantity);
        }
      }
      if (devise.toLowerCase() == 'usd') {
        if (getProvider(listen: false)
            .targetedActivity['cashIn']
            .toString()
            .trim()
            .toLowerCase()
            .contains(typeOperation.toLowerCase())) {
          if (typePayment.toString().toLowerCase() == 'cash') {
            cashUSD = double.parse(getProvider(listen: false)
                    .accountData['sold_cash_usd']
                    .toString()
                    .trim()) +
                double.parse(montant);
          }
          stock = double.parse(getProvider(listen: false)
                  .accountActivity['stock']
                  .toString()
                  .trim()) -
              double.parse(quantity);
        }
        if (getProvider(listen: false)
            .targetedActivity['cashOut']
            .toString()
            .trim()
            .toLowerCase()
            .contains(typeOperation.toLowerCase())) {
          if (typePayment.toString().toLowerCase() == 'cash') {
            cashUSD = double.parse(getProvider(listen: false)
                    .accountData['sold_cash_usd']
                    .toString()
                    .trim()) -
                double.parse(montant);
          }
          stock = double.parse(getProvider(listen: false)
                  .accountActivity['stock']
                  .toString()
                  .trim()) +
              double.parse(quantity);
        }
      }
    } else {
      if (devise.toLowerCase() == 'cdf' &&
          typeOperation.toLowerCase().contains(getProvider(listen: false)
              .targetedActivity['cashOut']
              .toString()
              .trim()
              .toLowerCase()) &&
          typePayment.toLowerCase().trim() == 'cash') {
        if (double.parse(getProvider(listen: false)
                .accountData['sold_cash_cdf']
                .toString()
                .trim()) <
            double.parse(montant)) {
          Message.showToast(
              msg:
                  "Impossible de faire le retrait, solde cash CDF insuffisant");
          return null;
        }

        cashCDF = double.parse(getProvider(listen: false)
                .accountData['sold_cash_cdf']
                .toString()
                .trim()) -
            double.parse(montant);
        virtuelCDF = double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
      }
      //Withdrawal USD
      if (devise.toLowerCase() == 'usd' &&
          typeOperation.toLowerCase().contains(getProvider(listen: false)
              .targetedActivity['cashOut']
              .toString()
              .trim()
              .toLowerCase()) &&
          typePayment.toLowerCase().trim() == 'cash') {
        if (double.parse(getProvider(listen: false)
                .accountData['sold_cash_usd']
                .toString()
                .trim()) <
            double.parse(montant)) {
          Message.showToast(
              msg:
                  "Impossible de faire le retrait, solde cash USD insuffisant");
          return null;
        }
        cashUSD = double.parse(getProvider(listen: false)
                .accountData['sold_cash_usd']
                .toString()
                .trim()) -
            double.parse(montant);
        virtuelUSD = double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) +
            double.parse(montant);
      }
      //Deposit USD
      if (devise.toLowerCase() == 'usd' &&
          typeOperation.toLowerCase() ==
              getProvider(listen: false)
                  .targetedActivity['cashIn']
                  .toString()
                  .trim()
                  .toLowerCase() &&
          typePayment.toLowerCase().trim() == 'cash') {
        if (double.parse(getProvider(listen: false)
                    .accountActivity['virtual_usd']
                    .toString()
                    .trim()) <
                double.parse(montant) &&
            hasNegativeSold == false) {
          Message.showToast(
              msg:
                  "Impossible de finaliser l'opération, solde virtuel USD insuffisant");
          return null;
        }
        cashUSD = double.parse(getProvider(listen: false)
                .accountData['sold_cash_usd']
                .toString()
                .trim()) +
            double.parse(montant);
        virtuelUSD = double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) -
            double.parse(montant);
      }
      if (devise.toLowerCase() == 'cdf' &&
          typeOperation.toLowerCase() ==
              getProvider(listen: false)
                  .targetedActivity['cashIn']
                  .toString()
                  .trim()
                  .toLowerCase() &&
          typePayment.toLowerCase().trim() == 'cash') {
        if (double.parse(getProvider(listen: false)
                    .accountActivity['virtual_cdf']
                    .toString()
                    .trim()) <
                double.parse(montant) &&
            hasNegativeSold == false) {
          Message.showToast(
              msg:
                  "Impossible de finaliser l'opération, solde virtuel CDF insuffisant");
          return null;
        }
        cashCDF = double.parse(getProvider(listen: false)
                .accountData['sold_cash_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
        virtuelCDF = double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) -
            double.parse(montant);
      }

      //========================= Pret externe CDF=========================

      if (devise.toLowerCase() == 'cdf' &&
          typePayment.toLowerCase().contains('pret')) {
        if (double.parse(getProvider(listen: false)
                    .accountActivity['virtual_cdf']
                    .toString()
                    .trim()) <
                double.parse(montant) &&
            hasNegativeSold == false) {
          Message.showToast(
              msg:
                  "Impossible de faire le pret, solde virtuel CDF insuffisant");
          return null;
        }

        pretCDF = double.parse(getProvider(listen: false)
                .accountData['sold_pret_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
        virtuelCDF = double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) -
            double.parse(montant);
      }

      //Pret externe USD
      if (devise.toLowerCase() == 'usd' &&
          typePayment.toLowerCase().contains('pret')) {
        if (double.parse(getProvider(listen: false)
                    .accountActivity['virtual_usd']
                    .toString()
                    .trim()) <
                double.parse(montant) &&
            hasNegativeSold == false) {
          Message.showToast(
              msg:
                  "Impossible de faire le pret, solde virtuel CDF insuffisant");
          return null;
        }

        pretUSD = double.parse(getProvider(listen: false)
                .accountData['sold_pret_usd']
                .toString()
                .trim()) +
            double.parse(montant);
        virtuelUSD = double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) -
            double.parse(montant);
      }

      //========================= Emprunt externe CDF=========================

      if (devise.toLowerCase() == 'cdf' &&
          typePayment.toLowerCase().contains('emprunt')) {
        // if (double.parse(getProvider(listen:false).activeActivity['virtual_cdf'].toString().trim()) <
        //     double.parse(montant)) {
        //   Message.showToast(
        //       msg: "Impossible de faire le pret, solde virtuel CDF insuffisant");
        //   return null;
        // }

        empruntCDF = double.parse(getProvider(listen: false)
                .accountData['sold_emprunt_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
        virtuelCDF = double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
      }

      //Emprunt externe USD
      if (devise.toLowerCase() == 'usd' &&
          typePayment.toLowerCase().contains('emprunt')) {
        // if (double.parse(getProvider(listen:false).activeActivity['virtual_usd'].toString().trim()) <
        //     double.parse(montant)) {
        //   Message.showToast(
        //       msg: "Impossible de faire le pret, solde virtuel CDF insuffisant");
        //   return null;
        // }

        empruntUSD = double.parse(getProvider(listen: false)
                .accountData['sold_emprunt_usd']
                .toString()
                .trim()) +
            double.parse(montant);
        virtuelUSD = double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) +
            double.parse(montant);
      }
    }
    //Withdrawal CDF

    Map updatedSoldData = {
      "stock": stock,
      "cashCDF": cashCDF,
      "cashUSD": cashUSD,
      "virtuelUSD": virtuelUSD,
      "virtuelCDF": virtuelCDF,
      "pretCDF": pretCDF,
      "pretUSD": pretUSD,
      "empruntCDF": empruntCDF,
      "empruntUSD": empruntUSD,
    };
    print(updatedSoldData);
    if (cashCDF == null &&
        cashUSD == null &&
        virtuelCDF == null &&
        virtuelUSD == null &&
        stock == null) {
      return null;
    }

    return updatedSoldData;
  }

  static updateDataRefund(
      {required String typeOperation,
      required String devise,
      required String montant}) {
    double cashUSD = 0,
        cashCDF = 0,
        pretCDF = 0,
        pretUSD = 0,
        empruntCDF = 0,
        empruntUSD = 0;

    //=========================Paiement Pret externe CDF=========================

    if (devise.toLowerCase() == 'cdf' &&
        typeOperation.toLowerCase().contains('pret')) {
      pretCDF = double.parse(getProvider(listen: false)
              .accountData['sold_pret_cdf']
              .toString()
              .trim()) -
          double.parse(montant);
      cashCDF = double.parse(getProvider(listen: false)
              .accountData['sold_cash_cdf']
              .toString()
              .trim()) +
          double.parse(montant);
    }

    //Pret externe USD
    if (devise.toLowerCase() == 'usd' &&
        typeOperation.toLowerCase().contains('pret')) {
      pretUSD = double.parse(getProvider(listen: false)
              .accountData['sold_pret_usd']
              .toString()
              .trim()) -
          double.parse(montant);
      cashUSD = double.parse(getProvider(listen: false)
              .accountData['sold_cash_usd']
              .toString()
              .trim()) +
          double.parse(montant);
    }

    //=========================Paiement Emprunt externe CDF=========================

    if (devise.toLowerCase() == 'cdf' &&
        typeOperation.toLowerCase().contains('emprunt')) {
      if (double.parse(getProvider(listen: false)
              .accountData['sold_cash_cdf']
              .toString()
              .trim()) <
          double.parse(montant)) {
        Message.showToast(
            msg: "Impossible de faire le pret, solde cash CDF insuffisant");
        return null;
      }

      empruntCDF = double.parse(getProvider(listen: false)
              .accountData['sold_emprunt_cdf']
              .toString()
              .trim()) -
          double.parse(montant);
      cashCDF = double.parse(getProvider(listen: false)
              .accountData['sold_cash_cdf']
              .toString()
              .trim()) -
          double.parse(montant);
    }

    //Pret externe USD
    if (devise.toLowerCase() == 'usd' &&
        typeOperation.toLowerCase().contains('emprunt')) {
      if (double.parse(getProvider(listen: false)
              .accountData['sold_cash_usd']
              .toString()
              .trim()) <
          double.parse(montant)) {
        Message.showToast(
            msg: "Impossible de faire le pret, solde cash USD insuffisant");
        return null;
      }

      empruntUSD = double.parse(getProvider(listen: false)
              .accountData['sold_emprunt_usd']
              .toString()
              .trim()) -
          double.parse(montant);
      cashUSD = double.parse(getProvider(listen: false)
              .accountData['sold_cash_usd']
              .toString()
              .trim()) -
          double.parse(montant);
    }

    Map updatedSoldData = {
      "cashCDF": cashCDF,
      "cashUSD": cashUSD,
      "pretCDF": pretCDF,
      "pretUSD": pretUSD,
      "empruntCDF": empruntCDF,
      "empruntUSD": empruntUSD,
    };
    if (cashCDF == 0 && cashUSD == 0) {
      return null;
    }
    // print(updatedSoldData);
    return updatedSoldData;
  }
}
