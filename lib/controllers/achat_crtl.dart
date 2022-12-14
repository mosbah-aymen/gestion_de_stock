import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/controllers/fournisseur_crtl.dart';
import 'package:gestion_de_stock/controllers/product_crtl.dart';
import 'package:gestion_de_stock/imports.dart';

import '../models/achat.dart';

class AchatCrtl{
  static Achat fromJSON(Map<String, dynamic> data,String id){
    return Achat(products: ProductCrtl.jsonToList(
    List.generate(data['products'].length, (index) => data['products'][index])),
      description: data['description'],
      id: id,
      createdAt: data['createdAt'],
      fournisseurPhone: data['fournisseurPhone'],
      fournisseurName: data['fournisseurName'],
      fournisseurId: data['fournisseurId'],
      userName: data['userName'],
      rest: data['rest'],
      totalPrice: data['totalPrice'],
      userId: data['userId'],
      verse: data['verse'],
    );
  }

  static Map<String,dynamic> toJSON(Achat achat){
    return {
      'id':achat.id,
      'rest':achat.rest,
      'verse':achat.verse,
      'userId':achat.userId,
      'userName':achat.userName,
      'totalPrice':achat.totalPrice,
      'fournisseurId':achat.fournisseurId,
      'fournisseurName':achat.fournisseurName,
      'fournisseurPhone':achat.fournisseurPhone,
      'createdAt':achat.createdAt,
      'description':achat.description,
      'products':ProductCrtl.listToJSON(achat.products),
      'archived':false,
    };
  }

  static Future newAchat(Achat achat)async{
    await FirebaseFirestore.instance.collection('achats').doc(achat.id).set(
      toJSON(achat),
    );
    await FournisseurCrtl.makeAchat(achat);
  }


  static Future archiverAchat(Achat achat,bool archiver)async{
    await FirebaseFirestore.instance.collection('achats').doc(achat.id).update({
      'archived':archiver,
    });
  }

  static Future delete(Achat achat)async {
    await FirebaseFirestore.instance.collection('achats').doc(achat.id).delete();
  }
}