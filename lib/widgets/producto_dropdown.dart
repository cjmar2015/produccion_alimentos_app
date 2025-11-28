import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class ProductoDropdown extends StatefulWidget {
  final ApiService api;
  final Map<String, dynamic>? valorInicial;
  final Function(Map<String, dynamic>?) onChanged;
  final String? labelText;
  final bool requerido;

  const ProductoDropdown({
    super.key,
    required this.api,
    required this.onChanged,
    this.valorInicial,
    this.labelText = 'Producto',
    this.requerido = false,
  });

  @override
  State<ProductoDropdown> createState() => _ProductoDropdownState();
}

class _ProductoDropdownState extends State<ProductoDropdown> {
  List<dynamic> _productos = [];
  Map<String, dynamic>? _valorSeleccionado;
  bool _isLoading = true;
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _valorSeleccionado = widget.valorInicial;
    _cargarProductos();
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Future<void> _cargarProductos() async {
    try {
      setState(() => _isLoading = true);

      final productosData = await widget.api.getProductos();

      setState(() {
        _productos = productosData;
        _isLoading = false;
      });

      // Si hay valor inicial, verificar que existe en la lista
      if (widget.valorInicial != null) {
        final productoExiste = _productos.any(
          (p) => p['id_producto'] == widget.valorInicial!['id_producto'],
        );
        if (productoExiste) {
          setState(() {
            _valorSeleccionado = widget.valorInicial;
          });
          _busquedaController.text = widget.valorInicial!['nombre'] ?? '';
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar productos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _obtenerTextoProducto(Map<String, dynamic> producto) {
    return producto['nombre'] ?? 'Producto sin nombre';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Cargando productos...'),
          ],
        ),
      );
    }

    return Autocomplete<Map<String, dynamic>>(
      displayStringForOption:
          (Map<String, dynamic> producto) => _obtenerTextoProducto(producto),
      optionsBuilder: (TextEditingValue textEditingValue) {
        final String query = textEditingValue.text.toLowerCase();

        if (query.isEmpty) {
          return _productos.cast<Map<String, dynamic>>();
        }

        return _productos.where((producto) {
          final String nombre = (producto['nombre'] ?? '').toLowerCase();
          return nombre.contains(query);
        }).cast<Map<String, dynamic>>();
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<Map<String, dynamic>> onSelected,
        Iterable<Map<String, dynamic>> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 400),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> producto = options.elementAt(
                    index,
                  );
                  return InkWell(
                    onTap: () => onSelected(producto),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _obtenerTextoProducto(producto),
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF5D4037),
                            ),
                          ),
                          if (producto['descripcion'] != null &&
                              producto['descripcion']
                                  .toString()
                                  .isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              producto['descripcion'],
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController fieldTextEditingController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted,
      ) {
        // Sincronizar el controlador interno con el externo
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_busquedaController.text != fieldTextEditingController.text) {
            fieldTextEditingController.text = _busquedaController.text;
          }
        });

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: GoogleFonts.openSans(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Buscar producto...',
              hintStyle: GoogleFonts.openSans(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF600F40)),
              suffixIcon:
                  fieldTextEditingController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        color: Colors.grey[600],
                        onPressed: () {
                          fieldTextEditingController.clear();
                          _busquedaController.clear();
                          setState(() {
                            _valorSeleccionado = null;
                          });
                          widget.onChanged(null);
                        },
                      )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator:
                widget.requerido
                    ? (value) {
                      if (_valorSeleccionado == null) {
                        return 'Por favor selecciona un producto';
                      }
                      return null;
                    }
                    : null,
          ),
        );
      },
      onSelected: (Map<String, dynamic> selection) {
        setState(() {
          _valorSeleccionado = selection;
          _busquedaController.text = _obtenerTextoProducto(selection);
        });

        widget.onChanged(selection);
      },
    );
  }
}
