import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ControlParametrosScreen extends StatefulWidget {
  final ApiService api;

  const ControlParametrosScreen({super.key, required this.api});

  @override
  State<ControlParametrosScreen> createState() =>
      _ControlParametrosScreenState();
}

class _ControlParametrosScreenState extends State<ControlParametrosScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Paso 1 - Información General
  DateTime? _fechaProduccion;
  final _codigoLoteController = TextEditingController();
  final _productoController = TextEditingController();
  String? _turno;
  String? _operarioResponsable;
  String? _supervisor;

  final List<String> _turnos = ['Mañana', 'Tarde', 'Noche'];
  final List<String> _responsables = ['ROCIO', 'LORENA'];

  // Paso 2 - Parámetros Críticos (5 subsecciones)
  // 2.1 Mezcla inicial
  final Map<String, Map<String, dynamic>> _mezclaInicial = {
    'Temperatura inicial de mezclado': {
      'objetivo': '40–45 °C',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Estado de las yemas (homogeneizadas)': {
      'objetivo': 'Homogéneo',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Disolución del azúcar': {
      'objetivo': 'Completa',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Velocidad/agitación': {
      'objetivo': 'Continua',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
  };

  // 2.2 Cocción controlada
  final Map<String, Map<String, dynamic>> _coccionControlada = {
    'Temperatura mínima': {
      'objetivo': '70 °C',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Temperatura máxima': {
      'objetivo': '75 °C',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Tiempo de cocción': {
      'objetivo': '10–15 min',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Homogeneidad (sin grumos)': {
      'objetivo': 'Sí',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
  };

  // 2.3 Enfriamiento previo
  final Map<String, Map<String, dynamic>> _enfriamientoPrevio = {
    'Temperatura antes de agregar licor': {
      'objetivo': '40–45 °C',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Tiempo de reposo previo (min)': {
      'objetivo': '5–10',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
  };

  // 2.4 Adición del licor
  final Map<String, Map<String, dynamic>> _adicionLicor = {
    'Cantidad de licor': {
      'objetivo': 'Según receta',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Incorporación completa': {
      'objetivo': 'Sí',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Temperatura durante la adición': {
      'objetivo': '< 50 °C',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
  };

  // 2.5 Enfriamiento final
  final Map<String, Map<String, dynamic>> _enfriamientoFinal = {
    'Temperatura antes del envasado': {
      'objetivo': '30–35 °C',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Tiempo de reposo': {
      'objetivo': '30 min',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
  };

  // Paso 3 - Control de Envases
  final Map<String, Map<String, dynamic>> _controlEnvases = {
    'Limpieza y sanitización de envases': {
      'objetivo': 'Conforme BPM',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Integridad de tapas y sellos': {
      'objetivo': 'Sin defectos',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Temperatura de llenado': {
      'objetivo': '30–35 °C',
      'valor': TextEditingController(),
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
  };

  // Paso 4 - Control de Calidad
  final Map<String, Map<String, dynamic>> _controlCalidad = {
    'Color': {
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Aroma': {
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Textura': {
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Sabor': {
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
    'Ausencia de separación de fases': {
      'cumple': null,
      'observaciones': '',
      'firma': TextEditingController(),
    },
  };

  // Paso 5 - No Conformidades
  final List<Map<String, dynamic>> _noConformidades = [];

  // Paso 6 - Liberación del Lote
  String? _resultadoFinal;

  @override
  void dispose() {
    _codigoLoteController.dispose();
    _productoController.dispose();
    for (var param in _mezclaInicial.values) {
      param['valor'].dispose();
      param['firma'].dispose();
    }
    for (var param in _coccionControlada.values) {
      param['valor'].dispose();
      param['firma'].dispose();
    }
    for (var param in _enfriamientoPrevio.values) {
      param['valor'].dispose();
      param['firma'].dispose();
    }
    for (var param in _adicionLicor.values) {
      param['valor'].dispose();
      param['firma'].dispose();
    }
    for (var param in _enfriamientoFinal.values) {
      param['valor'].dispose();
      param['firma'].dispose();
    }
    for (var param in _controlEnvases.values) {
      param['valor'].dispose();
      param['firma'].dispose();
    }
    for (var param in _controlCalidad.values) {
      param['firma'].dispose();
    }
    for (var nc in _noConformidades) {
      nc['noConformidad'].dispose();
      nc['parametro'].dispose();
      nc['accion'].dispose();
      nc['responsable'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Control de Parámetros Críticos',
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
        return 'Parámetros';
      case 2:
        return 'Envases';
      case 3:
        return 'Calidad';
      case 4:
        return 'No Conform.';
      case 5:
        return 'Liberación';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPaso1InfoGeneral();
      case 1:
        return _buildPaso2ParametrosCriticos();
      case 2:
        return _buildPaso3ControlEnvases();
      case 3:
        return _buildPaso4ControlCalidad();
      case 4:
        return _buildPaso5NoConformidades();
      case 5:
        return _buildPaso6Liberacion();
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
        _buildDateField(
          label: 'Fecha de Producción',
          value: _fechaProduccion,
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
                _fechaProduccion = date;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _codigoLoteController,
          label: 'Código del Lote',
          required: true,
          icon: Icons.qr_code_outlined,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _productoController,
          label: 'Producto',
          required: true,
          icon: Icons.inventory_2_outlined,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Turno',
          value: _turno,
          items: _turnos,
          required: true,
          icon: Icons.schedule_outlined,
          onChanged: (value) {
            setState(() {
              _turno = value;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Operario Responsable',
          value: _operarioResponsable,
          items: _responsables,
          required: true,
          icon: Icons.person_outlined,
          onChanged: (value) {
            setState(() {
              _operarioResponsable = value;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Supervisor / Jefe de Producción',
          value: _supervisor,
          items: _responsables,
          required: true,
          icon: Icons.supervisor_account_outlined,
          onChanged: (value) {
            setState(() {
              _supervisor = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaso2ParametrosCriticos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Parámetros Críticos del Proceso',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        // 2.1 Mezcla inicial
        const Text(
          '2.1 Mezcla Inicial',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF600F40),
          ),
        ),
        const SizedBox(height: 12),
        ..._mezclaInicial.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildParametroCard(entry.key, entry.value),
          );
        }).toList(),
        const SizedBox(height: 16),
        // 2.2 Cocción controlada
        const Text(
          '2.2 Cocción Controlada',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF600F40),
          ),
        ),
        const SizedBox(height: 12),
        ..._coccionControlada.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildParametroCard(entry.key, entry.value),
          );
        }).toList(),
        const SizedBox(height: 16),
        // 2.3 Enfriamiento previo
        const Text(
          '2.3 Enfriamiento Previo a la Adición del Licor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF600F40),
          ),
        ),
        const SizedBox(height: 12),
        ..._enfriamientoPrevio.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildParametroCard(entry.key, entry.value),
          );
        }).toList(),
        const SizedBox(height: 16),
        // 2.4 Adición del licor
        const Text(
          '2.4 Adición del Licor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF600F40),
          ),
        ),
        const SizedBox(height: 12),
        ..._adicionLicor.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildParametroCard(entry.key, entry.value),
          );
        }).toList(),
        const SizedBox(height: 16),
        // 2.5 Enfriamiento final
        const Text(
          '2.5 Enfriamiento Final y Maduración',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF600F40),
          ),
        ),
        const SizedBox(height: 12),
        ..._enfriamientoFinal.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildParametroCard(entry.key, entry.value),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPaso3ControlEnvases() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Control de Envases',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        ..._controlEnvases.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildParametroCard(entry.key, entry.value),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPaso4ControlCalidad() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. Resultados de Control de Calidad',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),
        ..._controlCalidad.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCalidadCard(entry.key, entry.value),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPaso5NoConformidades() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5. No Conformidades y Acciones',
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
        }).toList(),
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

  Widget _buildPaso6Liberacion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '6. Liberación del Lote',
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
                title: const Text('No aprobado'),
                value: 'No aprobado',
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

  Widget _buildParametroCard(String nombre, Map<String, dynamic> param) {
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
            'Objetivo: ${param['objetivo']}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: param['valor'],
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
                  title: const Text('Sí', style: TextStyle(fontSize: 12)),
                  value: true,
                  groupValue: param['cumple'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      param['cumple'] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('No', style: TextStyle(fontSize: 12)),
                  value: false,
                  groupValue: param['cumple'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      param['cumple'] = value;
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
              param['observaciones'] = value;
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: param['firma'],
            decoration: InputDecoration(
              labelText: 'Firma Responsable',
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
        ],
      ),
    );
  }

  Widget _buildCalidadCard(String nombre, Map<String, dynamic> param) {
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
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('Sí', style: TextStyle(fontSize: 12)),
                  value: true,
                  groupValue: param['cumple'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      param['cumple'] = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('No', style: TextStyle(fontSize: 12)),
                  value: false,
                  groupValue: param['cumple'],
                  activeColor: const Color(0xFF600F40),
                  onChanged: (value) {
                    setState(() {
                      param['cumple'] = value;
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
              param['observaciones'] = value;
            },
          ),
          const SizedBox(height: 8),
          TextField(
            controller: param['firma'],
            decoration: InputDecoration(
              labelText: 'Firma CC',
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
            controller: nc['noConformidad'],
            decoration: InputDecoration(
              labelText: 'No Conformidad',
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
            controller: nc['parametro'],
            decoration: InputDecoration(
              labelText: 'Parámetro Afectado',
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
              labelText: 'Acción Correctiva',
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
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              labelText: 'Resultado',
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
              nc['resultado'] = value;
            },
          ),
        ],
      ),
    );
  }

  void _agregarNoConformidad() {
    setState(() {
      _noConformidades.add({
        'noConformidad': TextEditingController(),
        'parametro': TextEditingController(),
        'accion': TextEditingController(),
        'responsable': TextEditingController(),
        'fecha': null,
        'resultado': '',
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
        if (_fechaProduccion == null) {
          _showError('La fecha de producción es obligatoria');
          return false;
        }
        if (_codigoLoteController.text.isEmpty) {
          _showError('El código del lote es obligatorio');
          return false;
        }
        if (_productoController.text.isEmpty) {
          _showError('El producto es obligatorio');
          return false;
        }
        if (_turno == null || _turno!.isEmpty) {
          _showError('El turno es obligatorio');
          return false;
        }
        if (_operarioResponsable == null || _operarioResponsable!.isEmpty) {
          _showError('El operario responsable es obligatorio');
          return false;
        }
        if (_supervisor == null || _supervisor!.isEmpty) {
          _showError('El supervisor es obligatorio');
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
            'El formulario de control de parámetros críticos ha sido enviado correctamente.',
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
