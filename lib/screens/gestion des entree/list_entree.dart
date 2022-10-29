import 'dart:math';

import 'package:gestion_de_stock/components/search_field.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/achat.dart';
import 'package:gestion_de_stock/models/user.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';
import 'package:gestion_de_stock/screens/workspace.dart';

class ListEntree extends StatefulWidget {
  static const String id = 'List Entree';

  const ListEntree({Key? key}) : super(key: key);

  @override
  State<ListEntree> createState() => _ListEntreeState();
}

class _ListEntreeState extends State<ListEntree> {
  String search='';
  List<Achat> achats=[];

  bool paid=false;
  @override
  void initState() {
    for (int i = 0; i < 100; i++) {
      int t= Random().nextInt(100000),v= Random().nextInt(100000);
      exampleAchat.add(
        Achat(products: exampleProducts.sublist(0,Random().nextInt(10)),
        id: i.toString(),
        totalPrice: t,
        fournisseurPhone: '0590930303',
        fournisseurName: 'Mosbah Eddine Layadi',
        description: '',
        verse:v,
        rest: t-v,
        userId: currentUser.id,
        fournisseurId: '0',
        createdAt: DateTime.now().toString(),

        userName: "Hamza")
      );
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    achats=[];
    for (var value in exampleAchat.where((element) => condition(element, paid))) {
      achats.add(value);
};
    return WorkSpace(headChildren: [
      HeaderElement(title: 'Paid',
      onTap: (){
        paid=!paid;
        setState((){});
      },
      icon: Icons.add_shopping_cart,),
      HeaderElement(title: 'Archiver',
          onTap: (){},
          icon: Icons.archive_outlined,),
      HeaderElement(title: 'Supprimer',
                onTap: (){},
                icon: Icons.delete,),

    ],
    searchBar: SearchField(
      onSubmitted: (s){
        search=s.toLowerCase();
        setState((){});
      },
    ),
      child: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: List.generate(achats.where((element) => condition(element, paid && element.rest==0)).length, (i) => Card(
              margin: const EdgeInsets.all(10),
              child: ExpansionTile(
                backgroundColor: (i % 2 == 0)
                                          ? secondaryColor.withOpacity(0.1)
                                          : Colors.white54,
                textColor: secondaryColor,
                childrenPadding: const EdgeInsets.all(10),
                leading:                     Text(achats[i].id??"",style: TextStyle(color: secondaryColor),),
                trailing:                     Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total =${achats[i].totalPrice} DZD",
                    style: TextStyle(color: secondaryColor,fontSize: 17,fontWeight: FontWeight.bold),),
                    Text("Payer par: ${achats[i].userName}"),
                  ],
                ),
                subtitle:                     Text(achats[i].fournisseurPhone??''),
                title: Text(achats[i].fournisseurName??''),
                      children: [
                        SizedBox(
                          child: DataTable(columns:const [
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
                              rows: List.generate(achats[i].products.length, (index) => myDataRow(achats[i].products[index], index))),
                        )
                      ],
                      ),
            ),),
          ),
        ),
      ),
    );
  }
  bool condition(Achat element,bool paid){
    return element.fournisseurName!.toLowerCase().startsWith(search)
    || element.fournisseurPhone!.startsWith(search)
        || element.products.firstWhere((prd) => prd.nom!.toLowerCase().startsWith(search)).nom!.startsWith(search)
        || element.products.firstWhere((prd) => prd.ref!.toLowerCase().startsWith(search)).ref!.startsWith(search)
        || element.products.firstWhere((prd) => prd.mark!.toLowerCase().startsWith(search)).mark!.startsWith(search)
        || element.products.firstWhere((prd) => prd.category!.toLowerCase().startsWith(search)).category!.startsWith(search)
      || paid
        ;
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
