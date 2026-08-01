import 'package:flutter/material.dart';
import '../database/database_helper.dart';
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

  List<Medicament> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await DatabaseHelper.instance.getByCategorie(
      widget.categorie,
    );
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _laboController.dispose();
    _posologieController.dispose();
    _prixController.dispose();
    super.dispose();
  }

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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final newMed = Medicament(
                    id: existing?.id,
                    nom: _nomController.text,
                    labo: _laboController.text,
                    posologie: _posologieController.text,
                    prix: _prixController.text,
                    categorie: widget.categorie,
                  );

                  if (existing == null) {
                    await DatabaseHelper.instance.insert(newMed);
                  } else {
                    await DatabaseHelper.instance.update(newMed);
                  }

                  if (context.mounted) Navigator.pop(context);
                  await _loadItems();
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
              onPressed: () async {
                await DatabaseHelper.instance.delete(med.id!);
                if (context.mounted) Navigator.pop(context);
                await _loadItems();
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? const Center(child: Text('Aucun médicament dans cette catégorie'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final med = _items[index];
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
