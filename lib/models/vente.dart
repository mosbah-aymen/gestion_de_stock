
import 'package:gestion_de_stock/imports.dart';

class Vente {
  String? id, createdAt, clientName, phone1, phone2, clientId, userName;
  List<Product>? products = [];
  int? totalNet,remise,tva,ttc,timbre,autreTaxe, verse, rest,totalPrice;

  Vente({
    this.id,
    this.createdAt,
    this.clientName,
    this.userName,
    this.phone1,
    this.phone2,
    this.clientId,
    this.products,
    this.totalPrice,
    this.verse,
    this.rest,
  });
}

List<Vente> exampleCommands = [];
