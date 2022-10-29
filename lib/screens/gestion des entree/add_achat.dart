import 'package:flutter/services.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/achat.dart';
import 'package:gestion_de_stock/models/fourniseur.dart';
import 'package:gestion_de_stock/models/user.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/add_product.dart';

class AddAchat extends StatefulWidget {
  final List<Product> selectedProducts;
  const AddAchat({Key? key, required this.selectedProducts}) : super(key: key);

  @override
  State<AddAchat> createState() => _AddAchatState();
}

class _AddAchatState extends State<AddAchat> {
  Fournisseur? fournisseur;
  TextEditingController? verse=TextEditingController(text: '0'),rest=TextEditingController(text: '0'),description=TextEditingController(text: '');
  int total=0,versed=0,reste=0;
  @override
  void initState() {
    total=0;
    for (var element in widget.selectedProducts) {
      total=total+element.prixAchat!;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Window(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          button('Valider', Icons.add, () {
            ajouterAchat();
            Navigator.pop(context);
          }),
          const Text(
            "Nouveau Achat",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FieldNewPackageForm(
                  title: 'Fournisseur',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: PopupMenuButton(
                      position: PopupMenuPosition.over,
                      child:  Text(
                                               fournisseur==null?'Selectionner le fournisseur': '${fournisseur!.nom!} ${fournisseur!.prenom!}'),
                      itemBuilder: (context) => List.generate(
                        exampleFournisseurs.length,
                        (index) => PopupMenuItem(
                          onTap: (){
                            fournisseur=exampleFournisseurs[index];
                            setState((){});
                          },
                          child: ListTile(
                            title: Text(
                                '${exampleFournisseurs[index].nom!} ${exampleFournisseurs[index].prenom!}',
                            textAlign: TextAlign.center,),
                            subtitle: Column(
                              children: [
                                Text('${exampleFournisseurs[index].phone1}'),
                                Text(
                                    '${exampleFournisseurs[index].commune!} ${exampleFournisseurs[index].wilaya!}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ExpansionTile(
                title: const Text('Les Produits'),
                leading: Text(currentUser.name ?? 'no name'),
                children: [listProducts()],
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
      ),
    );
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

  void showDetails(Product product) {
    showDialog(
        context: context,
        builder: (context) => AddProduct(
              product: product,
            ));
  }

  bool allVerified(){
    return fournisseur!=null;

  }
  void ajouterAchat() {
    if(allVerified()){
      Achat achat = Achat(products: widget.selectedProducts,
      rest: reste,
      totalPrice: total,
      verse: versed,
      fournisseurId: fournisseur!.id,
      fournisseurPhone: fournisseur!.phone1,
      fournisseurName: fournisseur!.nom,
      userName: currentUser.name,
      userId: currentUser.id,
      description: description!.text,
      createdAt: DateTime.now().toString(),
      );
exampleAchat.add(achat);
    }
  }
}
