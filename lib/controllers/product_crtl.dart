
import 'package:gestion_de_stock/imports.dart';

class ProductCrtl{
  Map<String,dynamic> toJSON(Product product){
    return {
      'id':product.id,
      'nom':product.nom,
      'createdAt':product.createdAt,
      'updatedAt':product.updatedAt,
      'description':product.description,
      'ref':product.ref,
      'nombreDesVente':product.nombreDesVente,
      'quantityInStock':product.quantityInStock,
      'prixAchat':product.prixAchat,
      'category':product.category,
      'mark':product.mark,
      'fournisseurPhone':product.fournisseurPhone,
      'fournisseurName':product.fournisseurName,
      'prixVente':product.prixVente,
      'addedBy':product.addedBy,
      'expDate':product.expDate,
      'fabDate':product.fabDate,
      'fournisseurId':product.fournisseurId,
      'history':product.history,
      'minQuantity':product.minQuantity,
      'unitPrice':product.unitPrice,
    };
  }

  static Product fromJSON(Map<String, dynamic> data){
    return Product(
      nom: data['nom'],
      unitPrice: data['unitPrice'],
      createdAt: data['createdAt'],
      minQuantity: data['minQuantity'],
      history: data['history'],
      fournisseurId: data['fournisseurId'],
      fabDate: data['fabDate'],
      nombreDesVente:  data['nombreDesVente'],
      expDate: data['expDate'],
      addedBy: data['addedBy'],
      prixVente: data['prixVente'],
      fournisseurName: data['fournisseurName'],
      fournisseurPhone: data['fournisseurPhone'],
      mark: data['mark'],
      category: data['category'],
      prixAchat: data['prixAchat'],
      quantityInStock: data['quantityInStock'],
      ref: data['ref'],
      description: data['description'],
      updatedAt: data['updatedAt'],
      id: data['id'],
    );
  }

  static Future addProduct(Product product)async{

  }
}