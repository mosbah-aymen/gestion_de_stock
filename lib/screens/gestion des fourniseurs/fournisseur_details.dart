import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/components/StatCard.dart';
import 'package:gestion_de_stock/controllers/achat_crtl.dart';
import 'package:gestion_de_stock/controllers/fournisseur_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/achat.dart';
import 'package:gestion_de_stock/models/fourniseur.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';

class FournisseurDetails extends StatefulWidget {
   final Fournisseur fournisseur;


  const FournisseurDetails({Key? key,required this.fournisseur}) : super(key: key);

  @override
  State<FournisseurDetails> createState() => _FournisseurDetailsState();
}

class _FournisseurDetailsState extends State<FournisseurDetails> {
  List<Achat> achats=[];
  int versement=0;
  Fournisseur fournisseur=Fournisseur();
  @override
  void initState() {
    fournisseur=widget.fournisseur;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // products=exampleProducts.sublist(0,10);
    return Window(header:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:const [

                 Text(
                  "Détails De Fournisseur",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ), body: Padding(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('fournisseur').doc(widget.fournisseur.id!).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    fournisseur=FournisseurCrtl.fromJSON(snapshot.data!.data()!, snapshot.data!.id);
                  }
                  return !snapshot.hasData?
                      const Center(child: CircularProgressIndicator(),)
                      :SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Padding(
                              padding:  EdgeInsets.only(top: 20),
                              child:  CircleAvatar(
                                                             backgroundColor: bgColor,
                                                             backgroundImage:
                                AssetImage('assets/images/profile.png'),
                                                             radius: 100,
                                                           ),
                            )),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Card(
                                      color: Colors.teal,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 10,right: 20,left: 20,top: 10),
                                        child: Column(
                                          children: [
                                            const Text('Information de Fournisseur:',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                            const Divider(color: Colors.white,),
                                            productDetails('Nom', fournisseur.nom??''),

                                            productDetails('Prénom', fournisseur.prenom??''),
                                                                           productDetails('Téléphone', fournisseur.phone1??''),
                                                                           productDetails('Wilaya', fournisseur.wilaya??''),
                                                                           productDetails('Commune', fournisseur.commune??''),
                                                                           productDetails('Ajouter depuis', fournisseur.createdAt!.substring(0,14)),
                                                                           productDetails('Derniere Commande En', fournisseur.lastCommandeAt!.substring(0,14)),

                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: FieldNewPackageForm(title: 'Versement',
                                      icon: Icons.paid_outlined,
                                        child: TextFormField(

                                          onFieldSubmitted: (s){
                                            versement=int.tryParse(s)??0;
                                            showDialog(context: context, builder: (context)=> AlertDialog(
                                              title: const Text("Confirmation"),
                                              content: Text("Merci de confirmer que ${fournisseur.nom} ${fournisseur.prenom} a verser $versement ."),
                                              actions: [
                                                TextButton(onPressed: ()async{
                                                  showDialog(context: context, builder: (context)=>const Center(child: CircularProgressIndicator(),));
                                                  await FournisseurCrtl.updateVersement(fournisseur.id!, versement).then((value) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                                }, child: const Text('Confirmer')),
                                                TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Annuler')),

                                              ],
                                            ));
                                          },
                                          inputFormatters: [
                                                                             FilteringTextInputFormatter.allow(
                                                                                 RegExp('[0-9]')),
                                                                           ],
                                          decoration: decoration('Versement'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Expanded(
                                flex:2,child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [ StatCard(value: fournisseur.totalCommand.toStringAsFixed(0), title: 'Total Commandes', unit: "CMD"),
                                StatCard(value: fournisseur.verse.toStringAsFixed(0), title: 'Total Versé', unit: "DZD"),
                                StatCard(value: fournisseur.rest.toStringAsFixed(0), title: 'Total Resté', unit: "DZD"),
                                StatCard(value: (fournisseur.verse+fournisseur.rest).toStringAsFixed(0), title: 'Total Des Achats', unit: "DZD"),
                            ],))
                          ],
                        ),
                        const Divider(
                                               thickness: 0.5,
                                               color: secondaryColor,
                                             ),
                        SizedBox(
                                                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                    stream: FirebaseFirestore.instance.collection('achats').where('fournisseurId',isEqualTo: fournisseur.id!).snapshots(),
                                                    builder: (context, snapshot) {
                                                      // achats.clear();
                                                      if(snapshot.hasData){
                                                        achats.clear();
                                                        for (var value in snapshot.data!.docs) {
                                                          achats.add(AchatCrtl.fromJSON(value.data(), value.id));
                                                        }
                                                      }
                                                      return !snapshot.hasData?
                                                          const Center(child: CircularProgressIndicator(),)
                                                          :achats.isEmpty?
                                                          const Center(
                                                            child: Text("Aucune Achat Terminé",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),),
                                                          )
                                                          :Column(
                                                                                      children: List.generate(
                                                                                        achats.length,
                                                                                        (i) => Card(
                                                                                          margin: const EdgeInsets.all(10),
                                                                                          child: ExpansionTile(
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
                                                                                              children: [
                                                                                                button('Versement', Icons.archive_outlined, (){},backgroundColor: Colors.green[600]),
                                                   const SizedBox(width: 20,),
                                                   button('Imprimer', Icons.print, (){

                                                   },backgroundColor: Colors.orange[800]),
                                                   const SizedBox(width: 20,),
                                                                                                button('Archiver', Icons.archive_outlined, (){},),
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
                                                                                                          "Quantintée Acheté",
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
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                    }
                                                  ),
                                                )
                      ],
                    ),
                  );
                }
              ),
            ));
  }

  void showDetails(Product product) {
      showDialog(
          context: context,
          builder: (context) => ProductDetails(
                product: product,
              ));
    }

    DataRow myDataRow(Product product, int index) {
      Color color = (index % 2 == 0)
              ? primaryColor.withOpacity(0.1)
              : Colors.white54;
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

  productDetails(
    String title,
    String data,
      { Color? color}

  ) =>
      SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text(
                  data,
                  maxLines: 50,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color:color?? Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );

}
