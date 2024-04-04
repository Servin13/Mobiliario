import 'package:flutter/material.dart';
import 'package:mobiliario/models/furniture_model.dart';

class HistorialRentaScreen extends StatelessWidget {
  final List<Renta> rentas;

  HistorialRentaScreen({required this.rentas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Rentas'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16.0,
          columns: [
            DataColumn(label: Text('Cliente')),
            DataColumn(label: Text('Fecha de Renta')),
            DataColumn(label: Text('Tipo de Evento')),
            DataColumn(label: Text('Estado')),
          ],
          rows: rentas.map<DataRow>((renta) {
            return DataRow(
              cells: [
                DataCell(Text(renta.cliente.nombre)),
                DataCell(Text('${renta.fechaInicio.day}/${renta.fechaInicio.month}/${renta.fechaInicio.year}')),
                DataCell(Text(renta.cliente.tipoEvento)),
                DataCell(Text(renta.estado)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}





