import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MovimientosInventarioScreen extends StatefulWidget {
  final ApiService api;

  const MovimientosInventarioScreen({super.key, required this.api});

  @override
  State<MovimientosInventarioScreen> createState() =>
      _MovimientosInventarioScreenState();
}

class _MovimientosInventarioScreenState
    extends State<MovimientosInventarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _movimientos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Movimientos de Inventario',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Movimientos de Inventario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Registra los movimientos de productos en el inventario',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    if (_movimientos.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.inventory_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay movimientos registrados',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Presiona el botón de abajo para agregar',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._movimientos.asMap().entries.map((entry) {
                        final index = entry.key;
                        final mov = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildMovimientoCard(mov, index),
                        );
                      }).toList(),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _agregarMovimiento,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar Movimiento'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF600F40),
                        side: const BorderSide(color: Color(0xFF600F40)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_movimientos.isNotEmpty) _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMovimientoCard(Map<String, dynamic> mov, int index) {
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
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF600F40),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Movimiento',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  setState(() {
                    mov['fecha']?.dispose();
                    mov['producto']?.dispose();
                    mov['sabor']?.dispose();
                    mov['cantidad']?.dispose();
                    mov['presentacion']?.dispose();
                    mov['valorVenta']?.dispose();
                    _movimientos.removeAt(index);
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                  mov['fechaValue'] = date;
                });
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Fecha *',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              child: Text(
                mov['fechaValue'] != null
                    ? '${mov['fechaValue'].day}/${mov['fechaValue'].month}/${mov['fechaValue'].year}'
                    : 'Seleccionar fecha',
                style: TextStyle(
                  color:
                      mov['fechaValue'] != null
                          ? Colors.black
                          : Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mov['producto'],
            decoration: InputDecoration(
              labelText: 'Producto *',
              prefixIcon: const Icon(Icons.inventory_2_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mov['sabor'],
            decoration: InputDecoration(
              labelText: 'Sabor *',
              prefixIcon: const Icon(Icons.eco_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mov['cantidad'],
            decoration: InputDecoration(
              labelText: 'Cantidad *',
              prefixIcon: const Icon(Icons.numbers_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mov['presentacion'],
            decoration: InputDecoration(
              labelText: 'Presentación *',
              prefixIcon: const Icon(Icons.straighten_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: mov['valorVenta'],
            decoration: InputDecoration(
              labelText: 'Valor de Venta *',
              prefixIcon: const Icon(Icons.attach_money_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  void _agregarMovimiento() {
    setState(() {
      _movimientos.add({
        'fechaValue': null,
        'producto': TextEditingController(),
        'sabor': TextEditingController(),
        'cantidad': TextEditingController(),
        'presentacion': TextEditingController(),
        'valorVenta': TextEditingController(),
      });
    });
  }

  Widget _buildSubmitButton() {
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
      child: ElevatedButton(
        onPressed: _enviarFormulario,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF600F40),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Enviar Movimientos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _enviarFormulario() {
    // Validar que todos los campos estén completos
    for (var i = 0; i < _movimientos.length; i++) {
      final mov = _movimientos[i];
      if (mov['fechaValue'] == null) {
        _showError('La fecha del movimiento ${i + 1} es obligatoria');
        return;
      }
      if (mov['producto'].text.isEmpty) {
        _showError('El producto del movimiento ${i + 1} es obligatorio');
        return;
      }
      if (mov['sabor'].text.isEmpty) {
        _showError('El sabor del movimiento ${i + 1} es obligatorio');
        return;
      }
      if (mov['cantidad'].text.isEmpty) {
        _showError('La cantidad del movimiento ${i + 1} es obligatoria');
        return;
      }
      if (mov['presentacion'].text.isEmpty) {
        _showError('La presentación del movimiento ${i + 1} es obligatoria');
        return;
      }
      if (mov['valorVenta'].text.isEmpty) {
        _showError('El valor de venta del movimiento ${i + 1} es obligatorio');
        return;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outlined, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Movimientos Registrados'),
            ],
          ),
          content: Text(
            'Se han registrado ${_movimientos.length} movimiento(s) de inventario correctamente.',
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    for (var mov in _movimientos) {
      mov['producto']?.dispose();
      mov['sabor']?.dispose();
      mov['cantidad']?.dispose();
      mov['presentacion']?.dispose();
      mov['valorVenta']?.dispose();
    }
    super.dispose();
  }
}
