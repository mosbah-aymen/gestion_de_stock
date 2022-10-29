import 'package:gestion_de_stock/components/StatCard.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/models/fourniseur.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';

class FournisseurDetails extends StatefulWidget {
  final Fournisseur fournisseur;


  const FournisseurDetails({Key? key,required this.fournisseur}) : super(key: key);

  @override
  State<FournisseurDetails> createState() => _FournisseurDetailsState();
}

class _FournisseurDetailsState extends State<FournisseurDetails> {
  List<Product> products=[];

  @override
  Widget build(BuildContext context) {
    products=exampleProducts.sublist(0,10);
    return Window(header:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:const [

                 Text(
                  "Détails De Fournisseur",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ), body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: Padding(
                        padding:  EdgeInsets.only(top: 20),
                        child:  CircleAvatar(
                                                       backgroundColor: bgColor,
                                                       backgroundImage:
                          AssetImage('assets/images/profile.png'),
                                                       radius: 100,
                                                     ),
                      )),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              productDetails('Nom', widget.fournisseur.nom??''),
                              productDetails('Prénom', widget.fournisseur.prenom??''),
                              productDetails('Téléphone', widget.fournisseur.phone1??''),
                              productDetails('Wilaya', widget.fournisseur.wilaya??''),
                              productDetails('Commune', widget.fournisseur.commune??''),
                              productDetails('Ajouter depuis', widget.fournisseur.createdAt!.substring(0,14)),
                              productDetails('Derniere Commande En', widget.fournisseur.lastCommandeAt!.substring(0,14)),

                            ],
                          ),
                        ),
                      ),

                      Expanded(
                          flex:2,child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [ StatCard(value: widget.fournisseur.totalCommand.toStringAsFixed(0), title: 'Total Commandes', unit: "commande"),
                          StatCard(value: widget.fournisseur.versed.toStringAsFixed(0), title: 'Versé', unit: "DZD"),
                          StatCard(value: widget.fournisseur.rest.toStringAsFixed(0), title: 'Resté', unit: "DZD"),
                          StatCard(value: (widget.fournisseur.versed+widget.fournisseur.rest).toStringAsFixed(0), title: 'Total', unit: "DZD"),
                      ],))
                    ],
                  ),
                  Divider(
                                         thickness: 0.5,
                                         color: secondaryColor,
                                       ),
                  Expanded(
                    child: SizedBox(
                                              child: SingleChildScrollView(
                                                child: DataTable(columns:const [
                                                                DataColumn(
                                                                  label: Text(
                                                                    "Nº Ref",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    "Nom",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    "Catégory",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    "Mark",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    "Entrée en",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    "Quantintée",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    "Prix",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                              ],
                                                    rows: List.generate(products.length, (index) => myDataRow(products[index], index))),
                                              ),
                                            ),
                  )
                ],
              ),
            ));
  }

  void showDetails(Product product) {
      showDialog(
          context: context,
          builder: (context) => ProductDetails(
                product: product,
              ));
    }

    DataRow myDataRow(Product product, int index) {
      Color color = product.quantityInStock! <= product.minQuantity!
          ? Colors.red.shade100
          : (index % 2 == 0)
              ? secondaryColor.withOpacity(0.1)
              : Colors.white54;
      return DataRow(color: MaterialStateProperty.all(color), cells: [
        DataCell(
          Text(product.ref ?? ''),
          onTap: () {
            showDetails(product);
          },
        ),
        DataCell(
          Text(product.nom ?? ''),
          onTap: () {
            showDetails(product);
          },
        ),
        DataCell(
          Text(product.category ?? ''),
          onTap: () {
            showDetails(product);
          },
        ),
        DataCell(
          Text(product.mark ?? ''),
          onTap: () {
            showDetails(product);
          },
        ),
        DataCell(
          Text(product.createdAt != null
              ? product.createdAt!.substring(0, 16)
              : ''),
          onTap: () {
            showDetails(product);
          },
        ),
        DataCell(
          Text("${product.quantityInStock}"),
          onTap: () {
            showDetails(product);
          },
        ),
        DataCell(
          Text("${product.unitPrice}  DZD"),
          onTap: () {
            showDetails(product);
          },
        ),
      ]);
    }

  productDetails(
    String title,
    String data,
      { Color? color}

  ) =>
      SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text(
                  data,
                  maxLines: 50,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color:color?? secondaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      );

  Widget button(String title, IconData icon, Function onPressed) =>
        ElevatedButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
          ),
          onPressed: () {
            onPressed();
          },
          icon: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
          label: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        );
}
