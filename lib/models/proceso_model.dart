/// Modelo de datos para los procesos de producción
class ProcesoProduccion {
  final String id;
  final String nombre;
  final String descripcion;
  final String icono;
  final List<Campo> campos;

  ProcesoProduccion({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.campos,
  });
}

/// Modelo para los campos de datos de cada proceso
class Campo {
  final String nombre;
  final String tipo; // 'texto', 'numero', 'numero_con_unidad', 'fecha', 'hora'
  final String? unidad;
  final List<String>? unidadesDisponibles; // Para dropdown de unidades
  final bool requerido;
  String valor;
  String? unidadSeleccionada; // Unidad seleccionada por el usuario

  Campo({
    required this.nombre,
    required this.tipo,
    this.unidad,
    this.unidadesDisponibles,
    this.requerido = false,
    this.valor = '',
    this.unidadSeleccionada,
  });
}

/// Unidades predefinidas para diferentes tipos de medidas
class UnidadesMedida {
  static const List<String> peso = ['g', 'kg', 'mg', 'lb', 'oz'];
  static const List<String> volumen = ['ml', 'l', 'galón', 'pinta'];
  static const List<String> temperatura = ['°C', '°F', 'K'];
  static const List<String> tiempo = ['min', 'h', 'seg', 'días'];
  static const List<String> concentracion = ['ppm', 'mg/l', '%', 'mol/l'];
  static const List<String> presion = ['bar', 'psi', 'atm', 'Pa'];
  static const List<String> unidades = [
    'unidades',
    'piezas',
    'docenas',
    'cajas',
  ];
  static const List<String> porcentaje = ['%'];
  static const List<String> cantidadRecibida = ['BOTELLAS', 'LIBRAS', 'GRAMOS'];
}

