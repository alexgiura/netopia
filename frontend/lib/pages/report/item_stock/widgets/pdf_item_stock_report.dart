import 'dart:typed_data';
import 'package:erp_frontend_v2/models/report/item_stock_report_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../pdf/pdf_helpers.dart';

class PdfItemStockReport {
  static Future<Uint8List> generate(
      List<ItemStockReport> report, String date) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        buildTitle(date),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoice(report),
        //Divider(thickness: 0.3),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(name: 'document.pdf', pdf: pdf);
  }

  static pw.Widget buildTitle(String date) {
    final titles = <String>[
      'Data: ',
    ];
    final data = <String>[
      date,
    ];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('RAPORT STOCURI',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: List.generate(titles.length, (index) {
            final title = titles[index];
            final value = data[index];

            return pw.Row(
              children: [
                pw.Text(title,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                pw.Text(value,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
              ],
            );
          }),
        )
      ],
    );
  }

  static pw.Widget buildInvoice(List<ItemStockReport> report) {
    final headers = [
      'Cod',
      'Denumire',
      'UM',
      'Cantitate',
    ];
    // final data = invoice.items.map((item) {
    //   final total = item.unitPrice * item.quantity * (1 + item.vat);

    final data = report.map((item) {
      return [
        item.itemCode,
        item.itemName,
        item.itemUm,
        item.itemQuantity,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const pw.TableBorder(
        bottom: pw.BorderSide(width: 0.2, color: PdfColors.black),
      ),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
      },
    );
  }

  static pw.Widget buildFooter() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Divider(thickness: 0.2),
          pw.SizedBox(height: 2 * PdfPageFormat.mm),
        ],
      );
}
