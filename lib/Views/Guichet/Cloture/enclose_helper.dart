import 'package:flutter/material.dart';
import 'package:orion/Resources/AppStateProvider/cloture.provider.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:provider/provider.dart';

enum EncloseAction { Update, Accept, View }

class EncloseHelper {
  final Map? encloseData;
  final Map? senderInfo, receiverInfo;
  final bool? isCash;
  // final String? montant, montant_USD;

  EncloseHelper({
    this.encloseData,
    this.receiverInfo,
    this.senderInfo,
    this.isCash,
  });

  submitEncloseDay({List activitiesUpdated = const []}) async {
    if (receiverInfo == null) {
      Message.showToast(msg: "Aucun compte pour recevoir la cloture");
      return;
    }
    await Provider.of<TransactionsStateProvider>(navKey.currentContext!,
            listen: false)
        .getAccountActivities();
    Map clotureData = {
      "cloture": {
        "amount_usd":
            double.parse(senderInfo!['sold_cash_usd'].toString().trim())
                .toStringAsFixed(3),
        "amount_cdf":
            double.parse(senderInfo!['sold_cash_cdf'].toString().trim())
                .toStringAsFixed(3),
        "date_send": DateTime.now().toString().substring(0, 10),
        "sender_id": senderInfo!['id'].toString(),
        "receiver_id": receiverInfo!['id'].toString(),
        "status": "Pending",
      },
      "activities": [
        ...List.generate(senderInfo!['activities'].length, (index) {
          return {
            "amount_usd": double.parse(senderInfo!['activities'][index]
                    ['virtual_usd']
                .toString()
                .trim()),
            "amount_cdf": double.parse(senderInfo!['activities'][index]
                    ['virtual_cdf']
                .toString()
                .trim()),
            "stock": double.parse(
                senderInfo!['activities'][index]['stock'].toString().trim()),
            "activity_id": senderInfo!['activities'][index]['activity_id'],
          };
        })
      ],
      "billetage":
          navKey.currentContext!.read<ClotureProvider>().encloseBills['data']
    };
    // return print(clotureData);
    Provider.of<ClotureProvider>(navKey.currentContext!, listen: false)
        .closingDay(body: clotureData, callback: () {});
  }

  // updateEncloseDay(
  //     {required String montantUSD,
  //     required String montantCDF,
  //     required String status}) async {
  //   await Provider.of<TransactionsStateProvider>(navKey.currentContext!,
  //           listen: false)
  //       .getAccountActivities();
  //   Map clotureData = {
  //     "amount_usd": double.parse(montantUSD).toStringAsFixed(3),
  //     "amount_cdf": double.parse(montantCDF).toStringAsFixed(3),
  //     "date_send": DateTime.now().toString().substring(0, 10),
  //     "sender_id": senderInfo!['id'].toString(),
  //     "receiver_id": receiverInfo!['id'].toString(),
  //     "status": status,
  //   };
  //   Provider.of<TransactionsStateProvider>(navKey.currentContext!,
  //           listen: false)
  //       .closingDay(body: clotureData, callback: () {});
  // }

