import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/user.dart';
import 'package:gestion_de_stock/screens/configuration/configuration.dart';
import 'package:gestion_de_stock/screens/gestion%20de%20caisse/caisse.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20clients/List_client.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20entree/list_entree.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20fourniseurs/list_fournisseurs.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/list_products.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20sorties/list_sortie.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20users/list_users.dart';


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
          Divider(color: Colors.white54,),
          DrawerListTile(
            title: "Gestion Des Produits",
            icon: Icons.keyboard_command_key,
            press: () {
              onPageChanged(ListProducts.id);
              },
            enabled: currentUser.access.contains(ListProducts.id),
          ),
          DrawerListTile(
                     title: "Gestion Des Entrées",
                     icon: Icons.input_outlined,
                     press: () {
                       onPageChanged(ListEntree.id);
                       },
            enabled: currentUser.access.contains(ListEntree.id),
                   ),
          DrawerListTile(
                               title: "Gestion Des Sortie",
                               icon: Icons.output,
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
                                        title: "Gestion Des Utilisateur",
                                        icon: Icons.admin_panel_settings,
                                        press: () {
                                          onPageChanged(ListUsers.id);
                                          },
            enabled: currentUser.access.contains(ListUsers.id),
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
      horizontalTitleGap: 0.0,
      leading:Icon(
        icon,
        color: Colors.white,

      ),
      title: Text(
        title,
        style:const  TextStyle(color: Colors.white),
      ),
    ):const SizedBox();
  }
}
