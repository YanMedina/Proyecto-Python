-- ==============================================================================
-- PROCEDIMIENTOS ALMACENADOS OFICIALES Y TRANSACCIONALES (bd_libros)
-- Arquitectura de Servicios de Base de Datos para Arquitectura MVC
-- ==============================================================================

USE bd_libros;

DELIMITER //

-- ==============================================================================
-- MÓDULO 1: SEGURIDAD, AUTENTICACIÓN Y USUARIOS
-- ==============================================================================

-- 1.1 Autenticación de Usuarios (Soporta Estudiantes y Empleados)
DROP PROCEDURE IF EXISTS sp_autenticar_usuario //
CREATE PROCEDURE sp_autenticar_usuario(
    IN p_correo VARCHAR(100),
    IN p_clave VARCHAR(255)
)
BEGIN
    SELECT 
        u.id_usuario,
        u.numero_documento,
        u.nombres,
        u.apellidos,
        u.correo,
        u.es_activo,
        r.id_rol,
        r.nombre_rol,
        -- Datos de Estudiante (Si aplica)
        e.carnet,
        prog.id_programa,
        prog.nombre_programa,
        e.tiene_sancion,
        -- Datos de Empleado (Si aplica)
        emp.codigo_empleado,
        emp.cargo,
        emp.turno
    FROM usuarios u
    JOIN roles r ON u.rol_id = r.id_rol
    LEFT JOIN estudiantes e ON u.id_usuario = e.usuario_id
    LEFT JOIN programas_estudio prog ON e.programa_id = prog.id_programa
    LEFT JOIN empleados emp ON u.id_usuario = emp.usuario_id
    WHERE u.correo = p_correo AND u.clave = p_clave AND u.es_activo = 1
    LIMIT 1;
END //

-- 1.2 Registrar Estudiante (Proceso Transaccional ACID)
DROP PROCEDURE IF EXISTS sp_registrar_estudiante //
CREATE PROCEDURE sp_registrar_estudiante(
    IN p_documento VARCHAR(15),
    IN p_nombres VARCHAR(80),
    IN p_apellidos VARCHAR(80),
    IN p_correo VARCHAR(100),
    IN p_clave VARCHAR(255),
    IN p_carnet VARCHAR(20),
    IN p_programa_id INT,
    IN p_semestre VARCHAR(10)
)
BEGIN
    DECLARE v_usuario_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Step 1: Insertar en la Tabla Padre (usuarios con rol_id = 4 Estudiante)
        INSERT INTO usuarios (numero_documento, nombres, apellidos, correo, clave, rol_id)
        VALUES (p_documento, p_nombres, p_apellidos, p_correo, p_clave, 4);
        
        SET v_usuario_id = LAST_INSERT_ID();

        -- Step 2: Insertar en la Tabla Hija (estudiantes)
        INSERT INTO estudiantes (usuario_id, carnet, programa_id, semestre)
        VALUES (v_usuario_id, p_carnet, p_programa_id, p_semestre);
    COMMIT;

    SELECT v_usuario_id AS id_usuario_registrado;
END //

-- 1.3 Registrar Empleado / Personal (Proceso Transaccional ACID)
DROP PROCEDURE IF EXISTS sp_registrar_empleado //
CREATE PROCEDURE sp_registrar_empleado(
    IN p_documento VARCHAR(15),
    IN p_nombres VARCHAR(80),
    IN p_apellidos VARCHAR(80),
    IN p_correo VARCHAR(100),
    IN p_clave VARCHAR(255),
    IN p_rol_id INT,
    IN p_codigo_empleado VARCHAR(20),
    IN p_cargo VARCHAR(80),
    IN p_turno VARCHAR(30)
)
BEGIN
    DECLARE v_usuario_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Step 1: Insertar en Tabla Padre (usuarios)
        INSERT INTO usuarios (numero_documento, nombres, apellidos, correo, clave, rol_id)
        VALUES (p_documento, p_nombres, p_apellidos, p_correo, p_clave, p_rol_id);
        
        SET v_usuario_id = LAST_INSERT_ID();

        -- Step 2: Insertar en Tabla Hija (empleados)
        INSERT INTO empleados (usuario_id, codigo_empleado, cargo, turno)
        VALUES (v_usuario_id, p_codigo_empleado, p_cargo, p_turno);
    COMMIT;

    SELECT v_usuario_id AS id_usuario_registrado;
