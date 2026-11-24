from typing import List

from database.conexion_bd import ConexionBD
from exceptions.biblioteca_exceptions import BibliotecaException
from models.entities.rol import Rol


class RolModel:
    """DAO de solo lectura para el catálogo de roles."""

    @staticmethod
    def listar() -> List[Rol]:
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor(dictionary=True)
            cursor.execute("SELECT id_rol, nombre_rol FROM roles ORDER BY nombre_rol")
            return [Rol(fila["id_rol"], fila["nombre_rol"]) for fila in cursor.fetchall()]
        except Exception as error:
            raise BibliotecaException(f"Error al consultar roles: {error}")
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()
