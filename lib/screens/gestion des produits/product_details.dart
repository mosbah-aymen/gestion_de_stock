import 'package:gestion_de_stock/imports.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: _size.width * .05, horizontal: _size.width * .1),
      child: Card(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              color: secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  button('Valider', Icons.check_circle, () {}),
                  const Text(
                    "Details De Produit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  button('Exit', Icons.cancel_outlined, () {
                    Navigator.pop(context);
                  }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.nom ?? 'Product name',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Nº : ${widget.product.ref}',
                              style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(
                              color: Colors.black45,
                              thickness: 0.5,
                            ),
                            productDetails(
                                'Nom De Produit', widget.product.nom ?? ''),
                            productDetails(
                                'Mark De Produit', widget.product.mark ?? ''),
                            productDetails(
                                'Refference', widget.product.ref ?? ''),
                            productDetails(
                                'Categorie', widget.product.category ?? ''),
                            productDetails(
                                'Ajouté Par ', widget.product.addedBy ?? ''),
                            const Divider(
                              thickness: 1,
                            ),
                            productDetails('Premiere Création En ',
                                widget.product.createdAt ?? ''),
                            productDetails('Derniere Modification ',
                                widget.product.updatedAt ?? ''),
                            productDetails('Date De Fabrication ',
                                widget.product.fabDate ?? ''),
                            productDetails("Date D'Expiration ",
                                widget.product.expDate ?? ''),
                            const Divider(
                              thickness: 1,
                            ),
                            productDetails(
                                'Quantité En Stock ',
                                widget.product.quantityInStock.toString() ),
                            productDetails('Quantité Minimal ',
                                widget.product.minQuantity.toString() ),
                            productDetails('Prix Unitaire ',
                                '${widget.product.unitPrice}   DZD' ,color: secondaryColor),
                            productDetails(
                                'Prix Total ',
                                "${widget.product.quantityInStock! *
                                            widget.product.unitPrice!}   DZD" ,
                            color: secondaryColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Circuit De Vie',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width:double.infinity,
                            margin:const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.4, color: Colors.black54),
                              color: secondaryColor.withOpacity(0.01),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              controller: ScrollController(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: List.generate(
                                  widget.product.history!.length,
                                  (i) => Container(
                                    margin:const  EdgeInsets.all(8),
                                    child:
                                        Card(child: ListTile(
                                            title: Text(widget.product.history?[i]??''))),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                flex: 2,
                child: Text(
                  data,
                  maxLines: 50,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color:color?? Colors.grey,
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
          padding:const EdgeInsets.symmetric(
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
          style: TextStyle(color: Colors.white),
        ),
      );
}
