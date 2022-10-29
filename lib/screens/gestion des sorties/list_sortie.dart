import 'dart:math';

import 'package:gestion_de_stock/components/search_field.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/commande.dart';
import 'package:gestion_de_stock/models/user.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';
import 'package:gestion_de_stock/screens/workspace.dart';
class ListSorties extends StatefulWidget {
  static const String id = 'List Sorties';
  const ListSorties({Key? key}) : super(key: key);

  @override
  State<ListSorties> createState() => _ListSortiesState();
}

class _ListSortiesState extends State<ListSorties> {
  String search='';
List<Command> selectedCommands=[];
@override
  void initState() {
  for(int i=0;i<10;i++){
    int t= Random().nextInt(100000);
    exampleCommands.add(Command(
      id: i.toString(),
      phone1: '0540047893',
      createdAt: DateTime.now().toString(),
      versed: t-Random().nextInt(100),
      totalPrice: t,
      quantities: List.generate(i+2, (index) =>Random().nextInt(10) ),
      productsIds: List.generate(i+2, (index) =>exampleProducts[Random().nextInt(20)].id! ),
      clientName: 'moussa',
      userName: currentUser.name,
      clientId: '',
    ));
  }
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WorkSpace(headChildren: [HeaderElement(title: 'title'),HeaderElement(title: 'title'),HeaderElement(title: 'title'),],
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
        child:  SizedBox(
                  child: Column(
                    children: List.generate(exampleCommands.where((element) => conditions(element,)).length, (i) => Card(
                      margin: const EdgeInsets.all(10),
                      child: ExpansionTile(
                        backgroundColor: (i % 2 == 0)
                                                  ? secondaryColor.withOpacity(0.1)
                                                  : Colors.white54,
                        textColor: secondaryColor,
                        childrenPadding: const EdgeInsets.all(10),
                        leading:                     Text(exampleCommands[i].id??"",style: TextStyle(color: secondaryColor),),
                        trailing:                     Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total =${exampleCommands[i].totalPrice} DZD",
                            style: TextStyle(color: secondaryColor,fontSize: 17,fontWeight: FontWeight.bold),),
                            Text("Payer par: ${exampleCommands[i].userName}"),
                          ],
                        ),
                        subtitle:                     Text(exampleCommands[i].phone1??''),
                        title: Text(exampleCommands[i].clientName??''),
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
                                      rows: List.generate(exampleCommands[i].productsIds!.length,
                                              (index) => myDataRow(exampleProducts.firstWhere(
                                                      (element) => element.id==exampleCommands[index].id),
                                                  index))),
                                )
                              ],
                              ),
                    ),),
                  ),
                ),
      ),
    );
  }
  bool conditions(Command command){
    return command.id!.contains(search);
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

