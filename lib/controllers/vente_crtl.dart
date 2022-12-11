import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_de_stock/controllers/client_crtl.dart';
import 'package:gestion_de_stock/controllers/product_crtl.dart';
import 'package:gestion_de_stock/models/vente.dart';

class VenteCrtl {
  static Vente fromJSON(Map<String, dynamic> data, String id) {
    return Vente(
      id: id,
      phone2: data['phone2'],
      phone1: data['phone1'],
      rest: data['rest'],
      createdAt: data['createdAt'],
      versed: data['versed'],
      totalPrice: data['totalPrice'],
      userName: data['userName'],
      clientName: data['clientName'],
      products: ProductCrtl.jsonToList(List.generate(
          data['products'].length, (index) => data['products'][index])),
      clientId: data['clientId'],
    );
  }

  static Map<String, dynamic> toJSON(Vente vente) {
    return {
      'id': vente.id,
      'clientId': vente.clientId,
      'products':ProductCrtl.listToJSON(vente.products!),
      'clientName': vente.clientName,
      'userName': vente.userName,
      'totalPrice': vente.totalPrice,
      'versed': vente.versed,
      'createdAt': vente.createdAt,
      'rest': vente.rest,
      'phone1': vente.phone1,
      'phone2': vente.phone2,
      'archived': false,
    };
  }

  static Future addVente(Vente vente) async {
    await FirebaseFirestore.instance
        .collection('ventes')
        .doc(vente.id)
        .set(toJSON(vente));
    if(vente.clientId!.isNotEmpty){
      try{
        await ClientCrtl.updateVersement(vente.clientId!, vente.versed!,vente.rest);
      }
      catch(e){
        print(e);
      }
        }
  }

  static Future archiverVente(Vente vente,bool archiver) async {
    await FirebaseFirestore.instance.collection('ventes').doc(vente.id).update({
      'archived': archiver,
    });

  }
}
