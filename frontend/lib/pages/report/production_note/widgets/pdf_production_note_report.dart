import 'dart:typed_data';
import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/report/production_note_report_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../pdf/pdf_helpers.dart';

class PdfProductionNoteReport {
  static Future<Uint8List> generate(List<ProductionNoteReport> report,
      String startDate, String endDate) async {
    final pdf = pw.Document();

    final totals = calculateTotals(report);

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 24, // Minimal bottom margin
          marginLeft: 24, // Minimal left margin
          marginRight: 24, // Minimal right margin
          marginTop: 24, // Minimal top margin
          width: PdfPageFormat.a4.height,
          height: PdfPageFormat.a4.width),
      build: (context) => [
        buildTitle(startDate, endDate),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoice(report, totals),
        //pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
      ],
    ));

    return PdfApi.saveDocument(name: 'document.pdf', pdf: pdf);
  }

  static List<double> calculateTotals(List<ProductionNoteReport> report) {
    double totalQuantity = 0;
    List<double> totalRawMaterials = List.generate(6, (index) => 0.0);

    for (var item in report) {
      totalQuantity += item.itemQuantity;
      for (int i = 0; i < 6; i++) {
        totalRawMaterials[i] += item.rawMaterial[i];
      }
    }

    return [totalQuantity, ...totalRawMaterials];
  }

  static pw.Widget buildTitle(String startDate, String endDate) {
    final titles = <String>['Interval: '];
    final data = <String>['$startDate - $endDate'];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('RAPORT PRODUCTIE',
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

  static pw.Widget buildInvoice(
      List<ProductionNoteReport> report, List<double> totals) {
    final headers = [
      'Data',
      'Client',
      'Tip Beton',
      'Cantitate',
      '0-4\n(Tone)',
      '4-8\n(Tone)',
      '8-16\n(Tone)',
      '16-32\n(Tone)',
      'Ciment',
      'Aditiv',
    ];

    final tableData = report.map((item) {
      return [
        item.date,
        item.partnerName,
        item.itemName,
        item.itemQuantity.toStringAsFixed(2),
        item.rawMaterial[0].toStringAsFixed(3),
        item.rawMaterial[1].toStringAsFixed(3),
        item.rawMaterial[2].toStringAsFixed(3),
        item.rawMaterial[3].toStringAsFixed(3),
        item.rawMaterial[4].toStringAsFixed(3),
        item.rawMaterial[5].toStringAsFixed(2),
      ];
    }).toList();

    // Add total row
    final totalRow = [
      '',
      '',
      'Total',
      totals[0].toStringAsFixed(2),
      totals[1].toStringAsFixed(3),
      totals[2].toStringAsFixed(3),
      totals[3].toStringAsFixed(3),
      totals[4].toStringAsFixed(3),
      totals[5].toStringAsFixed(3),
      totals[6].toStringAsFixed(2),
    ];

    final List<pw.Alignment> columnAlignments = [
      pw.Alignment.centerLeft, // Date (text)
      pw.Alignment.centerLeft, // Client (text)
      pw.Alignment.centerLeft, // Tip Beton (text)
      pw.Alignment.centerRight, // Cantitate (number)
      pw.Alignment.centerRight, // 0-4 (number)
      pw.Alignment.centerRight, // 4-8 (number)
      pw.Alignment.centerRight, // 8-16 (number)
      pw.Alignment.centerRight, // 16-32 (number)
      pw.Alignment.centerRight, // Ciment (number)
      pw.Alignment.centerRight, // Aditiv (number)
    ];

    final List<pw.Alignment> headerAlignments = [
      pw.Alignment.centerLeft, // Date (text)
      pw.Alignment.centerLeft, // Client (text)
      pw.Alignment.centerLeft, // Tip Beton (text)
      pw.Alignment.centerRight, // Cantitate (number)
      pw.Alignment.centerRight, // 0-4 (number)
      pw.Alignment.centerRight, // 4-8 (number)
      pw.Alignment.centerRight, // 8-16 (number)
      pw.Alignment.centerRight, // 16-32 (number)
      pw.Alignment.centerRight, // Ciment (number)
      pw.Alignment.centerRight, // Aditiv (number)
    ];

    return pw.Table(
      children: [
        // Header row
        pw.TableRow(
          children: List.generate(headers.length, (index) {
            return pw.Align(
              alignment: headerAlignments[
                  index], // Use custom alignment for each header
              child: pw.Text(headers[index],
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center),
            );
          }),
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        ),
        // Data rows
        ...tableData.map((row) => pw.TableRow(
              children: List.generate(
                  row.length,
                  (index) => pw.Align(
                      alignment: columnAlignments[index],
                      child: pw.Text(row[index],
                          style: const pw.TextStyle(fontSize: 12)))),
            )),
        // Separator
        pw.TableRow(
          children: List.generate(
            headers.length,
            (_) => pw.Divider(color: PdfColors.grey, thickness: 0.5),
          ),
        ),
        // Total row
        pw.TableRow(
          children: List.generate(
              totalRow.length,
              (index) => pw.Align(
                  alignment: columnAlignments[index],
                  child: pw.Text(totalRow[index],
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold)))),
        ),
      ],
    );
  }
}
