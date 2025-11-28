import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class ProveedorDropdown extends StatefulWidget {
  final ApiService api;
  final String? valorInicial;
  final Function(String?) onChanged;
  final String? labelText;
  final bool requerido;

  const ProveedorDropdown({
    super.key,
    required this.api,
    required this.onChanged,
    this.valorInicial,
    this.labelText = 'Proveedor',
    this.requerido = false,
  });

  @override
  State<ProveedorDropdown> createState() => _ProveedorDropdownState();
}

class _ProveedorDropdownState extends State<ProveedorDropdown> {
  List<dynamic> _proveedores = [];
  String? _valorSeleccionado;
  bool _isLoading = true;
  final TextEditingController _nuevoProveedorController =
      TextEditingController();
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // No asignar valorInicial directamente por problemas de validación
    _valorSeleccionado = null;
    _cargarProveedores();
  }

  @override
  void dispose() {
    _nuevoProveedorController.dispose();
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarProveedores() async {
    try {
      setState(() => _isLoading = true);
      final proveedores = await widget.api.getProveedores();
      setState(() {
        _proveedores = proveedores;

        // Validar que el valor seleccionado existe en la lista
        if (_valorSeleccionado != null && _valorSeleccionado != '_NUEVO_') {
          bool valorExiste = _proveedores.any(
            (p) => p['nombre_comercial']?.toString() == _valorSeleccionado,
          );
          if (!valorExiste) {
            _valorSeleccionado = null; // Resetear si no existe
          }
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // En caso de error, resetear valor para evitar problemas
        if (_valorSeleccionado != null && _valorSeleccionado != '_NUEVO_') {
          _valorSeleccionado = null;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar proveedores: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _mostrarDialogoNuevoProveedor() async {
    _nuevoProveedorController.clear();

    final resultado = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add_business,
                    color: Color(0xFF667EEA),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Nuevo Proveedor',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nuevoProveedorController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Nombre Comercial *',
                      hintText: 'Ingrese el nombre comercial',
                      prefixIcon: const Icon(Icons.business),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF667EEA),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre comercial es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'El proveedor se agregará con el nombre comercial especificado.',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final nombreComercial = _nuevoProveedorController.text.trim();
                  if (nombreComercial.isNotEmpty) {
                    try {
                      // Crear el nuevo proveedor
                      await widget.api.crearProveedor(
                        nombreComercial: nombreComercial,
                      );

                      // Recargar la lista de proveedores
                      await _cargarProveedores();

                      if (mounted) {
                        Navigator.of(context).pop(nombreComercial);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Proveedor "$nombreComercial" creado exitosamente',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al crear proveedor: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Crear Proveedor',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
    );

    if (resultado != null) {
      setState(() {
        _valorSeleccionado = resultado;
      });
      widget.onChanged(resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            final String query = textEditingValue.text.toLowerCase();

            // Si está cargando o no hay proveedores, devolver lista vacía
            if (_isLoading || _proveedores.isEmpty) {
              return const Iterable<String>.empty();
            }

            // Siempre incluir la opción de agregar nuevo proveedor
            List<String> opciones = ['Agregar Nuevo Proveedor'];

            // Filtrar proveedores según el texto ingresado
            if (query.isEmpty) {
              // Si no hay texto, mostrar todos los proveedores
              opciones.addAll(
                _proveedores.map<String>(
                  (proveedor) => proveedor['nombre_comercial'] ?? 'Sin nombre',
                ),
              );
            } else {
              // Filtrar proveedores que contengan el texto
              opciones.addAll(
                _proveedores
                    .where(
                      (proveedor) => (proveedor['nombre_comercial'] ?? '')
                          .toLowerCase()
                          .contains(query),
                    )
                    .map<String>(
                      (proveedor) =>
                          proveedor['nombre_comercial'] ?? 'Sin nombre',
                    ),
              );
            }

            return opciones;
          },
          onSelected: (String selection) {
            if (selection == 'Agregar Nuevo Proveedor') {
              _mostrarDialogoNuevoProveedor();
            } else {
              setState(() {
                _valorSeleccionado = selection;
              });
              widget.onChanged(selection);
            }
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            // Sincronizar el controller interno con nuestro valor seleccionado
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_valorSeleccionado != null &&
                  controller.text != _valorSeleccionado) {
                controller.text = _valorSeleccionado!;
              }
            });

            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: widget.labelText,
                prefixIcon: const Icon(Icons.business_outlined),
                suffixIcon:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                        : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.clear();
                            setState(() {
                              _valorSeleccionado = null;
                            });
                            widget.onChanged(null);
                          },
                        ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF667EEA),
                    width: 2,
                  ),
                ),
              ),
              validator:
                  widget.requerido
                      ? (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es requerido';
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
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 300,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final String option = options.elementAt(index);
                      final bool isNewOption =
                          option == 'Agregar Nuevo Proveedor';

                      return ListTile(
                        leading:
                            isNewOption
                                ? Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF667EEA,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: Color(0xFF667EEA),
                                  ),
                                )
                                : const Icon(
                                  Icons.business,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                        title: Text(
                          option,
                          style: GoogleFonts.montserrat(
                            fontWeight:
                                isNewOption
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                            color: isNewOption ? const Color(0xFF667EEA) : null,
                          ),
                        ),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        // Botón de refresh separado
        if (!_isLoading) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _cargarProveedores,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Recargar'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF667EEA),
                textStyle: GoogleFonts.montserrat(fontSize: 12),
              ),
            ),
          ),
        ],
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  'Cargando proveedores...',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
