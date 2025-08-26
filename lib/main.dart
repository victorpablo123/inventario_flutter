import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

// APP PRINCIPAL
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventario',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// PÁGINA PRINCIPAL
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> inventario = [];
  String searchText = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarInventario();
  }

  // 🔹 Guardar inventario en memoria
  Future<void> _guardarInventario() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("inventario", jsonEncode(inventario));
  }

  // 🔹 Cargar inventario desde memoria
  void _cargarInventario() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("inventario");

    if (data != null) {
      setState(() {
        inventario = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  // 🔹 Agregar nuevo producto
  void _agregarProducto(String codigo, String nombre, double precio) {
    setState(() {
      // Si ya existe el código, aumenta cantidad
      int index = inventario.indexWhere((p) => p['codigo'] == codigo);
      if (index != -1) {
        inventario[index]['cantidad']++;
      } else {
        inventario.add({
          "codigo": codigo,
          "nombre": nombre,
          "precio": precio,
          "cantidad": 1
        });
      }
      _guardarInventario();
    });
  }

  // 🔹 Mostrar diálogo para agregar producto
  void _mostrarFormulario() {
    final codigoCtrl = TextEditingController();
    final nombreCtrl = TextEditingController();
    final precioCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Agregar producto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codigoCtrl,
              decoration: InputDecoration(labelText: "Código"),
            ),
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: precioCtrl,
              decoration: InputDecoration(labelText: "Precio"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (codigoCtrl.text.isNotEmpty &&
                  nombreCtrl.text.isNotEmpty &&
                  precioCtrl.text.isNotEmpty) {
                _agregarProducto(
                  codigoCtrl.text,
                  nombreCtrl.text,
                  double.tryParse(precioCtrl.text) ?? 0.0,
                );
                Navigator.pop(context);
              }
            },
            child: Text("Agregar"),
          )
        ],
      ),
    );
  }

  // 🔹 Construir UI
  @override
  Widget build(BuildContext context) {
    // Filtrar productos por código
    final productosFiltrados = searchText.isEmpty
        ? inventario
        : inventario
            .where((p) =>
                p['codigo']
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("📦 Inventario"),
        actions: [
          IconButton(
      icon: Icon(Icons.attach_money),
      tooltip: "Ver total en mercadería",
      onPressed: () {
        double total = 0;
        for (var producto in inventario) {
          total += (producto['precio'] ?? 0) * (producto['cantidad'] ?? 0);
        }
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Total en mercadería"),
            content: Text(
              "S/ ${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cerrar"),
              ),
            ],
          ),
        );
      },
    ),
           IconButton(
      icon: Icon(Icons.add),
      onPressed: _mostrarFormulario,
    ),
  ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por código...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
        ),
      ),
      body: productosFiltrados.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              searchText.isEmpty
                  ? "No hay productos"
                  : "No existe ese producto",
              style: TextStyle(fontSize: 18),
            ),
            if (searchText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text("Agregar producto"),
                  onPressed: _mostrarFormulario,
                ),
              ),
          ],
        ),
      )
          : ListView.builder(
              itemCount: productosFiltrados.length,
              itemBuilder: (context, index) {
                var producto = productosFiltrados[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${producto['nombre']} (${producto['codigo']})",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text("💲 Precio: ${producto['precio']}"),
                        Text("📦 Cantidad: ${producto['cantidad']}"),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  if (producto['cantidad'] > 0) {
                                    producto['cantidad']--;
                                    _guardarInventario();
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  producto['cantidad']++;
                                  _guardarInventario();
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.black54),
                              onPressed: () {
                                setState(() {
                                  inventario.removeWhere((p) =>
                                      p['codigo'] == producto['codigo']);
                                  _guardarInventario();
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}