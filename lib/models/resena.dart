class Resena {
  final int? id;
  final int recetaId; // id de la receta a la que pertenece la reseña
  final String texto;
  final String fecha;

  const Resena({
    this.id,
    required this.recetaId,
    required this.texto,
    required this.fecha,
  });

  // objeto -> map (para guardar en sqlite)
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'recetaId': recetaId,
      'texto': texto,
      'fecha': fecha,
    };
  }

  // Mapa (una fila de SQLite) -> objeto
  factory Resena.fromMap(Map<String, Object?> mapa) {
    return Resena(
      id: mapa['id'] as int?,
      recetaId: mapa['recetaId'] as int,
      texto: mapa['texto'] as String,
      fecha: mapa['fecha'] as String,
    );
  }
}