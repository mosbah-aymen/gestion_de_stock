import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/controllers/magasin_crtl.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/magasin.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20magasin/add_magasin.dart';

import '../../components/workspace.dart';

class ListMagasins extends StatefulWidget {
  static const String id='Sites/Magasins';
  const ListMagasins({Key? key}) : super(key: key);

  @override
  State<ListMagasins> createState() => _ListMagasinsState();
}

class _ListMagasinsState extends State<ListMagasins> {
  List<Magasin> magasins=[];
  @override
  Widget build(BuildContext context) {
    return WorkSpace(
      headChildren: [
        HeaderElement(title: 'Ajouter',icon: Icons.add_circle,onTap: (){
          showDialog(context: context, builder: (context)=>AddMagasin());
        },),
        HeaderElement(title: 'Transferer',icon: Icons.compare_arrows,),
        HeaderElement(title: 'Supprimer',icon: Icons.delete),

      ],
      child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance.collection('magasins').orderBy('createdAt',descending: true).snapshots(),
        builder: (context, snapshot) {
          magasins.clear();
          if(snapshot.hasData){
            for (var value in snapshot.data!.docs) {
              magasins.add(MagasinCrtl.fromJSON(value.data(), value.id));
            }
          }
          return snapshot.hasError?
          const Center(child: Text("Something went wrong!!"),)
            :!snapshot.hasData?
              const Center(child: CircularProgressIndicator(),)
              :SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(magasins.length, (index) => Card(
                child:Column(
                  children: [

                    Row(
                      children: [
                        Text(magasins[index].name??''),
                        Spacer(),
                        Text('${magasins[index].wilaya} - ${magasins[index].commune}',)
                      ],
                    ),
                    Text(magasins[index].description??''),
                    Divider(
                      endIndent: MediaQuery.of(context).size.width*.5,
                    ),
                  ],
                ) ,
              )),
            ),
          );
        }
      ),
    );
  }
}
