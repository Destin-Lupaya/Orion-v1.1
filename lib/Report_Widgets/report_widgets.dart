import 'dart:convert';

// import 'dart:html' as webFile;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orion/Resources/Helpers/date_parser.dart';
import 'package:universal_html/html.dart' as webFile;
import 'package:flutter/foundation.dart';
import 'package:orion/Resources/AppStateProvider/transaction_stateprovider.dart';
import 'package:orion/Resources/global_variables.dart';
import 'package:orion/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

reportView(
    {required String title, required List data, required List inputs}) async {
  if (data.isEmpty) {
    Message.showToast(
        msg: "Impossible de produire le rapport, la liste est vide");
    return;
  }
  final pw.Document pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
      orientation: pw.PageOrientation.landscape,
      pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 0.5 * PdfPageFormat.cm,
          marginLeft: 0.5 * PdfPageFormat.cm,
          marginRight: 0.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(),
            child: pw.Text(
              'Report',
            ));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
            ));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(title, textScaleFactor: 2),
                      pw.PdfLogo()
                    ])),
            // pw.Header(level: 1, text: title),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>[
                'Operation',
                'Ref',
                'USD',
                'CDF',
                'Quantite',
                'Date',
                'Paiement',
                ...inputs.map((input) => input['designation'])
              ],
              ...data.map((e) => <String>[
                    "${e['type_operation']}",
                    "${e['refkey'] ?? e['id']}",
                    e['type_devise'].toString().trim().toLowerCase() == 'usd'
                        ? "${e['amount']}"
                        : '',
                    e['type_devise'].toString().trim().toLowerCase() == 'cdf'
                        ? "${e['amount']}"
                        : '',
                    e['quantity'].toString().trim().toLowerCase(),
                    e['dateTrans'] != null
                        ? DateTime.parse(e['dateTrans'].toString())
                            .toString()
                            .substring(0, 10)
                        : '',
                    e['type_payment'].toString().trim().toLowerCase(),
                    ...e.keys
                        .toList()
                        .where((key) => key.toString().contains('col_'))
                        .toList()
                        .map((el) => e[el])
                  ])
            ]),
          ]));

  if (kIsWeb) {
    // var blob = webFile.Blob(await pdf.save(), 'text/plain', 'native');

    webFile.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(await pdf.save())}")
      ..setAttribute("download", "$title${DateTime.now().toString()}.pdf")
      ..click();
  } else {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = "$dir/$title${DateTime.now().toString()}.pdf";
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
  }
}

dynamicFieldsReport(
    {required String title,
    required List data,
    required List inputs,
    required List fields}) async {
  if (data.isEmpty) {
    Message.showToast(
        msg: "Impossible de produire le rapport, la liste est vide");
    return;
  }
  final pw.Document pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
      orientation: pw.PageOrientation.landscape,
      pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 0.5 * PdfPageFormat.cm,
          marginLeft: 0.5 * PdfPageFormat.cm,
          marginRight: 0.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(),
            child: pw.Text(
              'Report',
            ));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
            ));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(title, textScaleFactor: 2),
                      pw.PdfLogo()
                    ])),
            // pw.Header(level: 1, text: title),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              List.generate(fields.length, (index) {
                if (fields[index].toString().toLowerCase().contains('type')) {
                  return fields[index].toString().split('_')[1] != null
                      ? fields[index].toString().split('_')[1].toUpperCase()
                      : fields[index].toString().toUpperCase();
                }
                return fields[index].toString().toUpperCase();
              }),
              ...data.map((e) {
                // print(e);
                return List.generate(
                    fields.length,
                    (indexCol) => inputs
                            .map((input) => input['designation'])
                            .contains(fields[indexCol].toString())
                        ? e['col_${inputs.indexWhere((input) => input['designation'].toString().toLowerCase() == fields[indexCol].toString().toLowerCase()) + 1}']
                            .toString()
                        : e[fields[indexCol]].toString());
              })
            ]),
          ]));

  if (kIsWeb) {
    // var blob = webFile.Blob(await pdf.save(), 'text/plain', 'native');

    webFile.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(await pdf.save())}")
      ..setAttribute("download", "$title${DateTime.now().toString()}.pdf")
      ..click();
  } else {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = "$dir/$title${DateTime.now().toString()}.pdf";
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
  }
}