  updateCashData(
      {required String amountUSD,
      required String amountCDF,
      String? devise,
      bool? isRefund = false}) async {
    if (double.parse(amountUSD.trim()) >
            double.parse(encloseData!['amount_usd'].toString()) ||
        double.parse(amountCDF.trim()) >
            double.parse(encloseData!['amount_cdf'].toString())) {
      Message.showToast(
          msg:
              "Le montant saisi en CDF ou USD ne doit pas être supérieur au montant de cloture");
      return null;
    }
    double cashRecUSD = 0, cashRecCDF = 0, cashSenderUSD = 0, cashSenderCDF = 0;
    //CDF

    cashSenderCDF =
        double.parse(senderInfo!['sold_cash_cdf'].toString().trim()) -
            double.parse(amountCDF.trim());
    cashRecCDF =
        double.parse(receiverInfo!['sold_cash_cdf'].toString().trim()) +
            double.parse(amountCDF.trim());

    //USD

    cashSenderUSD =
        double.parse(senderInfo!['sold_cash_usd'].toString().trim()) -
            double.parse(amountUSD.trim());
    cashRecUSD =
        double.parse(receiverInfo!['sold_cash_usd'].toString().trim()) +
            double.parse(amountUSD.trim());

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

  validateCashEnclose(
      {required String amountUSD,
      required String amountCDF,
      required String comment,
      required List billetage,
      required Map activitiesData}) async {
    String uuid =
        "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";

    //Transaction for the person who received the demand
    List bills = billetage;
    for (var i = 0; i < bills.length; i++) {
      bills[i]['commentaire'] = comment;
    }
    // return print(bills);
    Map transSenderData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(amountUSD.trim()).toStringAsFixed(3),
      "type_operation": "Cloture",
      "type_devise": "USD",
      "account_id": senderInfo!['id'].toString(),
      "status": "validated",
      "source": "mobile",
      "users_id": senderInfo!['users_id'].toString().trim()
    };
    Map transSenderDataCDF = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(amountCDF.trim()).toStringAsFixed(3),
      "type_operation": "Cloture",
      "type_devise": "CDF",
      "account_id": senderInfo!['id'].toString(),
      "status": "validated",
      "source": "mobile",
      "users_id": senderInfo!['users_id'].toString().trim()
    };
    //Transaction for the person who sent the demand
    Map transReceiverData = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(amountUSD.trim()).toStringAsFixed(3),
      "type_operation": "Reception cloture",
      "type_devise": "USD",
      "account_id": receiverInfo!['id'].toString(),
      "status": "validated",
      "source": "mobile",
      "users_id": receiverInfo!['users_id'].toString().trim()
    };
    Map transReceiverDataCDF = {
      "refkey": uuid,
      "dateTrans": DateTime.now().toString().substring(0, 10),
      "amount": double.parse(amountCDF.trim()).toStringAsFixed(3),
      "type_operation": "Reception cloture",
      "type_devise": "CDF",
      "account_id": receiverInfo!['id'].toString(),
      "status": "validated",
      "source": "mobile",
      "users_id": receiverInfo!['users_id'].toString().trim()
    };
    var updatedData =
        await updateCashData(amountCDF: amountCDF, amountUSD: amountUSD);
    if (updatedData == null) {
      return;
    }
    //Account for the person who received the demand
    Map receiverData = {
      "id": receiverInfo!['id'].toString().trim(),
      'sold_cash_cdf': updatedData['cashRecCDF'].toString().trim(),
      'sold_cash_usd': updatedData['cashRecUSD'].toString().trim(),
    };
    //Account for the person who sent the demand
    Map senderData = {
      "id": senderInfo!['id'].toString().trim(),
      'sold_cash_cdf': updatedData['cashSenderCDF'].toString().trim(),
      'sold_cash_usd': updatedData['cashSenderUSD'].toString().trim()
    };
    Map clotureData = {
      "id": encloseData!['id'].toString().trim(),
      "received_usd": double.parse(amountUSD.trim()).toStringAsFixed(3),
      "received_cdf": double.parse(amountCDF.trim()).toStringAsFixed(3),
      "status": "Accepted",
      "date_received": DateTime.now().toString()
    };
    Map data = {
      "trans": [
        transReceiverData,
        transReceiverDataCDF,
        transSenderData,
        transSenderDataCDF
      ], //the person who received the demand
      // "trans2": transSenderData, //the personn who send the demand
      "account1": receiverData,
      "account2": senderData,
      "cloture": clotureData,
      "billetage": bills,
      "accountActivities": activitiesData,
      "encloseActivities": encloseData!['activities'].map((item) {
        item.remove('avatar');
        item.remove('name');
        item.remove('created_at');
        item.remove('updated_at');
        return item;
      }).toList()
    };
    // return print(data['encloseActivities']);
    Provider.of<ClotureProvider>(navKey.currentContext!, listen: false)
        .acceptEncloseDay(
            encloseData: data,
            callback: () {
              Navigator.pop(navKey.currentContext!);
            });
  }
}
