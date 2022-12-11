import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/imports.dart';

class ClientCrtl{
  static Client fromJSON(Map<String, dynamic> data,String id){
    return Client(
      wilaya: data['wilaya'],
      commune: data['commune'],
      id: id,
      createdAt: data['createdAt'],
      rest: data['rest']??0,
      versed: data['versed']??0,
      phone1: data['phone1']??'',
      spentLastMonth: data['spentLastMonth']??0,
      phone2: data['phone2']??"",
      nom: data['nom'],
      prenom: data['prenom'],
      totalSpent: data['totalSpent']??0,
      totalCommandes: data['totalCommandes']??0,
    );
  }
  static Map<String, dynamic> toJSON(Client client){
    return {
      'wilaya':client.wilaya,
      'createdAt':client.createdAt,
      'id':client.id,
      'commune':client.commune,
      'nom':client.nom,
      'versed':client.versed??0,
      'rest':client.rest??0,
      'phone1':client.phone1,
      'phone2':client.phone2,
      'prenom':client.prenom,
      'totalSpent':client.totalSpent??0,
      'spentLastMonth':client.spentLastMonth??0,
      'totalCommandes':client.totalCommandes??0,
    };
  }
  static addClient(Client client)async{
    await FirebaseFirestore.instance.collection('clients').doc(client.id).set(toJSON(client));

  }

  static modifyClient(Client client)async{
     await FirebaseFirestore.instance.collection('clients').doc(client.id).update(toJSON(client));

   }

  static Future deleteClient(Client client)async {
    await FirebaseFirestore.instance.collection('clients').doc(client.id).delete();
  }

  static Future updateVersement(String clientId,int versed,rest)async{
   await FirebaseFirestore.instance.collection('clients').doc(clientId).update({
      'versed':FieldValue.increment(versed),
      'rest':FieldValue.increment(rest),
    });
  }
}