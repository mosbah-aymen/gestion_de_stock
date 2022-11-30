
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/imports.dart';

class ProductCrtl{
  static Map<String,dynamic> toJSON(Product product){
    return {
      'nom':product.nom??'',
      'createdAt':product.createdAt??'',
      'updatedAt':product.updatedAt??'',
      'description':product.description??'',
      'ref':product.ref??"",
      'nombreDesVente':product.nombreDesVente??0,
      'quantityInStock':product.quantityInStock??0,
      'prixAchat':product.prixAchat??0,
      'category':product.category??'',
      'mark':product.mark??'',
      'fournisseurPhone':product.fournisseurPhone??'',
      'fournisseurName':product.fournisseurName??'',
      'prixVente':product.prixVente??0,
      'addedBy':product.addedBy??'',
      'expDate':product.expDate??'',
      'fabDate':product.fabDate??'',
      'fournisseurId':product.fournisseurId??"",
      'history':product.history??[],
      'minQuantity':product.minQuantity??0,
      'unitPrice':product.unitPrice??0,
    };
  }

  static Product fromJSON(Map<String, dynamic> data,String id){
    return Product(
      nom: data['nom']??'no name',
      unitPrice: data['unitPrice']??0,
      createdAt: data['createdAt'],
      minQuantity: data['minQuantity']??0,
      history: List.generate(data['history']==null?0:data['history'].length, (index) => data['history'][index].toString()),
      fournisseurId: data['fournisseurId']??'',
      fabDate: data['fabDate']??'',
      nombreDesVente:  data['nombreDesVente']??0,
      expDate: data['expDate']??'',
      addedBy: data['addedBy']??'',
      prixVente: data['prixVente']??0,
      fournisseurName: data['fournisseurName']??'no name ',
      fournisseurPhone: data['fournisseurPhone']??'no phone',
      mark: data['mark']??'no marque',
      category: data['category']??'no category',
      prixAchat: data['prixAchat']??0,
      quantityInStock: data['quantityInStock']??0,
      ref: data['ref']??'',
      description: data['description']??'',
      updatedAt: data['updatedAt']??'',
      id: id,
    );
  }

  static Future addProduct(Product product)async{
    String err='';
    try {
      print('inside');
      await FirebaseFirestore.instance.collection('products').doc().set(
          ProductCrtl.toJSON(product));

    }
    catch(e){
      print(err);
      print(e);
    }
  }
}