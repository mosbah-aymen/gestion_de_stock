class Fournisseur {
  String? id, nom, prenom, phone1,phone2, wilaya, commune, createdAt,lastCommandeAt;
  int totalCommand, versed,rest;

  Fournisseur(
      {this.id,
      this.nom,
      this.prenom,
      this.phone1,
        this.phone2='-',
      this.wilaya,
      this.commune,
      this.createdAt,
        this.lastCommandeAt,
      this.totalCommand=0,
      this.versed=0,
        this.rest=0,
      });
}
List<Fournisseur> exampleFournisseurs=[
  Fournisseur(
       phone1: '0540049890',
       nom: 'Zarour',
       prenom: "Fouad",
       wilaya: 'Jijel',
       createdAt: DateTime.now().toString(),
       commune: 'El Milya',
       lastCommandeAt: DateTime.now().toString(),
       totalCommand: 45,
       versed: 200000,
    rest: 10000,
     ),
];
