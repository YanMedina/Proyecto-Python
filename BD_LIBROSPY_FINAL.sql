-- ==============================================================================
-- SISTEMA DE GESTIÓN DE BIBLIOTECA Y RECURSOS TECNOLÓGICOS (bd_libros)
-- Arquitectura de Base de Datos Normalizada en 3NF (Versión Final Oficial)
-- ==============================================================================

DROP DATABASE IF EXISTS bd_libros;
CREATE DATABASE bd_libros CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bd_libros;

-- ==============================================================================
-- 1. MÓDULO DE ORGANIZACIÓN, CARRERAS Y SEGURIDAD
-- ==============================================================================

-- 1.1 Catálogo Maestro: Programas de Estudio (Carreras)
CREATE TABLE programas_estudio (
    id_programa INT AUTO_INCREMENT PRIMARY KEY,
    codigo_programa VARCHAR(10) NOT NULL UNIQUE,   -- Ej: 'DSI', 'RSI', 'DDS'
    nombre_programa VARCHAR(120) NOT NULL UNIQUE,  -- Ej: 'Desarrollo de Sistemas de Información'
    estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 1.2 Catálogo Maestro: Roles del Sistema
CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150) NULL
) ENGINE=InnoDB;

-- 1.3 Tabla Padre: Usuarios (Supertipo - Autenticación y Datos Biográficos)
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    numero_documento VARCHAR(15) NOT NULL UNIQUE,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    es_activo TINYINT(1) NOT NULL DEFAULT 1,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) 
        REFERENCES roles(id_rol) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 1.4 Subtipo: Estudiantes (Especialización de Usuario)