/// Datos predefinidos de los 6 formularios de control de procesos
class DatosProcesos {
  static List<ProcesoProduccion> obtenerProcesos() {
    return [
      // 1. RECEPCIÓN DE FRUTAS
      ProcesoProduccion(
        id: '1',
        nombre: 'Recepción de Frutas',
        descripcion: 'Control de calidad en recepción de frutas',
        icono: 'eco_outlined',
        campos: [
          // 1. DATOS GENERALES
          Campo(nombre: 'Fecha de Recepción', tipo: 'fecha', requerido: true),
          Campo(nombre: 'Hora de Recepción', tipo: 'hora', requerido: true),
          Campo(nombre: 'Proveedor', tipo: 'texto', requerido: true),
          Campo(nombre: 'Tipo de Fruta', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Cantidad Recibida (kg)',
            tipo: 'numero',
            requerido: true,
          ),
          Campo(nombre: 'Lote del Proveedor', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Temperatura de Llegada (°C)',
            tipo: 'numero',
            requerido: true,
          ),

          // 2. CONDICIONES DE TRANSPORTE Y ENTREGA
          Campo(
            nombre: 'Vehículo Limpio y en Buen Estado',
            tipo: 'texto',
            requerido: true,
          ),
          Campo(
            nombre: 'Temperatura Controlada Durante Transporte',
            tipo: 'texto',
            requerido: true,
          ),
          Campo(
            nombre: 'Embalaje Adecuado e Íntegro',
            tipo: 'texto',
            requerido: true,
          ),
          Campo(
            nombre: 'Ausencia de Contaminación Cruzada',
            tipo: 'texto',
            requerido: true,
          ),

          // 3. INSPECCIÓN DE CALIDAD DE FRUTA
          Campo(nombre: 'Color', tipo: 'texto', requerido: true),
          Campo(nombre: 'Olor', tipo: 'texto', requerido: true),
          Campo(nombre: 'Textura', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Ausencia de Plagas o Insectos',
            tipo: 'texto',
            requerido: true,
          ),
          Campo(
            nombre: 'Presencia de Magulladuras o Daños',
            tipo: 'texto',
            requerido: true,
          ),
          Campo(nombre: 'Madurez Adecuada', tipo: 'texto', requerido: true),

          // 4. RESULTADOS DE INSPECCIÓN
          Campo(
            nombre: 'Resultado de Inspección',
            tipo: 'texto',
            requerido: true,
          ),
          Campo(
            nombre: 'Observaciones Generales',
            tipo: 'texto',
            requerido: false,
          ),

          // 5. FIRMAS
          Campo(nombre: 'Nombre del Inspector', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Nombre del Proveedor/Transportista',
            tipo: 'texto',
            requerido: true,
          ),
        ],
      ),

      // 2. CONTROL DEL MATERIAL PRIMAS
      ProcesoProduccion(
        id: '2',
        nombre: 'Control de Materias Primas',
        descripcion: 'Registro de recepción de materias primas',
        icono: 'inventory_2_outlined',
        campos: [
          Campo(nombre: 'Ingrediente', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Cantidad Recibida',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.cantidadRecibida,
            unidadSeleccionada: 'LIBRAS',
            requerido: true,
          ),
        ],
      ),

      // 3. CONTROL DE COCCIÓN
      ProcesoProduccion(
        id: '3',
        nombre: 'Control de Cocción',
        descripcion: 'Registro de parámetros de cocción',
        icono: 'whatshot_outlined',
        campos: [
          Campo(nombre: 'Producto', tipo: 'texto', requerido: true),
          Campo(nombre: 'Lote', tipo: 'texto', requerido: true),
          Campo(nombre: 'Fecha', tipo: 'fecha', requerido: true),
          Campo(nombre: 'Hora Inicio', tipo: 'hora', requerido: true),
        ],
      ),

      // 4. CONTROL DE PARÁMETROS CRÍTICOS
      ProcesoProduccion(
        id: '4',
        nombre: 'Parámetros Críticos',
        descripcion: 'Control de parámetros críticos del proceso',
        icono: 'warning_amber_outlined',
        campos: [
          Campo(nombre: 'Proceso', tipo: 'texto', requerido: true),
          Campo(nombre: 'Fecha', tipo: 'fecha', requerido: true),
          Campo(nombre: 'Hora', tipo: 'hora', requerido: true),
          Campo(
            nombre: 'Temperatura',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.temperatura,
            unidadSeleccionada: '°C',
            requerido: true,
          ),
        ],
      ),

      // 5. ALMACENAMIENTO
      ProcesoProduccion(
        id: '5',
        nombre: 'Almacenamiento',
        descripcion: 'Control de almacenamiento de productos',
        icono: 'warehouse_outlined',
        campos: [
          Campo(nombre: 'Producto', tipo: 'texto', requerido: true),
          Campo(nombre: 'Lote', tipo: 'texto', requerido: true),
          Campo(nombre: 'Fecha de Ingreso', tipo: 'fecha', requerido: true),
          Campo(
            nombre: 'Cantidad',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.unidades,
            unidadSeleccionada: 'unidades',
            requerido: true,
          ),
        ],
      ),

      // 6. MOVIMIENTOS DE INVENTARIO
      ProcesoProduccion(
        id: '6',
        nombre: 'Movimientos de Inventario',
        descripcion: 'Registro de entradas y salidas de productos',
        icono: 'local_bar_outlined',
        campos: [
          Campo(nombre: 'Fecha', tipo: 'fecha', requerido: true),
          Campo(nombre: 'Producto', tipo: 'texto', requerido: true),
          Campo(nombre: 'Sabor', tipo: 'texto', requerido: true),
          Campo(nombre: 'Cantidad', tipo: 'numero', requerido: true),
          Campo(nombre: 'Presentación', tipo: 'texto', requerido: true),
          Campo(nombre: 'Valor de Venta', tipo: 'numero', requerido: true),
        ],
      ),
    ];
  }
}
