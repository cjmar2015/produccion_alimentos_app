import 'package:flutter/material.dart';
import '../models/proceso_model.dart';
import '../services/api_service.dart';
import 'proceso_detalle_screen.dart';
import 'recepcion_frutas_screen.dart';
import 'control_materias_screen.dart';
import 'control_coccion_screen.dart';
import 'control_parametros_screen.dart';
import 'control_almacenamiento_screen.dart';
import 'movimientos_inventario_screen.dart';
import 'login_screen.dart';

/// Pantalla principal para el control de procesos de producción
class ControlProcesosScreen extends StatefulWidget {
  final ApiService api;

  const ControlProcesosScreen({super.key, required this.api});

  @override
  State<ControlProcesosScreen> createState() => _ControlProcesosScreenState();
}

class _ControlProcesosScreenState extends State<ControlProcesosScreen> {
  // Lista de procesos predefinidos
  late List<ProcesoProduccion> procesos;

  @override
  void initState() {
    super.initState();
    // Inicializar los procesos predefinidos
    procesos = DatosProcesos.obtenerProcesos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con título y botón de cerrar sesión
      appBar: AppBar(
        title: const Text(
          'Control de Procesos',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF212121),
        elevation: 0,
        surfaceTintColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
        actions: [
          // Botón de actualizar formularios
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              // Forzar recarga del widget completo
              setState(() {
                procesos = DatosProcesos.obtenerProcesos();
              });
            },
            tooltip: 'Actualizar formularios',
          ),
          // Menú de usuario con opción de cerrar sesión
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle_outlined),
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
                        Icon(Icons.logout_outlined, color: Colors.red),
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
        color: const Color(0xFFF5F5F5),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Título de formularios de control
                  _buildTituloProcesos(),
                  const SizedBox(height: 12),
                ]),
              ),
            ),

            // Lista de procesos como SliverGrid
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
            ),
          ],
        ),
      ),
    );
  }

  /// Widget para la sección de selección de producto
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

  /// Tarjeta individual para cada proceso
  Widget _buildTarjetaProceso(ProcesoProduccion proceso) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Si es el formulario de Recepción de Frutas, usar pantalla especial con wizard
          if (proceso.id == '1') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecepcionFrutasScreen(api: widget.api),
              ),
            );
          }
          // Si es el formulario de Control de Materias Primas, usar pantalla especial con wizard
          else if (proceso.id == '2') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ControlMateriasScreen(api: widget.api),
              ),
            );
          }
          // Si es el formulario de Control de Cocción, usar pantalla especial con wizard
          else if (proceso.id == '3') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ControlCoccionScreen(api: widget.api),
              ),
            );
          }
          // Si es el formulario de Control de Parámetros Críticos, usar pantalla especial con wizard
          else if (proceso.id == '4') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ControlParametrosScreen(api: widget.api),
              ),
            );
          }
          // Si es el formulario de Control de Almacenamiento, usar pantalla especial con wizard
          else if (proceso.id == '5') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ControlAlmacenamientoScreen(api: widget.api),
              ),
            );
          }
          // Si es el formulario de Movimientos de Inventario
          else if (proceso.id == '6') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => MovimientosInventarioScreen(api: widget.api),
              ),
            );
          } else {
            // Para otros formularios, navegar directamente sin producto
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        ProcesoDetalleScreen(proceso: proceso, api: widget.api),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono del proceso (Material Design minimalista)
              Icon(
                _getIconData(proceso.icono),
                size: 36,
                color: const Color(0xFF600F40), // 🎨 PÚRPURA DE TIRO
              ),

              const SizedBox(height: 12),

              // Nombre del proceso
              Text(
                proceso.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                  letterSpacing: 0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Descripción breve
              Text(
                proceso.descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF757575),
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Convertir nombre de icono a IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'inventory_2_outlined':
        return Icons.inventory_2_outlined;
      case 'eco_outlined':
        return Icons.eco_outlined;
      case 'whatshot_outlined':
        return Icons.whatshot_outlined;
      case 'warning_amber_outlined':
        return Icons.warning_amber_outlined;
      case 'local_bar_outlined':
        return Icons.local_bar_outlined;
      case 'warehouse_outlined':
        return Icons.warehouse_outlined;
      default:
        return Icons.circle_outlined;
    }
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
