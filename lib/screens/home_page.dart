import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/screens/configuration/configuration.dart';
import 'package:gestion_de_stock/screens/gestion%20de%20caisse/caisse.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20clients/List_client.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/list_entree.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20fourniseurs/list_fournisseurs.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/list_sortie.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20users/list_users.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .22,
            height: MediaQuery.of(context).size.height,
            child: Container(
              color: Colors.blue,
              child: SideMenu(onPageChanged: (s) {
                idPage = s;
                setState(() {});
              }),
            ),
          ),
          Expanded(
              child: Container(
            color: bgColor,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16),
            child: Card(
              child: accueil(context, idPage),
            ),
          )),
        ],
      ),
    );
  }

  Widget accueil(context, String pageID) {
    return pageID == ListProducts.id
        ? const ListProducts()
        : pageID == ListEntree.id
            ? const ListEntree()
    :pageID==ListSorties.id?
        const ListSorties()
    :pageID==ListClients.id?
        const ListClients()
    :pageID==ListUsers.id?
        const ListUsers()
    :pageID==ListFournisseur.id?
        const ListFournisseur()
    :pageID==Caisse.id?
        const Caisse()
    :pageID==Configuration.id?
        const Configuration()
            : const SizedBox();
  }
}