reportDemand({required String title, required List data}) async {
  if (data.isEmpty) {
    Message.showToast(
        msg: "Impossible de produire le rapport, la liste est vide");
    return;
  }
  final pw.Document pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
      orientation: pw.PageOrientation.landscape,
      pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 0.5 * PdfPageFormat.cm,
          marginLeft: 0.5 * PdfPageFormat.cm,
          marginRight: 0.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(),
            child: pw.Text(
              'Report',
            ));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
            ));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(title, textScaleFactor: 2),
                      pw.PdfLogo()
                    ])),
            // pw.Header(level: 1, text: title),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>[
                'Demandeur',
                'Receveur',
                'Status',
                'Alerte',
                'Montant',
                'Deboursé',
                'Date'
              ],
              ...data.map((e) => <String>[
                    Provider.of<TransactionsStateProvider>(
                            navKey.currentContext!,
                            listen: false)
                        .othersAccounts
                        .where((account) =>
                            account['id'].toString().trim() ==
                            e['sender_id'].toString().trim())
                        .toList()[0]['names']
                        .toString()
                        .trim(),
                    Provider.of<TransactionsStateProvider>(
                            navKey.currentContext!,
                            listen: false)
                        .othersAccounts
                        .where((account) =>
                            account['id'].toString().trim() ==
                            e['receiver_id'].toString().trim())
                        .toList()[0]['names']
                        .toString()
                        .trim(),
                    "${e['status']}",
                    "${e['alerte']}",
                    "${e['amount']} ${e['type_devise']}",
                    "${e['amount_send']} ${e['type_devise']}",
                    e['created_at'] != null
                        ? DateTime.parse(e['created_at'].toString())
                            .toString()
                            .substring(0, 10)
                        : ''
                  ])
            ]),
          ]));

  if (kIsWeb) {
    // var blob = webFile.Blob(await pdf.save(), 'text/plain', 'native');

    webFile.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(await pdf.save())}")
      ..setAttribute("download", "$title${DateTime.now().toString()}.pdf")
      ..click();
  } else {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = "$dir/$title${DateTime.now().toString()}.pdf";
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
  }
}

pretReport(
    {required String title, required List data, required List inputs}) async {
  if (data.isEmpty) {
    Message.showToast(
        msg: "Impossible de produire le rapport, la liste est vide");
    return;
  }
  final pw.Document pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
      orientation: pw.PageOrientation.landscape,
      pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 0.5 * PdfPageFormat.cm,
          marginLeft: 0.5 * PdfPageFormat.cm,
          marginRight: 0.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(),
            child: pw.Text(
              'Report',
            ));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
            ));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Header(
                level: 0,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: <pw.Widget>[
                      pw.Text(title, textScaleFactor: 2),
                      pw.PdfLogo()
                    ])),
            // pw.Header(level: 1, text: title),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>[
                'Statut',
                'Operation',
                'Ref',
                'USD',
                'CDF',
                'Date',
                ...inputs.map((input) => input['designation'])
              ],
              ...data.map((e) => <String>[
                    "${e['status']}",
                    "${e['type_operation']}",
                    "${e['refkey'] ?? e['id']}",
                    e['type_devise'].toString().trim().toLowerCase() == 'usd'
                        ? "${e['amount']}"
                        : '',
                    e['type_devise'].toString().trim().toLowerCase() == 'cdf'
                        ? "${e['amount']}"
                        : '',
                    e['dateTrans'] != null
                        ? DateTime.parse(e['dateTrans'].toString())
                            .toString()
                            .substring(0, 10)
                        : '',
                    ...e.keys
                        .toList()
                        .where((key) => key.toString().contains('col_'))
                        .toList()
                        .map((el) => e[el])
                  ])
            ]),
          ]));

  if (kIsWeb) {
    // var blob = webFile.Blob(await pdf.save(), 'text/plain', 'native');

    webFile.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(await pdf.save())}")
      ..setAttribute("download", "$title${DateTime.now().toString()}.pdf")
      ..click();
  } else {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = "$dir/$title${DateTime.now().toString()}.pdf";
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
  }
}

