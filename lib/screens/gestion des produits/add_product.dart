import 'dart:math';

import 'package:flutter/services.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/imports.dart';
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
      category = TextEditingController(),
      pAchat = TextEditingController();
  String fab = '', exp = '';
  @override
  void initState() {
    right = getRight();
    left = getLeft();
if(widget.product!=null){
  initProductToModify(widget.product!);

}    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 800;
    return Window(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            button(widget.product==null?'Ajouter':'Modifier', widget.product==null?Icons.add:Icons.edit_note, () {
              ajouterProduct();
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
            decoration: decoration('Nom De Produit'),
          ),
        ),
        FieldNewPackageForm(
          title: 'Mark De Produit',
          child: TextFormField(
            controller: mark,
            decoration: decoration('Nom De Produit'),
          ),
        ),
        FieldNewPackageForm(
          title: "Prix D'Achat",
          child: TextFormField(
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
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: decoration("Prix De Vente"),
          ),
        ),
    StatefulBuilder(
      builder: (context,setState) {
        return FieldNewPackageForm(
                  title: 'Date De Fabrication',
                  onPressed: ()async{
                  await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(3000),).then((value) {
                    print(value);
                     if(value!=null){
                                    fab=value.toString().substring(0,10);
                                  }
                     else{
                       fab='/';
                     }
                    setState((){});

                   });
                  },
                  child: Center(
                    child: Text(
                                           fab.isEmpty?"Voir Le Calendier":fab,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                  ),
                );
      }
    ),
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
            decoration: decoration('Refference De Produit'),
          ),
        ),
        StatefulBuilder(builder: (context, setState) {
          return FieldNewPackageForm(
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
                        child: Expanded(child: Text(categories[index])),
                        onTap: () {
                          category.text = categories[index];
                          print(category.text);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: FieldNewPackageForm(
                                    title: "Nouveau Category",
                                    child: TextFormField(
                                      controller: category,
                                      decoration:
                                          decoration('Nouveau Category'),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          if (categories
                                              .contains(category.text)) {
                                            Navigator.pop(context);
                                          } else {
                                            categories.add(category.text);
                                            setState(() {});
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text(
                                            'Ajouter et Sauvegarder')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Annuler')),
                                  ],
                                ));
                      },
                      child: const Text('Ajouter Category'))
                ],
              ),
            ),
          );
        }),
        FieldNewPackageForm(
          title: "Prix De Vente",
          child: TextFormField(
            controller: pVente,
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
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            decoration: decoration("Quantity Minimal"),
          ),
        ),
    StatefulBuilder(
          builder: (context,setState) {
            return FieldNewPackageForm(
                      title: "Date D'Expiration",
                      onPressed: ()async{
                      await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(3000),).then((value) {
                        print(value);
                         if(value!=null){
                                        exp=value.toString().substring(0,10);
                                      }
                         else{
                           exp='/';
                         }
                        setState((){});

                       });
                      },
                      child: Center(
                        child: Text(
                                               exp.isEmpty?"Voir Le Calendier":exp,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                      ),
                    );
          }
        ),
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
    pVente.text=product.prixVente.toString();
    stock.text = product.quantityInStock.toString();
    description.text = product.description ?? '';
    category.text = product.category ?? '';
    fab = product.fabDate ?? '/';
    exp = product.expDate ?? '/';
  }

  ajouterProduct(){
    if(allVerified()){
      Product product=Product(
        nom: nom.text,
        ref: ref.text,
        mark: mark.text,
        category: category.text,
        quantityInStock: int.tryParse(stock.text),
        minQuantity: int.tryParse(min.text),
        unitPrice: int.tryParse(pAchat.text),
        prixAchat: int.tryParse(pAchat.text),
        prixVente: int.tryParse(pAchat.text),
        description: description.text,
        createdAt: DateTime.now().toString(),
        updatedAt:  DateTime.now().toString(),
        addedBy: currentUser.name,
        history: ['Ajouté par ${currentUser.name} '],
        id: Random().nextInt(1000000000).toString(),
        fabDate: fab,
        expDate: exp,
      );
      exampleProducts.add(product);
                      Navigator.pop(context);
    }
    else{
      showDialog(context: context, builder: (context)=>const AlertDialog(content: Text("Merci De Verifier Les Information Obligatoire"),));
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