END //

-- ==============================================================================
-- MÓDULO 2: CATÁLOGO Y GESTIÓN BIBLIOGRÁFICA
-- ==============================================================================

-- 2.1 Buscar o Crear Editorial
DROP PROCEDURE IF EXISTS sp_buscar_o_crear_editorial //
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

-- 2.2 Insertar Libro (Incluye vinculación 1:N obligatoria a Programa de Estudio)
DROP PROCEDURE IF EXISTS sp_insertar_libro //
CREATE PROCEDURE sp_insertar_libro(
    IN p_isbn VARCHAR(20),
    IN p_titulo VARCHAR(150),
    IN p_subtitulo VARCHAR(150),
    IN p_editorial_id INT,
    IN p_programa_id INT, -- Requerido por la regla 1:N
    IN p_anio INT,
    IN p_lugar VARCHAR(100),
    IN p_paginas INT,
    IN p_ubicacion VARCHAR(50)
)
BEGIN
    INSERT INTO libros (
        isbn, titulo, subtitulo, editorial_id, programa_id,
        anio_publicacion, lugar_publicacion, numero_paginas, ubicacion_estante
    ) VALUES (
        p_isbn, p_titulo, p_subtitulo, p_editorial_id, p_programa_id,
        p_anio, p_lugar, p_paginas, p_ubicacion
    );
    SELECT LAST_INSERT_ID() AS id;
END //

-- 2.3 Búsqueda Temática de Libros por Programa de Estudio (Server-Side)
DROP PROCEDURE IF EXISTS sp_buscar_libros_por_programa //
CREATE PROCEDURE sp_buscar_libros_por_programa(
    IN p_criterio VARCHAR(150),
    IN p_programa_id INT
)
BEGIN
    SET @pattern = CONCAT('%', p_criterio, '%');
    
    SELECT 
        l.id_libro,
        l.isbn, 
        l.titulo, 
        ed.nombre AS editorial, 
        p.nombre_programa,
        l.ubicacion_estante,
        (
            SELECT COUNT(*) 
            FROM ejemplares ej 
            WHERE ej.libro_id = l.id_libro AND ej.esta_disponible = 1
        ) AS stock_disponible
    FROM libros l
    JOIN editoriales ed ON l.editorial_id = ed.id_editorial
    JOIN programas_estudio p ON l.programa_id = p.id_programa
    WHERE (p_programa_id IS NULL OR l.programa_id = p_programa_id)
      AND (l.titulo LIKE @pattern OR l.isbn LIKE @pattern OR ed.nombre LIKE @pattern)
    LIMIT 20;
END //

-- 2.4 Insertar Ejemplar Físico
DROP PROCEDURE IF EXISTS sp_insertar_ejemplar //
CREATE PROCEDURE sp_insertar_ejemplar(
    IN p_codigo VARCHAR(50),
    IN p_libro_id INT,
    IN p_estado_conservacion VARCHAR(30)
)
BEGIN
    INSERT INTO ejemplares (codigo_patrimonial, libro_id, estado_conservacion, esta_disponible)
    VALUES (p_codigo, p_libro_id, IFNULL(p_estado_conservacion, 'Bueno'), 1);
END //

-- ==============================================================================
-- MÓDULO 3: RECURSOS TECNOLÓGICOS (COMPUTADORAS Y SESIONES DE 120 MIN)
-- ==============================================================================

-- 3.1 Obtener Estado del Tablero de PCs para el Dashboard del Bibliotecario
DROP PROCEDURE IF EXISTS sp_equipos_listar_dashboard //
CREATE PROCEDURE sp_equipos_listar_dashboard()
BEGIN
    SELECT 
        id_equipo,
        codigo_patrimonial,
        nombre_pc,
        tipo_equipo,
        estado,
        ip_address
    FROM equipos
    ORDER BY tipo_equipo ASC, nombre_pc ASC;
END //

