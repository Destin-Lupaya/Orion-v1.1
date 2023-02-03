import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/Helpers/transaction.helper.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

class CashUpdateHelper {
  static TransactionsStateProvider? _transactionProvider;
  static TransactionsStateProvider getProvider({required bool listen}) {
    _transactionProvider = Provider.of<TransactionsStateProvider>(
        navKey.currentContext!,
        listen: listen);
    return _transactionProvider!;
  }

  static updateCashHelper(
      {required String montant,
      required String paymentType,
      required String operationType,
      required String devise}) {
    TransactionTypeEnum operationTypeEnum;
    if (getProvider(listen: false)
        .targetedActivity['cashOut']
        .toString()
        .trim()
        .toLowerCase()
        .contains(operationType.toLowerCase())) {
      operationTypeEnum = TransactionTypeEnum.cashOut;
    } else {
      operationTypeEnum = TransactionTypeEnum.cashIn;
    }
    if (double.parse(getProvider(listen: false)
                .accountData['sold_cash_cdf']
                .toString()
                .trim()) <
            double.parse(montant) &&
        devise.toLowerCase() == 'cdf' &&
        operationTypeEnum == TransactionTypeEnum.cashOut) {
      Message.showToast(
          msg: "Impossible de faire , solde cash CDF insuffisant");
      return null;
    }
    if (double.parse(getProvider(listen: false)
                .accountData['sold_cash_usd']
                .toString()
                .trim()) <
            double.parse(montant) &&
        devise.toLowerCase() == 'usd' &&
        operationTypeEnum == TransactionTypeEnum.cashOut) {
      Message.showToast(
          msg: "Impossible de faire le retrait, solde cash CDF insuffisant");
      return null;
    }
    double? cashUSD, cashCDF;
    if (operationTypeEnum == TransactionTypeEnum.cashOut) {
      if (paymentType.toString().toLowerCase() == 'cash') {
        if (devise.toLowerCase() == 'usd') {
          cashUSD = double.parse(getProvider(listen: false)
                  .accountData['sold_cash_usd']
                  .toString()
                  .trim()) -
              double.parse(montant);
        }
        if (devise.toLowerCase() == 'cdf') {
          cashCDF = double.parse(getProvider(listen: false)
                  .accountData['sold_cash_cdf']
                  .toString()
                  .trim()) -
              double.parse(montant);
        }
      }
    }
    if (operationTypeEnum == TransactionTypeEnum.cashIn) {
      if (paymentType.toString().toLowerCase() == 'cash') {
        if (devise.toLowerCase() == 'usd') {
          cashUSD = double.parse(getProvider(listen: false)
                  .accountData['sold_cash_usd']
                  .toString()
                  .trim()) +
              double.parse(montant);
        }
        if (devise.toLowerCase() == 'cdf') {
          cashCDF = double.parse(getProvider(listen: false)
                  .accountData['sold_cash_cdf']
                  .toString()
                  .trim()) +
              double.parse(montant);
        }
      }
    }
    Map updatedSoldData = {
      "cashCDF": cashCDF,
      "cashUSD": cashUSD,
    };
    // print(updatedSoldData);
    if (cashCDF == null && cashUSD == null) {
      return null;
    }

    return updatedSoldData;
  }

  /**
   * Updating virtual account
   * Check if the amount is lower than the balance
   * Check if the activity allows to go to negative sold
   */

  static updateVirtualHelper(
      {required String montant,
      required String paymentType,
      required String operationType,
      required String devise,
      required bool hasNegativeSold}) {
    TransactionTypeEnum operationTypeEnum;
    PaymentTypeEnum paymentTypeEnum;
    if (getProvider(listen: false)
        .targetedActivity['cashOut']
        .toString()
        .trim()
        .toLowerCase()
        .contains(operationType.toLowerCase())) {
      operationTypeEnum = TransactionTypeEnum.cashOut;
    } else {
      operationTypeEnum = TransactionTypeEnum.cashIn;
    }
    if (paymentType.toLowerCase().contains('pret')) {
      paymentTypeEnum = PaymentTypeEnum.pret;
    } else if (paymentType.toLowerCase().contains('emprunt')) {
      paymentTypeEnum = PaymentTypeEnum.emprunt;
    } else {
      paymentTypeEnum = PaymentTypeEnum.cash;
    }
    if (double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) <
            double.parse(montant) &&
        hasNegativeSold == false &&
        devise.toLowerCase() == 'usd' &&
        (operationTypeEnum == TransactionTypeEnum.cashIn &&
            paymentTypeEnum == PaymentTypeEnum.pret)) {
      Message.showToast(
          msg:
              "Impossible de finaliser l'opération, solde virtuel USD insuffisant");
      return null;
    }

