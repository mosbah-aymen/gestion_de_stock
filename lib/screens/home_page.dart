import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/screens/configuration/configuration.dart';
import 'package:gestion_de_stock/screens/gestion%20de%20caisse/caisse.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20category/categories.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20clients/List_client.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/list_entree.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20fourniseurs/list_fournisseurs.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20magasin/gestion_magasins.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20roles/list_role.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/list_sortie.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20users/list_users.dart';
import 'package:gestion_de_stock/screens/scan%20direct/scan_direct.dart';
import 'package:gestion_de_stock/screens/statistiques/statistics.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .22,
            height: MediaQuery.of(context).size.height,
            child: SideMenu(onPageChanged: (s) {
              idPage = s;
              setState(() {});
            }),
          ),
          Expanded(
              child: Container(
            color: bgColor,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.white.withOpacity(0.9),
              elevation: 0,
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
            : pageID == ListSorties.id
                ? const ListSorties()
                : pageID == ListClients.id
                    ? const ListClients()
                    : pageID == ListRole.id
                        ? const ListRole()
                        : pageID == Categories.id
                            ? const Categories()
                            : pageID == ListMagasins.id
                                ? const ListMagasins()
                                : pageID == Statistics.id
                                    ? const Statistics()
                                    : pageID == ScanDirect.id
                                        ? const ScanDirect()
                                        : pageID == ListUsers.id
                                            ? const ListUsers()
                                            : pageID == ListFournisseur.id
                                                ? const ListFournisseur()
                                                : pageID == Caisse.id
                                                    ? const Caisse()
                                                    : pageID == Configuration.id
                                                        ? const Configuration()
                                                        : const SizedBox();
  }
}
