import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:mobiliario/models/furniture_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _dbName = 'rentas.db';
  static final _rentaTable = 'rentas';
  static final _detalleRentaTable = 'detalle_renta';
  static final _mobiliarioTable = 'mobiliario';
  static final _clienteTable = 'clientes';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_rentaTable(
            id INTEGER PRIMARY KEY,
            fechaInicio TEXT,
            fechaFin TEXT,
            estado TEXT,
            clienteId INTEGER,
            FOREIGN KEY (clienteId) REFERENCES $_clienteTable(id)
          )
          ''');

      await db.execute('''
          CREATE TABLE $_detalleRentaTable(
            id INTEGER PRIMARY KEY,
            rentaId INTEGER,
            mobiliarioId INTEGER,
            cantidad INTEGER,
            FOREIGN KEY (rentaId) REFERENCES $_rentaTable(id),
            FOREIGN KEY (mobiliarioId) REFERENCES $_mobiliarioTable(id)
          )
          ''');

      await db.execute('''
          CREATE TABLE $_mobiliarioTable(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            categoria TEXT
          )
          ''');

      await db.execute('''
          CREATE TABLE $_clienteTable(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            telefono1 TEXT,
            telefono2 TEXT,
            direccion TEXT,
            tipoEvento TEXT
          )
          ''');
    });
  }

  Future<int> insertRenta(Renta renta) async {
    Database db = await database;
    return await db.insert(_rentaTable, renta.toMap());
  }

  Future<List<Renta>> getRentas() async {
    Database db = await database;
    List<Map<String, dynamic>> rentas = await db.query(_rentaTable);
    return List.generate(rentas.length, (i) {
      return Renta(
        id: rentas[i]['id'],
        fechaInicio: DateTime.parse(rentas[i]['fechaInicio']),
        fechaFin: DateTime.parse(rentas[i]['fechaFin']),
        estado: rentas[i]['estado'],
        cliente: Cliente.fromMap(rentas[i]),
        detalles: [],
      );
    });
  }

  Future<int> insertDetalleRenta(DetalleRenta detalle) async {
    Database db = await database;
    return await db.insert(_detalleRentaTable, detalle.toMap());
  }

  Future<List<DetalleRenta>> getDetallesRenta(int rentaId) async {
    Database db = await database;
    List<Map<String, dynamic>> detalles =
        await db.query(_detalleRentaTable, where: 'rentaId = ?', whereArgs: [rentaId]);
    return List.generate(detalles.length, (i) {
      return DetalleRenta(
        id: detalles[i]['id'],
        mobiliario: Mobiliario.fromMap(detalles[i]),
        cantidad: detalles[i]['cantidad'],
      );
    });
  }

  Future<int> insertMobiliario(Mobiliario mobiliario) async {
    Database db = await database;
    return await db.insert(_mobiliarioTable, mobiliario.toMap());
  }

  Future<List<Mobiliario>> getMobiliarios() async {
    Database db = await database;
    List<Map<String, dynamic>> mobiliarios = await db.query(_mobiliarioTable);
    return List.generate(mobiliarios.length, (i) {
      return Mobiliario(
        id: mobiliarios[i]['id'],
        nombre: mobiliarios[i]['nombre'],
        categoria: mobiliarios[i]['categoria'],
      );
    });
  }

  Future<int> insertCliente(Cliente cliente) async {
    Database db = await database;
    return await db.insert(_clienteTable, cliente.toMap());
  }

  Future<List<Cliente>> getClientes() async {
    Database db = await database;
    List<Map<String, dynamic>> clientes = await db.query(_clienteTable);
    return List.generate(clientes.length, (i) {
      return Cliente(
        id: clientes[i]['id'],
        nombre: clientes[i]['nombre'],
        telefono1: clientes[i]['telefono1'],
        telefono2: clientes[i]['telefono2'],
        direccion: clientes[i]['direccion'],
        tipoEvento: clientes[i]['tipoEvento'],
      );
    });
  }

  Future<int> actualizarRenta(Renta renta) async {
  Database db = await database;
  return await db.update(
    _rentaTable,
    renta.toMap(),
    where: 'id = ?',
    whereArgs: [renta.id],
  );
}

}
