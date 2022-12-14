
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/components/search_field.dart';
import 'package:gestion_de_stock/controllers/vente_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/vente.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';
import 'package:gestion_de_stock/components/workspace.dart';
class ListSorties extends StatefulWidget {
  static const String id = 'Gestion Des Ventes';
  const ListSorties({Key? key}) : super(key: key);

  @override
  State<ListSorties> createState() => _ListSortiesState();
}

class _ListSortiesState extends State<ListSorties> {
  String search='';
List<Vente> selectedCommands=[],ventes=[];

  @override
  Widget build(BuildContext context) {
    return WorkSpace(headChildren: const [],
      searchBar: Card(
         margin: const EdgeInsets.all(10),
         child: SearchField(
             hint: 'Chercher ce que voulez ...',
             onSubmitted: (s) {
               search = s.toLowerCase();
               setState(() {});
             }),
       ),
      child: SingleChildScrollView(
              child: SizedBox(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('ventes')
                    .where('archived',isEqualTo: false)
                        // .orderBy('createdAt', descending: true)
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
                                    ventes.length,
                                    (i) => Card(
                                      margin: const EdgeInsets.all(10),
                                      child: ExpansionTile(
                                        backgroundColor:
                                            primaryColor.withOpacity(0.1),
                                        textColor: secondaryColor,
                                        childrenPadding: const EdgeInsets.all(10),
                                        leading: SizedBox(
                                          width: MediaQuery.of(context).size.width*.1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(child: Text(ventes[i].clientName??'',overflow: TextOverflow.ellipsis,)),
                                              Expanded(child: Text(ventes[i].phone1 ?? ventes[i].phone1 ??'-',overflow: TextOverflow.ellipsis,)),
                                            ],
                                          ),
                                        ),
                                        trailing: SizedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Total =${ventes[i].totalPrice} DZD",overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: secondaryColor,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(child: Text("Payer par: ${ventes[i].userName}",overflow: TextOverflow.ellipsis,)),
                                            ],
                                          ),
                                        ),
                                        // subtitle:
                                        //     Text(ventes[i].fournisseurPhone ?? ''),
                                        title: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              button('Imprimer', Icons.print, (){

                                              },backgroundColor: Colors.orange[800]),
                                              const SizedBox(width: 20,),
                                              button('Archiver', Icons.archive_outlined, ()async{
                                                await VenteCrtl.archiverVente(ventes[i],true);
                                              },
                                              backgroundColor: primaryColor,
                                              ),
                                              const SizedBox(width: 20,),
                                              button('Supprimer', Icons.archive_outlined, (){
                                                showDialog(context: context, builder: (context)=>AlertDialog(
                                                  title: const Text('Voulez vous vraiment Supprimer cette vente totalement'),
                                                  actions: [
                                                    TextButton(onPressed: (){
                                                      FirebaseFirestore.instance.collection('ventes').doc(ventes[i].id).delete();
                                                      Navigator.pop(context);
                                                    }, child: const Text('Supprimer')),
                                                    TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Annuler')),
                                                  ],
                                                ));
                                              },backgroundColor: Colors.red),
                                            ],
                                          ),
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
                                                      "Quantintée Vendu",
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
  bool conditions(Vente command){
    return command.id!.contains(search)||
    command.clientName!.toLowerCase().startsWith(search)||
        command.userName!.toLowerCase().startsWith(search);}

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

