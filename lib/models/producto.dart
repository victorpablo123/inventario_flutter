class Producto {
  final String codigo;
  final String nombre;
  final double precio;
  final int cantidad;

  Producto({
    required this.codigo,
    required this.nombre,
    required this.precio,
    required this.cantidad,
  });

  // Convertir a Map (para guardar como JSON en SharedPreferences o DB)
  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
    };
  }

  // Crear producto desde Map
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      codigo: map['codigo'] as String,
      nombre: map['nombre'] as String,
      precio: (map['precio'] as num).toDouble(),
      cantidad: map['cantidad'] as int,
    );
  }

  // Para actualizar parcialmente un producto
  Producto copyWith({
    String? codigo,
    String? nombre,
    double? precio,
    int? cantidad,
  }) {
    return Producto(
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  @override
  String toString() {
    return 'Producto(codigo: $codigo, nombre: $nombre, precio: $precio, cantidad: $cantidad)';
  }
}
