import 'package:flutter/material.dart';
import 'package:mobiliario/models/furniture_model.dart';
import 'package:mobiliario/screens/edit_rental_screen.dart';

class DetallesRentaScreen extends StatelessWidget {
  final List<Renta> rentas;

  DetallesRentaScreen({required this.rentas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Renta'),
      ),
      body: ListView.builder(
        itemCount: rentas.length,
        itemBuilder: (context, index) {
          final renta = rentas[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cliente: ${renta.cliente.nombre}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fecha de Renta: ${renta.fechaInicio.day}/${renta.fechaInicio.month}/${renta.fechaInicio.year}',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tipo de Evento: ${renta.cliente.tipoEvento}',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Estado: ${renta.estado}',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Detalles de la Renta:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: renta.detalles.map((detalle) {
                      return Text(
                          'Mobiliario: ${detalle.mobiliario.nombre}, Cantidad: ${detalle.cantidad}');
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarRentaScreen(renta: renta),
                            ),
                          );
                        },
                        child: Text('Editar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