-- 3.2 Iniciar Sesión de Cómputo para Estudiante (Asigna 120 minutos)
DROP PROCEDURE IF EXISTS sp_iniciar_sesion_pc //
CREATE PROCEDURE sp_iniciar_sesion_pc(
    IN p_equipo_id INT,
    IN p_usuario_id INT,
    IN p_minutos INT
)
BEGIN
    DECLARE v_estado VARCHAR(20);
    DECLARE v_minutos_final INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SET v_minutos_final = IFNULL(p_minutos, 120);

    START TRANSACTION;
        -- Verificar disponibilidad del equipo
        SELECT estado INTO v_estado FROM equipos WHERE id_equipo = p_equipo_id FOR UPDATE;

        IF v_estado != 'LIBRE' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El equipo no se encuentra disponible (LIBRE).';
        END IF;

        -- Cambiar estado del equipo a OCUPADO
        UPDATE equipos SET estado = 'OCUPADO' WHERE id_equipo = p_equipo_id;

        -- Registrar el inicio de la sesión
        INSERT INTO sesiones_pc (equipo_id, usuario_id, minutos_asignados, fecha_fin_estimada, estado)
        VALUES (
            p_equipo_id, 
            p_usuario_id, 
            v_minutos_final, 
            DATE_ADD(NOW(), INTERVAL v_minutos_final MINUTE), 
            'ACTIVA'
        );
    COMMIT;

    SELECT LAST_INSERT_ID() AS id_sesion;
END //

-- 3.3 Finalizar Sesión de Cómputo (Libera la PC)
DROP PROCEDURE IF EXISTS sp_finalizar_sesion_pc //
CREATE PROCEDURE sp_finalizar_sesion_pc(
    IN p_sesion_id INT
)
BEGIN
    DECLARE v_equipo_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        SELECT equipo_id INTO v_equipo_id FROM sesiones_pc WHERE id_sesion = p_sesion_id FOR UPDATE;

        -- Actualizar estado de la sesión
        UPDATE sesiones_pc 
        SET fecha_fin_real = NOW(), estado = 'FINALIZADA' 
        WHERE id_sesion = p_sesion_id;

        -- Liberar el equipo
        UPDATE equipos SET estado = 'LIBRE' WHERE id_equipo = v_equipo_id;
    COMMIT;
END //

-- ==============================================================================
-- MÓDULO 4: PRE-PRÉSTAMOS Y COLA DE ATENCIÓN EN TIEMPO REAL
-- ==============================================================================

-- 4.1 Registrar Solicitud de Pre-préstamo (Desde PC de Búsqueda)
DROP PROCEDURE IF EXISTS sp_crear_preprestamo //
CREATE PROCEDURE sp_crear_preprestamo(
    IN p_usuario_id INT,
    IN p_libro_id INT,
    IN p_observacion VARCHAR(200)
)
BEGIN
    INSERT INTO preprestamos (usuario_id, libro_id, observacion, estado)
    VALUES (p_usuario_id, p_libro_id, p_observacion, 'PENDIENTE');
    
    SELECT LAST_INSERT_ID() AS id_preprestamo;
END //

-- 4.2 Listar Cola de Pre-préstamos Pendientes (Para el Dashboard del Bibliotecario)
DROP PROCEDURE IF EXISTS sp_listar_preprestamos_pendientes //
CREATE PROCEDURE sp_listar_preprestamos_pendientes()
BEGIN
    SELECT 
        pr.id_preprestamo,
        pr.fecha_solicitud,
        CONCAT(u.apellidos, ', ', u.nombres) AS estudiante_nombre,
        u.numero_documento AS dni,
        e.carnet,
        l.titulo AS libro_titulo,
        l.ubicacion_estante,
        pr.observacion
    FROM preprestamos pr
    JOIN usuarios u ON pr.usuario_id = u.id_usuario
    JOIN estudiantes e ON u.id_usuario = e.usuario_id
    JOIN libros l ON pr.libro_id = l.id_libro
    WHERE pr.estado = 'PENDIENTE'
    ORDER BY pr.fecha_solicitud ASC;
END //

-- ==============================================================================
-- MÓDULO 5: PRÉSTAMOS EN SALA (SOPORTA 1 LIBRO Y/O 1 COMPUTADORA A LA VEZ)
-- ==============================================================================

