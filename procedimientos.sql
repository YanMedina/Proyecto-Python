-- ==============================================================================
-- 3. PROCEDIMIENTOS ALMACENADOS (SPs) - TRANSACCIONES Y CONSULTAS
-- ==============================================================================
DELIMITER //

-- SP 1: Autenticación de Usuarios (Refactorizado con Empleados)
CREATE PROCEDURE sp_autenticar_usuario(
    IN p_correo VARCHAR(100),
    IN p_clave VARCHAR(255)
)
BEGIN
    SELECT 
        u.id_usuario, u.numero_documento, u.nombre, u.correo, u.tipo_usuario, u.es_activo,
        e.carnet, e.programa_estudio, e.tiene_sancion,
        emp.codigo_empleado, emp.turno
    FROM usuarios u
    LEFT JOIN estudiantes e ON u.id_usuario = e.usuario_id
    LEFT JOIN empleados emp ON u.id_usuario = emp.usuario_id
    WHERE u.correo = p_correo AND u.clave = p_clave
    LIMIT 1;
END //

-- SP 2: Buscar o Crear Editorial
CREATE PROCEDURE sp_buscar_o_crear_editorial(
    IN p_nombre VARCHAR(100)
)
BEGIN
    DECLARE v_id INT;
    SELECT id_editorial INTO v_id FROM editoriales WHERE nombre = p_nombre LIMIT 1;
    IF v_id IS NULL THEN
        INSERT INTO editoriales (nombre) VALUES (p_nombre);
        SET v_id = LAST_INSERT_ID();
    END IF;
    SELECT v_id AS id;
END //

-- SP 3: Buscar o Crear Autor
CREATE PROCEDURE sp_buscar_o_crear_autor(
    IN p_nombre VARCHAR(100)
)
BEGIN
    DECLARE v_id INT;
    SELECT id_autor INTO v_id FROM autores WHERE nombre = p_nombre LIMIT 1;
    IF v_id IS NULL THEN
        INSERT INTO autores (nombre) VALUES (p_nombre);
        SET v_id = LAST_INSERT_ID();
    END IF;
    SELECT v_id AS id;
END //

-- SP 4: Insertar Libro Principal
CREATE PROCEDURE sp_insertar_libro(
    IN p_isbn VARCHAR(20),
    IN p_titulo VARCHAR(150),
    IN p_subtitulo VARCHAR(150),
    IN p_editorial_id INT,
    IN p_anio SMALLINT,
    IN p_lugar VARCHAR(100),
    IN p_paginas INT,
    IN p_ubicacion VARCHAR(50)
)
BEGIN
    INSERT INTO libros (
        isbn, titulo, subtitulo, editorial_id, 
        anio_publicacion, lugar_publicacion, numero_paginas, ubicacion_estante
    ) VALUES (
        p_isbn, p_titulo, p_subtitulo, p_editorial_id, 
        p_anio, p_lugar, p_paginas, p_ubicacion
    );
    SELECT LAST_INSERT_ID() AS id;
END //

-- SP 5: Vincular Libro y Autor (Tabla Intermedia)
CREATE PROCEDURE sp_vincular_libro_autor(
    IN p_libro_id INT,
    IN p_autor_id INT
)
BEGIN
    INSERT INTO libro_autor (libro_id, autor_id) 
    VALUES (p_libro_id, p_autor_id);
END //

-- SP 6: Insertar Ejemplar Físico
CREATE PROCEDURE sp_insertar_ejemplar(
    IN p_codigo VARCHAR(50),
    IN p_libro_id INT
)
BEGIN
    INSERT INTO ejemplares (codigo_patrimonial, libro_id, estado_conservacion, esta_disponible)
    VALUES (p_codigo, p_libro_id, 'Bueno', 1);
END //

DELIMITER ;

-- ==============================================================================
-- 4. DATOS SEMILLA DE PRUEBA (SEEDERS)
-- ==============================================================================
-- Usuarios
INSERT INTO usuarios (id_usuario, numero_documento, nombre, correo, clave, tipo_usuario) VALUES 
(1, '73528190', 'Carlos Mendoza', 'carlos.mendoza@instituto.edu.pe', 'clave123', 'ESTUDIANTE'),
(2, '09876543', 'Ana Torres', 'ana.torres@instituto.edu.pe', 'admin123', 'BIBLIOTECARIO'),
(3, '11223344', 'Luis Silva (IT)', 'luis.silva@instituto.edu.pe', 'super123', 'ADMINISTRADOR');

-- Subtipos
INSERT INTO estudiantes (usuario_id, carnet, programa_estudio, tiene_sancion) VALUES 
(1, 'EST-2026-01', 'Desarrollo de Sistemas', 0);

INSERT INTO empleados (usuario_id, codigo_empleado, turno) VALUES 
(2, 'EMP-100', 'Mañana'),
(3, 'EMP-999', 'Noche');

-- Catálogo de prueba
INSERT INTO editoriales (id_editorial, nombre) VALUES (1, 'Prentice Hall');
INSERT INTO autores (id_autor, nombre) VALUES (1, 'Robert C. Martin');
INSERT INTO libros (id_libro, isbn, titulo, editorial_id, anio_publicacion, numero_paginas, ubicacion_estante) 
VALUES (1, '978-0132350884', 'Clean Code', 1, 2008, 464, 'Estante A-01');
INSERT INTO libro_autor (libro_id, autor_id) VALUES (1, 1);
INSERT INTO ejemplares (libro_id, codigo_patrimonial) VALUES (1, 'EP-2026-CC01'), (1, 'EP-2026-CC02');