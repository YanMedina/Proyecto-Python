USE bd_libros;

-- ==============================================================================
-- PROCEDIMIENTO ALMACENADO OFICIAL DE AUTENTICACIÓN (Sesión 19)
-- Recupera la fila completa del usuario activo para validación BCrypt en Python
-- ==============================================================================
DROP PROCEDURE IF EXISTS sp_obtener_usuario_por_username;

DELIMITER $$
CREATE PROCEDURE sp_obtener_usuario_por_username(
    IN p_username VARCHAR(100)
)
BEGIN
    SELECT 
        u.id_usuario,
        u.username,
        u.password_hash,
        CONCAT(u.nombres, ' ', u.apellidos) AS nombre_completo,
        r.nombre_rol AS rol,
        u.es_activo
    FROM usuarios u
    INNER JOIN roles r ON u.rol_id = r.id_rol
    WHERE u.username = p_username 
      AND u.es_activo = 1
    LIMIT 1;
END$$
DELIMITER ;