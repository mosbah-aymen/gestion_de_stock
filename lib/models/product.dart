class Product {
  String? id,
      nom,
      mark,
      createdAt,
      updatedAt,
      fournisseurName,
      fournisseurId,
      fournisseurPhone,
      ref,
      addedBy,
      fabDate,
      expDate,
  description,
      category;


  List<String>? history=[];

  int? unitPrice, quantityInStock, minQuantity,prixAchat,prixVente,nombreDesVente;


  Product({
    this.id,
    this.nom,
    this.mark,
    this.createdAt,
    this.updatedAt,
    this.fournisseurName,
    this.fournisseurPhone,
    this.fournisseurId,
    this.description,
    this.ref,
    this.addedBy,
    this.fabDate,
    this.expDate,
    this.category,
    this.prixAchat,
    this.prixVente,
    this.unitPrice,
    this.quantityInStock,
    this.minQuantity,
    this.history,
    this.nombreDesVente,
    
  });
}
