import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/controllers/client_crtl.dart';
import 'package:gestion_de_stock/controllers/product_crtl.dart';
import 'package:gestion_de_stock/controllers/vente_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/vente.dart';
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
  TextEditingController? verse = TextEditingController(text: '0'),
      rest = TextEditingController(text: '0'),
      description = TextEditingController(text: '');
  int total = 0, versed = 0, reste = 0;
  List<int> qty = [];
  void calculeTotal() {
    total = 0;
    for (int i = 0; i < widget.selectedProducts.length; i++) {
      total = total +
          (widget.selectedProducts[i].prixAchat! *
              widget.selectedProducts[i].quantityInStock!);
      reste = total - (int.tryParse(rest!.text) ?? 0);
    }
  }

  @override
  void initState() {
    total = 0;
    for (int i = 0; i < widget.selectedProducts.length; i++) {
      total = total + widget.selectedProducts[i].prixAchat!;
      qty.add(widget.selectedProducts[i].quantityInStock!);
      widget.selectedProducts[i].quantityInStock = 1;
    }
    reste = total - (int.tryParse(rest!.text) ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Window(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            button('Confirmer', Icons.verified_sharp, () async {
              showDialog(
                  context: context,
                  builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ));
              await nouveauVente().then((value) {
                Navigator.pop(context);
              });
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
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text('Les Produits'),
                    leading: Text(currentUser.name ?? 'no name'),
                    children: [listProducts()],
                  ),
                  Card(
                    elevation: 6,
                    color: secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FieldNewPackageForm(
                              title: 'Client',
                              textColor: Colors.white,
                              borderColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('clients')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      exampleClients.clear();
                                      if (snapshot.hasData) {
                                        for (var value in snapshot.data!.docs) {
                                          exampleClients.add(
                                              ClientCrtl.fromJSON(
                                                  value.data(), value.id));
                                        }
                                      }
                                      return !snapshot.hasData
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : PopupMenuButton(
                                              child: Text(
                                                client == null
                                                    ? 'Selectionner un client '
                                                    : '${client!.nom} ${client!.prenom}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              itemBuilder: (context) =>
                                                  List.generate(
                                                exampleClients.length,
                                                (index) => PopupMenuItem(
                                                  onTap: () {
                                                    client =
                                                        exampleClients[index];
                                                    setState((){});
                                                  },
                                                  child: Text(
                                                    '${exampleClients[index].nom} ${exampleClients[index].prenom}\n${exampleClients[index].id}',
                                                  ),
                                                ),
                                              ),
                                            );
                                    }),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FieldNewPackageForm(
                                textColor: Colors.white,
                                borderColor: Colors.white,
                                title: 'Verser',
                                child: TextFormField(
                                  controller: verse,
                                  onChanged: (s) {
                                    setState(() {
                                      versed=int.tryParse(s)?? 0 ;
                                      reste = total - versed;
                                    });
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                  decoration: decoration('',
                                      prefix: 'DZD', prefixColor: Colors.white),
                                )),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FieldNewPackageForm(
                                textColor: Colors.white,
                                borderColor: Colors.white,
                                title: 'Reste',
                                child: TextFormField(
                                  enabled: false,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  controller:
                                      TextEditingController(text: '$reste'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                  decoration: decoration('',
                                      prefix: 'DZD', prefixColor: Colors.white),
                                )),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FieldNewPackageForm(
                                textColor: Colors.white,
                                borderColor: Colors.white,
                                title: 'Total',
                                child: TextFormField(
                                  enabled: false,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]')),
                                  ],
                                  controller: TextEditingController(
                                      text: total.toString()),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: decoration('',
                                      prefix: 'DZD', prefixColor: Colors.white),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FieldNewPackageForm(
                        title: 'Description',
                        height: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 100,
                          controller: description,
                          decoration: decoration(
                            'Est-il quelque choose spécial?',
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Widget listProducts() => SizedBox(
        child: ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: Scrollbar(
            scrollbarOrientation: ScrollbarOrientation.bottom,
            interactive: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              primary: true,
              scrollDirection: Axis.horizontal,
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
                    DataColumn(
                      label: Text(
                        "Prix/Qty",
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
                        "Details",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                  rows: List.generate(
                      widget.selectedProducts.length,
                      (index) =>
                          myDataRow(widget.selectedProducts[index], index))),
            ),
          ),
        ),
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
    TextEditingController q =
        TextEditingController(text: product.quantityInStock!.toString());
    TextEditingController price =
        TextEditingController(text: product.prixAchat!.toString());
    Color color =
        (index % 2 == 0) ? primaryColor.withOpacity(0.1) : Colors.white54;
    return DataRow(color: MaterialStateProperty.all(color), cells: [
      DataCell(
        Text(product.ref ?? ''),
      ),
      DataCell(
        Text(product.nom ?? ''),
      ),
      DataCell(
        Card(
          color:q.text.isEmpty && product.quantityInStock!>=qty[index] ? Colors.red : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    if(product.quantityInStock!<qty[index]) {
                      product.quantityInStock = product.quantityInStock! + 1;
                      calculeTotal();
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.add_circle)),
              Expanded(
                child: TextFormField(
                  controller: q,
                  enabled: product.quantityInStock!<qty[index],
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  decoration: decoration('Quantitée'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  onChanged: (s) {
                    if (s.isNotEmpty) {
                      if (int.tryParse(s)! >= 1) {
                        product.quantityInStock = (int.tryParse(s) ?? 1);
                      } else {
                        product.quantityInStock = 1;
                        setState(() {});
                      }
                    } else {
                      product.quantityInStock = (int.tryParse(s) ?? 1);
                      setState(() {});
                    }
                  },
                  onEditingComplete: () {
                    calculeTotal();
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (product.quantityInStock! > 1 ) {
                      product.quantityInStock = product.quantityInStock! - 1;
                      calculeTotal();
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.remove_circle)),
            ],
          ),
        ),
      ),
      DataCell(
        Card(
          child: TextFormField(
            controller: price,
            textAlign: TextAlign.center,
            decoration: decoration('Prix Achat'),
            autofocus: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            onChanged: (s) {
              if (s.isNotEmpty) {
                if (int.tryParse(s)! >= 1) {
                  product.prixAchat = (int.tryParse(s) ?? 1);
                } else {
                  product.prixAchat = 1;
                  setState(() {});
                }
              } else {
                product.prixAchat = (int.tryParse(s) ?? 1);
                setState(() {});
              }
            },
            onEditingComplete: () {
              calculeTotal();
              setState(() {});
            },
          ),
        ),
      ),
      DataCell(
        Text((product.prixAchat! * product.quantityInStock!).toString()),
      ),
      DataCell(
        Text(product.category ?? ''),
      ),
      DataCell(
        Text(product.mark ?? ''),
      ),
      DataCell(
        const Icon(Icons.more_horiz),
        onTap: () {
          showDetails(product);
        },
      )
    ]);
  }

  void showDetails(Product product) {
    showDialog(
        context: context,
        builder: (context) => AddProduct(
              product: product,
            ));
  }

  Future nouveauVente() async {
      Vente vente = Vente(
        createdAt: DateTime.now().toString(),
        totalPrice: total,
        versed: versed,
        products: widget.selectedProducts,
        rest: total - versed,
        clientId:client==null?'' :client!.id,
        clientName:client==null?'' : '${client!.nom!} ${client!.prenom!}',
        phone1: client==null?'' :client!.phone1,
        phone2:client==null?'' : client!.phone2,
        userName: currentUser.name);
      for (int i = 0; i < qty.length; i++) {
              qty[i] -= widget.selectedProducts[i].quantityInStock!;
            }
            await ProductCrtl.modifyQuantities(widget.selectedProducts, qty);
      await VenteCrtl.addVente(vente).then((value) {
        Navigator.pop(context);
      });

  }
}
