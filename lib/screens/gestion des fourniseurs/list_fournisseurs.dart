import 'package:gestion_de_stock/components/search_field.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/fourniseur.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20fourniseurs/add_fournisseur.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20fourniseurs/fournisseur_details.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/add_product.dart';
import 'package:gestion_de_stock/screens/workspace.dart';

class ListFournisseur extends StatefulWidget {
  static const String id = 'List Fournisseurs';
  const ListFournisseur({Key? key}) : super(key: key);

  @override
  State<ListFournisseur> createState() => _ListFournisseurState();
}

class _ListFournisseurState extends State<ListFournisseur> {
  String search='';
  int selectedIndex=-1;
  List<Fournisseur> fournisseurs=[];
  @override
  void initState() {
    fournisseurs=exampleFournisseurs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WorkSpace(headChildren: [
      HeaderElement(title: 'Créer Fournisseur',
          onTap: ()async{
       await showDialog(context: context, builder: (context)=>const AddFournisseur()).then((value) {
          setState((){});
        });
          },
          icon: Icons.person_add,),
          HeaderElement(title: 'Modifier',
              color: selectedIndex>-1?null: Colors.black54,
              onTap: ()async{
if(selectedIndex!=-1){
  await showDialog(context: context, builder: (context)=> AddFournisseur(fournisseur: exampleFournisseurs[selectedIndex])).then((value) {
           setState((){});
         });
}
              },
              icon: Icons.edit_note,),
          HeaderElement(title: 'Supprimer',
            color: selectedIndex>-1?null: Colors.black54,
                    onTap: (){},
                    icon: Icons.delete,),

    ],
      searchBar: SearchField(
                hint: 'Chercher ce que voulez ...',
                onSubmitted: (s) {
                  search = s.toLowerCase();
                  setState(() {});
                }),

    child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  dividerThickness: 2,
                  columns: const [
                    DataColumn(
                      label: Text(
                        "Nom",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Prénom",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        "Téléphone1",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    DataColumn(
                                        label: Text(
                                          "Téléphone2",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                    DataColumn(
                                         label: Text(
                                           "Wilaya",
                                           overflow: TextOverflow.ellipsis,
                                           maxLines: 1,
                                         ),
                                       ),
                    DataColumn(
                      label: Text(
                        "Commune",
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

                  ],
                  rows: List.generate(
                      fournisseurs.where((element) => conditions(element)).length,
                      (index) => myDataRow(
                          fournisseurs
                              .where((element) => conditions(element))
                              .elementAt(index),
                          index))),
            ),
          ),
    );
  }
  bool conditions(Fournisseur element) {
    return element.phone1!.startsWith(search) ||
        element.prenom!.toLowerCase().startsWith(search) ||
        element.nom!.toLowerCase().startsWith(search) ||
        element.commune!.toLowerCase().startsWith(search) ||
        element.wilaya!.toLowerCase().startsWith(search) ;
  }
  DataRow myDataRow(Fournisseur fournisseur, int index) {
    Color color = (index % 2 == 0)
            ? secondaryColor.withOpacity(0.1)
            : Colors.white54;
    return DataRow(
        onSelectChanged: (b){
          if(b==true){
            selectedIndex=index;
          }
          else{
            selectedIndex=-1;
          }
          setState((){});
        },
        selected: index==selectedIndex,
        color: MaterialStateProperty.all(color), cells: [
      DataCell(
        Text(fournisseur.nom ?? ''),
        onTap: () {
          showDetails(fournisseur);
        },
      ),
      DataCell(
        Text(fournisseur.prenom ?? ''),
        onTap: () {
          showDetails(fournisseur);
        },
      ),
      DataCell(
        Text(fournisseur.phone1 ?? ''),
        onTap: () {
          showDetails(fournisseur);
        },
      ),
      DataCell(
             Text(fournisseur.phone2 ?? '-'),
             onTap: () {
               showDetails(fournisseur);
             },
           ),
      DataCell(
        Text(fournisseur.wilaya ?? ''),
        onTap: () {
          showDetails(fournisseur);
        },
      ),
      DataCell(
              Text(fournisseur.commune ?? ''),
              onTap: () {
                showDetails(fournisseur);
              },
            ),
      DataCell(
        Text(fournisseur.createdAt != null
            ? fournisseur.createdAt!.substring(0, 16)
            : ''),
        onTap: () {
          showDetails(fournisseur);
        },
      ),
    ]);
  }
  void showDetails(Fournisseur fournisseur) {
      showDialog(
          context: context,
          builder: (context) => FournisseurDetails(
                fournisseur: fournisseur,
              ));
    }

}
