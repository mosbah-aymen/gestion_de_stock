import 'dart:math';

import 'package:gestion_de_stock/components/search_field.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/commande.dart';
import 'package:gestion_de_stock/models/user.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/add_achat.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/add_product.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/nouveur_vente.dart';
import 'package:gestion_de_stock/components/workspace.dart';

class ListProducts extends StatefulWidget {
  static const String id = 'List Products';
  const ListProducts({Key? key}) : super(key: key);

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  List<Product> products = [],selectedProducts=[];
  String search = '',plusVendu='',plusEnStock='';
  int totalEnStock=0;

  void getStat(){
    Product p=exampleProducts.first,p1=p;
    totalEnStock=0;
    for (var value in exampleProducts) {
      totalEnStock+=value.prixAchat!;
      if(value.quantityInStock!>p.quantityInStock!){
        plusEnStock=value.nom!;
        p=value;
      }
      if(value.nombreDesVente!>p1.nombreDesVente!){
        plusVendu=value.nom!;
        p1=value;
      }
    }
  }
  @override
  void initState() {
    for (int i = 2; i < 30; i++) {
      int p=Random().nextInt(1000000);
      products.add(
        Product(
          id: i.toString(),
          createdAt: DateTime.now().toString().substring(0, 16),
          prixAchat: p,
          unitPrice: p,
          prixVente: p+Random().nextInt(1000),
          nom: 'Galaxy S$i',
          addedBy: 'Hamza',
          category: 'Téléphone',
          expDate: '/',
          fabDate: '/',
          history: [],
          fournisseurName: 'Fouad Zarour',
          fournisseurPhone: '0567939383',
          mark: 'Samsung',
          minQuantity: 10,
          nombreDesVente: Random().nextInt(50),
          quantityInStock: Random().nextInt(50),
          ref: '${Random().nextInt(1000)}x${Random().nextInt(1000)}',
          updatedAt: DateTime.now().toString().substring(0, 16),
        ),
      );
    }
    exampleProducts=products;
    for(int i=0;i<10;i++){
        int t= Random().nextInt(100000);
        exampleCommands.add(Command(
          id: i.toString(),
          phone1: '0540047893',
          createdAt: DateTime.now().toString(),
          versed: t-Random().nextInt(100),
          totalPrice: t,
          quantities: List.generate(Random().nextInt(10) , (index) =>Random().nextInt(10) ),
          productsIds: List.generate(Random().nextInt(10) , (index) =>exampleProducts[Random().nextInt(20)].id! ),
          clientName: 'moussa',
          userName: currentUser.name,
          clientId: '',
        ));
      }
    getStat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getStat();
    return WorkSpace(
      statTitles: const[
        'Nombre De Produit',
        'Total En Stock',
        'Plus Vendu',
        'Plus En Stock'
      ],
      statValues: [
        exampleProducts.length.toStringAsFixed(0),
        '${totalEnStock.toStringAsFixed(0)} DZD',
        plusVendu,
        plusEnStock,
      ],
      headChildren: [
        HeaderElement(
          title: 'Ajouter',
          icon: Icons.add,
          onTap: () {
            showDialog(context: context, builder: (context)=>const AddProduct()).then((value) {
              setState(() {});
            });
          },
        ),
        HeaderElement(
          title: 'Vente',
          icon: Icons.sell_outlined,
          onTap: () {
            showDialog(context: context, builder: (context)=> NewVente(selectedProducts: selectedProducts)).then((value) {
                         setState(() {});
                       });
          },
        ),
        HeaderElement(
          title: 'Nouveau Achat',
          icon: Icons.add_shopping_cart_rounded,
          onTap: () {
           if(selectedProducts.isNotEmpty){
             showDialog(context: context, builder: (context)=> AddAchat(selectedProducts: selectedProducts,)).then((value) {
                          setState((){});
                        });
           }
           else{
             showDialog(context: context, builder: (context)=>const AlertDialog(
               title:  Text('Aucun produit selectionné'),
               content: Text("Merci de selectionner les produits á acheter .Si le produit n'existe pas, ajouter le"),
             ));
           }
          },
        ),
      ],
      searchBar: Card(
        margin: EdgeInsets.all(10),
        child: SearchField(
            hint: 'Chercher ce que voulez ...',
            onSubmitted: (s) {
              search = s.toLowerCase();
              setState(() {});
            }),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              dividerThickness: 2,
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
                  products.where((element) => conditions(element)).length,
                  (index) => myDataRow(
                      products.reversed
                          .where((element) => conditions(element))
                          .elementAt(index),
                      index))),
        ),
      ),
    );
  }

  void delete(){
    if(selectedProducts.isEmpty){
      showDialog(context: context, builder: (context)=>AlertDialog(
        content: Text('Selectionner les produit á supprimer'),
      ));
    }
    else {
      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text('Etes-vous sûr de supprimer la selection?'),
        actions: [TextButton(onPressed: (){
          for (var value in selectedProducts) {
            products.removeWhere((element) => element.id==value.id);
          }

          Navigator.pop(context);
        }, child: Text('Supprimer')),
          TextButton(onPressed: (){
                   Navigator.pop(context);
                  }, child: Text('Annuler')),
        ],
      )).then((value) {
        setState((){});
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

  void showDetails(Product product) {
    showDialog(
        context: context,
        builder: (context) => ProductDetails(
              product: product,
            ));
  }

  DataRow myDataRow(Product product, int index) {
    Color color = product.quantityInStock! <= product.minQuantity!
        ? Colors.red.shade100
        : (index % 2 == 0)
            ? secondaryColor.withOpacity(0.1)
            : Colors.white54;
    return DataRow(
      onSelectChanged: (b){
        if(b==true){
          selectedProducts.add(product);
          setState((){});
        }
        else{
          selectedProducts.removeWhere((element) => element.id==product.id);
          setState((){});
        }
      },
        selected: selectedProducts.firstWhere((element) => element.id==product.id,orElse: (){return Product(id: '-1');}) .id==product.id,
        color: MaterialStateProperty.all(color), cells: [
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
