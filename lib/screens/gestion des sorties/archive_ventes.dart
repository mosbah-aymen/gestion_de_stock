

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/controllers/vente_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/vente.dart';

import '../gestion des produits/product_details.dart';

class ArchiveVentes extends StatefulWidget {
  const ArchiveVentes({Key? key}) : super(key: key);

  @override
  State<ArchiveVentes> createState() => _ArchiveVentesState();
}

class _ArchiveVentesState extends State<ArchiveVentes> {
  List<Vente> ventes = [];
  
    bool paid=false;
    @override
    Widget build(BuildContext context) {
      return  Window(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          button('Tous Désarchiver', Icons.all_inbox, ()async{
            for (var value in ventes) {
              VenteCrtl.archiverVente(value, false);
            }
            Navigator.pop(context);
          }),
          const Text("Archive Des Ventes",
            style: TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.bold,

               ),),
          button('Exit', Icons.cancel, (){Navigator.pop(context);})
        ],
        ),
        body: SingleChildScrollView(
                child: SizedBox(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('ventes')
                      .where('archived',isEqualTo: true)
                          .orderBy('createdAt', descending: true)
                          .limit(20)
                          .snapshots(),
                      builder: (context, snapshot) {
                        ventes.clear();
                        if (snapshot.hasData) {
                          for (var value in snapshot.data!.docs) {
                            ventes.add(VenteCrtl.fromJSON(value.data(), value.id));
                            // FirebaseFirestore.instance.collection('ventes').doc(value.id).update({
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
                                      ventes
                                          .length,
                                      (i) => Card(
                                        margin: const EdgeInsets.all(10),
                                        child: ExpansionTile(
                                          backgroundColor:
                                              primaryColor.withOpacity(0.1),
                                          textColor: secondaryColor,
                                          childrenPadding: const EdgeInsets.all(10),
                                          leading: Column(
                                            children: [
                                              Text(ventes[i].clientName ?? ''),
                                              Text(ventes[i].phone1 ?? ''),
                                              Text(ventes[i].phone2 ?? ''),
                                            ],
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Total =${ventes[i].totalPrice} DZD",
                                                style: const TextStyle(
                                                    color: secondaryColor,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text("Payer par: ${ventes[i].userName}"),
                                            ],
                                          ),
                                          // subtitle:
                                          //     Text(ventes[i].fournisseurPhone ?? ''),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              button('Versement', Icons.archive_outlined, (){},backgroundColor: Colors.green[600]),
                                                                                          const SizedBox(width: 20,),
                                                                                          button('Imprimer', Icons.print, (){

                                                                                          },backgroundColor: Colors.orange[800]),
                                                                                          const SizedBox(width: 20,),
                                              button('Désarchiver', Icons.archive_outlined, ()async{
                                                await VenteCrtl.archiverVente(ventes[i],false);
                                              },),
                                              const SizedBox(width: 20,),
                                              button('Supprimer', Icons.archive_outlined, (){},backgroundColor: Colors.red),
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
                                                      ventes[i].products!.length,
                                                      (index) => myDataRow(
                                                          ventes[i].products![index],
                                                          index))),
                                            )
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
 
