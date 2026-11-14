import 'package:flutter/material.dart';
import 'package:recetasapp/data/receta_db.dart';
import 'package:recetasapp/models/receta.dart';
import 'package:recetasapp/models/resena.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  final _controlador = TextEditingController();
  List<Resena> _resenas = [];

  @override
  void initState() {
    super.initState();
    _cargarResenas();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  // trae de la bd las reseñas de ESTA receta
  Future<void> _cargarResenas() async {
    final lista = await RecetaDb.instancia.obtenerPorReceta(widget.receta.id);
    if (!mounted) return;
    setState(() => _resenas = lista);
  }

  Future<void> _agregarResena() async {
    final texto = _controlador.text.trim();
    if (texto.isEmpty) return;
    await RecetaDb.instancia.insertar(
      Resena(
        recetaId: widget.receta.id,
        texto: texto,
        fecha: DateTime.now().toString().substring(0, 16),
      ),
    );
    _controlador.clear();
    _cargarResenas();
  }

  Future<void> _eliminarResena(int id) async {
    await RecetaDb.instancia.eliminar(id);
    _cargarResenas();
  }

  @override
  Widget build(BuildContext context) {
    final receta = widget.receta;
    return Scaffold(
      appBar: AppBar(title: Text("Detalle de la receta")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(14),
            child: Image.network(
              receta.imagenUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/plato-placeholder.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text('${receta.tiempoTotal} min')),
              Chip(label: Text(receta.dificultad)),
              Chip(label: Text(receta.cocina)),
              Chip(label: Text('${receta.calorias} kcal')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingrediente))
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Preparación: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
          const SizedBox(height: 8),
          ...receta.instrucciones.asMap().entries.map(
            (entrada) => Padding(padding: const EdgeInsetsGeometry.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      '${entrada.key+1}',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entrada.value))
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Reseñas (${_resenas.length}): ",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controlador,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Escribe una reseña',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _agregarResena,
            child: const Text('Agregar reseña'),
          ),
          const SizedBox(height: 8),
          ..._resenas.map(
            (r) => Card(
              child: ListTile(
                title: Text(r.texto),
                subtitle: Text(r.fecha),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _eliminarResena(r.id!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}