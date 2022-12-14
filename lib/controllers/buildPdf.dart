
import 'dart:typed_data';
import 'package:gestion_de_stock/models/achat.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../imports.dart';


class MyPdf{

static Future<Uint8List> generateDocument(Achat achat) async {
  final pw.Document doc = pw.Document();
  doc.addPage(pw.MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 0.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return pw.SizedBox();
        }
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration:  const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(width: 0.5),)),
            child: pw.Text('Portable Document Format',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) => <pw.Widget>[
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,

                  children: [
                    pw.Text("Fournisseur       ${achat.fournisseurName}"),
                    pw.Text("Nº Téléphone    ${achat.fournisseurPhone}"),
                    pw.Text("Acheté Par        ${achat.userName}"),
                  ]
                ),
          pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [

                              pw.Text("Magasin      ${achat.products.first.magasinName}"),
                              pw.Text("Date            ${achat.createdAt!.substring(0,10)}"),
                              pw.Text("Heure          ${achat.createdAt!.substring(11,16)}"),


                            ]
                          ),
        ]
      ),
        pw.Divider(
          height: 80,
          thickness: 1,
        ),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Container(
            width: 200,
                  margin: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(5),
                    border: pw.Border.all(),
                    color: PdfColor.fromInt(Colors.white.value),
                  ),
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Container(
                        padding:const pw.EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(Colors.grey.shade700.value),
                          borderRadius: const pw.BorderRadius.vertical(top: pw.Radius.circular(5)),

                        ),
                        child: pw.Text("Magasin / Date",textAlign:pw.TextAlign.center,style: pw.TextStyle(color: PdfColor.fromInt(Colors.white.value))),
                      ),
                     pw.Padding(padding: const pw.EdgeInsets.all( 8),
                     child:  pw.Row(
                                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                     children: [
                                       pw.Text('Magasin'),
                                       pw.Text("${achat.products.first.magasinName}"),

                                     ]
                                   ),),
                     pw.Padding(padding: const pw.EdgeInsets.all( 8),
                     child:  pw.Row(
                                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    pw.Text('Date'),
                                                    pw.Text(achat.createdAt!.substring(0,10)),

                                                  ]
                                                ),),
                    pw.Padding(padding: const pw.EdgeInsets.all(8),
                    child:   pw.Row(
                                                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   pw.Text('Heure'),
                                                   pw.Text(achat.createdAt!.substring(11,16)),
                                                 ]
                                               ),),
                    ]
                  )
                ),
          pw.Spacer(),
          pw.Container(
            width: 200,
                  margin: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(5),
                    border: pw.Border.all(),
                    color: PdfColor.fromInt(Colors.white.value),
                  ),
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Container(
                        padding:const pw.EdgeInsets.all(5),
                        width: double.infinity,
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromInt(Colors.grey.shade700.value),
                          borderRadius: const pw.BorderRadius.vertical(top: pw.Radius.circular(5)),

                        ),
                        child: pw.Text("Fournisseur / Magasinier",textAlign:pw.TextAlign.center,style: pw.TextStyle(color: PdfColor.fromInt(Colors.white.value))),
                      ),
                     pw.Padding(padding: const pw.EdgeInsets.all( 8),
                     child:  pw.Row(
                                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                     children: [
                                       pw.Text('Nom Fournisseur'),
                                       pw.Text("${achat.fournisseurName}"),

                                     ]
                                   ),),
                     pw.Padding(padding: const pw.EdgeInsets.all( 8),
                     child:  pw.Row(
                                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    pw.Text('Nº Téléphone'),
                                                    pw.Text("${achat.fournisseurPhone}"),

                                                  ]
                                                ),),
                    pw.Padding(padding: const pw.EdgeInsets.all(8),
                    child:   pw.Row(
                                                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   pw.Text('Acheté Par'),
                                                   pw.Text("${achat.userName}"),

                                                 ]
                                               ),),
                    ]
                  )
                ),
        ]
      ),
         pw.Table.fromTextArray(
                context: context,
                border: pw.TableBorder.all(),
                headerAlignment: pw.Alignment.centerLeft,
                data: <List<String>>[
                                  <String>['','Ref','Nom', 'Marque','Prix Achat', 'qty',"Prix/Qty"],
                                  for (int i = 0; i < achat.products.length; i++)
                                    <String>['${i+1}) ',' ${achat.products[i].ref}','${achat.products.elementAt(i).nom}','${achat.products.elementAt(i).mark}',  '${achat.products.elementAt(i).prixAchat}','${achat.products.elementAt(i).quantityInStock}','${achat.products.elementAt(i).quantityInStock!*achat.products.elementAt(i).prixAchat!}',],
                                ]),
        pw.Paragraph(text: ""),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text("Subtotal: ${achat.totalPrice}",)
          ]
        ),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
          ]));

  return doc.save();
}
}