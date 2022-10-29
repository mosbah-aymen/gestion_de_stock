import 'package:flutter/services.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/commande.dart';
import 'package:gestion_de_stock/models/user.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/add_product.dart';

class NewVente extends StatefulWidget {
  final List<Product> selectedProducts;
  const NewVente({Key? key, required this.selectedProducts}) : super(key: key);

  @override
  State<NewVente> createState() => _NewVenteState();
}

class _NewVenteState extends State<NewVente> {
  Client? client;
  TextEditingController? verse=TextEditingController(text: '0'),rest=TextEditingController(text: '0'),description=TextEditingController(text: '');
  int total=0,versed=0,reste=0;  List<int> qty = [];
  @override
  void initState() {
    total=0;
    for (int i = 0; i < widget.selectedProducts.length; i++) {
      qty.add(1);
      total=total+widget.selectedProducts[i].prixAchat!;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Window(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            button('Confirmer', Icons.verified_sharp, () {
              nouveauVente();
            }),
            const Text(
              "Nouveau Vente",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            button('Annuler', Icons.cancel_outlined, () {
              Navigator.pop(context);
            }),
          ],
        ),
        body: StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  FieldNewPackageForm(
                    title: 'Client',
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: PopupMenuButton(
                        child: Text(client==null?'Selectionner Le client ou creer un':'${client!.nom} ${client!.prenom}',
                        style:const TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 20),),
                        itemBuilder: (context) => List.generate(
                          exampleClients.length,
                          (index) => PopupMenuItem(
                            onTap: (){
                              client=exampleClients[index];
                              setState;
                            },
                            child: Text(
                                '${exampleClients[index].nom} ${exampleClients[index].prenom}'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                                 children: [
                                   Expanded(
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: FieldNewPackageForm(title: 'Verser',
                                       child:TextFormField(
                                         controller: verse,
                                         onChanged: (s){
                                           setState((){
                                             reste=total-(int.tryParse(s)??0);
                                           });
                                         },
                                         inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                    ],
                                         textAlign: TextAlign.center,
                                         decoration: decoration('', prefix: 'DZD'),
                                       )),
                                     ),
                                   ),
                                   Expanded(
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: FieldNewPackageForm(title: 'Reste',
                                       child:TextFormField(
                                         readOnly: true,
                                         inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                    ],
                                         controller: TextEditingController(text: '$reste'),
                                         textAlign: TextAlign.center,
                                         decoration: decoration('', prefix: 'DZD'),
                                       )),
                                     ),
                                   ),
                                   Expanded(
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: FieldNewPackageForm(title: 'Total',
                                       child:TextFormField(
                                         readOnly: true,
                                         inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                    ],

                                         controller: TextEditingController(text: total.toString()),
                                         textAlign: TextAlign.center,
                                         decoration: decoration('', prefix: 'DZD'),
                                       )),
                                     ),
                                   ),
                                 ],
                               ),
                  ExpansionTile(
                                title: const Text('Les Produits'),
                                leading: Text(currentUser.name ?? 'no name'),
                                children: [listProducts()],
                              ),
                               Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: FieldNewPackageForm(title: 'Description',
                                                     height: 100,
                                                     child:TextFormField(
                                                       keyboardType: TextInputType.multiline,
                                                       maxLines: 100,
                                                       controller: description,
                                                       decoration: decoration('Est-il quelque choose spécial?',),
                                                     )),
                                                   ),
                ],
              ),
            ),
          );
        }));
  }

  Widget listProducts() => SizedBox(
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
                  "Quantintée en stoc",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              DataColumn(
                label: Text(
                  "Quantintée á vendu",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              DataColumn(
                label: Text(
                  "Prix Unitaire",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              DataColumn(
                             label: Text(
                               "Prix Quantitatif",
                               overflow: TextOverflow.ellipsis,
                               maxLines: 1,
                             ),
                           ),
            ],
            rows: List.generate(widget.selectedProducts.length,
                (index) => myDataRow(widget.selectedProducts[index], index))),
      );

  Widget button(String title, IconData icon, Function onPressed) =>
      ElevatedButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        ),
        onPressed: () {
          onPressed();
        },
        icon: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
        label: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      );

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
        Text("${product.quantityInStock}"),
        onTap: () {
          showDetails(product);
        },
      ),
      DataCell(
        TextFormField(
          decoration: decoration('Qntité'),
          inputFormatters: [
                                                                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                              ],

           onChanged: (s){
             qty[index]=int.tryParse(s)??1;
             setState((){});
           },
        ),
        onTap: () {
        },
      ),
      DataCell(
        Text("${product.unitPrice}  DZD"),
        onTap: () {
          showDetails(product);
        },
      ),
      DataCell(
             Text("${product.unitPrice!*qty[index]}  DZD"),
             onTap: () {
               showDetails(product);
             },
           ),
    ]);
  }

  void showDetails(Product product) {
    showDialog(
        context: context,
        builder: (context) => AddProduct(
              product: product,
            ));
  }

  void nouveauVente() {
    if(client!=null ){
      List<String> ids = [];
          for (var element in widget.selectedProducts) {
            ids.add(element.id!);
          }
          Command command = Command(
            createdAt: DateTime.now().toString(),
            totalPrice: total,
            versed: versed,
            rest: total - versed,
            clientId: client!.id,
            clientName: '${client!.nom!} ${client!.prenom!}',
            phone1: client!.phone1,
            phone2: client!.phone2,
            userName: currentUser.name,
            quantities: qty,
          );

    }
  }
}
