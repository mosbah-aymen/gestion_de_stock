import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/components/StatCard.dart';
import 'package:gestion_de_stock/controllers/magasin_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/magasin.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20magasin/add_magasin.dart';

import '../../components/workspace.dart';

class ListMagasins extends StatefulWidget {
  static const String id = 'Sites/Magasins';
  const ListMagasins({Key? key}) : super(key: key);

  @override
  State<ListMagasins> createState() => _ListMagasinsState();
}

class _ListMagasinsState extends State<ListMagasins> {
  List<Magasin> magasins = [];
  @override
  Widget build(BuildContext context) {
    return WorkSpace(
      headChildren: [
        HeaderElement(
          title: 'Ajouter',
          icon: Icons.add_circle,
          onTap: () {
            showDialog(
                context: context, builder: (context) => const AddMagasin());
          },
        ),
        const HeaderElement(
          title: 'Transferer',
          icon: Icons.compare_arrows,
        ),
        const HeaderElement(title: 'Supprimer', icon: Icons.delete),
      ],
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('magasins')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            magasins.clear();
            if (snapshot.hasData) {
              for (var value in snapshot.data!.docs) {
                magasins.add(MagasinCrtl.fromJSON(value.data(), value.id));
              }
            }
            return snapshot.hasError
                ? const Center(
                    child: Text("Something went wrong!!"),
                  )
                : !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(
                              magasins.length,
                              (index) => Card(
                                elevation: 4,

                                    margin: const EdgeInsets.all(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                         Row(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             Expanded(child: Image.asset('assets/images/perspective_matte-247-128x128.png',height: 100,)),
                                             Expanded(
                                               flex: 2,
                                               child: Column(
                                                 mainAxisSize: MainAxisSize.min,
                                                 children:[  productDetails('Nom de Magasin:','${magasins[index].name}' ),
                                                                                                                                            productDetails('Wilaya:','${magasins[index].wilaya}' ),
                                                                                                                                            productDetails('Commune:','${magasins[index].commune}' ),
                                                                                                                                            productDetails('Address:','${magasins[index].address}' ),
                                                                                                                                            productDetails('Description :','${magasins[index].description}' ),
                                                 ]      ),
                                             ),
                                           ],
                                         ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment
                                          //           .center,
                                          //   mainAxisSize:
                                          //       MainAxisSize.min,
                                          //   children: [
                                          //     const Text(
                                          //       "Wilaya: ",
                                          //       style:  TextStyle(
                                          //         fontWeight:
                                          //             FontWeight
                                          //                 .bold,
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //         '${magasins[index].wilaya}'),
                                          //   ],
                                          // ),
                                          // Row(
                                          //                                                         mainAxisAlignment:
                                          //                                                             MainAxisAlignment
                                          //                                                                 .center,
                                          //                                                         mainAxisSize:
                                          //                                                             MainAxisSize.min,
                                          //                                                         children: [
                                          //                                                           const Text(
                                          //                                                             "Commune: ",
                                          //                                                             style: TextStyle(
                                          //                                                               fontWeight:
                                          //                                                                   FontWeight
                                          //                                                                       .bold,
                                          //                                                             ),
                                          //                                                           ),
                                          //                                                           Text(
                                          //                                                               '${magasins[index].commune}'),
                                          //                                                         ],
                                          //                                                       ),


                                          SizedBox(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(child: StatCard(value: magasins[index].nbProducts.toString(), title: 'Nombre Des Produits', unit: '',)),
                                                Expanded(child: StatCard(value: magasins[index].max.toString(), title: 'Maximum', unit: '',)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      );
          }),
    );
  }

  productDetails(String title, String data, {Color? color}) => SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color ?? primaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );
}
