import 'package:flutter/material.dart';
import '../models/proceso_model.dart';
import '../services/api_service.dart';
import '../widgets/proveedor_dropdown.dart';
import 'login_screen.dart';

/// Pantalla de detalle para ingresar/ver datos específicos de un proceso
class ProcesoDetalleScreen extends StatefulWidget {
  final ProcesoProduccion proceso;
  final Map<String, dynamic>? producto;
  final ApiService api;

  const ProcesoDetalleScreen({
    super.key,
    required this.proceso,
    this.producto,
    required this.api,
  });

  @override
  State<ProcesoDetalleScreen> createState() => _ProcesoDetalleScreenState();
}

class _ProcesoDetalleScreenState extends State<ProcesoDetalleScreen> {
  // Clave para el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final Map<String, TextEditingController> _controladores = {};

  // FocusNode para el campo de ingrediente
  final FocusNode _ingredienteFocusNode = FocusNode();

  // Estado de guardado
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores para cada campo
    for (var campo in widget.proceso.campos) {
      _controladores[campo.nombre] = TextEditingController(text: campo.valor);
    }
  }

  @override
  void dispose() {
    // Limpiar controladores
    for (var controlador in _controladores.values) {
      controlador.dispose();
    }
    // Limpiar focus node
    _ingredienteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con información del proceso
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.proceso.nombre,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (widget.producto != null)
              Text(
                widget.producto!['nombre'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: const Color(0xFF600F40), // Azul Bancolombia
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Botón de cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Header con información del proceso
            _buildHeaderProceso(),

            // Formulario scrolleable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Generar campos dinámicamente
                      ...widget.proceso.campos
                          .map((campo) => _buildCampoFormulario(campo))
                          .toList(),

                      const SizedBox(height: 32),

                      // Botones de acción
                      _buildBotonesAccion(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header con información del proceso
  Widget _buildHeaderProceso() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono del proceso
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF600F40).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.proceso.icono,
              style: const TextStyle(fontSize: 24),
            ),
          ),

          const SizedBox(width: 16),

          // Información del proceso
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.proceso.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.proceso.descripcion,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye un campo del formulario basado en el tipo
  Widget _buildCampoFormulario(Campo campo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Etiqueta del campo
              Row(
                children: [
                  Text(
                    campo.nombre,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  if (campo.requerido) ...[
                    const SizedBox(width: 4),
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                  if (campo.unidad != null) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF600F40).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        campo.unidad!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              // Campo de entrada según el tipo
              _buildCampoInput(campo),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el input específico según el tipo de campo
  Widget _buildCampoInput(Campo campo) {
    switch (campo.tipo) {
      case 'numero_con_unidad':
        return Column(
          children: [
            // Campo de número
            TextFormField(
              controller: _controladores[campo.nombre],
              textCapitalization: TextCapitalization.characters,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Ingrese ${campo.nombre.toLowerCase()}',
                prefixIcon: const Icon(Icons.numbers),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF600F40),
                    width: 2,
                  ),
                ),
              ),
              validator:
                  campo.requerido
                      ? (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      }
                      : null,
            ),
            const SizedBox(height: 8),
            // Dropdown de unidades
            if (campo.unidadesDisponibles != null &&
                campo.unidadesDisponibles!.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: campo.unidadSeleccionada,
                decoration: InputDecoration(
                  labelText: 'Unidad de ${campo.nombre.toLowerCase()}',
                  prefixIcon: const Icon(Icons.straighten),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF600F40),
                      width: 2,
                    ),
                  ),
                ),
                items:
                    campo.unidadesDisponibles!.map((String unidad) {
                      return DropdownMenuItem<String>(
                        value: unidad,
                        child: Text(unidad),
                      );
                    }).toList(),
                onChanged: (String? nuevaUnidad) {
                  setState(() {
                    campo.unidadSeleccionada = nuevaUnidad;
                  });
                },
              ),
          ],
        );

      case 'numero':
      case 'temperatura':
        return TextFormField(
          controller: _controladores[campo.nombre],
          textCapitalization: TextCapitalization.characters,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Ingrese ${campo.nombre.toLowerCase()}',
            prefixIcon:
                campo.tipo == 'temperatura'
                    ? const Icon(Icons.thermostat)
                    : const Icon(Icons.numbers),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF600F40), width: 2),
            ),
          ),
          validator:
              campo.requerido
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  }
                  : null,
        );

      case 'fecha':
        return TextFormField(
          controller: _controladores[campo.nombre],
          readOnly: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            hintText: 'Seleccione fecha',
            prefixIcon: const Icon(Icons.calendar_today),
            suffixIcon: IconButton(
              icon: const Icon(Icons.date_range),
              onPressed: () => _seleccionarFecha(campo),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF600F40), width: 2),
            ),
          ),
          validator:
              campo.requerido
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  }
                  : null,
        );

      case 'hora':
        return TextFormField(
          controller: _controladores[campo.nombre],
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Seleccione hora',
            prefixIcon: const Icon(Icons.access_time),
            suffixIcon: IconButton(
              icon: const Icon(Icons.schedule),
              onPressed: () => _seleccionarHora(campo),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF600F40), width: 2),
            ),
          ),
          validator:
              campo.requerido
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  }
                  : null,
        );

      default: // texto
        // Verificar si es un campo de proveedor
        if (campo.nombre.toLowerCase().contains('proveedor')) {
          return ProveedorDropdown(
            api: widget.api,
            valorInicial: null, // Dejar null por ahora para evitar conflictos
            requerido: campo.requerido,
            labelText: campo.nombre,
            onChanged: (valor) {
              if (valor != null) {
                _controladores[campo.nombre]?.text = valor;
              }
            },
          );
        }

        // Campo de texto normal
        return TextFormField(
          controller: _controladores[campo.nombre],
          focusNode:
              campo.nombre == 'Ingrediente' ? _ingredienteFocusNode : null,
          textCapitalization: TextCapitalization.characters,
          maxLines: campo.nombre.toLowerCase().contains('observacion') ? 3 : 1,
          decoration: InputDecoration(
            hintText: 'Ingrese ${campo.nombre.toLowerCase()}',
            prefixIcon: const Icon(Icons.text_fields),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF600F40), width: 2),
            ),
          ),
          validator:
              campo.requerido
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  }
                  : null,
        );
    }
  }

  /// Botones de acción en la parte inferior
  Widget _buildBotonesAccion() {
    return Row(
      children: [
        // Botón Cancelar
        Expanded(
          child: OutlinedButton(
            onPressed:
                _guardando
                    ? null
                    : () {
                      Navigator.pop(context);
                    },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Botón Guardar
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _guardando ? null : _guardarDatos,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF600F40), // Azul Bancolombia
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                _guardando
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      'Guardar Datos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  /// Selector de fecha
  Future<void> _seleccionarFecha(Campo campo) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (fecha != null) {
      final String fechaFormateada =
          "${fecha.day.toString().padLeft(2, '0')}/"
          "${fecha.month.toString().padLeft(2, '0')}/"
          "${fecha.year}";

      _controladores[campo.nombre]?.text = fechaFormateada;
    }
  }

  /// Selector de hora
  Future<void> _seleccionarHora(Campo campo) async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora != null) {
      final String horaFormateada =
          "${hora.hour.toString().padLeft(2, '0')}:"
          "${hora.minute.toString().padLeft(2, '0')}";

      _controladores[campo.nombre]?.text = horaFormateada;
    }
  }

  /// Función para guardar los datos
  Future<void> _guardarDatos() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      // Recopilar datos del formulario
      Map<String, dynamic> datosFormulario = {};

      for (var campo in widget.proceso.campos) {
        String valor = _controladores[campo.nombre]?.text ?? '';

        // Para campos con unidades, incluir la unidad seleccionada
        if (campo.tipo == 'numero_con_unidad' &&
            campo.unidadSeleccionada != null) {
          datosFormulario[campo.nombre] = {
            'valor': valor,
            'unidad': campo.unidadSeleccionada,
          };
        } else {
          datosFormulario[campo.nombre] = valor;
        }
      }

      // Si es el proceso "Control de Materias Primas", usar endpoint específico
      if (widget.proceso.id == '2' &&
          widget.proceso.nombre == 'Control de Materias Primas') {
        await _guardarMateriaPrima(datosFormulario);

        if (mounted) {
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Ingrediente "${datosFormulario['Ingrediente']}" guardado correctamente',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          // Limpiar los campos para permitir ingreso de otro ingrediente
          _limpiarCamposMateriaPrima();
        }
      } else {
        // Para otros procesos, usar el método general
        await _guardarProcesoGeneral(datosFormulario);

        // Actualizar valores en el modelo local
        for (var campo in widget.proceso.campos) {
          campo.valor = _controladores[campo.nombre]?.text ?? '';
        }

        if (mounted) {
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ ${widget.proceso.nombre} guardado en base de datos',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          // Volver a la pantalla anterior
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al guardar en BD: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  /// Guardar específicamente datos de Materia Prima
  Future<void> _guardarMateriaPrima(Map<String, dynamic> datos) async {
    print('🔍 Datos recibidos en _guardarMateriaPrima: $datos');
    print('🔍 Producto seleccionado: ${widget.producto}');

    // Validar que el producto esté disponible
    if (widget.producto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No hay producto seleccionado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Usar el ID del producto seleccionado en la pantalla anterior
    int productoId = widget.producto!['id_producto'] ?? 1;
    String ingrediente = datos['Ingrediente'] ?? '';

    // Manejar cantidad con unidad
    double cantidad = 0.0;
    String unidad = 'LIBRAS';

    if (datos['Cantidad Recibida'] is Map) {
      cantidad =
          double.tryParse(datos['Cantidad Recibida']['valor'] ?? '0') ?? 0.0;
      unidad = datos['Cantidad Recibida']['unidad'] ?? 'LIBRAS';
    } else {
      cantidad = double.tryParse(datos['Cantidad Recibida'] ?? '0') ?? 0.0;
    }

    // Valores fijos como solicitado
    String proveedor = '1'; // Siempre enviar "1"
    String fechaRecepcion = DateTime.now().toIso8601String().substring(
      0,
      10,
    ); // Siempre fecha actual
    String observaciones = '1'; // Siempre enviar "1"

    print('📊 Datos para API:');
    print('  - productoId: $productoId (del producto seleccionado)');
    print('  - productoNombre: ${widget.producto!['nombre']}');
    print('  - ingrediente: $ingrediente');
    print('  - cantidad: $cantidad');
    print('  - unidad: $unidad');
    print('  - fechaRecepcion: $fechaRecepcion (fecha actual)');
    print('  - proveedor: $proveedor (valor fijo)');
    print('  - observaciones: $observaciones (valor fijo)');

    // Validar datos requeridos
    if (ingrediente.isEmpty) {
      throw Exception('El ingrediente es requerido');
    }
    if (cantidad <= 0) {
      throw Exception('La cantidad debe ser mayor a 0');
    }

    // Llamar al endpoint específico de materia prima
    await widget.api.crearMateriaPrima(
      productoId: productoId,
      ingrediente: ingrediente,
      cantidad: cantidad,
      unidad: unidad,
      fechaRecepcion: fechaRecepcion,
      proveedor: proveedor,
      observaciones: observaciones,
      creadoPor: 'APP_USER',
    );
  }

  /// Limpiar los campos del formulario de Materia Prima para permitir ingreso de otro ingrediente
  void _limpiarCamposMateriaPrima() {
    setState(() {
      // Limpiar solo los controladores de texto
      for (var campo in widget.proceso.campos) {
        if (_controladores[campo.nombre] != null) {
          if (campo.nombre == 'Ingrediente') {
            // Limpiar el campo ingrediente
            _controladores[campo.nombre]!.clear();
            campo.valor = '';
          } else if (campo.nombre == 'Cantidad Recibida') {
            // Limpiar el campo cantidad pero mantener la unidad seleccionada
            _controladores[campo.nombre]!.clear();
            campo.valor = '';
            // La unidad se mantiene en campo.unidadSeleccionada
          }
        }
      }
    });

    print('🧹 Campos limpiados para ingresar otro ingrediente');

    // Enfocar el campo de ingrediente para facilitar el siguiente ingreso
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _ingredienteFocusNode.requestFocus();
      }
    });
  }

  /// Guardar proceso usando el método general
  Future<void> _guardarProcesoGeneral(
    Map<String, dynamic> datosFormulario,
  ) async {
    // Obtener información del usuario actual
    String operarioActual = 'usuario_actual';

    // Llamar a la API para guardar los datos usando el método general
    await widget.api.guardarProcesoProduccion(
      idProducto: widget.producto?['id_producto'] ?? 0,
      tipoProces: widget.proceso.id,
      operario: operarioActual,
      datos: datosFormulario,
      lote: 'LOTE-${DateTime.now().millisecondsSinceEpoch}',
      observaciones: 'Proceso: ${widget.proceso.nombre}',
    );
  }

  /// Diálogo de confirmación para cerrar sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Cerrar Sesión'),
            ],
          ),
          content: const Text(
            '¿Estás seguro de que deseas cerrar sesión?\n\nSe perderán los datos no guardados.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  /// Función para cerrar sesión
  void _logout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('👋 Sesión cerrada'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 1),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => false,
    );
  }
}
