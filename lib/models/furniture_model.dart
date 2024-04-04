class Renta {
  int id;
  DateTime fechaInicio;
  DateTime fechaFin;
  String estado;
  Cliente cliente;
  List<DetalleRenta> detalles;

  Renta({
    required this.id,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    required this.cliente,
    this.detalles = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'estado': estado,
      'cliente': cliente.toMap(),
    };
  }

  factory Renta.fromMap(Map<String, dynamic> map) {
    return Renta(
      id: map['id'],
      fechaInicio: DateTime.parse(map['fechaInicio']),
      fechaFin: DateTime.parse(map['fechaFin']),
      estado: map['estado'],
      cliente: Cliente.fromMap(map['cliente']),
    );
  }
}


class DetalleRenta {
  int id;
  Mobiliario mobiliario;
  int cantidad;

  DetalleRenta({
    required this.id,
    required this.mobiliario,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mobiliario': mobiliario.toMap(),
      'cantidad': cantidad,
    };
  }

  factory DetalleRenta.fromMap(Map<String, dynamic> map) {
    return DetalleRenta(
      id: map['id'],
      mobiliario: Mobiliario.fromMap(map['mobiliario']),
      cantidad: map['cantidad'],
    );
  }
}

class Mobiliario {
  int id;
  String nombre;
  String categoria;

  Mobiliario({
    required this.id,
    required this.nombre,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria,
    };
  }

  factory Mobiliario.fromMap(Map<String, dynamic> map) {
    return Mobiliario(
      id: map['id'],
      nombre: map['nombre'],
      categoria: map['categoria'],
    );
  }
}

class Cliente {
  int id;
  String nombre;
  String telefono1;
  String telefono2;
  String direccion;
  String tipoEvento;

  Cliente({
    required this.id,
    required this.nombre,
    required this.telefono1,
    required this.telefono2,
    required this.direccion,
    required this.tipoEvento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono1': telefono1,
      'telefono2': telefono2,
      'direccion': direccion,
      'tipoEvento': tipoEvento,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nombre: map['nombre'],
      telefono1: map['telefono1'],
      telefono2: map['telefono2'],
      direccion: map['direccion'],
      tipoEvento: map['tipoEvento'],
    );
  }
}




