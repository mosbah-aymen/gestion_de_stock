
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Categorie{
  String? id,name,createdBy,createdAt;
  int? color,nbrArticles;

  Categorie(
      {this.id,
      this.name,
      this.createdBy,
      this.createdAt,
      this.color,
      this.nbrArticles,
      });
}

class CategoryCrtl{

  static Categorie fromJSON(Map<String,dynamic> data,String id){
    return Categorie(
      id: id,
      name: data['name'],
      createdAt: data['createdAt'],
      color: data['color'],
      createdBy: data['createdBy'],
      nbrArticles: data['nbrArticles']??0,
    );
  }
  static Map<String,dynamic> toJSON(Categorie category){
    return {
      'id':category.id,
      'name':category.name,
      'createdAt':category.createdAt,
      'color':category.color,
      'createdBy':category.createdBy,
      'nbrArticles':category.nbrArticles??0,
    };
  }

  static Future addCategory(Categorie categorie)async{
    await FirebaseFirestore.instance.collection('categories').doc(categorie.id).set(toJSON(categorie));
  }

  static Future modifyCategory(Categorie categorie)async{
     await FirebaseFirestore.instance.collection('categories').doc(categorie.id).update(toJSON(categorie));
   }
  static Future deleteCategory(Categorie category)async{
      await FirebaseFirestore.instance.collection('categories').doc(category.id).delete();
  }

}
