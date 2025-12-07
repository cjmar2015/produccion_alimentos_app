import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class ControlMateriasScreen extends StatefulWidget {
  final ApiService api;

  const ControlMateriasScreen({super.key, required this.api});

  @override
  State<ControlMateriasScreen> createState() => _ControlMateriasScreenState();
}

class _ControlMateriasScreenState extends State<ControlMateriasScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Paso 1 - Información General
  DateTime? _fechaInspeccion;
  final _horaController = TextEditingController();
  String? _responsable;
  String? _productoSeleccionado;
  final _cantidadController = TextEditingController();
  String? _unidadSeleccionada;
  final _valorCompraController = TextEditingController();

  final List<String> _responsables = ['ROCIO', 'LORENA'];
  final List<String> _productos = [
    'LECHE',
    'AZUCAR',
    'HUEVOS',
    'LICORES',
    'OTROS',
  ];

  final _licorController = TextEditingController();
  final _otroProductoController = TextEditingController();

  // Unidades según el producto
  final Map<String, List<String>> _productoUnidades = {
    'LECHE': ['LITROS', 'BOTELLAS'],
    'AZUCAR': ['KILOS', 'LIBRAS', 'BULTOS'],
    'HUEVOS': ['UNIDADES', 'BANDEJAS'],
    'LICORES': ['LITROS', 'BOTELLAS', 'GARRAFAS'],
    'OTROS': ['KILOS', 'GRAMOS', 'LITROS', 'UNIDADES'],
  };

  List<String> get _unidadesDisponibles {
    if (_productoSeleccionado == null) return [];
    return _productoUnidades[_productoSeleccionado] ?? [];
  }

  // Paso 2 - Materias Primas Recibidas
  // Mapeo de productos a sus materias primas específicas
  final Map<String, List<String>> _productoMateriasPrimas = {
    'LECHE': ['Leche'],
    'AZUCAR': ['Azúcar'],
    'HUEVOS': ['Huevos / yemas'],
    'LICORES': ['Licor'],
    'OTROS': ['Otro producto'],
  };

  final Map<String, Map<String, dynamic>> _todasMateriasPrimas = {
    'Leche': {
      'proveedor': TextEditingController(),
      'cantidad': TextEditingController(),
      'condicionEmpaque': null,
      'aprobada': null,
    },
    'Azúcar': {
      'proveedor': TextEditingController(),
      'cantidad': TextEditingController(),
      'condicionEmpaque': null,
      'aprobada': null,
    },
    'Huevos / yemas': {
      'proveedor': TextEditingController(),
      'cantidad': TextEditingController(),
      'condicionEmpaque': null,
      'aprobada': null,
    },
    'Licor': {
      'proveedor': TextEditingController(),
      'cantidad': TextEditingController(),
      'condicionEmpaque': null,
      'aprobada': null,
    },
    'Otro producto': {
      'proveedor': TextEditingController(),
      'cantidad': TextEditingController(),
      'condicionEmpaque': null,
      'aprobada': null,
    },
  };

  List<Map<String, dynamic>> get _materiasPrimas {
    if (_productoSeleccionado == null) return [];

    final materiasPrimasProducto =
        _productoMateriasPrimas[_productoSeleccionado] ?? [];
    return materiasPrimasProducto.map((nombre) {
      return {'nombre': nombre, ..._todasMateriasPrimas[nombre]!};
    }).toList();
  }

  // Paso 3 - Criterios de Inspección por materia prima
  final Map<String, Map<String, Map<String, dynamic>>>
  _todosCriteriosInspeccion = {
    'Leche': {
      'Olor fresco, sin fermentación': {'cumple': null, 'observaciones': ''},
      'Color blanco-crema uniforme': {'cumple': null, 'observaciones': ''},
      'No presenta grumos o separación': {'cumple': null, 'observaciones': ''},
      'Temp. a recepción adecuada': {'cumple': null, 'observaciones': ''},
      'Empaque íntegro, limpio': {'cumple': null, 'observaciones': ''},
    },
    'Huevos / yemas': {
      'Sin olor desagradable': {'cumple': null, 'observaciones': ''},
      'Cáscara limpia (si aplica)': {'cumple': null, 'observaciones': ''},
      'Yema con color normal': {'cumple': null, 'observaciones': ''},
      'Sin señales de contaminación': {'cumple': null, 'observaciones': ''},
    },
    'Azúcar': {
      'Color blanco estándar': {'cumple': null, 'observaciones': ''},
      'Ausencia de impurezas': {'cumple': null, 'observaciones': ''},
      'Sin humedad o apelmazamiento': {'cumple': null, 'observaciones': ''},
      'Empaque íntegro': {'cumple': null, 'observaciones': ''},
    },
    'Licor': {
      'Sello de seguridad intacto': {'cumple': null, 'observaciones': ''},
      'Transparencia sin partículas': {'cumple': null, 'observaciones': ''},
      'Graduación alcohólica declarada': {'cumple': null, 'observaciones': ''},
      'Proveedor autorizado': {'cumple': null, 'observaciones': ''},
    },
    'Otro producto': {
      'Apariencia general adecuada': {'cumple': null, 'observaciones': ''},
      'Sin contaminación visible': {'cumple': null, 'observaciones': ''},
      'Empaque íntegro': {'cumple': null, 'observaciones': ''},
      'Documentación completa': {'cumple': null, 'observaciones': ''},
    },
  };

  Map<String, Map<String, Map<String, dynamic>>> get _criteriosInspeccion {
    final criteriosFiltrados = <String, Map<String, Map<String, dynamic>>>{};
    for (var mp in _materiasPrimas) {
      final nombre = mp['nombre'];
      if (_todosCriteriosInspeccion.containsKey(nombre)) {
        criteriosFiltrados[nombre] = _todosCriteriosInspeccion[nombre]!;
      }
    }
    return criteriosFiltrados;
  }

  // Paso 4 - Condiciones de Transporte
  final Map<String, Map<String, dynamic>> _condicionesTransporte = {
    'Vehículo limpio y en buenas condiciones': {
      'cumple': null,
      'observaciones': '',
    },
    'Materias primas protegidas de calor/luz': {
      'cumple': null,
      'observaciones': '',
    },
    'Temperatura adecuada durante transporte': {
      'cumple': null,
      'observaciones': '',
    },
    'Tiempo de entrega conforme': {'cumple': null, 'observaciones': ''},
  };

  // Paso 5 - No Conformidades
  final List<Map<String, dynamic>> _noConformidades = [];

  // Paso 6 - Aprobación Final
  String? _resultadoFinal;
  final _observacionesFinalesController = TextEditingController();

  @override
  void dispose() {
    _horaController.dispose();
    _cantidadController.dispose();
    _valorCompraController.dispose();
    _licorController.dispose();
    _otroProductoController.dispose();
    for (var mp in _todasMateriasPrimas.values) {
      mp['proveedor'].dispose();
      mp['cantidad'].dispose();
    }
    for (var nc in _noConformidades) {
      nc['descripcion'].dispose();
      nc['cantidad'].dispose();
      nc['accion'].dispose();
      nc['responsable'].dispose();
    }
    _observacionesFinalesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Control de Materias Primas',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF212121),
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF600F40)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(6, (index) {
            final isActive = index == _currentStep;
            final isCompleted = index < _currentStep;

            return Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isActive || isCompleted
                                ? const Color(0xFF600F40)
                                : Colors.grey[300],
                      ),
                      child: Center(
                        child:
                            isCompleted
                                ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                                : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color:
                                        isActive || isCompleted
                                            ? Colors.white
                                            : Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 70,
                      child: Text(
                        _getStepTitle(index),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          color:
                              isActive
                                  ? const Color(0xFF600F40)
                                  : Colors.grey[600],
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (index < 5)
                  Container(
                    width: 20,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 30),
                    color:
                        isCompleted
                            ? const Color(0xFF600F40)
                            : Colors.grey[300],
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _getStepTitle(int index) {
    switch (index) {
      case 0:
        return 'Info General';
      case 1:
        return 'Materias Primas';
      case 2:
        return 'Criterios';
      case 3:
        return 'Transporte';
      case 4:
        return 'No Conform.';
      case 5:
        return 'Aprobación';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPaso1InfoGeneral();
      case 1:
        return _buildPaso2MateriasPrimas();
      case 2:
        return _buildPaso3CriteriosInspeccion();
      case 3:
        return _buildPaso4CondicionesTransporte();
      case 4:
        return _buildPaso5NoConformidades();
      case 5:
        return _buildPaso6AprobacionFinal();
      default:
        return Container();
    }
  }

  Widget _buildPaso1InfoGeneral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Información General',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        _buildDropdownField(
          label: 'Producto',
          value: _productoSeleccionado,
          items: _productos,
          required: true,
          icon: Icons.inventory_2_outlined,
          onChanged: (value) {
            setState(() {
              _productoSeleccionado = value;
              _unidadSeleccionada = null;
              _cantidadController.clear();
              _licorController.clear();
              _otroProductoController.clear();
            });
          },
        ),
        if (_productoSeleccionado == 'LICORES') ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _licorController,
            inputFormatters: [UpperCaseTextFormatter()],
            decoration: InputDecoration(
              labelText: '¿Qué licor? *',
              hintText: 'Ej: AGUARDIENTE, RON, GINEBRA',
              prefixIcon: const Icon(Icons.liquor_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Debe especificar el tipo de licor';
              }
              return null;
            },
          ),
        ],
        if (_productoSeleccionado == 'OTROS') ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _otroProductoController,
            inputFormatters: [UpperCaseTextFormatter()],
            decoration: InputDecoration(
              labelText: '¿Qué producto? *',
              hintText: 'ESPECIFIQUE EL PRODUCTO',
              prefixIcon: const Icon(Icons.edit_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Debe especificar el producto';
              }
              return null;
            },
          ),
        ],
        if (_productoSeleccionado != null) ...[
          const SizedBox(height: 16),
          _buildNumberField(
            controller: _cantidadController,
            label: 'Cantidad',
            required: true,
            icon: Icons.scale_outlined,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Unidad',
            value: _unidadSeleccionada,
            items: _unidadesDisponibles,
            required: true,
            icon: Icons.straighten_outlined,
            onChanged: (value) {
              setState(() {
                _unidadSeleccionada = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildNumberField(
            controller: _valorCompraController,
            label: 'Valor de Compra \$COP',
            required: true,
            icon: Icons.attach_money_outlined,
          ),
        ],
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Fecha de Inspección',
          value: _fechaInspeccion,
          required: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() {
                _fechaInspeccion = date;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildTimeField(
          controller: _horaController,
          label: 'Hora',
          required: true,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Responsable de la Inspección',
          value: _responsable,
          items: _responsables,
          required: true,
          icon: Icons.person_outlined,
          onChanged: (value) {
            setState(() {
              _responsable = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaso2MateriasPrimas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Materias Primas Recibidas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        ..._materiasPrimas.map((mp) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildMateriaPrimaCard(mp),
          );
        }),
      ],
    );
  }

  Widget _buildPaso3CriteriosInspeccion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Criterios de Inspección',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        ..._criteriosInspeccion.entries.map((categoria) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  categoria.key,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF600F40),
                  ),
                ),
              ),
              ...categoria.value.entries.map((criterio) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildCriterioCard(
                    titulo: criterio.key,
                    cumple: criterio.value['cumple'],
                    observaciones: criterio.value['observaciones'],
                    onCumpleChanged: (value) {
                      setState(() {
                        _todosCriteriosInspeccion[categoria.key]![criterio
                                .key]!['cumple'] =
                            value;
                      });
                    },
                    onObservacionesChanged: (value) {
                      _todosCriteriosInspeccion[categoria.key]![criterio
                              .key]!['observaciones'] =
                          value;
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPaso4CondicionesTransporte() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. Condiciones del Transporte y Entrega',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        ..._condicionesTransporte.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCriterioCard(
              titulo: entry.key,
              cumple: entry.value['cumple'],
              observaciones: entry.value['observaciones'],
              onCumpleChanged: (value) {
                setState(() {
                  _condicionesTransporte[entry.key]!['cumple'] = value;
                });
              },
              onObservacionesChanged: (value) {
                _condicionesTransporte[entry.key]!['observaciones'] = value;
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPaso5NoConformidades() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5. No Conformidades Detectadas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        ..._noConformidades.asMap().entries.map((entry) {
          final index = entry.key;
          final nc = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildNoConformidadCard(nc, index),
          );
        }),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _agregarNoConformidad,
          icon: const Icon(Icons.add),
          label: const Text('Agregar No Conformidad'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF600F40),
            side: const BorderSide(color: Color(0xFF600F40)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaso6AprobacionFinal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '6. Aprobación Final',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resultado Final',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 12),
              RadioListTile<String>(
                title: const Text('Aprobado'),
                value: 'Aprobado',
                groupValue: _resultadoFinal,
                activeColor: const Color(0xFF600F40),
                onChanged: (value) {
                  setState(() {
                    _resultadoFinal = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                title: const Text('Rechazado'),
                value: 'Rechazado',
                groupValue: _resultadoFinal,
                activeColor: const Color(0xFF600F40),
                onChanged: (value) {
                  setState(() {
                    _resultadoFinal = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _observacionesFinalesController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Observaciones',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator:
          required
              ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              }
              : null,
    );
  }

  Widget _buildTimeField({
    required TextEditingController controller,
    required String label,
    required bool required,
  }) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          controller.text =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : ''),
            prefixIcon: const Icon(Icons.access_time_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator:
              required
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  }
                  : null,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required bool required,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(
          value != null
              ? '${value.day}/${value.month}/${value.year}'
              : 'Seleccionar fecha',
          style: TextStyle(
            color: value != null ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required bool required,
    required ValueChanged<String?> onChanged,
    IconData? icon,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      items:
          items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
      validator:
          required
              ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obligatorio';
                }
                return null;
              }
              : null,
    );
  }

  Widget _buildMateriaPrimaCard(Map<String, dynamic> mp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mp['nombre'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF600F40),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mp['proveedor'],
            decoration: InputDecoration(
              labelText: 'Proveedor',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: mp['cantidad'],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cantidad Recibida',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Condición del Empaque',
            style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Apta', style: TextStyle(fontSize: 12)),
                  value: 'Apta',
                  groupValue: mp['condicionEmpaque'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      mp['condicionEmpaque'] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('No apta', style: TextStyle(fontSize: 12)),
                  value: 'No apta',
                  groupValue: mp['condicionEmpaque'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      mp['condicionEmpaque'] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Aprobada para Uso',
            style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Sí', style: TextStyle(fontSize: 12)),
                  value: 'Sí',
                  groupValue: mp['aprobada'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      mp['aprobada'] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('No', style: TextStyle(fontSize: 12)),
                  value: 'No',
                  groupValue: mp['aprobada'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      mp['aprobada'] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCriterioCard({
    required String titulo,
    required bool? cumple,
    required String observaciones,
    required ValueChanged<bool?> onCumpleChanged,
    required ValueChanged<String> onObservacionesChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('Sí', style: TextStyle(fontSize: 12)),
                  value: true,
                  groupValue: cumple,
                  activeColor: const Color(0xFF600F40),
                  onChanged: onCumpleChanged,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('No', style: TextStyle(fontSize: 12)),
                  value: false,
                  groupValue: cumple,
                  activeColor: const Color(0xFF600F40),
                  onChanged: onCumpleChanged,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Observaciones',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
            onChanged: onObservacionesChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNoConformidadCard(Map<String, dynamic> nc, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No Conformidad ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF600F40),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _noConformidades.removeAt(index);
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nc['descripcion'],
            decoration: InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nc['cantidad'],
            decoration: InputDecoration(
              labelText: 'Cantidad Afectada',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nc['accion'],
            decoration: InputDecoration(
              labelText: 'Acción Tomada',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: nc['responsable'],
            decoration: InputDecoration(
              labelText: 'Responsable',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                setState(() {
                  nc['fecha'] = date;
                });
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
              child: Text(
                nc['fecha'] != null
                    ? '${nc['fecha'].day}/${nc['fecha'].month}/${nc['fecha'].year}'
                    : 'Seleccionar',
                style: TextStyle(
                  color: nc['fecha'] != null ? Colors.black : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _agregarNoConformidad() {
    setState(() {
      _noConformidades.add({
        'descripcion': TextEditingController(),
        'cantidad': TextEditingController(),
        'accion': TextEditingController(),
        'responsable': TextEditingController(),
        'fecha': null,
      });
    });
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF600F40)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Anterior',
                  style: TextStyle(
                    color: Color(0xFF600F40),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_validateCurrentStep()) {
                  if (_currentStep < 5) {
                    setState(() {
                      _currentStep++;
                    });
                  } else {
                    _enviarFormulario();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF600F40),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _currentStep < 5 ? 'Siguiente' : 'Enviar',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_fechaInspeccion == null) {
          _showError('La fecha de inspección es obligatoria');
          return false;
        }
        if (_horaController.text.isEmpty) {
          _showError('La hora es obligatoria');
          return false;
        }
        if (_responsable == null || _responsable!.isEmpty) {
          _showError('El responsable es obligatorio');
          return false;
        }
        if (_productoSeleccionado == null || _productoSeleccionado!.isEmpty) {
          _showError('Debe seleccionar un producto');
          return false;
        }
        if (_productoSeleccionado == 'LICORES' &&
            _licorController.text.isEmpty) {
          _showError('Debe especificar qué tipo de licor');
          return false;
        }
        if (_productoSeleccionado == 'OTROS' &&
            _otroProductoController.text.isEmpty) {
          _showError('Debe especificar qué producto es');
          return false;
        }
        if (_cantidadController.text.isEmpty) {
          _showError('La cantidad es obligatoria');
          return false;
        }
        if (_unidadSeleccionada == null || _unidadSeleccionada!.isEmpty) {
          _showError('Debe seleccionar una unidad');
          return false;
        }
        if (_valorCompraController.text.isEmpty) {
          _showError('El valor de compra es obligatorio');
          return false;
        }
        return true;

      case 5:
        if (_resultadoFinal == null) {
          _showError('Seleccione el resultado final');
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _enviarFormulario() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outlined, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Formulario Enviado'),
            ],
          ),
          content: const Text(
            'El formulario de control de materias primas ha sido enviado correctamente.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Color(0xFF600F40)),
              ),
            ),
          ],
        );
      },
    );
  }
}
