import 'dart:convert';

class FieldDef {
  final String name;
  final String type;
  final String? unit;
  FieldDef({required this.name, required this.type, this.unit});

  factory FieldDef.fromMap(Map<String, dynamic> m) =>
      FieldDef(name: m['name'], type: m['type'], unit: m['unit']);
}

class PasoTemplate {
  final int pasoId;
  final String tipo;
  final String nombre;
  final String? descripcion;
  final List<FieldDef> fields;

  PasoTemplate({required this.pasoId, required this.tipo, required this.nombre, this.descripcion, required this.fields});

  factory PasoTemplate.fromMap(Map<String, dynamic> m) {
    final parsed = jsonDecode(m['campos_json']);
    final fields = (parsed['fields'] as List).map((e) => FieldDef.fromMap(e)).toList();
    return PasoTemplate(
      pasoId: m['paso_id'],
      tipo: m['tipo'],
      nombre: m['nombre'],
      descripcion: m['descripcion'],
      fields: fields,
    );
  }
}
