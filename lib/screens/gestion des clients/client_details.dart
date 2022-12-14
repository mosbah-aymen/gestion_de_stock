import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/components/StatCard.dart';
import 'package:gestion_de_stock/controllers/vente_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/vente.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';

class ClientDetails extends StatefulWidget {
  final Client client;
  const ClientDetails({Key? key,required this.client}) : super(key: key);

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  List<Vente> ventes=[];
  @override
  Widget build(BuildContext context) {
    return Window(header:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
    
                     Text(
                      "Détails De client",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
    
                  ],
                ), body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
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
                                  children: [
                                    productDetails('Nom', widget.client.nom??''),
                                    productDetails('Prénom', widget.client.prenom??''),
                                    productDetails('Téléphone', widget.client.phone1??''),
                                    productDetails('Wilaya', widget.client.wilaya??''),
                                    productDetails('Commune', widget.client.commune??''),
                                    productDetails('Ajouter depuis', widget.client.createdAt!.substring(0,14)),
    
                                  ],
                                ),
                              ),
                            ),
    
                            Expanded(
                                flex:2,child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StatCard(value: widget.client.totalCommandes!.toStringAsFixed(0), title: 'Total Commandes', unit: "CMD"),
                                StatCard(value: widget.client.verse!.toStringAsFixed(0), title: 'Versé', unit: "DZD"),
                                StatCard(value: widget.client.rest!.toStringAsFixed(0), title: 'Resté', unit: "DZD"),
                                StatCard(value: (widget.client.verse!+widget.client.rest!).toStringAsFixed(0), title: 'Total', unit: "DZD"),
                            ],))
                          ],
                        ),
                        const Divider(
                                               thickness: 0.5,
                                               color: secondaryColor,
                                             ),
                        SizedBox(
                                                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                    stream: FirebaseFirestore.instance.collection('ventes').where('clientId',isEqualTo: widget.client.id!).snapshots(),
                                                    builder: (context, snapshot) {
                                                      // ventes.clear();
                                                      if(snapshot.hasData){
                                                        for (var value in snapshot.data!.docs) {
                                                          ventes.add(VenteCrtl.fromJSON(value.data(), value.id));
                                                        }
                                                        if(ventes.isNotEmpty){
                                                          FirebaseFirestore.instance.doc('/clients/${widget.client.id}').update({
                                                            'totalCommandes':ventes.length,
                                                          });
                                                        }
                                                      }
                                                      return !snapshot.hasData?
                                                          const Center(child: CircularProgressIndicator(),)
                                                          :ventes.isEmpty?
                                                          const Center(
                                                            child: Text("Aucune Achat Terminé",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),),
                                                          )
                                                          :Column(
                                                                                      children: List.generate(
                                                                                        ventes.length,
                                                                                        (i) => Card(
                                                                                          margin: const EdgeInsets.all(10),
                                                                                          child: ExpansionTile(
                                                                                            backgroundColor:
                                                                                                primaryColor.withOpacity(0.1),
                                                                                            textColor: secondaryColor,
                                                                                            childrenPadding: const EdgeInsets.all(10),
                                                                                            leading: Column(
                                                                                              children: [
                                                                                                Text(ventes[i].clientName ?? 'Guest'),
                                                                                                Text(ventes[i].phone1?? ventes[i].phone2??'Guest'),
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
                                                                                            //     Text(ventes[i].clientPhone ?? ''),
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
                                                    }
                                                  ),
                                                )
                      ],
                    ),
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
                        color: Colors.black,
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
                        color:color?? secondaryColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          );
    
    }
    
