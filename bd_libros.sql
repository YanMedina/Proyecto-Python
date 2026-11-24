
DROP DATABASE IF EXISTS bd_libros;
CREATE DATABASE bd_libros CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bd_libros;

-- ==============================================================================
-- 1. MÓDULO DE SEGURIDAD Y USUARIOS (REFACTORIZADO CON 'EMPLEADOS')
-- ==============================================================================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    numero_documento VARCHAR(15) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('ESTUDIANTE', 'BIBLIOTECARIO', 'ADMINISTRADOR') NOT NULL,
    es_activo TINYINT(1) NOT NULL DEFAULT 1,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE estudiantes (
    usuario_id INT PRIMARY KEY,
    carnet VARCHAR(20) NOT NULL UNIQUE,
    programa_estudio VARCHAR(100) NOT NULL,
    tiene_sancion TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_estudiantes_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE empleados (
    usuario_id INT PRIMARY KEY,
    codigo_empleado VARCHAR(20) NOT NULL UNIQUE,
    turno VARCHAR(30) NOT NULL DEFAULT 'Mañana',
    CONSTRAINT fk_empleados_usuario FOREIGN KEY (usuario_id) 
        REFERENCES usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ==============================================================================
-- 2. MÓDULO DE CATÁLOGO E INVENTARIO BIBLIOGRÁFICO
-- ==============================================================================
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
    anio_publicacion INT NOT NULL,
    lugar_publicacion VARCHAR(100) NULL,
    numero_paginas INT NOT NULL,
    ubicacion_estante VARCHAR(50) NOT NULL,
    CONSTRAINT fk_libros_editorial FOREIGN KEY (editorial_id) 
        REFERENCES editoriales(id_editorial) ON DELETE RESTRICT ON UPDATE CASCADE
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