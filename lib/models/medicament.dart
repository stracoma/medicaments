class Medicament {
  final String nom;
  final String labo;
  final String posologie;
  final String prix;
  final String categorie; // doit correspondre au libellé du bouton

  const Medicament({
    required this.nom,
    required this.labo,
    required this.posologie,
    required this.prix,
    required this.categorie,
  });
}
