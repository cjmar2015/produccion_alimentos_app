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

class RecepcionFrutasScreen extends StatefulWidget {
  final ApiService api;

  const RecepcionFrutasScreen({super.key, required this.api});

  @override
  State<RecepcionFrutasScreen> createState() => _RecepcionFrutasScreenState();
}

class _RecepcionFrutasScreenState extends State<RecepcionFrutasScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Paso 1 - Datos Generales
  final _proveedorController = TextEditingController();
  Map<String, dynamic>? _proveedorSeleccionado;
  List<dynamic> _proveedores = [];
  DateTime? _fechaRecepcion;
  String? _tipoFruta;
  final _cantidadController = TextEditingController();
  final _facturaController = TextEditingController();
  final _valorCompraController = TextEditingController();
  String? _responsable;
  final List<String> _tiposFruta = [
    'Brevas',
    'Carambolo',
    'Ciruela',
    'Cocktail',
    'Durazno',
    'Feijoa',
    'Fresa',
    'Guanábana',
    'Guayaba',
    'Kiwi',
    'Limón',
    'Mamey',
    'Mango',
    'Manzana',
    'Mora',
    'Naranja',
    'Papayuela',
    'Piña',
    'Piñuela',
    'Pitaya',
    'Tomate de Árbol',
    'Uchuva',
  ];

  final List<String> _responsables = ['ROCIO', 'LORENA'];

  // Paso 2 - Condiciones de Transporte
  final Map<String, Map<String, dynamic>> _condicionesTransporte = {
    'Vehículo limpio y cerrado': {'cumple': null, 'observaciones': ''},
    'Temperatura adecuada': {'cumple': null, 'observaciones': ''},
    'Fruta sin contaminación': {'cumple': null, 'observaciones': ''},
    'Empaques en buen estado': {'cumple': null, 'observaciones': ''},
  };

  // Paso 3 - Inspección de Calidad
  final Map<String, Map<String, dynamic>> _criteriosCalidad = {
    'Madurez adecuada': {
      'especificacion': 'Color y textura propios',
      'cumple': null,
      'observaciones': '',
    },
    'Sin moho': {
      'especificacion': 'Sin manchas ni mal olor',
      'cumple': null,
      'observaciones': '',
    },
    'Tamaño uniforme': {
      'especificacion': 'Según receta estándar',
      'cumple': null,
      'observaciones': '',
    },
    'Sin cuerpos extraños': {
      'especificacion': 'Sin tierra/hojas/insectos',
      'cumple': null,
      'observaciones': '',
    },
    'Limpieza visual': {
      'especificacion': 'Frutas limpias y frescas',
      'cumple': null,
      'observaciones': '',
    },
  };

  // Paso 4 - Resultado Final
  String? _resultadoFinal;
  final _observacionesGeneralesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    try {
      final proveedores = await widget.api.getProveedores();
      setState(() {
        _proveedores = proveedores;
      });
    } catch (e) {
      print('Error cargando proveedores: $e');
    }
  }

  @override
  void dispose() {
    _proveedorController.dispose();
    _cantidadController.dispose();
    _facturaController.dispose();
    _valorCompraController.dispose();
    _observacionesGeneralesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Recepción de Frutas',
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
            // Indicador de pasos
            _buildStepIndicator(),

            // Contenido del paso actual
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStep(),
              ),
            ),

            // Botones de navegación
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
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
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getStepTitle(index),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color:
                              isActive
                                  ? const Color(0xFF600F40)
                                  : Colors.grey[600],
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < 3)
                  Container(
                    width: 20,
                    height: 2,
                    color:
                        isCompleted
                            ? const Color(0xFF600F40)
                            : Colors.grey[300],
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getStepTitle(int index) {
    switch (index) {
      case 0:
        return 'Datos';
      case 1:
        return 'Transporte';
      case 2:
        return 'Calidad';
      case 3:
        return 'Resultado';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPaso1DatosGenerales();
      case 1:
        return _buildPaso2CondicionesTransporte();
      case 2:
        return _buildPaso3InspeccionCalidad();
      case 3:
        return _buildPaso4ResultadoFinal();
      default:
        return Container();
    }
  }

  Widget _buildPaso1DatosGenerales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Datos Generales',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        _buildProveedorAutocomplete(),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Fecha de Recepción',
          value: _fechaRecepcion,
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
                _fechaRecepcion = date;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildAutocompleteField(
          label: 'Tipo de Fruta',
          value: _tipoFruta,
          items: _tiposFruta,
          required: true,
          onChanged: (value) {
            setState(() {
              _tipoFruta = value;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _cantidadController,
          label: 'Cantidad Recibida (lb)',
          required: true,
          keyboardType: TextInputType.number,
          icon: Icons.scale_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _facturaController,
          label: 'Factura / Guía de Remisión No.',
          icon: Icons.receipt_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _valorCompraController,
          label: 'Valor de Compra',
          keyboardType: TextInputType.number,
          icon: Icons.attach_money_outlined,
          prefix: '\$COP ',
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Responsable de Recepción',
          value: _responsable,
          items: _responsables,
          required: true,
          onChanged: (value) {
            setState(() {
              _responsable = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaso2CondicionesTransporte() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Condiciones de Transporte y Entrega',
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
        }).toList(),
      ],
    );
  }

  Widget _buildPaso3InspeccionCalidad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Inspección de Calidad',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        ..._criteriosCalidad.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCriterioCalidadCard(
              titulo: entry.key,
              especificacion: entry.value['especificacion'],
              cumple: entry.value['cumple'],
              observaciones: entry.value['observaciones'],
              onCumpleChanged: (value) {
                setState(() {
                  _criteriosCalidad[entry.key]!['cumple'] = value;
                });
              },
              onObservacionesChanged: (value) {
                _criteriosCalidad[entry.key]!['observaciones'] = value;
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPaso4ResultadoFinal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. Resultado Final y Firmas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        // Resultado Final
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
                title: const Text('Aceptado'),
                value: 'Aceptado',
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
                title: const Text('Parcial'),
                value: 'Parcial',
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
          controller: _observacionesGeneralesController,
          inputFormatters: [UpperCaseTextFormatter()],
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Observaciones Generales',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    TextInputType? keyboardType,
    IconData? icon,
    String? prefix,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: [UpperCaseTextFormatter()],
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        prefixIcon: icon != null ? Icon(icon) : null,
        prefixText: prefix,
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
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        prefixIcon: const Icon(Icons.eco_outlined),
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

  Widget _buildAutocompleteField({
    required String label,
    required String? value,
    required List<String> items,
    required bool required,
    required ValueChanged<String?> onChanged,
  }) {
    return Autocomplete<String>(
      initialValue: value != null ? TextEditingValue(text: value) : null,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return items;
        }
        return items.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        onChanged(selection);
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : ''),
            prefixIcon: const Icon(Icons.eco_outlined),
            suffixIcon: const Icon(Icons.arrow_drop_down),
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
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              width: MediaQuery.of(context).size.width - 40,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('Cumple'),
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
                  title: const Text('No cumple'),
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
            inputFormatters: [UpperCaseTextFormatter()],
            onChanged: onObservacionesChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildProveedorAutocomplete() {
    return Autocomplete<Map<String, dynamic>>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return _proveedores.cast<Map<String, dynamic>>();
        }
        return _proveedores.cast<Map<String, dynamic>>().where((proveedor) {
          final nombreComercial =
              proveedor['nombre_comercial']?.toString().toLowerCase() ?? '';
          final razonSocial =
              proveedor['razon_social']?.toString().toLowerCase() ?? '';
          final searchText = textEditingValue.text.toLowerCase();
          return nombreComercial.contains(searchText) ||
              razonSocial.contains(searchText);
        });
      },
      displayStringForOption:
          (proveedor) => proveedor['nombre_comercial'] ?? '',
      onSelected: (proveedor) {
        setState(() {
          _proveedorSeleccionado = proveedor;
          _proveedorController.text = proveedor['nombre_comercial'] ?? '';
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        if (_proveedorController.text.isNotEmpty && controller.text.isEmpty) {
          controller.text = _proveedorController.text;
        }
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          inputFormatters: [UpperCaseTextFormatter()],
          decoration: InputDecoration(
            labelText: 'Proveedor *',
            prefixIcon: const Icon(Icons.business_outlined),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_proveedorSeleccionado != null)
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 20),
                    onPressed: () => _mostrarDetallesProveedor(),
                    tooltip: 'Ver detalles',
                  ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed:
                      () => _mostrarDialogoNuevoProveedor(controller.text),
                  tooltip: 'Crear nuevo proveedor',
                ),
              ],
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obligatorio';
            }
            return null;
          },
          onChanged: (value) {
            _proveedorController.text = value;
            if (_proveedorSeleccionado != null &&
                _proveedorSeleccionado!['nombre_comercial'] != value) {
              setState(() {
                _proveedorSeleccionado = null;
              });
            }
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              width: MediaQuery.of(context).size.width - 40,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final proveedor = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(proveedor),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            proveedor['nombre_comercial'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (proveedor['razon_social'] != null &&
                              proveedor['razon_social'] !=
                                  proveedor['nombre_comercial'])
                            Text(
                              proveedor['razon_social'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          if (proveedor['telefono'] != null)
                            Text(
                              proveedor['telefono'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarDetallesProveedor() {
    if (_proveedorSeleccionado == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(Icons.business, color: Color(0xFF600F40)),
              SizedBox(width: 12),
              Text('Detalles del Proveedor'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetalleItem(
                  'Nombre Comercial',
                  _proveedorSeleccionado!['nombre_comercial'] ?? 'N/A',
                ),
                _buildDetalleItem(
                  'Razón Social',
                  _proveedorSeleccionado!['razon_social'] ?? 'N/A',
                ),
                _buildDetalleItem(
                  'Teléfono',
                  _proveedorSeleccionado!['telefono'] ?? 'N/A',
                ),
                _buildDetalleItem(
                  'Email',
                  _proveedorSeleccionado!['email'] ?? 'N/A',
                ),
                _buildDetalleItem(
                  'Dirección',
                  _proveedorSeleccionado!['direccion'] ?? 'N/A',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Color(0xFF600F40)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetalleItem(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoNuevoProveedor(String? nombreInicial) {
    final nombreController = TextEditingController(text: nombreInicial ?? '');
    final razonSocialController = TextEditingController();
    final telefonoController = TextEditingController();
    final emailController = TextEditingController();
    final direccionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(Icons.add_business, color: Color(0xFF600F40)),
              SizedBox(width: 12),
              Text('Nuevo Proveedor'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Nombre Comercial *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: razonSocialController,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Razón Social',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: telefonoController,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: direccionController,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Dirección',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final nuevoProveedor = await widget.api.crearProveedor(
                      nombreComercial: nombreController.text,
                      razonSocial:
                          razonSocialController.text.isEmpty
                              ? null
                              : razonSocialController.text,
                      telefono:
                          telefonoController.text.isEmpty
                              ? null
                              : telefonoController.text,
                      email:
                          emailController.text.isEmpty
                              ? null
                              : emailController.text,
                      direccion:
                          direccionController.text.isEmpty
                              ? null
                              : direccionController.text,
                    );

                    await _cargarProveedores();

                    setState(() {
                      _proveedorSeleccionado = nuevoProveedor;
                      _proveedorController.text =
                          nuevoProveedor['nombre_comercial'] ?? '';
                    });

                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proveedor creado exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF600F40),
              ),
              child: const Text('Crear', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCriterioCalidadCard({
    required String titulo,
    required String especificacion,
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            especificacion,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('Cumple'),
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
                  title: const Text('No cumple'),
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
            inputFormatters: [UpperCaseTextFormatter()],
            onChanged: onObservacionesChanged,
          ),
        ],
      ),
    );
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
                  if (_currentStep < 3) {
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
                _currentStep < 3 ? 'Siguiente' : 'Enviar',
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
        if (_proveedorController.text.isEmpty) {
          _showError('El proveedor es obligatorio');
          return false;
        }
        if (_fechaRecepcion == null) {
          _showError('La fecha de recepción es obligatoria');
          return false;
        }
        if (_tipoFruta == null) {
          _showError('El tipo de fruta es obligatorio');
          return false;
        }
        if (_cantidadController.text.isEmpty) {
          _showError('La cantidad recibida es obligatoria');
          return false;
        }
        if (_responsable == null || _responsable!.isEmpty) {
          _showError('El responsable de recepción es obligatorio');
          return false;
        }
        return true;

      case 1:
        for (var entry in _condicionesTransporte.entries) {
          if (entry.value['cumple'] == null) {
            _showError('Complete todos los criterios de transporte');
            return false;
          }
        }
        return true;

      case 2:
        for (var entry in _criteriosCalidad.entries) {
          if (entry.value['cumple'] == null) {
            _showError('Complete todos los criterios de calidad');
            return false;
          }
        }
        return true;

      case 3:
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
            'El formulario de recepción de frutas ha sido enviado correctamente.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver a pantalla anterior
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
