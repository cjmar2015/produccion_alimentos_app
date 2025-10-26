import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'paso_form_screen.dart';
import 'login_screen.dart';

class PasosScreen extends StatefulWidget {
  final ApiService api;
  final Map producto;
  const PasosScreen({super.key, required this.api, required this.producto});

  @override
  State<PasosScreen> createState() => _PasosScreenState();
}

class _PasosScreenState extends State<PasosScreen> {
  late Future<List<dynamic>> pasos;
  int? idProceso;

  @override
  void initState() {
    super.initState();
    pasos = widget.api.getPasos(widget.producto['id_producto']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.producto['nombre']),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: FutureBuilder(
        future: pasos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final paso = data[i];
              return ListTile(
                title: Text('Paso ${paso['paso_id']} - ${paso['nombre']}'),
                subtitle: Text(paso['descripcion'] ?? ''),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PasoFormScreen(api: widget.api, productoId: widget.producto['id_producto'], paso: paso),
                    ),
                  );
                },
              );
            },
          );
        },
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
            '¿Estás seguro de que deseas cerrar sesión?',
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
