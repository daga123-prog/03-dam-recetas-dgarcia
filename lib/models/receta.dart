class Receta {
  final int id;
  final String nombre;
  final String cocina;
  final String dificultad;
  final List<String> ingredientes;
  final List<String> instrucciones;
  final int tiempoPreparacion;
  final int tiempoCoccion;
  final int porciones;
  final int calorias;
  final String imagenUrl;
  final double calificacion;

  const Receta({
    required this.id,
    required this.nombre,
    required this.cocina,
    required this.dificultad,
    required this.ingredientes,
    required this.instrucciones,
    required this.tiempoPreparacion,
    required this.tiempoCoccion,
    required this.porciones,
    required this.calorias,
    required this.imagenUrl,
    required this.calificacion,
  });

  factory Receta.fromJson(Map<String, dynamic> json){
    return Receta(
      id: json['id'],
      nombre: json['name'],
      cocina: json['cuisine'] ?? '',
      dificultad: json['difficulty'] ?? '',
      ingredientes: List<String>.from(json['ingredients']),
      instrucciones: List<String>.from(json['instructions']),
      tiempoPreparacion: json['prepTimeMinutes'],
      tiempoCoccion: json['cookTimeMinutes'],
      porciones: json['servings'],
      calorias: json['caloriesPerServing'],
      imagenUrl: json['image'],
      calificacion: (json['rating'] as num).toDouble(),
    );
  }

  int get tiempoTotal => tiempoPreparacion + tiempoCoccion;
}