    if (double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) <
            double.parse(montant) &&
        hasNegativeSold == false &&
        devise.toLowerCase() == 'cdf' &&
        (operationTypeEnum == TransactionTypeEnum.cashIn &&
            paymentTypeEnum == PaymentTypeEnum.cash)) {
      Message.showToast(
          msg:
              "Impossible de finaliser l'opération, solde virtuel CDF insuffisant");
      return null;
    }

    double? virtuelUSD, virtuelCDF;
    if (operationTypeEnum == TransactionTypeEnum.cashOut &&
        paymentTypeEnum == PaymentTypeEnum.cash) {
      if (devise.toLowerCase() == 'usd') {
        virtuelUSD = double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) +
            double.parse(montant);
      }
      if (devise.toLowerCase() == 'cdf') {
        virtuelCDF = double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
      }
    }
    if (operationTypeEnum == TransactionTypeEnum.cashIn &&
        paymentTypeEnum == PaymentTypeEnum.cash) {
      if (devise.toLowerCase() == 'usd') {
        virtuelUSD = double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) -
            double.parse(montant);
      }

      if (devise.toLowerCase() == 'cdf') {
        virtuelCDF = double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) -
            double.parse(montant);
      }
    }

    /**
     * Virtual pret and emprunt management as payment type, independant with the operation type
     */
    if (paymentTypeEnum == PaymentTypeEnum.emprunt) {
      if (devise.toLowerCase() == 'usd') {
        virtuelUSD = double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) +
            double.parse(montant);
      }
      if (devise.toLowerCase() == 'cdf') {
        virtuelCDF = double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
      }
    }
    if (paymentTypeEnum == PaymentTypeEnum.pret) {
      if (devise.toLowerCase() == 'usd') {
        virtuelUSD = double.parse(getProvider(listen: false)
                .accountActivity['virtual_usd']
                .toString()
                .trim()) -
            double.parse(montant);
      }

      if (devise.toLowerCase() == 'cdf') {
        virtuelCDF = double.parse(getProvider(listen: false)
                .accountActivity['virtual_cdf']
                .toString()
                .trim()) -
            double.parse(montant);
      }
    }
    Map updatedSoldData = {
      "virtuelUSD": virtuelUSD,
      "virtuelCDF": virtuelCDF,
    };
    // print(updatedSoldData);
    if (virtuelCDF == null && virtuelUSD == null) {
      return null;
    }

    return updatedSoldData;
  }

  /**
   * Updating pret account
   */

  static updatePretEmpruntHelper(
      {required String montant,
      required String paymentType,
      required String operationType,
      required String devise}) {
    TransactionTypeEnum? operationTypeEnum;
    PaymentTypeEnum? paymentTypeEnum;
    if (paymentType.trim().toLowerCase().contains('pret')) {
      paymentTypeEnum = PaymentTypeEnum.pret;
    }
    if (paymentType.trim().toLowerCase().contains('emprunt')) {
      paymentTypeEnum = PaymentTypeEnum.emprunt;
    }
    double? pretUSD, pretCDF, empruntUSD, empruntCDF;
    if (paymentTypeEnum == PaymentTypeEnum.pret) {
      if (devise.toLowerCase() == 'usd') {
        pretUSD = double.parse(getProvider(listen: false)
                .accountData['sold_pret_usd']
                .toString()
                .trim()) +
            double.parse(montant);
      }
      if (devise.toLowerCase() == 'cdf') {
        pretCDF = double.parse(getProvider(listen: false)
                .accountData['sold_pret_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
      }
    }
    if (paymentTypeEnum == PaymentTypeEnum.emprunt) {
      if (devise.toLowerCase() == 'usd') {
        empruntUSD = double.parse(getProvider(listen: false)
                .accountData['sold_emprunt_usd']
                .toString()
                .trim()) +
            double.parse(montant);
      }
      if (devise.toLowerCase() == 'cdf') {
        empruntCDF = double.parse(getProvider(listen: false)
                .accountData['sold_emprunt_cdf']
                .toString()
                .trim()) +
            double.parse(montant);
      }
    }
    Map updatedSoldData = {
      "pretCDF": pretCDF,
      "pretUSD": pretUSD,
      "empruntCDF": empruntCDF,
      "empruntUSD": empruntUSD,
    };
    // print(updatedSoldData);
    if (pretCDF == null &&
        pretUSD == null &&
        empruntCDF == null &&
        empruntUSD == null) {
      return null;
    }

    return updatedSoldData;
  }
}