reportRecu({
  required String title,
  required Map data,
  required List inputs,
}) async {
  if (data.isEmpty) {
    Message.showToast(
        msg: "Impossible de produire le rapport, la liste est vide");
    return;
  }
  final pw.Document pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
      pageFormat:
          PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.center,
            // margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            // padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(),
            child: pw.Text('Reçu',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 25,
                    decoration: pw.TextDecoration.underline)));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Row(children: [
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("Date : "),
                          pw.Text(
                              parseDate(
                                  date: data['dateTrans'] ?? "0000-00-00"),
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("Numero : "),
                          pw.Text(data['refkey'].toString(),
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ]),
                    pw.Padding(padding: const pw.EdgeInsets.all(5)),
                    pw.Row(children: [
                      pw.Text("Montant : "),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColor.fromRYB(1, 1, 1),
                                          width: 1))),
                              child: pw.Column(children: [
                                pw.Text(
                                    "${data['amount'].toString()} ${data['type_devise'].toString()}",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Row(mainAxisSize: pw.MainAxisSize.max)
                              ])))
                    ]),
                    pw.Row(children: [
                      pw.Text("Operation : "),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColor.fromRYB(1, 1, 1),
                                          width: 1))),
                              child: pw.Column(children: [
                                pw.Text(data['type_operation'].toString(),
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Row(mainAxisSize: pw.MainAxisSize.max)
                              ])))
                    ]),
                    pw.Padding(padding: const pw.EdgeInsets.all(5)),
                    pw.Text("Informations supplémentaires",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            decoration: pw.TextDecoration.underline)),
                    pw.Padding(padding: const pw.EdgeInsets.all(3)),
                    ...data.keys
                        .toList()
                        .where((key) => key.toString().contains('col_'))
                        .toList()
                        .map(
                          (el) => pw.Row(children: [
                            pw.Text(
                                "${inputs[int.parse(el.split('_')[1].toString()) - 1]['designation']} : "),
                            pw.Expanded(
                                child: pw.Container(
                                    decoration: pw.BoxDecoration(
                                        border: pw.Border(
                                            bottom: pw.BorderSide(
                                                color:
                                                    PdfColor.fromRYB(1, 1, 1),
                                                width: 1))),
                                    child: pw.Column(children: [
                                      pw.Text(data[el].toString(),
                                          style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                          )),
                                      pw.Row(mainAxisSize: pw.MainAxisSize.max)
                                    ])))
                          ]),
                        ),
                    pw.Padding(padding: const pw.EdgeInsets.all(5)),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Column(children: [
                            pw.Text("Signature"),
                            pw.Padding(padding: const pw.EdgeInsets.all(5)),
                            pw.Text(title,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 16,
                                    decoration: pw.TextDecoration.underline)),
                          ])
                        ]),
                  ])),
              pw.Container(width: 100, height: 200),
            ])
          ]));

  if (kIsWeb) {
    // var blob = webFile.Blob(await pdf.save(), 'text/plain', 'native');

    webFile.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(await pdf.save())}")
      ..setAttribute("download", "$title${DateTime.now().toString()}.pdf")
      ..click();
  } else {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = "$dir/$title${DateTime.now().toString()}.pdf";
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
  }
}

reportFacture({required String title, required Map data}) async {
  if (data.isEmpty) {
    Message.showToast(
        msg: "Impossible de produire le rapport, la liste est vide");
    return;
  }
  final pw.Document pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
      pageFormat:
          PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.center,
            // margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            // padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(),
            child: pw.Text('Reçu',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 25,
                    decoration: pw.TextDecoration.underline)));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Row(children: [
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("Date : "),
                          pw.Text("2022-04-04",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("Numero : "),
                          pw.Text("86877678687",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ]),
                    pw.Padding(padding: const pw.EdgeInsets.all(5)),
                    pw.Row(children: [
                      pw.Text("Reçu de : "),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColor.fromRYB(1, 1, 1),
                                          width: 1))),
                              child: pw.Column(children: [
                                pw.Text("Tester02",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Row(mainAxisSize: pw.MainAxisSize.max)
                              ])))
                    ]),
                    pw.Row(children: [
                      pw.Text("Montant : "),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColor.fromRYB(1, 1, 1),
                                          width: 1))),
                              child: pw.Column(children: [
                                pw.Text("USD 50",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Row(mainAxisSize: pw.MainAxisSize.max)
                              ])))
                    ]),
                    pw.Row(children: [
                      pw.Text("Operation : "),
                      pw.Expanded(
                          child: pw.Container(
                              decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                      bottom: pw.BorderSide(
                                          color: PdfColor.fromRYB(1, 1, 1),
                                          width: 1))),
                              child: pw.Column(children: [
                                pw.Text("Depot",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.Row(mainAxisSize: pw.MainAxisSize.max)
                              ])))
                    ]),
                    pw.Padding(padding: const pw.EdgeInsets.all(5)),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Column(children: [
                            pw.Text("Signature"),
                            pw.Padding(padding: const pw.EdgeInsets.all(5)),
                            pw.Text("Tester02 sign"),
                          ])
                        ]),
                  ])),
              pw.Container(width: 100, height: 200),
            ])
          ]));

  if (kIsWeb) {
    // var blob = webFile.Blob(await pdf.save(), 'text/plain', 'native');

    webFile.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(await pdf.save())}")
      ..setAttribute("download", "$title${DateTime.now().toString()}.pdf")
      ..click();
  } else {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = "$dir/$title${DateTime.now().toString()}.pdf";
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
  }
}
