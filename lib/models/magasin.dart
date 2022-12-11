
class Magasin{
  String? id,name,description,wilaya,commune,address,createdAt,createdBy;
  int? nbProducts,max;

  Magasin(
      {this.id,
      this.name,
        this.description,
      this.wilaya,
      this.commune,
      this.address,
      this.createdAt,
      this.createdBy,
        this.max,
        this.nbProducts,
      });
}