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
  int? totalPrice, verse, rest;

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
      this.totalPrice});
}

List<Achat> exampleAchat = [];
