import 'package:gestion_de_stock/imports.dart';

class Command{
  String? id,
  createdAt,
  clientName,phone1,phone2,clientId,userName;
  List<String>? productsIds=[];
  List<int>? quantities=[];
  int? totalPrice,versed,rest;

  Command(
      {this.id,
      this.createdAt,
      this.clientName,
        this.userName,
      this.phone1,
      this.phone2,
      this.clientId,
      this.productsIds,
      this.quantities,
      this.totalPrice,
      this.versed,
      this.rest,});
}
List<Command> exampleCommands=[];