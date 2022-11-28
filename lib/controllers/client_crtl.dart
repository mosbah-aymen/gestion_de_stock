import 'package:gestion_de_stock/imports.dart';

class ClientCrtl{
  static Client fromJSON(Map<String, dynamic> data){
    return Client(
      wilaya: data['wilaya'],
      commune: data['commune'],
      id: data['id'],
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
      'versed':client.versed,
      'phone1':client.phone1,
      'phone2':client.phone2,
      'prenom':client.prenom,
      'totalSpent':client.totalSpent,
      'spentLastMonth':client.spentLastMonth,
      'totalCommandes':client.totalCommandes,
    };
  }
  static newClient(Client client)async{

  }
}