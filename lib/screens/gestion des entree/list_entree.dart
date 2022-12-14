import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/components/search_field.dart';
import 'package:gestion_de_stock/controllers/achat_crtl.dart';
import 'package:gestion_de_stock/controllers/buildPdf.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/achat.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';
import 'package:gestion_de_stock/components/workspace.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ListEntree extends StatefulWidget {
  static const String id = 'Gestion Des Achats';

  const ListEntree({Key? key}) : super(key: key);

  @override
  State<ListEntree> createState() => _ListEntreeState();
}

class _ListEntreeState extends State<ListEntree> {
  String search = '';
  List<Achat> achats = [];

  bool paid = false;
  @override
  void initState() {
    super.initState();
  }

  void getPdf(Achat achat) async{
    await MyPdf.generateDocument(achat).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Scaffold(
        appBar: AppBar(backgroundColor: secondaryColor,),
        body: PdfPreview(
                   build: (format)=> value,
                 ),
      )));
    });


    // Uint8List uint8list = await MyPdf.generateDocument(achat);
    // final output = await getTemporaryDirectory();
    // final file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await MyPdf.generateDocument(achat));
    //
    // await Printing.layoutPdf(
    //       onLayout: (PdfPageFormat format) async =>await MyPdf.generateDocument(achat));
  }

  @override
  Widget build(BuildContext context) {
    return WorkSpace(
      headChildren: const [],
      searchBar: SearchField(
        onSubmitted: (s) {
          search = s.toLowerCase();
          setState(() {});
        },
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          child:
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('achats')
              .where('archived',isEqualTo: false)
                  .orderBy('createdAt', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                achats.clear();
                if (snapshot.hasData) {
                  for (var value in snapshot.data!.docs) {
                    achats.add(AchatCrtl.fromJSON(value.data(), value.id));
                    // FirebaseFirestore.instance.collection('achats').doc(value.id).update({
                    //   'archived':false,
                    // });
                  }
                }
                return snapshot.hasError
                    ? const Center(
                        child: Text("Something went wrong"),
                      )
                    : !snapshot.hasData
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: List.generate(
                              achats
                                  .where((element) => condition(
                                      element, paid && element.rest == 0))
                                  .length,
                              (i) => Card(
                                margin: const EdgeInsets.all(10),
                                child: ExpansionTile(
                                  collapsedBackgroundColor: primaryColor.shade50,
                                  backgroundColor:
                                      primaryColor.withOpacity(0.1),
                                  textColor: secondaryColor,
                                  childrenPadding: const EdgeInsets.all(10),
                                  leading: Column(
                                    children: [
                                      Text(achats[i].fournisseurName ?? ''),
                                      Text(achats[i].fournisseurPhone ?? ''),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total =${achats[i].totalPrice} DZD",
                                        style: const TextStyle(
                                            color: secondaryColor,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Payer par: ${achats[i].userName}"),
                                    ],
                                  ),
                                  // subtitle:
                                  //     Text(achats[i].fournisseurPhone ?? ''),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                                                                  button('Imprimer', Icons.print, (){
getPdf(achats[i]);
                                                                                  },backgroundColor: Colors.orange[800]),
                                                                                  const SizedBox(width: 20,),
                                      button('Archiver', Icons.archive_outlined, ()async{
                                        await AchatCrtl.archiverAchat(achats[i],true);
                                      },),
                                      const SizedBox(width: 20,),
                                      button('Supprimer', Icons.archive_outlined, (){
                                        AchatCrtl.delete(achats[i]);
                                      },backgroundColor: Colors.red),
                                      ],
                                  ),
                                  children: [
                                    SizedBox(
                                      child: DataTable(
                                          columns: const [
                                            DataColumn(
                                              label: Text(
                                                "Nº Ref",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Nom",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Catégory",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Mark",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Entrée en",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Quantintée",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                "Prix",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                          rows: List.generate(
                                              achats[i].products.length,
                                              (index) => myDataRow(
                                                  achats[i].products[index],
                                                  index))),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
              }),
        ),
      ),
    );
  }

  bool condition(Achat element, bool paid) {
    return element.fournisseurName!.toLowerCase().startsWith(search) ||
        element.fournisseurPhone!.startsWith(search) ||
        element.products
            .firstWhere((prd) => prd.nom!.toLowerCase().startsWith(search))
            .nom!
            .startsWith(search) ||
        element.products
            .firstWhere((prd) => prd.ref!.toLowerCase().startsWith(search))
            .ref!
            .startsWith(search) ||
        element.products
            .firstWhere((prd) => prd.mark!.toLowerCase().startsWith(search))
            .mark!
            .startsWith(search) ||
        element.products
            .firstWhere((prd) => prd.category!.toLowerCase().startsWith(search))
            .category!
            .startsWith(search) ||
        paid;
  }

  void showDetails(Product product) {
    showDialog(
        context: context,
        builder: (context) => ProductDetails(
              product: product,
            ));
  }

  DataRow myDataRow(Product product, int index) {
    Color color =
        (index % 2 == 0) ? primaryColor.withOpacity(0.1) : Colors.white54;
    return DataRow(color: MaterialStateProperty.all(color), cells: [
      DataCell(
        Text(product.ref ?? ''),
        onTap: () {
          showDetails(product);
        },
      ),
      DataCell(
        Text(product.nom ?? ''),
        onTap: () {
          showDetails(product);
        },
      ),
      DataCell(
        Text(product.category ?? ''),
        onTap: () {
          showDetails(product);
        },
      ),
      DataCell(
        Text(product.mark ?? ''),
        onTap: () {
          showDetails(product);
        },
      ),
      DataCell(
        Text(product.createdAt != null
            ? product.createdAt!.substring(0, 16)
            : ''),
        onTap: () {
          showDetails(product);
        },
      ),
      DataCell(
        Text("${product.quantityInStock}"),
        onTap: () {
          showDetails(product);
        },
      ),
      DataCell(
        Text("${product.unitPrice}  DZD"),
        onTap: () {
          showDetails(product);
        },
      ),
    ]);
  }
}
