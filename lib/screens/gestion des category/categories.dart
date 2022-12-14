import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/components/workspace.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/categorie.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20category/add_categorie.dart';

class Categories extends StatefulWidget {
  static const String id='Categories';
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // List<Categorie> categories=[];
  Categorie? selectedCategorie;
  @override
  Widget build(BuildContext context) {
    return WorkSpace(headChildren:  [
      HeaderElement(title: 'Ajouter',icon: Icons.add_circle,onTap: (){
        showDialog(context: context, builder: (context)=>const AddCategory());
      },),
       HeaderElement(title: 'Modifier',icon: Icons.update,onTap: (){
         if(selectedCategorie!=null){
           showDialog(context: context, builder: (context)=> AddCategory(categorie: selectedCategorie,));
         }
       },),
       HeaderElement(title: 'Supprimer',icon: Icons.delete,onTap: (){
        if(selectedCategorie!=null){
          showDialog(context: context, builder: (context)=>AlertDialog(
            title: Text('Voulez-vous vraiment supprimer cette catégorie?'),
            actions: [TextButton(onPressed: (){
              FirebaseFirestore.instance.collection('categories').doc(selectedCategorie!.id).delete();
              Navigator.pop(context);
            }, child: const Text('Supprimer')),
            TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Annuler'))],
          ));
        }
      },)
    ],child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('categories').orderBy('createdAt',descending: true).snapshots(),
      builder: (context, snapshot) {
        categories.clear();
        if(snapshot.hasData){
          for (var value in snapshot.data!.docs) {
            categories.add(CategoryCrtl.fromJSON(value.data(), value.id));
          }
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DataTable(
                dataRowHeight: 30,
                dividerThickness: 2,
                showCheckboxColumn: true,
                columns:const [
                  DataColumn(label: Text('Couleur')),
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Créer Par')),
                  DataColumn(label: Text('Créer En')),
                ],
                rows:List.generate(categories.length, (index) => dataRow(categories[index],index)),
              ),
            ],
          ),
        );
      }
    ),);
  }
  DataRow dataRow(Categorie categorie,int index){
    Color color =  (index % 2 == 0)
              ? primaryColor.withOpacity(0.1)
              : Colors.white12;
    return DataRow(
        onSelectChanged: (b) {
               if (b == true) {
                 selectedCategorie=categorie;
                 setState(() {});

               } else {
                 selectedCategorie=null;
                 setState(() {});

               }

             },
        color: MaterialStateProperty.all(color),
        selected: selectedCategorie!=null && categorie.id==selectedCategorie!.id,
        cells: [
      DataCell(Icon(Icons.radio_button_checked,color: Color(categorie.color!),)),
      DataCell(Text(categorie.name??'')),
      DataCell(Text(categorie.createdBy.toString())),
      DataCell(Text(categorie.createdAt.toString().substring(0,16)))
    ]);
  }
}
