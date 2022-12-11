import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dzair_data_usage/commune.dart';
import 'package:dzair_data_usage/dzair.dart';
import 'package:dzair_data_usage/langs.dart';
import 'package:dzair_data_usage/wilaya.dart';
import 'package:flutter/services.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/controllers/fournisseur_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/fourniseur.dart';

class AddFournisseur extends StatefulWidget {
  final Fournisseur? fournisseur;
  const AddFournisseur({Key? key, this.fournisseur}) : super(key: key);

  @override
  State<AddFournisseur> createState() => _AddFournisseurState();
}

class _AddFournisseurState extends State<AddFournisseur> {
  TextEditingController nom = TextEditingController(),
      prenom = TextEditingController(),
      phone = TextEditingController(),
      commune = TextEditingController(),
      wilaya = TextEditingController();

  List<Wilaya?>? wilayas = [];
  List<Commune?>? communes = [];
  getWilayas() {
    wilayas = Dzair().getWilayat();
    wilaya.text = wilayas!.first!.getWilayaName(Language.FR)!;
  }

  getCommunes(int index) {
    communes = wilayas![index]!.getCommunes();
    commune.text = communes!.first!.getCommuneName(Language.FR)!;
  }

  bool modification = false;
  @override
  void initState() {
    getWilayas();
    getCommunes(0);
    if (widget.fournisseur != null) {
      initProductToModify(widget.fournisseur!);
      modification = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Window(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            button(modification ? "Modifier" : 'Ajouter',
                modification ? Icons.update : Icons.add, () async{
              await ajouterFournisseur().then((value) {
                Navigator.pop(context);
              });
            }),
            const Text(
              "Nouveau Fournisseur",
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
                    title: 'Nom ',
                    child: TextFormField(
                      controller: nom,
                      decoration: decoration('Nom'),
                    ),
                  ),
                  FieldNewPackageForm(
                    title: 'Prénom ',
                    child: TextFormField(
                      controller: prenom,
                      decoration: decoration('Prénom'),
                    ),
                  ),
                  FieldNewPackageForm(
                    title: "Téléphone",
                    child: TextFormField(
                      controller: phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      decoration: decoration("Nº Téléphone"),
                    ),
                  ),
                  FieldNewPackageForm(
                    title: 'Wilaya ',
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: PopupMenuButton(
                          child: Text(
                            wilaya.text,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          itemBuilder: (context) => List.generate(
                              57,
                              (index) => PopupMenuItem(
                                  onTap: () {
                                    wilaya.text = wilayas![index]!
                                        .getWilayaName(Language.FR)!;
                                    getCommunes(index);
                                    setState(() {});
                                  },
                                  child: Text(wilayas![index]!
                                      .getWilayaName(Language.FR)!)))),
                    ),
                  ),
                  FieldNewPackageForm(
                    title: 'Commune ',
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: PopupMenuButton(
                          child: Text(
                            commune.text,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          itemBuilder: (context) => List.generate(
                              communes!.length,
                              (index) => PopupMenuItem(
                                  onTap: () {
                                    commune.text = communes![index]!
                                        .getCommuneName(Language.FR)!;
                                    setState(() {});
                                  },
                                  child: Text(communes![index]!
                                      .getCommuneName(Language.FR)!)))),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  bool allVerified() {
    return nom.text.length > 2 &&
        prenom.text.length > 2 &&
        phone.text.isNotEmpty &&
        commune.text.isNotEmpty &&
        wilaya.text.isNotEmpty;
  }

  initProductToModify(Fournisseur fournisseur) {
    nom.text = fournisseur.nom ?? '';
    prenom.text = fournisseur.prenom ?? '';
    phone.text = fournisseur.phone1 ?? '';
    wilaya.text = fournisseur.wilaya ?? '';
    commune.text = fournisseur.commune ?? '';
  }

  Future ajouterFournisseur() async {
    if (allVerified()) {
      showDialog(context: context, builder: (context)=>const Center(child: CircularProgressIndicator(),),barrierDismissible: false);
      if (modification == true) {
        widget.fournisseur!.commune = commune.text;
        widget.fournisseur!.wilaya = wilaya.text;
        widget.fournisseur!.nom = nom.text;
        widget.fournisseur!.phone1 = phone.text;
        widget.fournisseur!.prenom = prenom.text;
        await FournisseurCrtl.updateFournisseur(widget.fournisseur!).then((value) {
          Navigator.pop(context);
        });
      } else {
        Fournisseur fournisseur = Fournisseur(
          nom: nom.text,
          prenom: prenom.text,
          phone1: phone.text,
          wilaya: wilaya.text,
          commune: commune.text,
          createdAt: DateTime.now().toString(),
          lastCommandeAt: DateTime.now().toString(),
        );
        await FournisseurCrtl.addFournisseur(fournisseur).then((value) {
          Navigator.pop(context);
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("Merci De Verifier Les Information Obligatoire"),
              ));
    }
  }

}