-- 5.1 Registrar Préstamo Completo (Cabecera y Detalle Polimórfico)
DROP PROCEDURE IF EXISTS sp_registrar_prestamo_completo //
CREATE PROCEDURE sp_registrar_prestamo_completo(
    IN p_usuario_id INT,
    IN p_empleado_id INT,
    IN p_tipo_prestamo VARCHAR(20),
    IN p_ejemplar_id INT, -- Opcional (NULL si solo es PC)
    IN p_equipo_id INT    -- Opcional (NULL si solo es Libro)
)
BEGIN
    DECLARE v_prestamo_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Validar que al menos se envíe un recurso
    IF p_ejemplar_id IS NULL AND p_equipo_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe especificar al menos un recurso (Libro o PC) para realizar el préstamo.';
    END IF;

    START TRANSACTION;
        -- Step 1: Insertar Cabecera del Préstamo (Devolución esperada en 2 horas si es SALA)
        INSERT INTO prestamos (
            usuario_id, empleado_id, tipo_prestamo, 
            fecha_dev_esperada, estado
        ) VALUES (
            p_usuario_id, p_empleado_id, IFNULL(p_tipo_prestamo, 'SALA'),
            DATE_ADD(NOW(), INTERVAL 2 HOUR), 'ACTIVO'
        );

        SET v_prestamo_id = LAST_INSERT_ID();

        -- Step 2: Procesar Ejemplar de Libro (Si aplica)
        IF p_ejemplar_id IS NOT NULL THEN
            INSERT INTO prestamo_detalles (prestamo_id, tipo_recurso, ejemplar_id, estado_recurso)
            VALUES (v_prestamo_id, 'LIBRO', p_ejemplar_id, 'PRESTADO');

            -- Marcar ejemplar como no disponible
            UPDATE ejemplares SET esta_disponible = 0 WHERE id_ejemplar = p_ejemplar_id;
        END IF;

        -- Step 3: Procesar Equipo de Cómputo (Si aplica)
        IF p_equipo_id IS NOT NULL THEN
            INSERT INTO prestamo_detalles (prestamo_id, tipo_recurso, equipo_id, estado_recurso)
            VALUES (v_prestamo_id, 'COMPUTADORA', p_equipo_id, 'PRESTADO');

            -- Marcar equipo como ocupado
            UPDATE equipos SET estado = 'OCUPADO' WHERE id_equipo = p_equipo_id;
        END IF;

    COMMIT;

    SELECT v_prestamo_id AS id_prestamo_generado;
END //
-- ==============================================================================
-- MÓDULO 6: los nuevos
-- ==============================================================================

-- SP: Listar Programas Activos
DROP PROCEDURE IF EXISTS sp_programas_listar_activos //
CREATE PROCEDURE sp_programas_listar_activos()
BEGIN
    SELECT id_programa, codigo_programa, nombre_programa, estado
    FROM programas_estudio
    WHERE estado = 'Activo'
    ORDER BY nombre_programa ASC;
END //
-- SP: Guardar / Actualizar Programa
DROP PROCEDURE IF EXISTS sp_programas_guardar //
CREATE PROCEDURE sp_programas_guardar(
    IN p_id_programa INT,
    IN p_codigo VARCHAR(10),
    IN p_nombre VARCHAR(120)
)
BEGIN
    IF p_id_programa IS NULL OR p_id_programa = 0 THEN
        INSERT INTO programas_estudio (codigo_programa, nombre_programa) 
        VALUES (p_codigo, p_nombre);
    ELSE
        UPDATE programas_estudio 
        SET codigo_programa = p_codigo, nombre_programa = p_nombre 
        WHERE id_programa = p_id_programa;
    END IF;
END //
-- SP: Listar Top 20 Estudiantes
DROP PROCEDURE IF EXISTS sp_estudiantes_listar_top20 //
CREATE PROCEDURE sp_estudiantes_listar_top20()
BEGIN
    SELECT 
        u.id_usuario, u.numero_documento, u.nombres, u.apellidos, u.correo, u.es_activo,
        e.carnet, prog.id_programa, prog.nombre_programa, e.semestre, e.tiene_sancion
    FROM estudiantes e
    JOIN usuarios u ON e.usuario_id = u.id_usuario
    JOIN programas_estudio prog ON e.programa_id = prog.id_programa
    ORDER BY u.creado_en DESC
    LIMIT 20;
END //



DELIMITER ;