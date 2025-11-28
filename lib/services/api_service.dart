import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  static const String _apiKey =
      'client_3m2n1o0p9q8r7s6t5u4v3w2x1y0z9a8b7c6d5e4f3g2h1i0j9k8l7m6n5o4p';

  ApiService(this.baseUrl);

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'X-API-Key': _apiKey,
  };

  Future<List<dynamic>> getProductos() async {
    try {
      final r = await http.get(
        Uri.parse('$baseUrl/api/productos'),
        headers: _headers,
      );

      // Si hay error de autenticación, usar datos de ejemplo directamente
      if (r.statusCode == 401) {
        print(
          '🔒 Error de autenticación 401, usando productos de ejemplo locales',
        );
        return _getProductosEjemplo();
      }

      if (r.statusCode != 200) throw Exception('Error: ${r.statusCode}');

      final responseData = jsonDecode(r.body);

      // Verificar si la respuesta indica tabla vacía
      if (responseData is Map &&
          responseData['id_producto'] == null &&
          responseData['nombre'] == null) {
        print(
          '⚠️ Tabla producto vacía, intentando insertar productos de ejemplo...',
        );

        // Intentar insertar productos de ejemplo
        await _insertarProductosEjemplo();

        // Intentar obtener datos nuevamente
        final r2 = await http.get(
          Uri.parse('$baseUrl/api/productos'),
          headers: _headers,
        );

        if (r2.statusCode == 200) {
          final newData = jsonDecode(r2.body);
          if (newData is List && newData.isNotEmpty) {
            return newData;
          }
        }

        // Si aún no hay datos, usar fallback local
        print('📦 Usando productos de ejemplo locales');
        return _getProductosEjemplo();
      }

      // Si la respuesta es una lista válida con datos, devolverla
      if (responseData is List) {
        return responseData;
      }

      // Si es un objeto válido, convertirlo en lista
      return [responseData];
    } catch (e) {
      print('❌ Error conectando con API: $e');
      // En caso de error, devolver datos de ejemplo
      print('📦 Usando productos de ejemplo locales por error de conexión');
      return _getProductosEjemplo();
    }
  }

  Future<void> _insertarProductosEjemplo() async {
    try {
      final productos = _getProductosEjemplo();

      for (final producto in productos) {
        try {
          await http.post(
            Uri.parse('$baseUrl/api/productos'),
            headers: _headers,
            body: jsonEncode({
              'nombre': producto['nombre'],
              'descripcion': producto['descripcion'],
              'categoria': producto['categoria'],
            }),
          );
        } catch (e) {
          print('⚠️ Error insertando producto ${producto['nombre']}: $e');
        }
      }
    } catch (e) {
      print('❌ Error al intentar insertar productos: $e');
    }
  }

  List<dynamic> _getProductosEjemplo() {
    return [
      {
        'id_producto': 1,
        'nombre': 'Mermelada de Fresa',
        'descripcion': 'Mermelada artesanal de fresa natural',
        'categoria': 'Conservas Dulces',
      },
      {
        'id_producto': 2,
        'nombre': 'Salsa de Tomate',
        'descripcion': 'Salsa de tomate casera concentrada',
        'categoria': 'Conservas Saladas',
      },
      {
        'id_producto': 3,
        'nombre': 'Dulce de Leche',
        'descripcion': 'Dulce de leche tradicional cremoso',
        'categoria': 'Dulces',
      },
      {
        'id_producto': 4,
        'nombre': 'Encurtidos Mixtos',
        'descripcion': 'Vegetales encurtidos en vinagre',
        'categoria': 'Conservas Saladas',
      },
    ];
  }

  Future<List<dynamic>> getPasos(int idProducto) async {
    final r = await http.get(
      Uri.parse('$baseUrl/api/plantilla/$idProducto/pasos'),
      headers: _headers,
    );
    if (r.statusCode != 200) throw Exception('Error: ${r.statusCode}');
    return jsonDecode(r.body);
  }

  Future<int> crearProceso(
    int idTpl,
    String operario, {
    String? lote,
    String? obs,
  }) async {
    final r = await http.post(
      Uri.parse('$baseUrl/api/proceso/nuevo'),
      headers: _headers,
      body: jsonEncode({
        "id_tpl": idTpl,
        "operario": operario,
        "lote": lote,
        "observaciones": obs,
      }),
    );
    if (r.statusCode != 200) throw Exception('Error crear proceso');
    return (jsonDecode(r.body)['id_proceso'] as num).toInt();
  }

  Future<void> registrarPaso(
    int idProceso,
    int pasoId,
    String usuario,
    Map<String, dynamic> datos,
  ) async {
    final r = await http.post(
      Uri.parse('$baseUrl/api/proceso/$idProceso/paso/$pasoId'),
      headers: _headers,
      body: jsonEncode({"usuario": usuario, "datos_json": jsonEncode(datos)}),
    );
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
      headers: _headers,
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

  /// Obtener lista de proveedores desde el namespace 'proveedores'
  Future<List<dynamic>> getProveedores() async {
    try {
      final r = await http.get(
        Uri.parse('$baseUrl/api/proveedores'),
        headers: _headers,
      );

      // Si hay error de autenticación, usar datos de ejemplo directamente
      if (r.statusCode == 401) {
        print(
          '🔒 Error de autenticación 401 en proveedores, usando datos de ejemplo locales',
        );
        return [
          {
            'id': 1,
            'nombre_comercial': 'DISTRIBUIDORA ALIMENTOS S.A.S',
            'razon_social':
                'Distribuidora de Alimentos Sociedad por Acciones Simplificada',
            'telefono': '300-123-4567',
            'email': 'contacto@distribuidoraalimentos.com',
            'direccion': 'CALLE 45 #67-89 ZONA INDUSTRIAL',
          },
          {
            'id': 2,
            'nombre_comercial': 'PROVEEDORA LA GRANJA LTDA',
            'razon_social': 'Proveedora La Granja Limitada',
            'telefono': '310-987-6543',
            'email': 'ventas@lagranja.com',
            'direccion': 'CARRERA 12 #34-56 SECTOR RURAL',
          },
          {
            'id': 3,
            'nombre_comercial': 'AGROINDUSTRIAL DEL VALLE',
            'razon_social': 'Agroindustrial del Valle S.A.S',
            'telefono': '320-456-7890',
            'email': 'info@agrovalle.com',
            'direccion': 'AVENIDA 18 #90-12 PARQUE INDUSTRIAL',
          },
        ];
      }

      if (r.statusCode != 200) {
        throw Exception('Error al obtener proveedores: ${r.statusCode}');
      }

      final responseData = jsonDecode(r.body);

      // Si la respuesta es una lista válida con datos, devolverla
      if (responseData is List && responseData.isNotEmpty) {
        return responseData;
      }

      // Si no hay datos, devolver proveedores de ejemplo
      print('⚠️ API de proveedores vacía, usando datos de ejemplo');
      return [
        {
          'id': 1,
          'nombre_comercial': 'DISTRIBUIDORA ALIMENTOS S.A.S',
          'razon_social':
              'Distribuidora de Alimentos Sociedad por Acciones Simplificada',
          'telefono': '300-123-4567',
          'email': 'contacto@distribuidoraalimentos.com',
          'direccion': 'CALLE 45 #67-89 ZONA INDUSTRIAL',
        },
        {
          'id': 2,
          'nombre_comercial': 'PROVEEDORA LA GRANJA LTDA',
          'razon_social': 'Proveedora La Granja Limitada',
          'telefono': '310-987-6543',
          'email': 'ventas@lagranja.com',
          'direccion': 'CARRERA 12 #34-56 SECTOR RURAL',
        },
        {
          'id': 3,
          'nombre_comercial': 'AGROINDUSTRIAL DEL VALLE',
          'razon_social': 'Agroindustrial del Valle S.A.S',
          'telefono': '320-456-7890',
          'email': 'info@agrovalle.com',
          'direccion': 'AVENIDA 18 #90-12 PARQUE INDUSTRIAL',
        },
      ];
    } catch (e) {
      print('❌ Error conectando con API de proveedores: $e');
      // En caso de error, devolver datos de ejemplo
      return [
        {
          'id': 1,
          'nombre_comercial': 'PROVEEDOR LOCAL S.A.S',
          'razon_social': 'Proveedor Local Sociedad por Acciones Simplificada',
          'telefono': '300-111-2222',
          'email': 'contacto@proveedorlocal.com',
          'direccion': 'CALLE 10 #20-30 CENTRO',
        },
      ];
    }
  }

  /// Crear un nuevo proveedor
  Future<Map<String, dynamic>> crearProveedor({
    required String nombreComercial,
    String? razonSocial,
    String? telefono,
    String? email,
    String? direccion,
  }) async {
    final r = await http.post(
      Uri.parse('$baseUrl/api/proveedores'),
      headers: _headers,
      body: jsonEncode({
        "nombre_comercial": nombreComercial,
        "razon_social": razonSocial,
        "telefono": telefono,
        "email": email,
        "direccion": direccion,
        "fecha_registro": DateTime.now().toIso8601String(),
      }),
    );

    if (r.statusCode != 200 && r.statusCode != 201) {
      throw Exception('Error al crear proveedor: ${r.statusCode}');
    }

    return jsonDecode(r.body);
  }

  /// Buscar proveedores por nombre comercial
  Future<List<dynamic>> buscarProveedoresPorNombre(String nombre) async {
    final r = await http.get(
      Uri.parse(
        '$baseUrl/api/proveedores/buscar?nombre_comercial=${Uri.encodeComponent(nombre)}',
      ),
      headers: _headers,
    );
    if (r.statusCode != 200)
      throw Exception('Error al buscar proveedores: ${r.statusCode}');
    return jsonDecode(r.body);
  }

  /// Crear un nuevo registro de materia prima
  Future<Map<String, dynamic>> crearMateriaPrima({
    required int productoId,
    required String ingrediente,
    required double cantidad,
    required String unidad,
    required String fechaRecepcion,
    String? proveedor,
    String? observaciones,
    String? creadoPor,
  }) async {
    final Map<String, dynamic> requestBody = {
      'producto_id': productoId.toString(), // Convertir a string por si acaso
      'ingrediente': ingrediente,
      'cantidad': cantidad.toString(), // Convertir a string por si acaso
      'unidad': unidad,
      'fecha_recepcion': fechaRecepcion,
      'proveedor': proveedor ?? '',
      'observaciones': observaciones ?? '',
      'creado_por': creadoPor ?? 'APP_USER',
    };

    print('🚀 Enviando datos a /api/materia-prima:');
    print('   URL: $baseUrl/api/materia-prima');
    print('   Headers: $_headers');
    print('   Body: ${jsonEncode(requestBody)}');

    try {
      final r = await http.post(
        Uri.parse('$baseUrl/api/materia-prima'),
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      print('📡 Respuesta del servidor:');
      print('   Status: ${r.statusCode}');
      print('   Body: ${r.body}');

      if (r.statusCode != 200 && r.statusCode != 201) {
        String errorMessage = 'Error al crear materia prima: ${r.statusCode}';

        try {
          final errorData = jsonDecode(r.body);
          if (errorData is Map && errorData.containsKey('error')) {
            errorMessage += ' - ${errorData['error']}';
          } else if (errorData is Map && errorData.containsKey('message')) {
            errorMessage += ' - ${errorData['message']}';
          } else {
            errorMessage += ' - Response: ${r.body}';
          }
        } catch (e) {
          errorMessage += ' - Response: ${r.body}';
          print('⚠️ No se pudo decodificar error del servidor: $e');
        }

        throw Exception(errorMessage);
      }

      return jsonDecode(r.body);
    } catch (e) {
      print('❌ Error en crearMateriaPrima: $e');
      rethrow;
    }
  }

  /// Obtener lista de materia prima
  Future<List<dynamic>> getMateriaPrima() async {
    final r = await http.get(
      Uri.parse('$baseUrl/api/materia-prima'),
      headers: _headers,
    );

    if (r.statusCode != 200) {
      throw Exception('Error al obtener materia prima: ${r.statusCode}');
    }

    return jsonDecode(r.body);
  }
}
