# 🏢 **Integración de Proveedores - AURORA**

## 📋 **Funcionalidad Implementada**

### **✅ Nuevas Características:**

#### **1. Conexión al API de Proveedores**

- **Endpoint:** `proveedores_ns = api.namespace('proveedores', description='Gestión de proveedores')`
- **Métodos implementados:**
  - `getProveedores()` - Obtener todos los proveedores
  - `crearProveedor()` - Crear nuevo proveedor
  - `buscarProveedoresPorNombre()` - Buscar por nombre comercial

#### **2. Widget ProveedorDropdown Personalizado**

- **Ubicación:** `/lib/widgets/proveedor_dropdown.dart`
- **Características:**
  - ✅ Dropdown con lista de proveedores existentes
  - ✅ Opción "Agregar Nuevo Proveedor"
  - ✅ Diálogo modal para crear proveedores
  - ✅ Validación de campos requeridos
  - ✅ Feedback visual con SnackBars
  - ✅ Auto-recarga después de agregar
  - ✅ Texto automático en MAYÚSCULAS

#### **3. Integración Automática**

- **Detección inteligente:** Cualquier campo que contenga "proveedor" en el nombre
- **Implementación:** En `proceso_detalle_screen.dart`
- **API Service:** Pasa la instancia correcta del API

---

## 🎯 **Cómo Usar la Funcionalidad**

### **Para el Usuario Final:**

#### **1. Seleccionar Proveedor Existente:**

1. Abrir formulario de proceso que contenga campo "Proveedor"
2. Hacer clic en el dropdown de proveedor
3. Seleccionar de la lista de proveedores existentes

#### **2. Agregar Nuevo Proveedor:**

1. Hacer clic en el dropdown de proveedor
2. Seleccionar "➕ Agregar Nuevo Proveedor"
3. En el diálogo modal:
   - Escribir el **Nombre Comercial** (se convierte automáticamente a MAYÚSCULAS)
   - Hacer clic en "Crear Proveedor"
4. El nuevo proveedor se agrega automáticamente a la lista
5. Se selecciona automáticamente en el formulario

---

## 🔧 **Configuración del Backend API**

### **Servidor Configurado:**

- **URL Base:** `http://168.90.15.177:5050`
- **Swagger UI:** `http://168.90.15.177:5050/swagger/`
- **Estado:** ✅ Configurado en la aplicación

### **Endpoints Requeridos:**

#### **1. Obtener Proveedores**

```http
GET http://168.90.15.177:5050/api/proveedores
```

**Respuesta esperada:**

```json
[
  {
    "id": 1,
    "nombre_comercial": "PROVEEDOR EJEMPLO S.A.S",
    "razon_social": "Proveedor Ejemplo Sociedad por Acciones Simplificada",
    "telefono": "300-123-4567",
    "email": "contacto@ejemplo.com",
    "direccion": "CALLE 123 #45-67"
  }
]
```

#### **2. Crear Proveedor**

```http
POST http://168.90.15.177:5050/api/proveedores
Content-Type: application/json
```

**Cuerpo de la petición:**

```json
{
  "nombre_comercial": "NUEVO PROVEEDOR S.A.S",
  "razon_social": "Opcional - Razón Social Completa",
  "telefono": "300-987-6543",
  "email": "nuevo@proveedor.com",
  "direccion": "NUEVA DIRECCION 789"
}
```

#### **3. Buscar Proveedores**

```http
GET http://168.90.15.177:5050/api/proveedores/buscar?nombre_comercial=TEXTO
```

**Respuesta esperada:**

```json
[
  {
    "id": 1,
    "nombre_comercial": "DISTRIBUIDORA ALIMENTOS SA"
  }
]
```

---

## 📁 **Archivos Modificados**

### **1. `/lib/services/api_service.dart`**

- ➕ `getProveedores()`
- ➕ `crearProveedor()`
- ➕ `buscarProveedoresPorNombre()`

### **2. `/lib/widgets/proveedor_dropdown.dart` (NUEVO)**

- 🆕 Widget completo para manejo de proveedores
- 🎨 Diseño moderno con Material Design 3
- ⚡ Funcionalidad completa CRUD

### **3. `/lib/screens/proceso_detalle_screen.dart`**

- ➕ Import del ProveedorDropdown
- ➕ Lógica de detección automática
- ➕ Parámetro ApiService
- 🔄 Switch mejorado en `_buildCampoInput()`

### **4. `/lib/screens/control_procesos_screen.dart`**

- 🔄 Navegación actualizada con ApiService

---

## 🎨 **Características de Diseño**

### **Dropdown Principal:**

- 🎯 **Icono:** `business_outlined`
- 🔄 **Botón refrescar:** Para recargar proveedores
- ⚡ **Loading indicator:** Durante carga de datos

### **Opción "Agregar Nuevo":**

- ➕ **Icono distintivo:** Con fondo azul claro
- 🎨 **Color corporativo:** #667EEA
- 📝 **Texto destacado:** "Agregar Nuevo Proveedor"

### **Diálogo Modal:**

- 🏢 **Icono header:** `add_business`
- 📝 **Campo obligatorio:** Nombre Comercial
- ✅ **Botones styled:** Cancelar / Crear Proveedor
- 🎯 **Validación:** Campo requerido

### **Feedback Visual:**

- ✅ **Success SnackBar:** Verde con check
- ❌ **Error SnackBar:** Rojo con mensaje
- 🔄 **Loading states:** Indicadores de progreso

---

## 🚀 **Beneficios**

### **Para el Usuario:**

- ⚡ **Rapidez:** No salir del formulario para agregar proveedores
- 🎯 **Simplicidad:** Solo necesita el nombre comercial
- 🔄 **Actualización automática:** Lista se recarga instantáneamente
- 📱 **Experiencia mobile-first:** Optimizado para dispositivos móviles

### **Para el Sistema:**

- 🏗️ **Arquitectura escalable:** Fácil agregar nuevos endpoints
- 🔌 **Integración automática:** Detecta campos por nombre
- 🛡️ **Validación robusta:** Frontend y backend
- 📊 **Consistencia de datos:** MAYÚSCULAS automáticas

---

## 🧪 **Para Probar la Funcionalidad**

1. **Compilar la app:** ✅ Ya completado
2. **Iniciar sesión:** Usar cualquier usuario (ej: `admin` / `123456`)
3. **Ir a Control de Procesos**
4. **Seleccionar un producto**
5. **Hacer clic en cualquier proceso que tenga campo "Proveedor"**
6. **Probar el dropdown de proveedores** 🎯

---

**¡La funcionalidad de proveedores está completamente integrada y lista para usar! 🎉**
