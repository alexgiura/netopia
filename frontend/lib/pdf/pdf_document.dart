import 'dart:js_util';
import 'dart:typed_data';
import 'package:erp_frontend_v2/boxes.dart';
import 'package:erp_frontend_v2/models/company/company_model.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart' as doc;
import 'package:erp_frontend_v2/models/partner/partner_model.dart';
import 'package:erp_frontend_v2/models/user/user.dart';
import 'package:erp_frontend_v2/services/company.dart';
import 'package:erp_frontend_v2/utils/util_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import 'pdf_helpers.dart';

class PdfDocument {
  static Future<Uint8List> generate(
      doc.Document document, WidgetRef ref) async {
    final pdf = Document();

    User? user = boxUser.get('user') as User?;
    Company company = user != null ? user.company! : Company.empty();

    if (document.documentType.id == 2) {
      pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 24,
          marginLeft: 24,
          marginRight: 24,
          marginTop: 36,
        ),
        build: (context) => [
          buildHeader(document, company),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildTitle(),
          buildInvoice(document),
          //Divider(thickness: 0.3),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildTotal(document),
        ],
        footer: (context) => buildFooter(),
      ));
    } else if (document.documentType.id == 4) {
      pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginBottom: 24,
          marginLeft: 24,
          marginRight: 24,
          marginTop: 36,
        ),
        build: (context) => [
          buildHeader(document, company),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildDeliveryNote(document),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
        ],
        // footer: (context) => buildFooter(),
      ));
    } else if (document.documentType.id == 5) {
      pdf.addPage(MultiPage(
        build: (context) => [
          buildRecipeNoteHeader(
            document,
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildRecipeNote(document),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
        ],
        // footer: (context) => buildFooter(),
      ));
    }

    return PdfApi.saveDocument(name: 'document.pdf', pdf: pdf);
  }

  static Widget buildHeader(doc.Document document, Company? company) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                alignment: Alignment.topLeft,
                child: buildInvoiceInfo(document,
                    document.documentType.id == 2 ? 'Factura Fiscala' : null),
              )),
              SizedBox(width: 48),
              Expanded(
                child: Container(
                  child: Spacer(),
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: buildSupplierAddress(company),
                ),
              ),
              SizedBox(width: 48),
              Expanded(
                  child: Container(
                alignment: Alignment.topRight,
                child: buildCustomerAddress(document.partner!),
              ))
            ],
          ),
        ],
      );

  static Widget buildRecipeNoteHeader(
    doc.Document document,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                child: buildInvoiceInfo(document, null),
              )),
              Expanded(child: Spacer()),
            ],
          ),
          Divider(thickness: 0.2),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 48),
              Expanded(
                  child: Container(
                alignment: Alignment.topRight,
                child: buildCustomerAddress(document.partner!),
              ))
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Partner partner) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText2(
            title: "Client: ",
            value: partner.name,
          ),
          buildText2(
            title: "CUI / CNP: ",
            value: partner.vatNumber ?? '',
          ),
          buildText2(
            title: "Nr. Reg. Com: ",
            value: partner.registrationNumber ?? '',
          ),
        ],
      );

  static Widget buildInvoiceInfo(doc.Document document, String? title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title != null ? title : document.documentType.nameRo,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        buildText2(
          title: "Serie si Nr.: ",
          value: '${document.series} / ${document.number}',
        ),
        buildText2(
          title: "Data: ",
          value: DateFormat('dd-MM-yyyy').format(DateTime.parse(document.date)),
        ),
      ],
    );
  }

  static Widget buildSupplierAddress(Company? company) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText2(
            title: "Furnizor: ",
            value: company != null ? company.name ?? "" : '',
          ),
          buildText2(
            title: "CUI: ",
            value: company != null ? company.vatNumber ?? '' : '',
          ),
          buildText2(
            title: "Nr. Reg. Com: ",
            value: company != null ? company.registrationNumber ?? '' : '',
          ),
          buildText2(
            title: "Adresa: ",
            value: company != null ? company.address!.address ?? '' : '',
          ),
          // buildText2(
          //   title: "Email: ",
          //   value: company != null ? company.email ?? '' : '',
          // ),
          // buildText2(
          //   title: "Cont: ",
          //   value: company != null ? company.bankAccount ?? '' : '',
          // ),
          // buildText2(
          //   title: "Banca: ",
          //   value: company != null ? company.bankName ?? '' : '',
          // ),

          //SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Factura valabila fara semnatura si stampila conform art.5, alin.2 din Ordonanta nr.319 17/2015, art. alin.29 din Legea nr.227/2015 privind codul fiscal si modificarile ulterioare',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10)),
          SizedBox(height: 4)
        ],
      );

  static Widget buildInvoice(doc.Document document) {
    final headers = [
      'Produs/Serviciu',
      'Cantitate',
      '   U.M.',
      'Pret unitar',
      '   TVA',
      'Valoare fara\n       TVA',
      'Valoare\n   TVA',
      // 'Total',
    ];

    final data = document.documentItems.isEmpty
        ? <List<String>>[]
        : document.documentItems.map((documentItem) {
            return [
              documentItem.item.name,
              (truncateToDecimals(documentItem.quantity, 2)),
              documentItem.item.um.name,
              (truncateToDecimals(documentItem.price, 2)),
              documentItem.item.vat.name,
              (truncateToDecimals(documentItem.amountNet, 2)),
              (truncateToDecimals(documentItem.amountVat, 2)),
            ];
          }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        bottom: BorderSide(width: 0.2, color: PdfColors.black),
      ),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      cellStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      // columnWidths: {
      //   0: FlexColumnWidth(3), // First column is twice as wide
      //   1: FlexColumnWidth(1), // Each of the rest of the columns
      //   2: FlexColumnWidth(2),
      //   3: FlexColumnWidth(2),
      //   4: FlexColumnWidth(2),
      //   5: FlexColumnWidth(2),
      //   6: FlexColumnWidth(2),
      // },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      },
    );
  }

  static Widget buildDeliveryNote(doc.Document document) {
    final headers = [
      'Produs',
      'UM',
      'Cantitate',
    ];

    final data = document.documentItems.map((documentItem) {
      return [
        documentItem.item.name,
        documentItem.item.um.name,
        (documentItem.quantity.toStringAsFixed(2)),
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        bottom: BorderSide(width: 0.2, color: PdfColors.black),
      ),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      cellStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
      },
      columnWidths: {
        0: FixedColumnWidth(1.0 / 2.0), // First column gets 1/2
        1: FixedColumnWidth(1.0 / 4.0), // Second column gets 1/4
        2: FixedColumnWidth(1.0 / 4.0), // Third column gets 1/4
      },
    );
  }

  static Widget buildRecipeNote(doc.Document document) {
    final headers = [
      'Produs',
      'UM',
      'Cantitate',
    ];

    final data = document.documentItems.map((documentItem) {
      return [
        documentItem.item.name,
        documentItem.item.um.name,
        (documentItem.quantity.toStringAsFixed(2)),
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: const TableBorder(
        bottom: BorderSide(width: 0.2, color: PdfColors.black),
      ),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      cellStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
      },
      columnWidths: {
        0: FixedColumnWidth(1.0 / 2.0), // First column gets 1/2
        1: FixedColumnWidth(1.0 / 4.0), // Second column gets 1/4
        2: FixedColumnWidth(1.0 / 4.0), // Third column gets 1/4
      },
    );
  }

  static Widget buildTotal(doc.Document document) {
    final netTotal = document.documentItems.isEmpty
        ? 0.00
        : document.documentItems
            .map((item) => item.amountNet ?? 0.0)
            .reduce((item1, item2) => item1 + item2);

    final vatTotal = document.documentItems.isEmpty
        ? 0.00
        : document.documentItems
            .map((item) => item.amountVat ?? 0.0)
            .reduce((item1, item2) => item1 + item2);

    final total = document.documentItems.isEmpty
        ? 0.00
        : document.documentItems
            .map((item) => item.amountGross ?? 0.0)
            .reduce((item1, item2) => item1 + item2);

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(child: Spacer()),
          SizedBox(width: 48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Subtotal:',
                  value: formatPrice(netTotal),
                ),
                SizedBox(height: 4),
                buildText(
                  title: 'TVA:',
                  value: formatPrice(vatTotal),
                ),
                Divider(thickness: 0.2),
                buildText(
                  title: 'Total:',
                  titleStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  value: formatPrice(total),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Prezenta factura tine loc de contract. Neachitarea la scadenta a facturii atrage penalitati de intarziere de 0.4% pe zi.",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
          ),
          SizedBox(height: 4),
          Text(
            "Am luat la cunostiinta si sunt de acord cu faptul ca datele cu caracter personal sunt stocate in baza de date a societatii si pot fi prelucrate in conformitate cu prevederile Directivei CE/95/46 si Legea 677/2001 privind protectia persoanelor la prelucrarea datelor cu caracter personal si libera circulatie a datelor",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
          ),
        ],
      );

  static buildText({
    required String title,
    required String value,
    TextStyle? titleStyle,
  }) {
    final style =
        titleStyle ?? TextStyle(fontWeight: FontWeight.normal, fontSize: 11);

    return Row(
      children: [
        Text(title, style: style),
        Spacer(),
        Text(value, style: style),
      ],
    );
  }

  static buildText2({
    required String title,
    required String value,
  }) {
    return Column(children: [
      Row(
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11)),
        ],
      ),
      SizedBox(height: 2),
    ]);
  }
}
