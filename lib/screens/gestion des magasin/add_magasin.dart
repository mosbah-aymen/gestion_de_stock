
import 'package:dzair_data_usage/commune.dart';
import 'package:dzair_data_usage/dzair.dart';
import 'package:dzair_data_usage/langs.dart';
import 'package:dzair_data_usage/wilaya.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/controllers/magasin_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/magasin.dart';
import 'package:gestion_de_stock/models/user.dart';

class AddMagasin extends StatefulWidget {
  final Magasin? magasin;
  const AddMagasin({Key? key,this.magasin}) : super(key: key);

  @override
  State<AddMagasin> createState() => _AddMagasinState();
}

class _AddMagasinState extends State<AddMagasin> {
  Magasin magasin=Magasin();
  TextEditingController nameCrtl=TextEditingController(),descriptionCrtl=TextEditingController(),
  addressCrtl=TextEditingController(),maxCrtl=TextEditingController(),commune = TextEditingController(),
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
  @override
  void initState() {
   getWilayas();
   getCommunes(0);
    if(widget.magasin!=null){
      magasin=widget.magasin!;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Window(header: Row(
      children: [
        button('Appliquer', Icons.check_circle, ()async{
          await MagasinCrtl.addMagasin(Magasin(
            description: descriptionCrtl.text,
            max: int.tryParse(maxCrtl.text)??10000,
            createdBy: currentUser.name,
            createdAt: DateTime.now().toString(),
            name: nameCrtl.text,
            commune: commune.text,
            wilaya: wilaya.text,
            address: addressCrtl.text,
          )).then((value) {
            Navigator.pop(context);
          });
        })
      ],
    ), body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: FieldNewPackageForm(
                    title: 'Nom De Magasin',
                    child: TextFormField(decoration: decoration('Nom De Magasin'),
                      controller: nameCrtl,
                    ),
                  ),
                ),
                SizedBox(width: 30,),
                Expanded(
                              child: FieldNewPackageForm(
                                title: 'Maximum Des Articles',
                                child: TextFormField(decoration: decoration('Maximum Des Articles'),
                                  controller: maxCrtl,
                                ),
                              ),
                            ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: FieldNewPackageForm(
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
                ),
                                SizedBox(width: 30,),
                                Expanded(
                                  child: FieldNewPackageForm(
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
                                ),
                SizedBox(width: 30,),
                                Expanded(
                                              child: FieldNewPackageForm(
                                                title: 'Address',
                                                child: TextFormField(decoration: decoration('Address'),
                                                  controller: addressCrtl,
                                                ),
                                              ),
                                            ),
              ],
            ),
          ),
          FieldNewPackageForm(
                   title: 'Description',
                   height: 80,
                   icon: Icons.description_outlined,
                   child: TextFormField(decoration: decoration('Description'),
                     controller: descriptionCrtl,
                     maxLines: 50,
                     keyboardType: TextInputType.multiline,
                   ),
                 ),

        ],
      ),),
    ));
  }
}
