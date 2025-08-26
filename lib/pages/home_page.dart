import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> inventario = [
    {"codigo": "001", "nombre": "Producto A", "precio": 10.0, "cantidad": 5},
    {"codigo": "002", "nombre": "Producto B", "precio": 20.0, "cantidad": 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventario"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Aquí después vamos a abrir un formulario para agregar productos
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: inventario.length,
        itemBuilder: (context, index) {
          var producto = inventario[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(10),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${producto['nombre']} (${producto['codigo']})",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            producto['cantidad']++;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.black54),
                        onPressed: () {
                          setState(() {
                            inventario.removeAt(index);
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
