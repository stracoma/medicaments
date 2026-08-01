class Medicament {
  final int? id; // null tant que l'élément n'est pas encore en base
  final String nom;
  final String labo;
  final String posologie;
  final String prix;
  final String categorie;
  final String couleur; // 'vert', 'rouge' ou 'bleu'

  const Medicament({
    this.id,
    required this.nom,
    required this.labo,
    required this.posologie,
    required this.prix,
    required this.categorie,
    this.couleur = 'bleu', // valeur par défaut
  });

  // Convertit un Medicament en Map (pour l'écriture en base)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nom': nom,
      'labo': labo,
      'posologie': posologie,
      'prix': prix,
      'categorie': categorie,
      'couleur': couleur,
    };
  }

  // Construit un Medicament à partir d'une Map (lecture depuis la base)
  factory Medicament.fromMap(Map<String, dynamic> map) {
    return Medicament(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      labo: map['labo'] as String,
      posologie: map['posologie'] as String,
      prix: map['prix'] as String,
      categorie: map['categorie'] as String,
      couleur: map['couleur'] as String? ?? 'bleu',
    );
  }

  // Utile pour créer une copie modifiée (ex: lors d'une mise à jour)
  Medicament copyWith({
    int? id,
    String? nom,
    String? labo,
    String? posologie,
    String? prix,
    String? categorie,
    String? couleur,
  }) {
    return Medicament(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      labo: labo ?? this.labo,
      posologie: posologie ?? this.posologie,
      prix: prix ?? this.prix,
      categorie: categorie ?? this.categorie,
      couleur: couleur ?? this.couleur,
    );
  }
}
