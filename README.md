# 🍯 App de Producción de Alimentos v2.3

Una aplicación Flutter completa para la gestión de procesos de producción de alimentos artesanales, especializada en conservas y dulces.

## ✨ Características Principales

### 🎨 Diseño Personalizado

- **Paleta de colores púrpura** (#600F40, #87556B, #B07992, #D4B0C4)
- **Typography profesional** con Google Fonts:
  - Montserrat Medium para "HECHO A MANO"
  - Playfair Display Bold para "AURORA"
- **Logo personalizado** integrado en splash y login
- **Interfaz responsiva** adaptada a diferentes tamaños de pantalla

### 📱 Funcionalidades Core

- **Login seguro** con validación de credenciales
- **Splash screen** con branding consistente
- **Control de procesos** para gestión de conservas y dulces
- **Gestión de pasos** por producto con formularios dinámicos
- **Dropdowns de unidades** implementados en 10 procesos
- **Navegación fluida** con animaciones personalizadas

### 🔧 Mejoras Técnicas

- **Overflow corregido** en home screen con layout optimizado
- **SingleChildScrollView** para scroll seguro
- **Grid responsivo** con altura fija para evitar problemas de layout
- **Hot reload funcional** para desarrollo ágil
- **APK optimizado** (50MB) con tree-shaking de iconos

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   ├── paso_model.dart      # Modelo de datos para pasos
│   └── proceso_model.dart   # Modelo de datos para procesos
├── screens/
│   ├── splash_screen.dart   # Pantalla de carga con branding
│   ├── login_screen.dart    # Autenticación de usuario
│   ├── home_screen.dart     # Pantalla principal (OVERFLOW FIXED)
│   ├── control_procesos_screen.dart  # Gestión de procesos
│   ├── pasos_screen.dart    # Lista de pasos por producto
│   └── paso_form_screen.dart # Formulario de creación/edición
├── services/
│   └── api_service.dart     # Servicio de comunicación con API
├── widgets/
│   └── dynamic_form.dart    # Formularios dinámicos reutilizables
└── assets/
    └── images/
        └── logo.png         # Logo personalizado
```

## 🚀 Instalación y Uso

### Prerrequisitos

- Flutter 3.29.3 o superior
- Dart SDK
- Android Studio / Xcode (para simuladores)

### Configuración

```bash
# Clonar el repositorio
git clone [URL_DEL_REPOSITORIO]
cd produccion_alimentos_app

# Instalar dependencias
flutter pub get

# Ejecutar en simulador
flutter run

# Generar APK
flutter build apk --release
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.2 # Comunicación con API
  google_fonts: ^6.2.1 # Typography personalizada

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0 # Análisis de código
```

## 🎯 Versiones y Changelog

### v2.3 - Overflow Fix & Responsive Design (Actual)

- ✅ **OVERFLOW CORREGIDO**: Grid con altura fija (250px)
- ✅ **Layout responsivo**: Adaptación automática a pantallas
- ✅ **Simulador funcional**: Restaurada compatibilidad iOS
- ✅ **APK optimizado**: 50MB con mejoras de rendimiento

### v2.0 - Typography & Branding

- ✅ **Google Fonts**: Montserrat + Playfair Display
- ✅ **Logo personalizado**: Integración completa
- ✅ **Colores púrpura**: Paleta corporativa implementada

### v1.9 - Dropdowns & Core Features

- ✅ **Dropdowns de unidades**: 10 procesos implementados
- ✅ **Gestión de pasos**: CRUD completo
- ✅ **Control de procesos**: Funcionalidad base

## 🛠️ Desarrollo

### Comandos Útiles

```bash
# Hot reload durante desarrollo
r

# Hot restart completo
R

# Análisis de código
flutter analyze

# Ejecutar tests
flutter test

# Construir para producción
flutter build apk --release --build-name="[VERSION]" --build-number=[NUMBER]
```

### Estructura de Commits

- 🎉 Nuevas características
- 🔧 Correcciones técnicas
- 🎨 Mejoras de diseño
- 📱 Optimizaciones móviles
- 🚀 Despliegues y releases

## 📝 Notas de Desarrollo

- **Overflow Issue**: Resuelto con `SizedBox(height: 250)` en GridView
- **Responsive Design**: Implementado con MediaQuery para adaptación
- **Performance**: Tree-shaking activado, reducción de iconos a 4.9KB
- **Hot Reload**: Funcional en simulador iOS y Android

## 👨‍💻 Autor

**Carlos Márquez**

- Email: carlos.marquez@email.com
- Proyecto: App de Producción de Alimentos Artesanales

---

_Desarrollado con ❤️ usando Flutter 3.29.3_
