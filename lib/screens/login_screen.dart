import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // 🔐 Usuarios y contraseñas predefinidos
  final Map<String, Map<String, dynamic>> _validUsers = {
    'ADMIN': {
      'password': '123456',
      'role': 'Administrador',
      'name': 'Administrador del Sistema',
    },
    'OPERADOR': {
      'password': 'produccion2024',
      'role': 'Operador',
      'name': 'Operador de Producción',
    },
    'SUPERVISOR': {
      'password': 'alimentos123',
      'role': 'Supervisor',
      'name': 'Supervisor de Calidad',
    },
    'CARLOS.MARQUEZ': {
      'password': 'carlos123',
      'role': 'Gerente',
      'name': 'Carlos Márquez',
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simular tiempo de autenticación
    await Future.delayed(const Duration(seconds: 1));

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Validar credenciales
    if (_validUsers.containsKey(username) &&
        _validUsers[username]!['password'] == password) {
      final userInfo = _validUsers[username]!;

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Mostrar mensaje de bienvenida
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Bienvenido ${userInfo['name']}! - ${userInfo['role']}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navegar a la pantalla principal
        final api = ApiService("http://168.90.15.177:5050");
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    HomeScreen(api: api),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    } else {
      // Credenciales incorrectas
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Usuario o contraseña incorrectos'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );

        // Limpiar campos
        _passwordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF600F40), // 🎨 PÚRPURA DE TIRO
              Color(0xFF87556B), // 💜 HEXO BÍBLIA
              Color(0xFFB07992), // 🌸 VIOLETA CLARO
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo y título
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/logo.png', // 🖼️ TU IMAGEN PERSONALIZADA
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              // Si la imagen no se encuentra, muestra el ícono por defecto
                              return const Icon(
                                Icons.restaurant_menu,
                                size: 80,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      Text(
                        'HECHO A MANO',
                        style: GoogleFonts.montserrat(
                          fontSize: 18, // Aumentado de 18 a 24
                          fontWeight: FontWeight.w500, // Medium weight
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ), // Reducido drásticamente para que sea muy visible

                      Text(
                        'AURORA',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 62, // Aumentado de 28 a 32
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'TIBASOSA, BOYACÁ',
                        style: GoogleFonts.montserrat(
                          fontSize: 18, // Reducido de 18 a 14
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w300, // Light weight
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Formulario de login
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Campo de usuario
                              TextFormField(
                                controller: _usernameController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                  labelText: 'Usuario',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(
                                        0xFF600F40,
                                      ), // 🎨 PÚRPURA DE TIRO
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu usuario';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Campo de contraseña
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(
                                        0xFF600F40,
                                      ), // 🎨 PÚRPURA DE TIRO
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu contraseña';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),

                              // Botón de login
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF600F40,
                                    ), // 🎨 PÚRPURA DE TIRO
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 3,
                                  ),
                                  child:
                                      _isLoading
                                          ? const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text('Verificando...'),
                                            ],
                                          )
                                          : const Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Texto de "olvidé mi contraseña"
                              TextButton(
                                onPressed: () {
                                  _showUsersDialog();
                                },
                                child: Text(
                                  '👥 Ver usuarios de prueba',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF600F40, // 🎨 PÚRPURA DE TIRO
                                    ).withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Información adicional
                      Text(
                        'v1.0.0 • Desarrollado con Flutter',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUsersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '👥 Usuarios de Prueba',
            style: TextStyle(
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Toca cualquier usuario para auto-completar:',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ..._validUsers.entries.map((entry) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(
                          0xFF600F40,
                        ), // 🎨 PÚRPURA DE TIRO
                        child: Text(
                          entry.key[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contraseña: ${entry.value['password']}'),
                          Text(
                            '${entry.value['role']} - ${entry.value['name']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _usernameController.text = entry.key;
                        _passwordController.text = entry.value['password'];
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
