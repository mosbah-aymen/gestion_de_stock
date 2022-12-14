
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/models/magasin.dart';

class MagasinCrtl{
  static Magasin fromJSON(Map<String,dynamic> data,String id){
    return Magasin(
      id: id,
      createdBy: data['createdBy'],
      name: data['name'],
      createdAt: data['createdAt'],
      commune: data['commune'],
      wilaya: data['wilaya'],
      address: data['address'],
      description: data['description'],
      max: data['max'],
      nbProducts: data['nbProducts'],
    );
  }
  static Map<String,dynamic> toJSON(Magasin magasin){
    return {
      'id':magasin.id,
      'description':magasin.description,
      'address':magasin.address,
      'wilaya':magasin.wilaya,
      'commune':magasin.commune,
      'createdAt':magasin.createdAt,
      'name':magasin.name,
      'createdBy':magasin.createdBy,
      'nbProducts':magasin.nbProducts??0,
      'max':magasin.max??100000,
    };
  }
  static Future addMagasin(Magasin magasin)async{
    await FirebaseFirestore.instance.collection('magasins').doc().set(toJSON(magasin));
  }

  static Future modifyMagasin(Magasin magasin)async{
    await FirebaseFirestore.instance.collection('magasins').doc().set(toJSON(magasin));
  }




}