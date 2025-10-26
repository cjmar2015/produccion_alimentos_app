import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  ApiService(this.baseUrl);

  Future<List<dynamic>> getProductos() async {
    final r = await http.get(Uri.parse('$baseUrl/api/productos'));
    if (r.statusCode != 200) throw Exception('Error: ${r.statusCode}');
    return jsonDecode(r.body);
  }

  Future<List<dynamic>> getPasos(int idProducto) async {
    final r = await http.get(Uri.parse('$baseUrl/api/plantilla/$idProducto/pasos'));
    if (r.statusCode != 200) throw Exception('Error: ${r.statusCode}');
    return jsonDecode(r.body);
  }

  Future<int> crearProceso(int idTpl, String operario, {String? lote, String? obs}) async {
    final r = await http.post(Uri.parse('$baseUrl/api/proceso/nuevo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id_tpl": idTpl,
        "operario": operario,
        "lote": lote,
        "observaciones": obs
      }));
    if (r.statusCode != 200) throw Exception('Error crear proceso');
    return (jsonDecode(r.body)['id_proceso'] as num).toInt();
  }

  Future<void> registrarPaso(int idProceso, int pasoId, String usuario, Map<String, dynamic> datos) async {
    final r = await http.post(Uri.parse('$baseUrl/api/proceso/$idProceso/paso/$pasoId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "usuario": usuario,
        "datos_json": jsonEncode(datos)
      }));
    if (r.statusCode != 200) throw Exception('Error registrar paso');
  }

  /// Nuevo método para guardar procesos de producción (materias primas, etc.)
  Future<void> guardarProcesoProduccion({
    required int idProducto,
    required String tipoProces,
    required String operario,
    required Map<String, dynamic> datos,
    String? lote,
    String? observaciones,
  }) async {
    final r = await http.post(
      Uri.parse('$baseUrl/api/proceso-produccion/guardar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id_producto": idProducto,
        "tipo_proceso": tipoProces,
        "operario": operario,
        "datos_campos": datos,
        "lote": lote,
        "observaciones": observaciones,
        "fecha_registro": DateTime.now().toIso8601String(),
      }),
    );
    
    if (r.statusCode != 200) {
      throw Exception('Error al guardar proceso: ${r.statusCode}');
    }
  }
}
