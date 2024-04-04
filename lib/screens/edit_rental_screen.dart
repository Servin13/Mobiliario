import 'package:flutter/material.dart';
import 'package:mobiliario/models/furniture_model.dart';
import 'package:mobiliario/database/furniture_database.dart';

class EditarRentaScreen extends StatefulWidget {
  final Renta renta;

  EditarRentaScreen({required this.renta});

  @override
  _EditarRentaScreenState createState() => _EditarRentaScreenState();
}

class _EditarRentaScreenState extends State<EditarRentaScreen> {
  late TextEditingController _clienteNombreController;
  late TextEditingController _clienteTelefono1Controller;
  late TextEditingController _clienteTelefono2Controller;
  late TextEditingController _clienteDireccionController;
  late TextEditingController _clienteTipoEventoController;
  late TextEditingController _estadoController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _clienteNombreController =
        TextEditingController(text: widget.renta.cliente.nombre);
    _clienteTelefono1Controller =
        TextEditingController(text: widget.renta.cliente.telefono1);
    _clienteTelefono2Controller =
        TextEditingController(text: widget.renta.cliente.telefono2);
    _clienteDireccionController =
        TextEditingController(text: widget.renta.cliente.direccion);
    _clienteTipoEventoController =
        TextEditingController(text: widget.renta.cliente.tipoEvento);
    _estadoController = TextEditingController(text: widget.renta.estado);
    _selectedDate = widget.renta.fechaInicio;
  }

  @override
  void dispose() {
    _clienteNombreController.dispose();
    _clienteTelefono1Controller.dispose();
    _clienteTelefono2Controller.dispose();
    _clienteDireccionController.dispose();
    _clienteTipoEventoController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Renta'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detalles del Cliente',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _clienteNombreController,
              decoration: InputDecoration(labelText: 'Nombre del Cliente'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _clienteTelefono1Controller,
              decoration: InputDecoration(labelText: 'Teléfono 1'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _clienteTelefono2Controller,
              decoration: InputDecoration(labelText: 'Teléfono 2'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _clienteDireccionController,
              decoration: InputDecoration(labelText: 'Dirección del Cliente'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _clienteTipoEventoController,
              decoration: InputDecoration(labelText: 'Tipo de evento'),
            ),
            SizedBox(height: 16),
            Text(
              'Fecha de Renta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _selectDate();
              },
              child: Text(
                'Seleccionar fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Estado de la Renta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _estadoController,
              decoration: InputDecoration(labelText: 'Estado'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _guardarCambios();
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarCambios() async {
    String nuevoEstado = _estadoController.text;

    Cliente clienteActualizado = Cliente(
      id: widget.renta.cliente.id,
      nombre: _clienteNombreController.text,
      telefono1: _clienteTelefono1Controller.text,
      telefono2: _clienteTelefono2Controller.text,
      direccion: _clienteDireccionController.text,
      tipoEvento: _clienteTipoEventoController.text,
    );

    Renta rentaActualizada = Renta(
      id: widget.renta.id,
      fechaInicio: _selectedDate,
      fechaFin: _selectedDate,
      estado: nuevoEstado,
      cliente: clienteActualizado,
      detalles: widget.renta.detalles,
    );

    int filasActualizadas = await _actualizarRenta(rentaActualizada);

    if (filasActualizadas > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cambios guardados exitosamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar los cambios')),
      );
    }
  }

  Future<int> _actualizarRenta(Renta renta) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return await databaseHelper.actualizarRenta(renta);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
