import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/paso_model.dart';
import '../widgets/dynamic_form.dart';
import 'login_screen.dart';

class PasoFormScreen extends StatefulWidget {
  final ApiService api;
  final int productoId;
  final Map<String, dynamic> paso;
  const PasoFormScreen({super.key, required this.api, required this.productoId, required this.paso});

  @override
  State<PasoFormScreen> createState() => _PasoFormScreenState();
}

class _PasoFormScreenState extends State<PasoFormScreen> {
  @override
  Widget build(BuildContext context) {
    final p = PasoTemplate.fromMap(widget.paso);

    return Scaffold(
      appBar: AppBar(
        title: Text('Paso ${p.pasoId}: ${p.nombre}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DynamicForm(
          paso: p,
          onSubmit: (values) async {
            try {
              await widget.api.registrarPaso(1, p.pasoId, 'carlos.marquez', values);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paso registrado ✅')));
                Navigator.pop(context);
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            }
          },
        ),
      ),
    );
  }

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
        pageBuilder: (context, animation, secondaryAnimation) => 
            const LoginScreen(),
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
