import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ControlAlmacenamientoScreen extends StatefulWidget {
  final ApiService api;

  const ControlAlmacenamientoScreen({super.key, required this.api});

  @override
  State<ControlAlmacenamientoScreen> createState() =>
      _ControlAlmacenamientoScreenState();
}

class _ControlAlmacenamientoScreenState
    extends State<ControlAlmacenamientoScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Paso 1 - Datos Generales
  final _productoController = TextEditingController();
  String? _tipoFruta;
  final _numeroLoteController = TextEditingController();
  DateTime? _fechaElaboracion;
  DateTime? _fechaIngresoAlmacen;
  DateTime? _fechaVencimiento;
  final _tipoEmpaqueController = TextEditingController();
  final _tamanoEmpaqueController = TextEditingController();
  final _cantidadController = TextEditingController();
  String? _responsableIngreso;

  final List<String> _tiposFruta = [
    'Guanábana',
    'Maracuyá',
    'Mora',
    'Lulo',
    'Mango',
    'Fresa',
    'Guayaba',
    'Piña',
    'Papaya',
    'Coco',
    'Tamarindo',
    'Ciruela',
    'Durazno',
    'Uchuva',
    'Limón',
    'Naranja',
    'Mandarina',
    'Tomate de árbol',
    'Borojó',
    'Corozo',
    'Badea',
    'Arándanos',
  ];

  final List<String> _responsables = ['ROCIO', 'LORENA'];

  // Paso 2 - Condiciones del Área
  final Map<String, Map<String, dynamic>> _condicionesArea = {
    'Temperatura ambiente': {
      'limite': '18–25 °C',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
    },
    'Humedad relativa': {
      'limite': '40–60 %',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
    },
    'Limpieza del área': {
      'limite': 'Adecuada / Inadecuada',
      'valor': null,
      'cumple': null,
      'observaciones': '',
    },
    'Ventilación': {
      'limite': 'Adecuada / Inadecuada',
      'valor': null,
      'cumple': null,
      'observaciones': '',
    },
    'Orden del producto': {
      'limite': 'Correcto / Incorrecto',
      'valor': null,
      'cumple': null,
      'observaciones': '',
    },
  };

  @override
  void dispose() {
    _productoController.dispose();
    _numeroLoteController.dispose();
    _tipoEmpaqueController.dispose();
    _tamanoEmpaqueController.dispose();
    _cantidadController.dispose();
    for (var cond in _condicionesArea.values) {
      if (cond['valor'] is TextEditingController) {
        cond['valor'].dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Control de Almacenamiento',
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
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
                    width: 100,
                    child: Text(
                      _getStepTitle(index),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
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
              if (index < 1)
                Container(
                  width: 40,
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 30),
                  color:
                      isCompleted ? const Color(0xFF600F40) : Colors.grey[300],
                ),
            ],
          );
        }),
      ),
    );
  }

  String _getStepTitle(int index) {
    switch (index) {
      case 0:
        return 'Datos Generales';
      case 1:
        return 'Condiciones del Área';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPaso1DatosGenerales();
      case 1:
        return _buildPaso2CondicionesArea();
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
        _buildTextField(
          controller: _productoController,
          label: 'Producto',
          required: true,
          icon: Icons.inventory_2_outlined,
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
          controller: _numeroLoteController,
          label: 'Número de Lote',
          required: true,
          icon: Icons.qr_code_outlined,
        ),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Fecha de Elaboración',
          value: _fechaElaboracion,
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
                _fechaElaboracion = date;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Fecha de Ingreso al Almacén',
          value: _fechaIngresoAlmacen,
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
                _fechaIngresoAlmacen = date;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildDateField(
          label: 'Fecha de Vencimiento',
          value: _fechaVencimiento,
          required: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 365)),
              firstDate: DateTime.now(),
              lastDate: DateTime(2035),
            );
            if (date != null) {
              setState(() {
                _fechaVencimiento = date;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _tipoEmpaqueController,
          label: 'Tipo de Empaque',
          required: true,
          icon: Icons.inventory_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _tamanoEmpaqueController,
          label: 'Tamaño del Empaque',
          required: true,
          icon: Icons.straighten_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _cantidadController,
          label: 'Cantidad',
          required: true,
          icon: Icons.numbers_outlined,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Responsable de Ingreso',
          value: _responsableIngreso,
          items: _responsables,
          required: true,
          icon: Icons.person_outlined,
          onChanged: (value) {
            setState(() {
              _responsableIngreso = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaso2CondicionesArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Condiciones del Área de Almacenamiento',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        ..._condicionesArea.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCondicionCard(entry.key, entry.value),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _buildAutocompleteField({
    required String label,
    required String? value,
    required List<String> items,
    required bool required,
    required ValueChanged<String?> onChanged,
  }) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: value ?? ''),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return items;
        }
        return items.where((item) {
          return item.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: onChanged,
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label + (required ? ' *' : ''),
            prefixIcon: const Icon(Icons.eco_outlined),
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
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              width: MediaQuery.of(context).size.width - 40,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
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
      value: value,
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

  Widget _buildCondicionCard(String nombre, Map<String, dynamic> cond) {
    final isQualitative =
        nombre == 'Limpieza del área' ||
        nombre == 'Ventilación' ||
        nombre == 'Orden del producto';

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
            nombre,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Límite: ${cond['limite']}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          if (isQualitative)
            DropdownButtonFormField<String>(
              value: cond['valor'],
              decoration: InputDecoration(
                labelText: 'Valor Registrado',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
              items:
                  _getQualitativeOptions(nombre).map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  cond['valor'] = value;
                });
              },
            )
          else
            TextField(
              controller: cond['valor'],
              decoration: InputDecoration(
                labelText: 'Valor Registrado',
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
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('✔', style: TextStyle(fontSize: 16)),
                  value: true,
                  groupValue: cond['cumple'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      cond['cumple'] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('✖', style: TextStyle(fontSize: 16)),
                  value: false,
                  groupValue: cond['cumple'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      cond['cumple'] = value;
                    });
                  },
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
            onChanged: (value) {
              cond['observaciones'] = value;
            },
          ),
        ],
      ),
    );
  }

  List<String> _getQualitativeOptions(String nombre) {
    if (nombre == 'Limpieza del área') {
      return ['Adecuada', 'Inadecuada'];
    } else if (nombre == 'Ventilación') {
      return ['Adecuada', 'Inadecuada'];
    } else if (nombre == 'Orden del producto') {
      return ['Correcto', 'Incorrecto'];
    }
    return [];
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
                  if (_currentStep < 1) {
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
                _currentStep < 1 ? 'Siguiente' : 'Enviar',
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
        if (_productoController.text.isEmpty) {
          _showError('El producto es obligatorio');
          return false;
        }
        if (_tipoFruta == null || _tipoFruta!.isEmpty) {
          _showError('El tipo de fruta es obligatorio');
          return false;
        }
        if (_numeroLoteController.text.isEmpty) {
          _showError('El número de lote es obligatorio');
          return false;
        }
        if (_fechaElaboracion == null) {
          _showError('La fecha de elaboración es obligatoria');
          return false;
        }
        if (_fechaIngresoAlmacen == null) {
          _showError('La fecha de ingreso al almacén es obligatoria');
          return false;
        }
        if (_fechaVencimiento == null) {
          _showError('La fecha de vencimiento es obligatoria');
          return false;
        }
        if (_tipoEmpaqueController.text.isEmpty) {
          _showError('El tipo de empaque es obligatorio');
          return false;
        }
        if (_tamanoEmpaqueController.text.isEmpty) {
          _showError('El tamaño del empaque es obligatorio');
          return false;
        }
        if (_cantidadController.text.isEmpty) {
          _showError('La cantidad es obligatoria');
          return false;
        }
        if (_responsableIngreso == null || _responsableIngreso!.isEmpty) {
          _showError('El responsable de ingreso es obligatorio');
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
            'El formulario de control de almacenamiento ha sido enviado correctamente.',
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
