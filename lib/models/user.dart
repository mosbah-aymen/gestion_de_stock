
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/screens/configuration/configuration.dart';
import 'package:gestion_de_stock/screens/gestion%20de%20caisse/caisse.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20clients/List_client.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/list_entree.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20fourniseurs/list_fournisseurs.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/list_sortie.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20users/list_users.dart';

class User{
  String? id,name,phone,password;
  List<String> access=defaultAccess;

  User.admin({this.id, this.name, this.phone, this.password,required this.access});
}

final List<String> defaultAccess=[
  ListProducts.id,
  ListClients.id,
  ListUsers.id,
  ListFournisseur.id,
  ListEntree.id,
  ListSorties.id,
  Caisse.id,
  Configuration.id,
];

User currentUser=User.admin(access: defaultAccess,name: 'Hamza Bouchagour',phone: '0789029332',password: '123456');