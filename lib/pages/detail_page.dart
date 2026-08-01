import 'package:flutter/material.dart';
import '../data/medicaments_data.dart';
import '../models/medicament.dart';

class DetailPage extends StatefulWidget {
  final String categorie;

  const DetailPage({super.key, required this.categorie});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _laboController = TextEditingController();
  final _posologieController = TextEditingController();
  final _prixController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _laboController.dispose();
    _posologieController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  // existing == null -> ajout ; existing != null -> modification
  void _showFormDialog({Medicament? existing}) {
    _nomController.text = existing?.nom ?? '';
    _laboController.text = existing?.labo ?? '';
    _posologieController.text = existing?.posologie ?? '';
    _prixController.text = existing?.prix ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            existing == null
                ? 'Ajouter - ${widget.categorie}'
                : 'Modifier - ${widget.categorie}',
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                  TextFormField(
                    controller: _laboController,
                    decoration: const InputDecoration(labelText: 'Labo'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                  TextFormField(
                    controller: _posologieController,
                    decoration: const InputDecoration(labelText: 'Posologie'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                  TextFormField(
                    controller: _prixController,
                    decoration: const InputDecoration(labelText: 'Prix'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newMed = Medicament(
                    nom: _nomController.text,
                    labo: _laboController.text,
                    posologie: _posologieController.text,
                    prix: _prixController.text,
                    categorie: widget.categorie,
                  );
                  setState(() {
                    if (existing == null) {
                      medicamentsData.add(newMed);
                    } else {
                      final index = medicamentsData.indexOf(existing);
                      medicamentsData[index] = newMed;
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(existing == null ? 'Ajouter' : 'Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(Medicament med) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer'),
          content: Text('Supprimer "${med.nom}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  medicamentsData.remove(med);
                });
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = medicamentsData
        .where((m) => m.categorie == widget.categorie)
        .toList();

    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text(widget.categorie),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Aucun médicament dans cette catégorie'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final med = items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[800]!, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med.nom,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Labo : ${med.labo}'),
                            Text('Posologie : ${med.posologie}'),
                            Text('Prix : ${med.prix}'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue[800]),
                            onPressed: () => _showFormDialog(existing: med),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(med),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
