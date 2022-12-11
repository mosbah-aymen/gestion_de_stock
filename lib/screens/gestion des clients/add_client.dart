
import 'package:dzair_data_usage/commune.dart';
import 'package:dzair_data_usage/dzair.dart';
import 'package:dzair_data_usage/langs.dart';
import 'package:dzair_data_usage/wilaya.dart';
import 'package:flutter/services.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/controllers/client_crtl.dart';
import 'package:gestion_de_stock/imports.dart';

class AddClient extends StatefulWidget {
  final Client? client;
  const AddClient({Key? key,this.client}) : super(key: key);

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  TextEditingController nom = TextEditingController(),
       prenom = TextEditingController(),
       commune = TextEditingController(),
       wilaya = TextEditingController(),
       phone = TextEditingController();
 
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
     if (widget.client != null) {
       initProductToModify(widget.client!);
       modification = true;
     }
     super.initState();
   }
  
  @override
  Widget build(BuildContext context) {
    return  Window(
            header: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                button(modification ? "Modifier" : 'Ajouter',
                    modification ? Icons.update : Icons.add, () async{
                  await ajouterClient().then((value) {
                    Navigator.pop(context);
                  });
                }),
                const Text(
                  "Nouveau client",
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
    
      initProductToModify(Client client) {
        nom.text = client.nom ?? '';
        prenom.text = client.prenom ?? '';
        phone.text = client.phone1 ?? '';
        wilaya.text = client.wilaya ?? '';
        commune.text = client.commune ?? '';
      }
    
      Future ajouterClient() async {
        if (allVerified()) {
          showDialog(context: context, builder: (context)=>const Center(child: CircularProgressIndicator(),),barrierDismissible: false);
          if (modification == true) {
            widget.client!.commune = commune.text;
            widget.client!.wilaya = wilaya.text;
            widget.client!.nom = nom.text;
            widget.client!.phone1 = phone.text;
            widget.client!.prenom = prenom.text;
            await ClientCrtl.modifyClient(widget.client!).then((value) {
              Navigator.pop(context);
            });
          } else {
            Client client = Client(
              nom: nom.text,
              prenom: prenom.text,
              phone1: phone.text,
              wilaya: wilaya.text,
              commune: commune.text,
              createdAt: DateTime.now().toString(),
            );
            await ClientCrtl.addClient(client).then((value) {
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
