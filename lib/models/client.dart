

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
List<Client> exampleClients=[Client(
  phone1: '0655750571',
  rest: 0,
  wilaya: 'Setif',
  commune: 'Commune',
   versed: 3000,
  totalCommandes: 3,
  createdAt: DateTime.now().toString(),
  totalSpent: 3000,
  prenom: 'Moussa',
  nom: 'Aouinane',
  phone2: '0767878787',
  spentLastMonth: 1000,
  id: '12'
)];
