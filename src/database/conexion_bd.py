import mysql.connector
from mysql.connector import Error

class ConexionBD:
    """Clase helper especializada en gestionar las conexiones a MySQL."""

    _CONFIG = {
        'host': 'localhost',
        'user': 'root',
        'password': 'Medina2004', # Cambiar según las credenciales del entorno
        'database': 'bd_libros',          # Base de datos unificada oficial
        'port': 3306                      # Puerto por defecto de MySQL
    }

    @staticmethod
    def obtener_conexion():
        """Abre y devuelve una nueva conexión a la base de datos."""
        try:
            conexion = mysql.connector.connect(**ConexionBD._CONFIG)
            return conexion
        except Error as err:
            raise Exception(f"Error crítico de conexión a la Base de Datos: {err}")

    @staticmethod
    def ejecutar_sp_resultado(nombre_sp: str, parametros: list = None) -> list[dict]:
        """
        Ejecuta un Stored Procedure que devuelve un conjunto de resultados (SELECT).
        Garantiza el cierre seguro de cursores y conexiones en el bloque finally.
        """
        conexion = None
        cursor = None
        resultados = []
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor(dictionary=True)
            cursor.callproc(nombre_sp, parametros or [])

            for result in cursor.stored_results():
                resultados = result.fetchall()

            conexion.commit()
            return resultados
        except Error as err:
            if conexion and conexion.is_connected():
                conexion.rollback()
            raise Exception(f"Fallo en la ejecución del procedimiento almacenado [{nombre_sp}]: {err}")
        finally:
            if cursor:
                cursor.close()
            if conexion and conexion.is_connected():
                conexion.close()