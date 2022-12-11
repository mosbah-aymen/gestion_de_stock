import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/user.dart';
import 'package:gestion_de_stock/screens/configuration/configuration.dart';
import 'package:gestion_de_stock/screens/gestion%20de%20caisse/caisse.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20category/categories.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20clients/List_client.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/list_entree.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20fourniseurs/list_fournisseurs.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20magasin/gestion_magasins.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/list_products.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20roles/list_role.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/list_sortie.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20users/list_users.dart';
import 'package:gestion_de_stock/screens/scan%20direct/scan_direct.dart';
import 'package:gestion_de_stock/screens/statistiques/statistics.dart';


class SideMenu extends StatelessWidget {
 final Function(String pageID) onPageChanged;
  const SideMenu({
    Key? key,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      child: ListView(
        controller: ScrollController(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: const[
                Text('Gestion De Stock',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),),
              ],
            ),
          ),
          const Divider(color: Colors.white54,),
          DrawerListTile(
                                                          title: "Scan Direct",
                                                          icon: Icons.qr_code_scanner,
                                                          press: () {
                                                             onPageChanged(ScanDirect.id);
                                                            },
            enabled: currentUser.access.contains(ScanDirect.id),
                                                        ),
          DrawerListTile(
                                                title: "Caisse",
                                                icon: Icons.account_balance_wallet_outlined,
                                                press: () {
                                                  onPageChanged(Caisse.id);
                                                  },
                    enabled: currentUser.access.contains(Caisse.id),

                                              ),
          DrawerListTile(
            title: "Gestion Des Produits",
            icon: Icons.keyboard_command_key,
            press: () {
              onPageChanged(ListProducts.id);
              },
            enabled: currentUser.access.contains(ListProducts.id),
          ),
          DrawerListTile(
                     title: "Gestion Des Achats",
                     icon: Icons.inventory_rounded,
                     press: () {
                       onPageChanged(ListEntree.id);
                       },
            enabled: currentUser.access.contains(ListEntree.id),
                   ),
          DrawerListTile(
                               title: "Gestion Des Ventes",
                               icon: Icons.sell,
                               press: () {
                                 onPageChanged(ListSorties.id);
                                 },

            enabled: currentUser.access.contains(ListSorties.id),

                             ),
          DrawerListTile(
                                        title: "Gestion Des Clients",
                                        icon: Icons.person,
                                        press: () {
                                          onPageChanged(ListClients.id);
                                          },
            enabled: currentUser.access.contains(ListClients.id),

                                      ),
          DrawerListTile(
                                        title: "Gestion Des Fournisseurs",
                                        icon: Icons.account_box_outlined,
                                        press: () {
                                          onPageChanged(ListFournisseur.id);
                                          },
            enabled: currentUser.access.contains(ListFournisseur.id),

                                      ),
          DrawerListTile(
                                                title: "Gestion Des Categories",
                                                icon: Icons.category,
                                                press: () {
                                                  onPageChanged(Categories.id);
                                                  },
            enabled: currentUser.access.contains(Categories.id),

                                              ),
          DrawerListTile(
                                                 title: "Sites/Magasins",
                                                 icon: Icons.store_mall_directory_rounded,
                                                 press: () {
                                                   onPageChanged(ListMagasins.id);
                                                   },
            enabled: currentUser.access.contains(ListMagasins.id),
                                               ),
          DrawerListTile(
                                        title: "Gestion Des Utilisateur",
                                        icon: Icons.admin_panel_settings,
                                        press: () {
                                          onPageChanged(ListUsers.id);
                                          },
            enabled: currentUser.access.contains(ListUsers.id),
                                      ),
          DrawerListTile(
                                                       title: "Gestion Des Roles",
                                                       icon: Icons.work,
                                                       press: () {
                                                         onPageChanged(ListRole.id);
                                                         },
            enabled: currentUser.access.contains(ListRole.id),

                                                     ),
          DrawerListTile(
                                                 title: "Statistiques",
                                                 icon: Icons.pie_chart_sharp,
                                                 press: () {
                                                   onPageChanged(Statistics.id);
                                                   },
            enabled: currentUser.access.contains(Statistics.id),
                                               ),
          DrawerListTile(
                                        title: "Configuration",
                                        icon: Icons.settings,
                                        press: () {
                                          onPageChanged(Configuration.id);
                                          },
            enabled: currentUser.access.contains(Configuration.id),
                                      ),

        ],
      ),
    );
  }
}


class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
    this.enabled,
  }) : super(key: key);
final bool? enabled;
  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return enabled==true? ListTile(
      onTap: press,
      hoverColor: Colors.white54,
      tileColor: idPage==title?Colors.white:null,
      horizontalTitleGap: 0.0,
      leading:Icon(
        icon,
        color: idPage==title?secondaryColor:Colors.white,

      ),
      title: Text(
        title,
        style:TextStyle(
          color: idPage==title?secondaryColor:Colors.white,
        ),
      ),
    ):const SizedBox();
  }
}
