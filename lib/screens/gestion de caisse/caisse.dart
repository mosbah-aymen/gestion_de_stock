import 'package:gestion_de_stock/components/workspace.dart';
import 'package:gestion_de_stock/imports.dart';
import 'package:gestion_de_stock/screens/gestion%20des%20produits/product_details.dart';

class Caisse extends StatefulWidget {
  static const String id = 'Caisse';
  const Caisse({Key? key}) : super(key: key);

  @override
  State<Caisse> createState() => _CaisseState();
}

class _CaisseState extends State<Caisse> {
  List<Product> products = [];
  @override
  Widget build(BuildContext context) {
    return WorkSpace(
      headChildren: const [
        HeaderElement(title: 'Nouveau', icon: Icons.add_circle_outline_sharp),
        HeaderElement(
          title: 'Valider',
          icon: Icons.check_circle_outline,
        ),
        HeaderElement(
          title: 'Annuler',
          icon: Icons.cancel_outlined,
        ),
        HeaderElement(
          title: 'Supprimer',
          icon: Icons.delete,
        ),
      ],
      child: Row(
        children: [
          Expanded(child: Column()),
          Expanded(
              child: Column(
            children: [
              Card(
                color: secondaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: const [
                        Text(
                          'Montant Actuel Dans la Caisse: ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          '0 DA',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )))
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                    color: secondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        child: DataTable(
                          headingTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          columns: const [
                            DataColumn(label: Text('Ref')),
                            DataColumn(label: Text('Nom')),
                            DataColumn(label: Text('Marque')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Prix')),
                          ],
                          rows: List.generate(products.length, (index) => myDataRow(products[index], index)),
                        ),
                      ),
                    )),
              ),
            ],
          ))
        ],
      ),
    );
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
        Text(product.mark ?? ''),
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
        Text("${product.unitPrice}  DZD"),
        onTap: () {
          showDetails(product);
        },
      ),
    ]);
  }
}
