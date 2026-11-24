import 'package:flutter/material.dart';
import 'package:recetasapp/models/receta.dart';
import 'package:recetasapp/screens/detalle_receta_screen.dart';
import 'package:recetasapp/services/recipe_service.dart';
import 'package:recetasapp/widgets/receta_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<Receta>> _futureRecetas;

  // Filtro y buscador
  final TextEditingController _buscadorController = TextEditingController();
  List<Receta> _recetasFiltradas = [];
  List<Receta> _todasLasRecetas = [];

  @override
  void initState() {
    super.initState();
    _futureRecetas = _recipeService.obtenerRecetas();
  }

  @override
  void dispose() {
    _buscadorController.dispose();
    super.dispose();
  }

  void _filtrarRecetas(String texto) {
    setState(() {
      _recetasFiltradas = _todasLasRecetas.where((receta) {
        return receta.nombre.toLowerCase().contains(texto.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecetasApp'),
        backgroundColor: const Color.fromARGB(255, 80, 23, 3),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscadorController,
              onChanged: _filtrarRecetas,
              decoration: const InputDecoration(
                hintText: "Buscar receta por nombre",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Receta>>(
              future: _futureRecetas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                //condicion para el buscador
                if (_todasLasRecetas.isEmpty) {
                  _todasLasRecetas = snapshot.data!;
                  _recetasFiltradas = snapshot.data!;
                }
                if (_recetasFiltradas.isEmpty) {
                  return const Center(child: Text('No se encontraron recetas'));
                }

                final recetas = _recetasFiltradas;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: recetas.length,
                  itemBuilder: (context, index) {
                    return RecetaCard(
                      receta: recetas[index],
                      onTap: () async {
                        final bool? esFavorita = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetalleRecetaScreen(receta: recetas[index]),
                          ),
                        );
                        if (esFavorita != null) {
                          // Si luego usas esFavorita, aquí puedes reaccionar
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}