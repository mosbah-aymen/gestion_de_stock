import 'package:gestion_de_stock/imports.dart';

class Achat {
  String? id,
      fournisseurName,
      fournisseurPhone,
      fournisseurId,
      createdAt,
      description,
      userName,
      userId;
  List<Product> products = [];
  int? totalNet,remise,tva,ttc,timbre,autreTaxe, verse, rest,totalPrice;

  Achat(
      {this.id,
      this.fournisseurName,
      this.fournisseurPhone,
      this.fournisseurId,
      this.createdAt,
      this.description,
      this.userName,
      this.userId,
      this.verse = 0,
      this.rest = 0,
      required this.products,
      this.totalPrice,
      this.autreTaxe,
      this.remise,
        this.timbre,
        this.totalNet,
        this.ttc,this.tva,
      });
}

List<Achat> exampleAchat = [];