CREATE TABLE estudiantes (
    usuario_id INT PRIMARY KEY,
    carnet VARCHAR(20) NOT NULL UNIQUE,
    programa_id INT NOT NULL,
    semestre VARCHAR(10) NOT NULL DEFAULT 'I',
    tiene_sancion TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_estudiantes_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_estudiantes_programa FOREIGN KEY (programa_id) 
        REFERENCES programas_estudio(id_programa) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 1.5 Subtipo: Empleados / Personal (Especialización de Usuario)
CREATE TABLE empleados (
    usuario_id INT PRIMARY KEY,
    codigo_empleado VARCHAR(20) NOT NULL UNIQUE,
    cargo VARCHAR(80) NOT NULL,
    turno VARCHAR(30) NOT NULL DEFAULT 'Mañana',
    CONSTRAINT fk_empleados_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- 2. MÓDULO DE CATÁLOGOS Y MATERIAL BIBLIOGRÁFICO
-- ==============================================================================

-- 2.1 Editoriales
CREATE TABLE editoriales (
    id_editorial INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 2.2 Autores
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    nacionalidad VARCHAR(100) NOT NULL DEFAULT 'Desconocida'
) ENGINE=InnoDB;

-- 2.3 Entidad Principal: Libros (Con Vinculación 1:N Estricta a Programa de Estudio)
CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    subtitulo VARCHAR(150) NULL,
    editorial_id INT NOT NULL,
    programa_id INT NOT NULL, -- Un libro pertenece obligatoriamente a UN Programa de Estudio
    anio_publicacion INT NOT NULL,
    lugar_publicacion VARCHAR(100) NULL,
    numero_paginas INT NOT NULL,
    ubicacion_estante VARCHAR(50) NOT NULL,
    CONSTRAINT fk_libros_editorial FOREIGN KEY (editorial_id) 
        REFERENCES editoriales(id_editorial) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_libros_programa FOREIGN KEY (programa_id) 
        REFERENCES programas_estudio(id_programa) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 2.4 Tabla Intermedia: Libro - Autor (Relación N:M)
CREATE TABLE libro_autor (
    id_libro_autor INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    autor_id INT NOT NULL,
    orden_autor INT NOT NULL DEFAULT 1,
    rol_autor VARCHAR(50) NOT NULL DEFAULT 'Autor Principal',
    CONSTRAINT fk_la_libro FOREIGN KEY (libro_id) 
        REFERENCES libros(id_libro) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_la_autor FOREIGN KEY (autor_id) 
        REFERENCES autores(id_autor) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uk_libro_autor UNIQUE (libro_id, autor_id)
) ENGINE=InnoDB;

-- 2.5 Ejemplares Físicos
CREATE TABLE ejemplares (
    id_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    codigo_patrimonial VARCHAR(50) NOT NULL UNIQUE,
    estado_conservacion VARCHAR(30) NOT NULL DEFAULT 'Bueno',
    esta_disponible TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_ejemplar_libro FOREIGN KEY (libro_id) 
        REFERENCES libros(id_libro) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 2.6 Capítulos e Índices del Libro (Para Búsqueda Temática)
CREATE TABLE indices_libro (
    id_indice INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    numero_capitulo INT NOT NULL,
    titulo_capitulo VARCHAR(200) NOT NULL,
    pagina_inicio INT NOT NULL,
    CONSTRAINT fk_indice_libro FOREIGN KEY (libro_id) 
        REFERENCES libros(id_libro) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- 3. MÓDULO DE RECURSOS TECNOLÓGICOS (COMPUTADORAS Y SESIONES)
-- ==============================================================================

-- 3.1 Inventario de PCs de la Biblioteca
CREATE TABLE equipos (
    id_equipo INT AUTO_INCREMENT PRIMARY KEY,
    codigo_patrimonial VARCHAR(50) NOT NULL UNIQUE,
    nombre_pc VARCHAR(50) NOT NULL UNIQUE, -- Ej: PC-BUSQUEDA-01, PC-TRABAJO-05
    tipo_equipo ENUM('BUSQUEDA', 'TRABAJO') NOT NULL DEFAULT 'TRABAJO',
    estado ENUM('LIBRE', 'OCUPADO', 'BLOQUEADO', 'MANTENIMIENTO') NOT NULL DEFAULT 'LIBRE',
    ip_address VARCHAR(45) NULL,
    observaciones VARCHAR(200) NULL
) ENGINE=InnoDB;

-- 3.2 Control de Sesiones de Cómputo (Tiempo máximo: 120 min)
CREATE TABLE sesiones_pc (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    equipo_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    minutos_asignados INT NOT NULL DEFAULT 120,
    fecha_fin_estimada DATETIME NOT NULL,
    fecha_fin_real DATETIME NULL,
    estado ENUM('ACTIVA', 'FINALIZADA', 'EXPIRADA', 'CANCELADA') NOT NULL DEFAULT 'ACTIVA',
    CONSTRAINT fk_sesiones_equipo FOREIGN KEY (equipo_id) 
        REFERENCES equipos(id_equipo) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sesiones_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- 4. MÓDULO TRANSACCIONAL: PRE-PRÉSTAMOS, PRÉSTAMOS Y DETALLES
-- ==============================================================================

-- 4.1 Solicitudes de Pre-préstamo (Generadas desde PCs de Búsqueda)
CREATE TABLE preprestamos (
    id_preprestamo INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    libro_id INT NOT NULL,
    fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('PENDIENTE', 'ATENDIDO', 'RECHAZADO', 'CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
    observacion VARCHAR(200) NULL,
    CONSTRAINT fk_preprestamo_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_preprestamo_libro FOREIGN KEY (libro_id) 
        REFERENCES libros(id_libro) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4.2 Cabecera del Préstamo (Atendido por el Bibliotecario)
CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,          -- FK 1: Lector (Estudiante / Docente que recibe)
    empleado_id INT NOT NULL,         -- FK 2: Bibliotecario que aprueba y autoriza
    tipo_prestamo ENUM('SALA', 'DOMICILIO') NOT NULL DEFAULT 'SALA',
    fecha_prestamo DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_dev_esperada DATETIME NOT NULL,
    fecha_dev_real DATETIME NULL,
    estado ENUM('ACTIVO', 'DEVUELTO', 'VENCIDO') NOT NULL DEFAULT 'ACTIVO',
    observaciones VARCHAR(250) NULL,
    CONSTRAINT fk_prestamos_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_prestamos_empleado FOREIGN KEY (empleado_id) 
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4.3 Detalle del Préstamo (Polimorfismo: Máx 1 Libro + 1 PC a la vez)
CREATE TABLE prestamo_detalles (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    prestamo_id INT NOT NULL,
    tipo_recurso ENUM('LIBRO', 'COMPUTADORA') NOT NULL,
    ejemplar_id INT NULL,             -- Requerido si tipo_recurso = 'LIBRO'
    equipo_id INT NULL,               -- Requerido si tipo_recurso = 'COMPUTADORA'
    estado_recurso ENUM('PRESTADO', 'DEVUELTO', 'CON_OBSERVACION') NOT NULL DEFAULT 'PRESTADO',
    CONSTRAINT fk_detalle_prestamo FOREIGN KEY (prestamo_id) 
        REFERENCES prestamos(id_prestamo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_ejemplar FOREIGN KEY (ejemplar_id) 
        REFERENCES ejemplares(id_ejemplar) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_equipo FOREIGN KEY (equipo_id) 
        REFERENCES equipos(id_equipo) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- 5. MÓDULO DE SANCIONES Y MULTAS
-- ==============================================================================

CREATE TABLE sanciones (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    prestamo_id INT NULL,
    motivo VARCHAR(200) NOT NULL,
    dias_sancion INT NOT NULL DEFAULT 1,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('ACTIVA', 'CUMPLIDA', 'CANCELADA') NOT NULL DEFAULT 'ACTIVA',
    CONSTRAINT fk_sancion_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sancion_prestamo FOREIGN KEY (prestamo_id) 
        REFERENCES prestamos(id_prestamo) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- 6. DATOS SEMILLA PARA PRUEBAS Y DESARROLLO (SEEDERS)
-- ==============================================================================

-- Roles de Usuario
INSERT INTO roles (id_rol, nombre_rol, descripcion) VALUES 
(1, 'Administrador', 'Acceso total y configuración global del sistema'),
(2, 'Bibliotecario', 'Atención de préstamos, control de sala y monitoreo de PCs'),
(3, 'Docente', 'Usuario lector docente'),
(4, 'Estudiante', 'Usuario lector estudiante');

-- Programas de Estudio (Carreras)
INSERT INTO programas_estudio (id_programa, codigo_programa, nombre_programa) VALUES
(1, 'DSI', 'Desarrollo de Sistemas de Información'),
(2, 'RSI', 'Redes y Seguridad Informática'),
(3, 'DDS', 'Diseño y Desarrollo de Software');

-- Usuarios Base
INSERT INTO usuarios (id_usuario, numero_documento, nombres, apellidos, correo, clave, rol_id) VALUES 
(1, '73528190', 'Carlos', 'Mendoza Pérez', 'carlos.mendoza@instituto.edu.pe', 'clave123', 4),
(2, '09876543', 'Ana', 'Torres López', 'ana.torres@instituto.edu.pe', 'admin123', 2),
(3, '11223344', 'Luis', 'Silva Ruiz', 'luis.silva@instituto.edu.pe', 'super123', 1);

-- Subtipos Especializados
INSERT INTO estudiantes (usuario_id, carnet, programa_id, semestre) VALUES 
(1, 'EST-2026-01', 1, 'V');

INSERT INTO empleados (usuario_id, codigo_empleado, cargo, turno) VALUES 
(2, 'EMP-100', 'Bibliotecario Principal', 'Mañana'),
(3, 'EMP-999', 'Administrador de TI', 'Completo');

-- Inventario de Computadoras
INSERT INTO equipos (codigo_patrimonial, nombre_pc, tipo_equipo, estado) VALUES
('PAT-PC-001', 'PC-BUSQUEDA-01', 'BUSQUEDA', 'LIBRE'),
('PAT-PC-002', 'PC-BUSQUEDA-02', 'BUSQUEDA', 'LIBRE'),
('PAT-PC-010', 'PC-TRABAJO-01', 'TRABAJO', 'LIBRE'),
('PAT-PC-011', 'PC-TRABAJO-02', 'TRABAJO', 'OCUPADO'),
('PAT-PC-012', 'PC-TRABAJO-03', 'TRABAJO', 'BLOQUEADO');

-- Catálogo Bibliográfico Semilla
INSERT INTO editoriales (id_editorial, nombre) VALUES (1, 'Prentice Hall');
INSERT INTO autores (id_autor, nombre) VALUES (1, 'Robert C. Martin');

-- Libro vinculado a Programa de Estudio #1 (DSI)
INSERT INTO libros (id_libro, isbn, titulo, subtitulo, editorial_id, programa_id, anio_publicacion, numero_paginas, ubicacion_estante) 
VALUES (1, '978-0132350884', 'Clean Code', 'A Handbook of Agile Software Craftsmanship', 1, 1, 2008, 464, 'Estante A-01');

INSERT INTO libro_autor (libro_id, autor_id) VALUES (1, 1);

INSERT INTO ejemplares (libro_id, codigo_patrimonial, esta_disponible) VALUES 
(1, 'EP-2026-CC01', 1), 
(1, 'EP-2026-CC02', 1);

INSERT INTO indices_libro (libro_id, numero_capitulo, titulo_capitulo, pagina_inicio) VALUES
(1, 1, 'Clean Code', 1),
(1, 2, 'Meaningful Names', 17),
(1, 3, 'Functions', 31),
(1, 9, 'Unit Tests', 121);