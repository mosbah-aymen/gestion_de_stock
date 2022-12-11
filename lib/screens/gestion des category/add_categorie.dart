
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gestion_de_stock/components/FormFieldCustom.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/categorie.dart';
import 'package:gestion_de_stock/models/user.dart';

class AddCategory extends StatefulWidget {
  final Categorie ? categorie;
  const AddCategory({Key? key,this.categorie}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController nameCrtl=TextEditingController();
  int color=0;
  Categorie categorie=Categorie();
  @override
  void initState() {
    if(widget.categorie!=null){
      color=widget.categorie!.color??0;
      nameCrtl.text=widget.categorie!.name??'';
      categorie=widget.categorie!;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Window(header: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        button('Appliquer', Icons.check_circle, (){
          categorie.name=nameCrtl.text;
          if(widget.categorie!=null){
            CategoryCrtl.modifyCategory(categorie);
            Navigator.pop(context);
          }else if(categorie.name!=null && categorie.name!.isNotEmpty && color!=0){

            CategoryCrtl.addCategory(Categorie(
                        color: color,
                        nbrArticles: 0,
                        name: categorie.name,
                        id: categorie.id,
                        createdAt: DateTime.now().toString(),
                        createdBy: currentUser.name,
                      ));


          }
          else{
            showDialog(context: context, builder: (context)=> AlertDialog(title: const Text('Entrer les information essentiel'),
            actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Ok'))],));
          }
        }),
        button('Exit', Icons.cancel, (){Navigator.pop(context);})
      ],
    ), body: SingleChildScrollView(child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('Choisir une couleur: '),
          IconButton(onPressed: (){
            showDialog(
                                     context: context,
                                     builder: (context) => AlertDialog(
                                       title: const Text('Pick a color!'),
                                       content: SingleChildScrollView(
                                         child: ColorPicker(
                                           pickerColor: Color(color==0? 0xff000000:color),
                                           onColorChanged: (Color col) {
                                             color = col.value;
                                             setState(() {});
                                           },
                                         ),
                                       ),
                                       actions: <Widget>[
                                         ElevatedButton(
                                           child: const Text('Got it'),
                                           onPressed: () {
                                             Navigator.pop(context);
                                             setState(() {});
                                           },
                                         ),
                                       ],
                                     ),
                                   );
          }, icon: Icon(Icons.radio_button_checked,size:30,color: Color(color==0? 0xff000000:color),)),
          const Spacer(),
          Expanded(
            child: FieldNewPackageForm(title: 'Nom',
            child: TextFormField(
              controller: nameCrtl,
              decoration: decoration('Nom'),

            ),
            ),
          ),
          const Spacer(),
        ],
      ),

    ],),));
  }
}
