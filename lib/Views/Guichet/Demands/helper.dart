import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/AppStateProvider/user_stateprovider.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

enum DemandAction { Update, Validate, Accept, Pay, Terminate }
enum ConnectedUser { Sender, Receiver, None }

class DemandHelper {
  final Map demandData;
  final Map? activityData, accountData, senderInfo, receiverInfo;
  final bool? isCash;
  final String? montant;

  DemandHelper(
      {required this.demandData,
      this.activityData,
      this.accountData,
      this.receiverInfo,
      this.senderInfo,
      this.isCash,
      this.montant});

  updateDemand() {
    Map data = {"demand": demandData};
    // return print(data);
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .demandResponse(
            body: data,
            callback: () {
              // Navigator.pop(navKey.currentContext!);
            });
  }

  updateCashData(
      {required String typeOperation,
      required String devise,
      bool? isRefund = false}) async {
    await Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .getAccountActivities();
    if (Provider.of<TransactionsStateProvider>(navKey.currentContext!,
                listen: false)
            .lastActivitiesCheck !=
        null) {
      if (DateTime.now()
              .difference(Provider.of<TransactionsStateProvider>(
                      navKey.currentContext!,
                      listen: false)
                  .lastActivitiesCheck!)
              .inSeconds >
          5) {
        Message.showToast(
            msg:
                "Impossible d'actualiser votre compte, vérifiez votre connexion puis réessayez");
        return null;
      }
    } else {
      Message.showToast(msg: "Vos soldes ne sont pas actualisés");
      return null;
    }

    double cashRecUSD = 0, cashRecCDF = 0, cashSenderUSD = 0, cashSenderCDF = 0;
    //CDF
    if (devise.toLowerCase() == 'cdf') {
      if (isRefund != null && isRefund == true) {
        if (double.parse(senderInfo!['sold_cash_cdf'].toString().trim()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire le retrait, solde cash CDF insuffisant");
          return null;
        }
        cashSenderCDF =
            double.parse(senderInfo!['sold_cash_cdf'].toString().trim()) -
                double.parse(montant!.trim());
        cashRecCDF =
            double.parse(receiverInfo!['sold_cash_cdf'].toString().trim()) +
                double.parse(montant!.trim());
      } else {
        if (double.parse(receiverInfo!['sold_cash_cdf'].toString().trim()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire le retrait, solde cash CDF du fournisseur insuffisant");
          return null;
        }
        cashSenderCDF =
            double.parse(senderInfo!['sold_cash_cdf'].toString().trim()) +
                double.parse(montant!.trim());
        cashRecCDF =
            double.parse(receiverInfo!['sold_cash_cdf'].toString().trim()) -
                double.parse(montant!.trim());
      }
    }
    //USD
    if (devise.toLowerCase() == 'usd') {
      if (isRefund != null && isRefund == true) {
        if (double.parse(senderInfo!['sold_cash_usd'].toString().trim()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire le retrait, solde cash USD insuffisant");
          return null;
        }
        cashSenderUSD =
            double.parse(senderInfo!['sold_cash_usd'].toString().trim()) -
                double.parse(montant!.trim());
        cashRecUSD =
            double.parse(receiverInfo!['sold_cash_usd'].toString().trim()) +
                double.parse(montant!.trim());
      } else {
        if (double.parse(receiverInfo!['sold_cash_usd'].toString().trim()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire le retrait, solde cash USD du fournisseur insuffisant");
          return null;
        }
        cashSenderUSD =
            double.parse(senderInfo!['sold_cash_usd'].toString().trim()) +
                double.parse(montant!.trim());
        cashRecUSD =
            double.parse(receiverInfo!['sold_cash_usd'].toString().trim()) -
                double.parse(montant!.trim());
      }
    }

    Map updatedSoldCashData = {
      "cashRecCDF": cashRecCDF,
      "cashRecUSD": cashRecUSD,
      "cashSenderCDF": cashSenderCDF,
      "cashSenderUSD": cashSenderUSD,
    };
    print(updatedSoldCashData);
    // print('\n pr');
    return updatedSoldCashData;
  }

  updateVirtualData(
      {required String typeOperation,
      required String devise,
      bool? isRefund = false}) async {
    await Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .getAccountActivities();
    if (Provider.of<TransactionsStateProvider>(navKey.currentContext!,
                listen: false)
            .lastActivitiesCheck !=
        null) {
      if (DateTime.now()
              .difference(Provider.of<TransactionsStateProvider>(
                      navKey.currentContext!,
                      listen: false)
                  .lastActivitiesCheck!)
              .inSeconds >
          5) {
        Message.showToast(
            msg:
                "Impossible d'actualiser votre compte, vérifiez votre connexion puis réessayez");
        return null;
      }
    } else {
      Message.showToast(msg: "Vos soldes ne sont pas actualisés");
      return null;
    }
    double virtuelRecUSD = 0,
        virtuelRecCDF = 0,
        virtuelSenderUSD = 0,
        virtuelSenderCDF = 0,
        stockSender = 0,
        stockReceiver = 0;
    Map senderActivity = senderInfo!['activities']
        .where((activity) =>
            activity['activity_id'].toString() ==
            demandData['activity_id'].toString())
        .toList()[0];
    Map receiverActivity = receiverInfo!['activities']
        .where((activity) =>
            activity['activity_id'].toString() ==
            demandData['activity_id'].toString())
        .toList()[0];
    //VIRTUAL OPERATION
    if (devise.toLowerCase() == 'cdf') {
      if (isRefund != null && isRefund == true) {
        if (double.parse(senderActivity['virtual_cdf'].toString()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire le retrait, solde virtuel CDF insuffisant");
          return null;
        }
        virtuelSenderCDF =
            double.parse(senderActivity['virtual_cdf'].toString().trim()) -
                double.parse(montant!.trim());
        virtuelRecCDF =
            double.parse(receiverActivity['virtual_cdf'].toString().trim()) +
                double.parse(montant!.trim());
      } else {
        if (double.parse(receiverActivity['virtual_cdf'].toString()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire l'operation, solde virtuel CDF du fournisseur insuffisant");
          return null;
        }
        virtuelSenderCDF =
            double.parse(senderActivity['virtual_cdf'].toString().trim()) +
                double.parse(montant!.trim());
        virtuelRecCDF =
            double.parse(receiverActivity['virtual_cdf'].toString().trim()) -
                double.parse(montant!.trim());
      }
    }
    //USD
    if (devise.toLowerCase() == 'usd') {
      if (isRefund != null && isRefund == true) {
        if (double.parse(senderActivity['virtual_usd'].toString()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire le retrait, solde virtuel USD insuffisant");
          return null;
        }
        virtuelSenderUSD =
            double.parse(senderActivity['virtual_usd'].toString().trim()) -
                double.parse(montant!.trim());
        virtuelRecUSD =
            double.parse(receiverActivity['virtual_usd'].toString().trim()) +
                double.parse(montant!.trim());
      } else {
        if (double.parse(receiverActivity['virtual_usd'].toString()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire le pret, solde virtuel USD du fournisseur insuffisant");
          return null;
        }
        virtuelSenderUSD =
            double.parse(senderActivity['virtual_usd'].toString().trim()) +
                double.parse(montant!.trim());
        virtuelRecUSD =
            double.parse(receiverActivity['virtual_usd'].toString().trim()) -
                double.parse(montant!.trim());
      }
    }

    //STOCK
    if (devise.toLowerCase() == 'stock') {
      if (isRefund != null && isRefund == true) {
        if (double.parse(senderActivity['stock'].toString()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire l'opération, solde en stock insuffisant");
          return null;
        }
        stockSender = double.parse(senderActivity['stock'].toString().trim()) -
            double.parse(montant!.trim());
        stockReceiver =
            double.parse(receiverActivity['stock'].toString().trim()) +
                double.parse(montant!.trim());
      } else {
        if (double.parse(receiverActivity['stock'].toString()) <
            double.parse(montant!.trim())) {
          Message.showToast(
              msg:
                  "Impossible de faire l'opération, solde en stock insuffisant");
          return null;
        }
        stockSender = double.parse(senderActivity['stock'].toString().trim()) +
            double.parse(montant!.trim());
        stockReceiver =
            double.parse(receiverActivity['stock'].toString().trim()) -
                double.parse(montant!.trim());
      }
    }

    Map updatedVirtualSoldData = {
      "virtuelRecCDF": virtuelRecCDF,
      "virtuelRecUSD": virtuelRecUSD,
      "virtuelSenderCDF": virtuelSenderCDF,
      "virtuelSenderUSD": virtuelSenderUSD,
      "stockSender": stockSender,
      "stockReceiver": stockReceiver,
    };
    // print(updatedVirtualSoldData);
    // print('\n pr');
    return updatedVirtualSoldData;
  }

  validateCashDemand(
      {required String choosedDevise,
      bool isSupply = false,
      Function? callback}) async {
    String uuid =
        "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";

    //Transaction for the person who received the demand
    Map transSenderData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(montant!.trim()).toStringAsFixed(3),
      "type_operation": isSupply == false ? "Emprunt" : "Approvisionnement",
      "type_devise": choosedDevise,
      "account_id": accountData!['id'].toString(),
      "status": "validated",
      "source": "mobile",
      "users_id":
          Provider.of<UserStateProvider>(navKey.currentContext!, listen: false)
              .clientData!
              .id!
              .toString()
              .trim()
    };
    //Transaction for the person who sent the demand
    Map transReceiverData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(montant!.trim()).toStringAsFixed(3),
      "type_operation": isSupply == false ? "Pret" : "Approvisionnement",
      "type_devise": choosedDevise,
      "account_id": demandData['receiver_id'].toString().trim(),
      "status": "validated",
      "source": "mobile",
      "users_id": senderInfo!['users_id'].toString().trim()
    };

    var updatedData =
        await updateCashData(typeOperation: "Pret", devise: choosedDevise);
    if (updatedData == null) {
      return;
    }
    demandData['amount_send'] =
        double.parse(montant!.trim()).toStringAsFixed(3);
    demandData['status'] = "Accepted";
    //Account for the person who received the demand
    Map receiverData = {
      "id": demandData['receiver_id'].toString().trim(),
      'sold_cash_cdf': updatedData['cashRecCDF'] == 0
          ? receiverInfo!['sold_cash_cdf'].toString().trim()
          : updatedData['cashRecCDF'].toString().trim(),
      'sold_cash_usd': updatedData['cashRecUSD'] == 0
          ? receiverInfo!['sold_cash_usd'].toString().trim()
          : updatedData['cashRecUSD'].toString().trim(),
      if (isSupply == false)
        'sold_pret_cdf': updatedData['cashRecCDF'] == 0
            ? receiverInfo!['sold_pret_cdf'].toString().trim()
            : double.parse(montant!.trim()) +
                double.parse(receiverInfo!['sold_pret_cdf'].toString().trim()),
      if (isSupply == false)
        'sold_pret_usd': updatedData['cashRecUSD'] == 0
            ? receiverInfo!['sold_pret_usd'].toString().trim()
            : double.parse(montant!.trim()) +
                double.parse(receiverInfo!['sold_pret_usd'].toString().trim()),
    };
    //Account for the person who sent the demand
    Map senderData = {
      "id": demandData['sender_id'].toString().trim(),
      'sold_cash_cdf': updatedData['cashSenderCDF'] == 0
          ? senderInfo!['sold_cash_cdf'].toString().trim()
          : updatedData['cashSenderCDF'].toString().trim(),
      'sold_cash_usd': updatedData['cashSenderUSD'] == 0
          ? senderInfo!['sold_cash_usd'].toString().trim()
          : updatedData['cashSenderUSD'].toString().trim(),
      if (isSupply == false)
        'sold_emprunt_cdf': updatedData['cashSenderCDF'] == 0
            ? senderInfo!['sold_emprunt_cdf'].toString().trim()
            : double.parse(montant!.trim()) +
                double.parse(senderInfo!['sold_emprunt_cdf'].toString().trim()),
      if (isSupply == false)
        'sold_emprunt_usd': updatedData['cashSenderUSD'] == 0
            ? senderInfo!['sold_emprunt_usd'].toString().trim()
            : double.parse(montant!.trim()) +
                double.parse(senderInfo!['sold_emprunt_usd'].toString().trim()),
    };
    Map data = {
      "activity_id": activityData!['activity_id'].toString(),
      "trans1": transReceiverData, //the person who received the demand
      "trans2": transSenderData, //the personn who send the demand
      "account1": receiverData,
      "account2": senderData,
      "demand": demandData
    };
    // return print(data);
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .demandResponse(
            body: data,
            canUpdateAccount: true,
            callback: () {
              callback?.call();
            });
  }

  validateVirtualDemand(
      {required String choosedDevise,
      bool isSupply = false,
      Function? callback}) async {
    String uuid =
        "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";

    //Transaction for the person who received the demand
    Map transSenderData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(montant!.trim()).toStringAsFixed(3),
      "type_operation": isSupply == false ? "Emprunt" : "Approvisionnement",
      "type_devise": choosedDevise,
      "account_id": demandData['sender_id'].toString().trim(),
      "status": "validated",
      "source": "mobile",
      "users_id": receiverInfo!['users_id'].toString().trim()
    };
    //Transaction for the person who sent the demand
    Map transReceiverData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(montant!.trim()).toStringAsFixed(3),
      "type_operation": isSupply == false ? "Pret" : "Approvisionnement",
      "type_devise": choosedDevise,
      "account_id": demandData['receiver_id'].toString().trim(),
      "status": "validated",
      "source": "mobile",
      "users_id": senderInfo!['users_id'].toString().trim()
    };
    var updatedData =
        await updateVirtualData(typeOperation: "Pret", devise: choosedDevise);
    print("updated data");
    // print(updatedData);
    if (updatedData == null) {
      return;
    }
    demandData['amount_send'] =
        double.parse(montant!.trim()).toStringAsFixed(3);
    demandData['status'] = "Accepted";

    Map senderActivity = senderInfo!['activities']
        .where((activity) =>
            activity['activity_id'].toString() ==
            demandData['activity_id'].toString())
        .toList()[0];
    Map receiverActivity = receiverInfo!['activities']
        .where((activity) =>
            activity['activity_id'].toString() ==
            demandData['activity_id'].toString())
        .toList()[0];
    //Account for the person who received the demand
    Map activityReceiverData = {};
    activityReceiverData = {
      "id": receiverActivity['id'].toString().trim(),
      "activity_id": activityData!['activity_id'].toString().trim(),
      'virtual_cdf': updatedData['virtuelRecCDF'] == 0
          ? receiverActivity['virtual_cdf'].toString().trim()
          : updatedData['virtuelRecCDF'].toString().trim(),
      'virtual_usd': updatedData['virtuelRecUSD'] == 0
          ? receiverActivity['virtual_usd'].toString().trim()
          : updatedData['virtuelRecUSD'].toString().trim(),
      'stock': updatedData['stockReceiver'] == 0
          ? receiverActivity['stock'].toString().trim()
          : updatedData['stockReceiver'].toString().trim(),
      if (isSupply == false)
        "pret_usd": updatedData['virtuelRecUSD'] == 0
            ? receiverActivity['pret_usd'].toString().trim()
            : double.parse(receiverActivity['pret_usd'].toString().trim()) +
                double.parse(montant!.trim()),
      if (isSupply == false)
        "pret_cdf": updatedData['virtuelRecCDF'] == 0
            ? receiverActivity['pret_cdf'].toString().trim()
            : double.parse(receiverActivity['pret_cdf'].toString().trim()) +
                double.parse(montant!.trim()),
    };

    Map activitySenderData = {};
    activitySenderData = {
      "id": senderActivity['id'].toString().trim(),
      "activity_id": activityData!['activity_id'].toString().trim(),
      'virtual_cdf': updatedData['virtuelSenderCDF'] == 0
          ? senderActivity['virtual_cdf'].toString().trim()
          : updatedData['virtuelSenderCDF'].toString().trim(),
      'virtual_usd': updatedData['virtuelSenderUSD'] == 0
          ? senderActivity['virtual_usd'].toString().trim()
          : updatedData['virtuelSenderUSD'].toString().trim(),
      'stock': updatedData['stockSender'] == 0
          ? receiverActivity['stock'].toString().trim()
          : updatedData['stockSender'].toString().trim(),
      if (isSupply == false)
        'emprunt_cdf': updatedData['virtuelSenderCDF'] == 0
            ? senderActivity['emprunt_cdf'].toString().trim()
            : double.parse(senderActivity['emprunt_cdf'].toString().trim()) +
                double.parse(montant!.trim()),
      if (isSupply == false)
        'emprunt_usd': updatedData['virtuelSenderUSD'] == 0
            ? senderActivity['emprunt_usd'].toString().trim()
            : double.parse(senderActivity['emprunt_usd'].toString().trim()) +
                double.parse(montant!.trim()),
    };

    Map data = {
      "activity_id": activityData!['activity_id'].toString(),
      "trans1": transReceiverData, //the person who received the demand
      "trans2": transSenderData, //the personn who send the demand
      "account_activity1": activityReceiverData,
      "account_activity2": activitySenderData,
      "demand": demandData
    };
    // print(data);
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .demandResponse(
            body: data,
            canUpdateAccount: true,
            callback: () {
              callback?.call();
              // Navigator.pop(navKey.currentContext!);
            });
  }

  refundCashDemand({
    required String choosedDevise,
  }) async {
    String uuid =
        "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";

    //Transaction for the person who received the demand
    Map transSenderData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(montant!.trim()).toStringAsFixed(3),
      "type_operation": "Paiement emprunt",
      "type_devise": choosedDevise,
      "account_id": demandData['sender_id'].toString().trim(),
      "status": "validated",
      "source": "mobile",
      "users_id": senderInfo!['users_id'].toString().trim()
    };
    //Transaction for the person who sent the demand
    Map transReceiverData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(montant!.trim()).toStringAsFixed(3),
      "type_operation": "Paiement pret",
      "type_devise": choosedDevise,
      "account_id": demandData['receiver_id'].toString().trim(),
      "status": "validated",
      "source": "mobile",
      "users_id": receiverInfo!['users_id'].toString().trim()
    };
    demandData['status'] = "Paid";
    var updatedData = await updateCashData(
        typeOperation: "Pret", devise: choosedDevise, isRefund: true);
    if (updatedData == null) {
      return;
    }
    //Account for the person who received the demand
    Map receiverData = {
      "id": demandData['receiver_id'].toString().trim(),
      'sold_cash_cdf': updatedData['cashRecCDF'] == 0
          ? receiverInfo!['sold_cash_cdf'].toString().trim()
          : updatedData['cashRecCDF'].toString().trim(),
      'sold_cash_usd': updatedData['cashRecUSD'] == 0
          ? receiverInfo!['sold_cash_usd'].toString().trim()
          : updatedData['cashRecUSD'].toString().trim(),
      'sold_pret_cdf': updatedData['cashRecCDF'] == 0
          ? receiverInfo!['sold_pret_cdf'].toString().trim()
          : double.parse(receiverInfo!['sold_pret_cdf'].toString().trim()) -
              double.parse(montant!.trim()),
      'sold_pret_usd': updatedData['cashRecUSD'] == 0
          ? receiverInfo!['sold_pret_usd'].toString().trim()
          : double.parse(receiverInfo!['sold_pret_usd'].toString().trim()) -
              double.parse(montant!.trim()),
    };
    //Account for the person who sent the demand
    Map senderData = {
      "id": demandData['sender_id'].toString().trim(),
      'sold_cash_cdf': updatedData['cashSenderCDF'] == 0
          ? senderInfo!['sold_cash_cdf'].toString().trim()
          : updatedData['cashSenderCDF'].toString().trim(),
      'sold_cash_usd': updatedData['cashSenderUSD'] == 0
          ? senderInfo!['sold_cash_usd'].toString().trim()
          : updatedData['cashSenderUSD'].toString().trim(),
      'sold_emprunt_cdf': updatedData['cashSenderCDF'] == 0
          ? senderInfo!['sold_emprunt_cdf'].toString().trim()
          : double.parse(senderInfo!['sold_emprunt_cdf'].toString().trim()) -
              double.parse(montant!.trim()),
      'sold_emprunt_usd': updatedData['cashSenderUSD'] == 0
          ? senderInfo!['sold_emprunt_usd'].toString().trim()
          : double.parse(senderInfo!['sold_emprunt_usd'].toString().trim()) -
              double.parse(montant!.trim()),
    };

    Map data = {
      "activity_id": activityData!['activity_id'].toString(),
      "trans1": transReceiverData, //the person who received the demand
      "trans2": transSenderData, //the personn who send the demand
      "account1": receiverData,
      "account2": senderData,
      "demand": demandData
    };
    // return print(data);
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .demandResponse(body: data, canUpdateAccount: true, callback: () {});
  }

  refundVirtualDemand({
    required String choosedDevise,
  }) async {
    String uuid =
        "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";

    //Transaction for the person who received the demand
    Map transSenderData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(montant!.trim()).toStringAsFixed(3),
      "type_operation": "Paiement emprunt",
      "type_devise": choosedDevise,
      "account_id": demandData['sender_id'].toString().trim(),
      "status": "validated",
      "source": "mobile",
      "users_id": senderInfo!['users_id'].toString().trim()
    };
    //Transaction for the person who sent the demand
    Map transReceiverData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(montant!.trim()).toStringAsFixed(3),
      "type_operation": "Paiement pret",
      "type_devise": choosedDevise,
      "account_id": demandData['receiver_id'].toString().trim(),
      "status": "validated",
      "source": "mobile",
      "users_id": receiverInfo!['users_id'].toString().trim()
    };
    demandData['status'] = "Paid";
    var updatedData = await updateVirtualData(
        typeOperation: "Pret", devise: choosedDevise, isRefund: true);
    if (updatedData == null) {
      return;
    }

    Map senderActivity = senderInfo!['activities']
        .where((activity) =>
            activity['activity_id'].toString() ==
            demandData['activity_id'].toString())
        .toList()[0];
    Map receiverActivity = receiverInfo!['activities']
        .where((activity) =>
            activity['activity_id'].toString() ==
            demandData['activity_id'].toString())
        .toList()[0];
    Map activityReceiverData = {};
    activityReceiverData = {
      "id": receiverActivity['id'].toString().trim(),
      "activity_id": activityData!['activity_id'].toString().trim(),
      'virtual_cdf': updatedData['virtuelRecCDF'] == 0
          ? receiverActivity['virtual_cdf'].toString().trim()
          : updatedData['virtuelRecCDF'].toString().trim(),
      'virtual_usd': updatedData['virtuelRecUSD'] == 0
          ? receiverActivity['virtual_usd'].toString().trim()
          : updatedData['virtuelRecUSD'].toString().trim(),
      'stock': updatedData['stockReceiver'] == 0
          ? receiverActivity['stock'].toString().trim()
          : updatedData['stockReceiver'].toString().trim(),
      "pret_usd": updatedData['virtuelRecUSD'] == 0
          ? receiverActivity['pret_usd'].toString().trim()
          : double.parse(receiverActivity['pret_usd'].toString().trim()) -
              double.parse(montant!.trim()),
      "pret_cdf": updatedData['virtuelRecCDF'] == 0
          ? receiverActivity['pret_cdf'].toString().trim()
          : double.parse(receiverActivity['pret_cdf'].toString().trim()) -
              double.parse(montant!.trim()),
    };

    Map activitySenderData = {};
    activitySenderData = {
      "id": senderActivity['id'].toString().trim(),
      "activity_id": activityData!['activity_id'].toString().trim(),
      'virtual_cdf': updatedData['virtuelSenderCDF'] == 0
          ? senderActivity['virtual_cdf'].toString().trim()
          : updatedData['virtuelSenderCDF'].toString().trim(),
      'virtual_usd': updatedData['virtuelSenderUSD'] == 0
          ? senderActivity['virtual_usd'].toString().trim()
          : updatedData['virtuelSenderUSD'].toString().trim(),
      'stock': updatedData['stockSender'] == 0
          ? receiverActivity['stock'].toString().trim()
          : updatedData['stockSender'].toString().trim(),
      'emprunt_cdf': updatedData['virtuelSenderCDF'] == 0
          ? senderActivity['emprunt_cdf'].toString().trim()
          : double.parse(senderActivity['emprunt_cdf'].toString().trim()) -
              double.parse(montant!.trim()),
      'emprunt_usd': updatedData['virtuelSenderUSD'] == 0
          ? senderActivity['emprunt_usd'].toString().trim()
          : double.parse(senderActivity['emprunt_usd'].toString().trim()) -
              double.parse(montant!.trim()),
    };
    Map data = {
      "activity_id": activityData!['activity_id'].toString(),
      "trans1": transReceiverData, //the person who received the demand
      "trans2": transSenderData, //the personn who send the demand
      "account_activity1": activityReceiverData,
      "account_activity2": activitySenderData,
      "demand": demandData
    };
    // return print(data);
    Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .demandResponse(
            body: data,
            canUpdateAccount: true,
            callback: () {
              // Navigator.pop(navKey.currentContext!);
            });
  }
}
