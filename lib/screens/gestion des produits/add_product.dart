import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/controllers/product_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/categorie.dart';
import 'package:gestion_de_stock/models/user.dart';

class AddProduct extends StatefulWidget {
  final Product? product;
  const AddProduct({Key? key, this.product}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<Widget> right = [], left = [];
  TextEditingController nom = TextEditingController(),
      ref = TextEditingController(),
      description = TextEditingController(),
      mark = TextEditingController(),
      stock = TextEditingController(),
      min = TextEditingController(),
      pVente = TextEditingController(),
      category = TextEditingController(text: ''),
      pAchat = TextEditingController();
  String fab = '', exp = '';
  int color=0;
  @override
  void initState() {
    right = getRight();
    left = getLeft();
    if (widget.product != null) {
      initProductToModify(widget.product!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 800;
    return Window(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            button(widget.product == null ? 'Ajouter' : 'Modifier',
                widget.product == null ? Icons.add : Icons.edit_note, () async {
              await ajouterProduct().then((value) {
                Navigator.pop(context);
              });
            }),
            const Text(
              "Nouveau Produit",
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
          child: Container(
            padding: const EdgeInsets.all(20),
            child: isSmall
                ? Column(
                    children: right + left,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: right,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          children: left,
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }

  getRight() => [
        FieldNewPackageForm(
          title: 'Nom De Produit',
          child: TextFormField(
            controller: nom,
            textAlign: TextAlign.center,
            decoration: decoration('Nom De Produit'),
          ),
        ),
        FieldNewPackageForm(
          title: 'Mark De Produit',
          child: TextFormField(
            controller: mark,
            textAlign: TextAlign.center,
            decoration: decoration('Nom De Produit'),
          ),
        ),
        FieldNewPackageForm(
          title: "Prix D'Achat",
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: pAchat,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: decoration("Prix D'Achat"),
          ),
        ),
        FieldNewPackageForm(
          title: "Quantity En Stock",
          child: TextFormField(
            controller: stock,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: decoration("Prix De Vente"),
          ),
        ),
        StatefulBuilder(builder: (context, setState) {
          return FieldNewPackageForm(
            title: 'Date De Fabrication',
            onPressed: () async {
              await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
              ).then((value) {
                print(value);
                if (value != null) {
                  fab = value.toString().substring(0, 10);
                } else {
                  fab = '/';
                }
                setState(() {});
              });
            },
            child: Center(
              child: Text(
                fab.isEmpty ? "Voir Le Calendier" : fab,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }),
        FieldNewPackageForm(
          title: 'Description',
          height: 100,
          child: TextFormField(
            controller: description,
            decoration: decoration('Description'),
          ),
        ),
      ];
  getLeft() => [
        FieldNewPackageForm(
          title: 'Refference De Produit',
          child: TextFormField(
            controller: ref,
            textAlign: TextAlign.center,
            decoration: decoration('Refference De Produit'),
          ),
        ),
        StatefulBuilder(builder: (context, setState) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                categories.clear();
                if (snapshot.hasData) {
                  for (var value in snapshot.data!.docs) {
                    categories
                        .add(CategoryCrtl.fromJSON(value.data(), value.id));
                  }
                }
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : FieldNewPackageForm(
                        title: "Category",
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PopupMenuButton(
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Text(
                                    category.text.isEmpty
                                        ? 'Clicker Pour Voir La List'
                                        : category.text,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                itemBuilder: (context) => List.generate(
                                  categories.length,
                                  (index) => PopupMenuItem(
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.radio_button_checked,
                                          color:
                                              Color(categories[index].color!),
                                        ),
                                        title: Text(
                                            categories[index].name.toString())),
                                    onTap: () {
                                      category.text =
                                          categories[index].name ?? '';
                                      color=categories[index].color!;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              });
        }),
        FieldNewPackageForm(
          title: "Prix De Vente",
          child: TextFormField(
            controller: pVente,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: decoration("Prix De Vente"),
          ),
        ),
        FieldNewPackageForm(
          title: "Quantity Minimal",
          child: TextFormField(
            controller: min,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: decoration("Quantity Minimal"),
          ),
        ),
        StatefulBuilder(builder: (context, setState) {
          return FieldNewPackageForm(
            title: "Date D'Expiration",
            onPressed: () async {
              await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
              ).then((value) {
                print(value);
                if (value != null) {
                  exp = value.toString().substring(0, 10);
                } else {
                  exp = '/';
                }
                setState(() {});
              });
            },
            child: Center(
              child: Text(
                exp.isEmpty ? "Voir Le Calendier" : exp,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }),
      ];

  bool allVerified() {
    return nom.text.length > 2 &&
        ref.text.isNotEmpty &&
        category.text.isNotEmpty &&
        pAchat.text.isNotEmpty &&
        pVente.text.isNotEmpty &&
        stock.text.isNotEmpty &&
        min.text.isNotEmpty &&
        mark.text.isNotEmpty;
  }

  initProductToModify(Product product) {
    nom.text = product.nom ?? '';
    ref.text = product.ref ?? '';
    mark.text = product.mark ?? '';
    min.text = product.minQuantity.toString();
    pAchat.text = product.prixAchat.toString();
    pVente.text = product.prixVente.toString();
    stock.text = product.quantityInStock.toString();
    description.text = product.description ?? '';
    category.text = product.category ?? '';
    fab = product.fabDate ?? '/';
    exp = product.expDate ?? '/';
  }

  Future ajouterProduct() async {
    if (allVerified()) {
      Product product = Product(
        nom: nom.text,
        id: widget.product == null ? null : widget.product!.id,
        ref: ref.text,
        mark: mark.text,
        category: category.text,
        categoryColor: color,
        quantityInStock: int.tryParse(stock.text),
        minQuantity: int.tryParse(min.text),
        unitPrice: int.tryParse(pAchat.text),
        prixAchat: int.tryParse(pAchat.text),
        prixVente: int.tryParse(pAchat.text),
        description: description.text,
        createdAt: widget.product == null
            ? DateTime.now().toString()
            : widget.product!.createdAt,
        updatedAt: DateTime.now().toString(),
        addedBy: currentUser.name,
        history: ['Ajouté par ${currentUser.name} '],
        fabDate: fab,
        expDate: exp,
      );
      await ProductCrtl.addProduct(product);
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("Merci De Verifier Les Information Obligatoire"),
              ));
    }
  }

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
}
