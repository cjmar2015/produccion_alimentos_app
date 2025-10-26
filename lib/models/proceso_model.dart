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
}

/// Datos predefinidos de los 10 procesos de producción
class DatosProcesos {
  static List<ProcesoProduccion> obtenerProcesos() {
    return [
      ProcesoProduccion(
        id: '1',
        nombre: 'Materias Primas e Insumos',
        descripcion: 'Control de ingredientes para conservas y mermeladas',
        icono: '🍓',
        campos: [
          Campo(nombre: 'Ingrediente', tipo: 'texto', requerido: true),
          Campo(nombre: 'Proveedor', tipo: 'texto'),
          Campo(
            nombre: 'Cantidad Recibida',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.peso,
            unidadSeleccionada: 'kg',
            requerido: true,
          ),
          Campo(nombre: 'Fecha de Recepción', tipo: 'fecha', requerido: true),
          Campo(nombre: 'Fecha de Vencimiento', tipo: 'fecha'),
          Campo(nombre: 'Estado', tipo: 'texto'),
        ],
      ),
      ProcesoProduccion(
        id: '2',
        nombre: 'Preparación de Utensilios',
        descripcion: 'Esterilización de frascos y equipos',
        icono: '🫙',
        campos: [
          Campo(nombre: 'Tipo de Utensilio', tipo: 'texto', requerido: true),
          Campo(nombre: 'Método de Limpieza', tipo: 'texto'),
          Campo(
            nombre: 'Tiempo de Esterilización',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.tiempo,
            unidadSeleccionada: 'min',
            requerido: true,
          ),
          Campo(
            nombre: 'Temperatura',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.temperatura,
            unidadSeleccionada: '°C',
          ),
          Campo(nombre: 'Responsable', tipo: 'texto'),
        ],
      ),
      ProcesoProduccion(
        id: '3',
        nombre: 'Limpieza y Sanitización',
        descripcion: 'Limpieza de áreas de trabajo y equipos',
        icono: '�',
        campos: [
          Campo(nombre: 'Área/Equipo', tipo: 'texto', requerido: true),
          Campo(nombre: 'Producto Utilizado', tipo: 'texto'),
          Campo(
            nombre: 'Concentración',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.concentracion,
            unidadSeleccionada: 'ppm',
          ),
          Campo(nombre: 'Hora Inicio', tipo: 'hora', requerido: true),
          Campo(nombre: 'Hora Fin', tipo: 'hora', requerido: true),
          Campo(nombre: 'Verificado por', tipo: 'texto'),
        ],
      ),
      ProcesoProduccion(
        id: '4',
        nombre: 'Cocción y Temperatura',
        descripcion: 'Control térmico en mermeladas y conservas',
        icono: '🍯',
        campos: [
          Campo(nombre: 'Punto de Control', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Temperatura Objetivo',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.temperatura,
            unidadSeleccionada: '°C',
          ),
          Campo(
            nombre: 'Temperatura Real',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.temperatura,
            unidadSeleccionada: '°C',
            requerido: true,
          ),
          Campo(nombre: 'Hora de Medición', tipo: 'hora', requerido: true),
          Campo(
            nombre: 'Desviación',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.temperatura,
            unidadSeleccionada: '°C',
          ),
          Campo(nombre: 'Acción Correctiva', tipo: 'texto'),
        ],
      ),
      ProcesoProduccion(
        id: '5',
        nombre: 'Control de Peso',
        descripcion: 'Verificación de pesos en productos terminados',
        icono: '🍬',
        campos: [
          Campo(nombre: 'Producto', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Peso Objetivo',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.peso,
            unidadSeleccionada: 'g',
          ),
          Campo(
            nombre: 'Peso Real',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.peso,
            unidadSeleccionada: 'g',
            requerido: true,
          ),
          Campo(
            nombre: 'Tolerancia',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.porcentaje,
            unidadSeleccionada: '%',
          ),
          Campo(nombre: 'Lote', tipo: 'texto'),
          Campo(nombre: 'Operador', tipo: 'texto'),
        ],
      ),
      ProcesoProduccion(
        id: '6',
        nombre: 'Control de Acidez y pH',
        descripcion: 'Medición de acidez en mermeladas y conservas',
        icono: '🍋',
        campos: [
          Campo(nombre: 'Muestra', tipo: 'texto', requerido: true),
          Campo(nombre: 'pH Objetivo', tipo: 'numero'),
          Campo(nombre: 'pH Medido', tipo: 'numero', requerido: true),
          Campo(nombre: 'Hora de Medición', tipo: 'hora'),
          Campo(nombre: 'Ajuste Realizado', tipo: 'texto'),
          Campo(nombre: 'pH Final', tipo: 'numero'),
        ],
      ),
      ProcesoProduccion(
        id: '7',
        nombre: 'Envasado en Frascos',
        descripcion: 'Llenado de frascos para conservas y mermeladas',
        icono: '🍯',
        campos: [
          Campo(nombre: 'Tipo de Envase', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Volumen',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.volumen,
            unidadSeleccionada: 'ml',
          ),
          Campo(nombre: 'Lote de Producción', tipo: 'texto', requerido: true),
          Campo(nombre: 'Fecha de Envasado', tipo: 'fecha', requerido: true),
          Campo(
            nombre: 'Cantidad Envasada',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.unidades,
            unidadSeleccionada: 'unidades',
          ),
          Campo(nombre: 'Operador', tipo: 'texto'),
        ],
      ),
      ProcesoProduccion(
        id: '8',
        nombre: 'Etiquetado de Productos',
        descripcion: 'Aplicación de etiquetas en conservas y dulces',
        icono: '🏺',
        campos: [
          Campo(nombre: 'Tipo de Etiqueta', tipo: 'texto', requerido: true),
          Campo(nombre: 'Código de Lote', tipo: 'texto', requerido: true),
          Campo(nombre: 'Fecha de Vencimiento', tipo: 'fecha', requerido: true),
          Campo(
            nombre: 'Cantidad Etiquetada',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.unidades,
            unidadSeleccionada: 'unidades',
          ),
          Campo(nombre: 'Verificación Visual', tipo: 'texto'),
          Campo(nombre: 'Responsable', tipo: 'texto'),
        ],
      ),
      ProcesoProduccion(
        id: '9',
        nombre: 'Control de Calidad',
        descripcion: 'Inspección de conservas, dulces y mermeladas',
        icono: '🧑‍🍳',
        campos: [
          Campo(nombre: 'Lote Inspeccionado', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Muestra Analizada',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.unidades,
            unidadSeleccionada: 'unidades',
          ),
          Campo(nombre: 'Defectos Encontrados', tipo: 'numero'),
          Campo(nombre: 'Resultado', tipo: 'texto', requerido: true),
          Campo(nombre: 'Inspector', tipo: 'texto'),
          Campo(nombre: 'Observaciones', tipo: 'texto'),
        ],
      ),
      ProcesoProduccion(
        id: '10',
        nombre: 'Almacenamiento',
        descripcion: 'Almacenaje de productos terminados',
        icono: '🍪',
        campos: [
          Campo(nombre: 'Área de Almacén', tipo: 'texto', requerido: true),
          Campo(
            nombre: 'Temperatura',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.temperatura,
            unidadSeleccionada: '°C',
          ),
          Campo(
            nombre: 'Humedad',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.porcentaje,
            unidadSeleccionada: '%',
          ),
          Campo(nombre: 'Fecha de Ingreso', tipo: 'fecha', requerido: true),
          Campo(
            nombre: 'Cantidad Almacenada',
            tipo: 'numero_con_unidad',
            unidadesDisponibles: UnidadesMedida.unidades,
            unidadSeleccionada: 'unidades',
          ),
          Campo(nombre: 'Responsable', tipo: 'texto'),
        ],
      ),
    ];
  }
}
