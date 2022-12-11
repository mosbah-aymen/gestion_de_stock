

class Client {
  String? id, nom, prenom, phone1,phone2, wilaya, commune, createdAt;

  int? totalCommandes,rest,versed, totalSpent, spentLastMonth;

  Client(
      {this.id,
      this.nom,
      this.prenom,
      this.phone1,
        this.phone2='-',
      this.wilaya,
      this.commune,
      this.createdAt,
      this.totalCommandes,
      this.totalSpent,
        this.rest,this.versed,
      this.spentLastMonth,
      });
}

List<Client> exampleClients=[];
