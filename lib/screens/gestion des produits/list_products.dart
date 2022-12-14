import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/components/search_field.dart';
import 'package:gestion_de_stock/controllers/magasin_crtl.dart';
import 'package:gestion_de_stock/controllers/product_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/magasin.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/add_achat.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/add_product.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/nouveur_vente.dart';
import 'package:gestion_de_stock/components/workspace.dart';

class ListProducts extends StatefulWidget {
  static const String id = 'Gestion Des Produits';
  const ListProducts({Key? key}) : super(key: key);

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  List<Product> products = [], selectedProducts = [];
  List<Magasin> magasins=[];
  Magasin? magasin;

  String search = '', plusVendu = '', plusEnStock = '';
  int totalEnStock = 0;

  void getStat() {
    Product p = products.first, p1 = p;
    totalEnStock = 0;
    for (var value in products) {
      totalEnStock += value.prixAchat!;
      if (value.quantityInStock! > p.quantityInStock!) {
        plusEnStock = value.nom!;
        p = value;
      }
      if (value.nombreDesVente! > p1.nombreDesVente!) {
        plusVendu = value.nom!;
        p1 = value;
      }
    }
  }



  @override
  void initState() {
    if (products.isNotEmpty) {
      getStat();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (products.isNotEmpty) {
      getStat();
    }
    return WorkSpace(
      statTitles: const [
        'Nombre De Produit',
        'Total En Stock',
        'Plus Vendu',
        'Plus En Stock'
      ],
      statValues: [
        products.length.toStringAsFixed(0),
        '${totalEnStock.toStringAsFixed(0)} DZD',
        plusVendu,
        plusEnStock,
      ],
      headChildren: [
        // HeaderElement(
        //   title: 'Supprimer',
        //   icon: Icons.delete,
        //   color: selectedProducts.isEmpty ? Colors.grey : null,
        //   onTap: () async {
        //     if (selectedProducts.isNotEmpty) {
        //       await showDialog(
        //           context: context,
        //           builder: (context) => AlertDialog(
        //                 title: const Text('Attention'),
        //                 content: const Text(
        //                     'Voulez vous vraiment Supprimer tous les produit selectionnés'),
        //                 actions: [
        //                   TextButton(
        //                       onPressed: () {
        //                         Navigator.pop(context);
        //                       },
        //                       child: const Text('Annuler')),
        //                   TextButton(
        //                       onPressed: () async {
        //                         await deleteProducts().then((value) {
        //                           Navigator.pop(context);
        //                         });
        //                       },
        //                       child: const Text('Supprimer')),
        //                 ],
        //               )).then((value) {
        //         setState(() {});
        //       });
        //     }
        //   },
        // ),
        HeaderElement(
          title: 'Ajouter',
          icon: Icons.add,
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => const AddProduct()).then((value) {
              setState(() {});
            });
          },
        ),
        HeaderElement(
          title: 'Modifier',
          icon: Icons.update,
          color: selectedProducts.length == 1 ? null : Colors.grey,
          onTap: () {
            if (selectedProducts.length == 1) {
              showDialog(
                  context: context,
                  builder: (context) =>  AddProduct(product: selectedProducts.first,));
            } else {
              showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                        content:
                            Text('Il faut selectionner seulement un produit'),
                      ));
            }
          },
        ),
        HeaderElement(
          title: 'Nouveau Vente',
          icon: Icons.sell_outlined,
          color: selectedProducts.isEmpty ? Colors.grey : null,
          onTap: ()async {
            if (selectedProducts.isNotEmpty) {
             await showDialog(
                      context: context,
                      builder: (context) =>
                          NewVente(selectedProducts: selectedProducts))
                  .then((value) {
                    selectedProducts.clear();
                setState(() {});
              });
            } else {
              showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                        title: Text('Aucun produit selectionné'),
                        content: Text(
                            "Merci de selectionner les produits á vendre .Si le produit n'existe pas, ajouter le"),
                      ));
            }
          },
        ),
        HeaderElement(
          title: 'Nouveau Achat',
          icon: Icons.add_shopping_cart_rounded,
          color: selectedProducts.isEmpty ? Colors.grey : null,
          onTap: () async{
            if (selectedProducts.isNotEmpty) {
             await showDialog(
                  context: context,
                  builder: (context) => AddAchat(
                        selectedProducts: selectedProducts,
                      )).then((value) {
               selectedProducts.clear();
                setState(() {});
              });
            } else {
              showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                        title: Text('Aucun produit selectionné'),
                        content: Text(
                            "Merci de selectionner les produits á acheter .Si le produit n'existe pas, ajouter le"),
                      ));
            }
          },
        ),
      ],
      searchBar: Card(
        margin: const EdgeInsets.all(10),
        child: SearchField(
            hint: 'Chercher ce que voulez ...',
            onSubmitted: (s) {
              search = s.toLowerCase();
              setState(() {});
            }),
      ),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('magasins').snapshots(),
        builder: (context, snapshot) {
          magasins.clear();
          if(snapshot.hasData){
            for (var value in snapshot.data!.docs) {
              magasins.add(MagasinCrtl.fromJSON(value.data(), value.id));
            }
            magasin ??= magasins.first;

          }
          return !snapshot.hasData?
              const CircularProgressIndicator()
            :magasin==null?
              const SizedBox()
              : SizedBox(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    FirebaseFirestore.instance.collection('products').where('magasinId',isEqualTo: magasin!.id).snapshots(),
                builder: (context, snapshot) {
                  products = [];
                  if (snapshot.hasData) {
                    for (var value in snapshot.data!.docs) {
                     Product product= ProductCrtl.fromJSON(value.data(), value.id);
                      products.add(product);

                    }
                  }
                  return !snapshot.hasData
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                        child: SingleChildScrollView(
                          primary: true,
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 300,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1,color: secondaryColor,),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: PopupMenuButton(
                                                child: Center(child: Text(magasin!.name.toString())),
                                                itemBuilder: (context)=>List.generate(magasins.length,(index)=>PopupMenuItem(
                                                    onTap: (){
                                                      magasin=magasins[index];
                                                      setState((){});
                                                    },
                                                    child: ListTile(
                                              title: Text(magasins[index].name.toString()),
                                              subtitle: Text('${magasins[index].wilaya} ${magasins[index].commune}'),
                                            )))),
                                          )
                                        ],
                                      )),
                                  DataTable(
                                    decoration: const BoxDecoration(
                                      border: Border.symmetric(horizontal: BorderSide()),
                                    ),
                                      dividerThickness: 1,
                                      dataRowColor: MaterialStateProperty.all(Colors.black12),
                                      dataTextStyle: const TextStyle(fontSize: 12,
                                      color: Colors.black,),
                                      dataRowHeight: 30,
                                      columnSpacing: 45,
                                      columns:  [
                                        DataColumn(
                                          onSort: (int i,bool b){
                                          },
                                          label: const Text(
                                            "Nº Ref",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            "Nom",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            "Catégory",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            "Mark",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            "Entrée en",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            "Quantintée",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const DataColumn(
                                          label: Text(
                                            "Prix",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                      rows: List.generate(
                                          products
                                              .where((element) => conditions(element))
                                              .length,
                                          (index) => myDataRow(
                                              products.where((element) => conditions(element))
                                                  .elementAt(index),
                                              index))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                }),
          );
        }
      ),
    );
  }

  void delete() {
    if (selectedProducts.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text('Selectionner les produit á supprimer'),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Etes-vous sûr de supprimer la selection?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        for (var value in selectedProducts) {
                          products
                              .removeWhere((element) => element.id == value.id);
                        }

                        Navigator.pop(context);
                      },
                      child: const Text('Supprimer')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Annuler')),
                ],
              )).then((value) {
        setState(() {});
      });
    }
  }

  bool conditions(Product element) {
    return element.category!.startsWith(search) ||
        element.nom!.toLowerCase().startsWith(search) ||
        element.mark!.toLowerCase().startsWith(search) ||
        element.ref!.startsWith(search) ||
        element.fournisseurName!.toLowerCase().startsWith(search) ||
        element.fournisseurPhone!.toLowerCase().startsWith(search) ||
        element.addedBy!.toLowerCase().startsWith(search);
  }

  void showDetails(Product product)async {
    await showDialog(
        context: context,
        builder: (context) => ProductDetails(
              product: product,
            )).then((value) {

              setState((){});
            });

  }

  DataRow myDataRow(Product product, int index) {
    Color color = product.quantityInStock! <= product.minQuantity!
        ? Colors.redAccent
        : (index % 2 == 0)
            ? primaryColor.withOpacity(0.3)
            : Colors.white12;
    return DataRow(
        onSelectChanged: (b) {
          if (b == true) {
            selectedProducts.add(product);
            setState(() {});
          } else {
            selectedProducts.removeWhere((element) => element.id == product.id);
            setState(() {});
          }
        },
        selected: selectedProducts
                .firstWhere((element) => element.id == product.id, orElse: () {
              return Product(id: '-1');
            }).id ==
            product.id,
        color: MaterialStateProperty.all(color),
        cells: [
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
            Row(
              children: [
                Icon(Icons.radio_button_checked,color:Color( product.categoryColor!),size: 18,),
                const SizedBox(width: 10,),
                Text(product.category ?? ''),
              ],
            ),
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

List<Product> exampleProducts = [
  Product(
    id: '1',
    createdAt: DateTime.now().toString().substring(0, 16),
    unitPrice: 1000,
    nom: 'roulemant',
    addedBy: 'Hamza',
    category: 'ROULEMANTS',
    expDate: '/',
    fabDate: '/',
    fournisseurName: 'Fouad Zarour',
    fournisseurPhone: '0567939383',
    mark: 'Apple',
    minQuantity: 10,
    quantityInStock: 78,
    ref: '190x1290',
    updatedAt: DateTime.now().toString().substring(0, 16),
  ),
];
