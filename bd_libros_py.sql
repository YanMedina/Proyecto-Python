-- ==============================================================================
-- SISTEMA DE GESTIÓN DE BIBLIOTECA (bd_libros)
-- Base de Datos Completa Normalizada (Versión Oficial de Arquitectura)
-- ==============================================================================

DROP DATABASE IF EXISTS bd_libros;
CREATE DATABASE bd_libros CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bd_libros;

-- 1. Catálogo Maestro: Roles del Sistema
CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150) NULL
) ENGINE=InnoDB;

-- 2. Tabla Padre: Usuarios (Supertipo)
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    numero_documento VARCHAR(15) NOT NULL UNIQUE,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,      -- Identificador de acceso / Correo
    password_hash VARCHAR(255) NOT NULL,       -- Hash BCrypt de 60 caracteres
    rol_id INT NOT NULL,
    es_activo TINYINT(1) NOT NULL DEFAULT 1,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (rol_id) 
        REFERENCES roles(id_rol) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Catálogo Maestro: Programas de Estudio
CREATE TABLE programas_estudio (
    id_programa INT AUTO_INCREMENT PRIMARY KEY,
    codigo_programa VARCHAR(10) NOT NULL UNIQUE,
    nombre_programa VARCHAR(120) NOT NULL UNIQUE,
    estado ENUM('Activo', 'Inactivo') NOT NULL DEFAULT 'Activo',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 4. Subtipo: Estudiantes (Hereda de Usuarios)
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

-- 5. Subtipo: Empleados / Personal (Hereda de Usuarios)
CREATE TABLE empleados (
    usuario_id INT PRIMARY KEY,
    codigo_empleado VARCHAR(20) NOT NULL UNIQUE,
    cargo VARCHAR(80) NOT NULL,
    turno VARCHAR(30) NOT NULL DEFAULT 'Mañana',
    CONSTRAINT fk_empleados_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Catálogos Bibliográficos
CREATE TABLE editoriales (
    id_editorial INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    nacionalidad VARCHAR(100) NOT NULL DEFAULT 'Desconocida'
) ENGINE=InnoDB;

CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    subtitulo VARCHAR(150) NULL,
    editorial_id INT NOT NULL,
    programa_id INT NOT NULL,
    anio_publicacion INT NOT NULL,
    lugar_publicacion VARCHAR(100) NULL,
    numero_paginas INT NOT NULL,
    ubicacion_estante VARCHAR(50) NOT NULL,
    CONSTRAINT fk_libros_editorial FOREIGN KEY (editorial_id) 
        REFERENCES editoriales(id_editorial) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_libros_programa FOREIGN KEY (programa_id) 
        REFERENCES programas_estudio(id_programa) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

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

CREATE TABLE ejemplares (
    id_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT NOT NULL,
    codigo_patrimonial VARCHAR(50) NOT NULL UNIQUE,
    estado_conservacion VARCHAR(30) NOT NULL DEFAULT 'Bueno',
    esta_disponible TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_ejemplar_libro FOREIGN KEY (libro_id) 
        REFERENCES libros(id_libro) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. Recursos Tecnológicos (Inventario de PCs)
CREATE TABLE equipos (
    id_equipo INT AUTO_INCREMENT PRIMARY KEY,
    codigo_patrimonial VARCHAR(50) NOT NULL UNIQUE,
    nombre_pc VARCHAR(50) NOT NULL UNIQUE,
    tipo_equipo ENUM('BUSQUEDA', 'TRABAJO') NOT NULL DEFAULT 'TRABAJO',
    estado ENUM('LIBRE', 'OCUPADO', 'BLOQUEADO', 'MANTENIMIENTO') NOT NULL DEFAULT 'LIBRE',
    ip_address VARCHAR(45) NULL,
    observaciones VARCHAR(200) NULL
) ENGINE=InnoDB;

-- 8. Módulo Transaccional de Préstamos
CREATE TABLE prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    empleado_id INT NOT NULL,
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

CREATE TABLE prestamo_detalles (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    prestamo_id INT NOT NULL,
    tipo_recurso ENUM('LIBRO', 'COMPUTADORA') NOT NULL,
    ejemplar_id INT NULL,
    equipo_id INT NULL,
    estado_recurso ENUM('PRESTADO', 'DEVUELTO', 'CON_OBSERVACION') NOT NULL DEFAULT 'PRESTADO',
    CONSTRAINT fk_detalle_prestamo FOREIGN KEY (prestamo_id) 
        REFERENCES prestamos(id_prestamo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_ejemplar FOREIGN KEY (ejemplar_id) 
        REFERENCES ejemplares(id_ejemplar) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_equipo FOREIGN KEY (equipo_id) 
        REFERENCES equipos(id_equipo) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- 9. DATOS SEMILLA PARA PRUEBAS (SEED DATA)
-- Hash BCrypt para clave 'admin123': $2b$12$e8UvVpWvI.7rY9xPZq82.OJq9Yv1hXm58.Y9Zp7W2Q0v18.M9x8.
-- ==============================================================================
INSERT INTO roles (id_rol, nombre_rol, descripcion) VALUES 
(1, 'Administrador', 'Acceso total y configuración del sistema'),
(2, 'Bibliotecario', 'Atención de préstamos y control de sala'),
(3, 'Estudiante', 'Usuario lector estudiante');

INSERT INTO programas_estudio (id_programa, codigo_programa, nombre_programa, estado) VALUES
(1, 'DSI', 'Desarrollo de Sistemas de Información', 'Activo'),
(2, 'RSI', 'Redes y Seguridad Informática', 'Activo'),
(3, 'DDS', 'Diseño y Desarrollo de Software', 'Activo');

-- Inserción en Supertipo (Usuarios base)
INSERT INTO usuarios (id_usuario, numero_documento, nombres, apellidos, username, password_hash, rol_id, es_activo) VALUES 
(1, '11223344', 'Luis', 'Silva Ruiz', 'admin@sistema.com', '$2b$12$e8UvVpWvI.7rY9xPZq82.OJq9Yv1hXm58.Y9Zp7W2Q0v18.M9x8.', 1, 1),
(2, '09876543', 'Ana', 'Torres López', 'ana.torres@sistema.com', '$2b$12$e8UvVpWvI.7rY9xPZq82.OJq9Yv1hXm58.Y9Zp7W2Q0v18.M9x8.', 2, 1),
(3, '73528190', 'Carlos', 'Mendoza Pérez', 'carlos.mendoza@sistema.com', '$2b$12$e8UvVpWvI.7rY9xPZq82.OJq9Yv1hXm58.Y9Zp7W2Q0v18.M9x8.', 3, 1);

-- Inserción en Subtipos (Herencia relacional para pruebas)
INSERT INTO empleados (usuario_id, codigo_empleado, cargo, turno) VALUES 
(1, 'EMP-001', 'Administrador General', 'Completo'),
(2, 'EMP-100', 'Bibliotecaria Encargada', 'Mañana');

INSERT INTO estudiantes (usuario_id, carnet, programa_id, semestre) VALUES 
(3, 'EST-2026-01', 1, 'V');

COMMIT;