
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/models/fourniseur.dart';

class FournisseurCrtl{

  static Fournisseur fromJSON(Map<String,dynamic> data,String id){
    return Fournisseur(
      id: id,
      nom: data['nom'],
      createdAt: data['createdAt'],
            rest: data['rest'],
      prenom: data['prenom'],
      phone1: data['phone1'],
      phone2: data['phone2'],
      versed: data['versed'],
      commune: data['commune'],
      wilaya: data['wilaya'],
      lastCommandeAt: data['lastCommandeAt'],
      totalCommand: data['totalCommand'],
    );
  }

  static Map<String,dynamic> toJSON(Fournisseur fournisseur){
    return {
      'id':fournisseur.id,
      'lastCommandeAt':fournisseur.lastCommandeAt,
      'commune':fournisseur.commune,
      'wilaya':fournisseur.wilaya,
      'versed':fournisseur.versed,
      'phone2':fournisseur.phone2,
      'phone1':fournisseur.phone1,
      'prenom':fournisseur.prenom,
      'createdAt':fournisseur.createdAt,
      'rest':fournisseur.rest,
      'nom':fournisseur.nom,
      'totalCommand':fournisseur.totalCommand,
    };
  }
  static Future addFournisseur(Fournisseur fournisseur)async{
    await FirebaseFirestore.instance.collection('fournisseur').doc(fournisseur.id).set(toJSON(fournisseur));
  }

  static Future updateFournisseur(Fournisseur fournisseur)async{
    await FirebaseFirestore.instance.collection('fournisseur').doc(fournisseur.id).update(toJSON(fournisseur));
  }

  static Future deleteFournisseur(Fournisseur fournisseur)async{
    await FirebaseFirestore.instance.collection('fournisseur').doc(fournisseur.id).delete();
  }
  static Future updateVersement(String clientId,int versed,rest)async{
     await FirebaseFirestore.instance.collection('fournisseur').doc(clientId).update({
        'versed':FieldValue.increment(versed),
        'rest':FieldValue.increment(rest),
      });
    }





}