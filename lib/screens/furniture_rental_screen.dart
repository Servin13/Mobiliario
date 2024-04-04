import 'package:flutter/material.dart';
import 'package:mobiliario/models/furniture_model.dart';
import 'package:mobiliario/screens/historial_rental_screen.dart';
import 'package:mobiliario/screens/details_rental_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:mobiliario/database/furniture_database.dart';

class AltaRentaScreen extends StatefulWidget {
  @override
  _AltaRentaScreenState createState() => _AltaRentaScreenState();
}

class _AltaRentaScreenState extends State<AltaRentaScreen> {
  late TextEditingController _clienteNombreController;
  late TextEditingController _clienteTelefono1Controller;
  late TextEditingController _clienteTelefono2Controller;
  late TextEditingController _clienteDireccionController;
  late TextEditingController _clienteTipoEventoController;
  Map<String, int> _cantidadSeleccionada = {
    'Sillas': 0,
    'Mesas': 0,
    'Manteles': 0,
    'Inflables': 0,
  };
  String _status = 'Pendiente';
  DateTime _selectedDate = DateTime.now();
  List<Renta> rentasList = []; // Lista de rentas

  @override
  void initState() {
    super.initState();
    _clienteNombreController = TextEditingController();
    _clienteTelefono1Controller = TextEditingController();
    _clienteTelefono2Controller = TextEditingController();
    _clienteDireccionController = TextEditingController();
    _clienteTipoEventoController = TextEditingController();
  }

  @override
  void dispose() {
    _clienteNombreController.dispose();
    _clienteTelefono1Controller.dispose();
    _clienteTelefono2Controller.dispose();
    _clienteDireccionController.dispose();
    _clienteTipoEventoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Renta De Mobiliario'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: badges.Badge(
              //badgeContent: Text('3'),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
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
              'Fecha de Renta', // Subtítulo agregado
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: _selectDate,
              child: Text(
                'Seleccionar fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Categorías de Mobiliario',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildCheckboxWithQuantity('Sillas'),
            _buildCheckboxWithQuantity('Mesas'),
            _buildCheckboxWithQuantity('Manteles'),
            _buildCheckboxWithQuantity('Inflables'),
            SizedBox(height: 16),
            Text(
              'Estado de la Renta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _status,
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: <String>['Pendiente', 'Cancelado', 'Cumplido']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _agregarDetalleRenta,
              child: Text('Agregar Detalle'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistorialRentaScreen(rentas: rentasList),
                ),
              );
            },
            child: Icon(Icons.history),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _navigateToDetallesRentaScreen,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _navigateToDetallesRentaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesRentaScreen(rentas: rentasList),
      ),
    );
  }

  Widget _buildCheckboxWithQuantity(String category) {
    return Row(
      children: [
        Checkbox(
          value: _cantidadSeleccionada[category]! > 0,
          onChanged: (bool? value) {
            setState(() {
              _cantidadSeleccionada[category] = value! ? 1 : 0;
            });
          },
        ),
        Text(category),
        SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cantidad',
            ),
            onChanged: (value) {
              setState(() {
                _cantidadSeleccionada[category] = int.tryParse(value) ?? 0;
              });
            },
          ),
        ),
      ],
    );
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

  void _agregarDetalleRenta() async {
    Cliente cliente = Cliente(
      id: 1,
      nombre: _clienteNombreController.text,
      telefono1: _clienteTelefono1Controller.text,
      telefono2: _clienteTelefono2Controller.text,
      direccion: _clienteDireccionController.text,
      tipoEvento: _clienteTipoEventoController.text,
    );

    List<DetalleRenta> detallesRenta = [];
    _cantidadSeleccionada.forEach((category, quantity) {
      if (quantity > 0) {
        detallesRenta.add(
          DetalleRenta(
            id: detallesRenta.length + 1,
            mobiliario: Mobiliario(
              id: detallesRenta.length + 1,
              nombre: category,
              categoria: category,
            ),
            cantidad: quantity,
          ),
        );
      }
    });

    Renta nuevaRenta = Renta(
      id: rentasList.length + 1,
      fechaInicio: _selectedDate,
      fechaFin:
          _selectedDate,
      estado: _status,
      cliente: cliente,
      detalles: detallesRenta,
    );

    rentasList.add(nuevaRenta);

    await DatabaseHelper().insertRenta(nuevaRenta);

    _clienteNombreController.clear();
    _clienteTelefono1Controller.clear();
    _clienteTelefono2Controller.clear();
    _clienteDireccionController.clear();
    _clienteTipoEventoController.clear();
    _selectedDate = DateTime.now();
    _cantidadSeleccionada.keys.toList().forEach((key) {
      setState(() {
        _cantidadSeleccionada[key] = 0;
      });
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles Agregados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cliente: ${cliente.nombre}'),
              SizedBox(height: 8),
              Text('Teléfono 1: ${cliente.telefono1}'),
              SizedBox(height: 8),
              Text('Teléfono 2: ${cliente.telefono2}'),
              SizedBox(height: 8),
              Text('Dirección: ${cliente.direccion}'),
              SizedBox(height: 8),
              Text('Tipo de Evento: ${cliente.tipoEvento}'),
              SizedBox(height: 8),
              Text(
                  'Fecha de Renta: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              SizedBox(height: 8),
              Text('Estado de la Renta: $_status'),
              SizedBox(height: 16),
              Text('Detalles de la Renta:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: detallesRenta.map((detalle) {
                  return Text(
                      'Mobiliario: ${detalle.mobiliario.nombre}, Cantidad: ${detalle.cantidad}');
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}



