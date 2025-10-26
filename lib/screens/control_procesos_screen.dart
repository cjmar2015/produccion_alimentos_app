import 'package:flutter/material.dart';
import '../models/proceso_model.dart';
import '../services/api_service.dart';
import 'proceso_detalle_screen.dart';
import 'login_screen.dart';

/// Pantalla principal para el control de procesos de producción
class ControlProcesosScreen extends StatefulWidget {
  final ApiService api;

  const ControlProcesosScreen({super.key, required this.api});

  @override
  State<ControlProcesosScreen> createState() => _ControlProcesosScreenState();
}

class _ControlProcesosScreenState extends State<ControlProcesosScreen> {
  // Lista de productos obtenidos de la API
  List<dynamic> productos = [];

  // Producto seleccionado actualmente
  Map<String, dynamic>? productoSeleccionado;

  // Lista de procesos predefinidos
  late List<ProcesoProduccion> procesos;

  // Estado de carga
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    // Inicializar los procesos predefinidos
    procesos = DatosProcesos.obtenerProcesos();
    // Cargar productos desde la API
    _cargarProductos();
  }

  /// Carga la lista de productos desde la API
  Future<void> _cargarProductos() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final productosData = await widget.api.getProductos();

      setState(() {
        productos = productosData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error al cargar productos: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con título y botón de cerrar sesión
      appBar: AppBar(
        title: const Text(
          'Control de Procesos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF600F40), // 🎨 PÚRPURA DE TIRO
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Botón de actualizar productos
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarProductos,
            tooltip: 'Actualizar productos',
          ),
          // Menú de usuario con opción de cerrar sesión
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (String value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Cerrar Sesión'),
                      ],
                    ),
                  ),
                ],
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
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Sección de selección de producto
                  _buildSeccionSeleccionProducto(),

                  const SizedBox(height: 16),

                  // Título de procesos
                  if (productoSeleccionado != null) ...[
                    _buildTituloProcesos(),
                    const SizedBox(height: 12),
                  ],
                ]),
              ),
            ),

            // Lista de procesos como SliverGrid
            if (productoSeleccionado != null)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final proceso = procesos[index];
                    return _buildTarjetaProceso(proceso);
                  }, childCount: procesos.length),
                ),
              )
            else
              SliverFillRemaining(child: _buildMensajeSeleccionarProducto()),
          ],
        ),
      ),
    );
  }

  /// Widget para la sección de selección de producto
  Widget _buildSeccionSeleccionProducto() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          const Row(
            children: [
              Icon(
                Icons.inventory_2,
                color: Color(0xFF600F40),
                size: 24,
              ), // 🎨 PÚRPURA DE TIRO
              SizedBox(width: 8),
              Text(
                'Seleccionar Producto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Dropdown de productos o mensaje de carga/error
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (error != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error!,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                ],
              ),
            )
          else
            // Dropdown con lista de productos
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: productoSeleccionado?['id_producto'],
                  hint: const Text(
                    'Selecciona un producto...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  isExpanded: true,
                  items:
                      productos.map((producto) {
                        return DropdownMenuItem<int>(
                          value: producto['id_producto'],
                          child: Text(
                            producto['nombre'] ?? 'Producto sin nombre',
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                  onChanged: (int? productoId) {
                    setState(() {
                      productoSeleccionado = productos.firstWhere(
                        (producto) => producto['id_producto'] == productoId,
                      );
                    });
                  },
                ),
              ),
            ),

          // Información del producto seleccionado
          if (productoSeleccionado != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8D6E63).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info,
                    color: Color(0xFF600F40), // 🎨 PÚRPURA DE TIRO
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      productoSeleccionado!['descripcion'] ?? 'Sin descripción',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Título de la sección de procesos
  Widget _buildTituloProcesos() {
    return Row(
      children: [
        const Icon(
          Icons.list_alt,
          color: Color(0xFF600F40), // 🎨 PÚRPURA DE TIRO
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Procesos de Producción',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  /// Lista de procesos en formato de tarjetas
  Widget _buildListaProcesos() {
    return GridView.builder(
      shrinkWrap: true, // Se ajusta al contenido
      physics: const NeverScrollableScrollPhysics(), // No scrollea internamente
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas en el grid
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0, // Proporción más cuadrada
      ),
      itemCount: procesos.length,
      itemBuilder: (context, index) {
        final proceso = procesos[index];
        return _buildTarjetaProceso(proceso);
      },
    );
  }

  /// Tarjeta individual para cada proceso
  Widget _buildTarjetaProceso(ProcesoProduccion proceso) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Navegar a la pantalla de detalle del proceso
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProcesoDetalleScreen(
                    proceso: proceso,
                    producto: productoSeleccionado!,
                  ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                const Color(
                  0xFF600F40, // 🎨 PÚRPURA DE TIRO
                ).withValues(alpha: 0.08),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono del proceso
              Text(proceso.icono, style: const TextStyle(fontSize: 28)),

              const SizedBox(height: 8),

              // Nombre del proceso
              Text(
                proceso.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Descripción breve
              Text(
                proceso.descripcion,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mensaje cuando no se ha seleccionado producto
  Widget _buildMensajeSeleccionarProducto() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_upward, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Selecciona un producto arriba\npara ver los procesos disponibles',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
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
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
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
