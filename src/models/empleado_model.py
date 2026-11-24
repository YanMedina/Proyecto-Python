from typing import Any, Dict, List, Optional

from database.conexion_bd import ConexionBD
from exceptions.biblioteca_exceptions import BibliotecaException
from models.entities.empleado import Empleado


class EmpleadoModel:
    """Capa DAO: acceso persistente a los datos de empleados."""

    @staticmethod
    def registrar(empleado: Empleado) -> int:
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor()
            parametros = (
                empleado.numero_documento,
                empleado.nombres,
                empleado.apellidos,
                empleado.nombre_usuario,
                empleado.clave_hash,
                empleado.rol_id,
                empleado.codigo_empleado,
                empleado.cargo,
                empleado.turno,
                0,
            )
            resultado = cursor.callproc("sp_empleado_registrar", parametros)
            return resultado[9]
        except Exception as error:
            if conexion is not None and conexion.is_connected():
                conexion.rollback()
            raise BibliotecaException(f"Error transaccional al registrar empleado: {error}")
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()

    @staticmethod
    def obtener_por_id(id_usuario: int) -> Optional[Dict[str, Any]]:
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor(dictionary=True)
            cursor.callproc("sp_empleado_obtener_por_id", (id_usuario,))
            for resultado in cursor.stored_results():
                return resultado.fetchone()
            return None
        except Exception as error:
            raise BibliotecaException(f"Error al consultar colaborador por ID: {error}")
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()

    @staticmethod
    def actualizar(empleado: Empleado) -> bool:
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor()
            parametros = (
                empleado.id_usuario,
                empleado.numero_documento,
                empleado.nombres,
                empleado.apellidos,
                empleado.nombre_usuario,
                empleado.clave_hash or "",
                empleado.rol_id,
                empleado.codigo_empleado,
                empleado.cargo,
                empleado.turno,
            )
            cursor.callproc("sp_empleado_actualizar", parametros)
            return True
        except Exception as error:
            if conexion is not None and conexion.is_connected():
                conexion.rollback()
            raise BibliotecaException(f"Falla transaccional al actualizar: {error}")
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()

    @staticmethod
    def eliminar(id_usuario: int, logico: bool = True) -> bool:
        """Desactiva la cuenta o elimina físicamente al colaborador."""
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor()
            if logico:
                cursor.callproc("sp_empleado_eliminar_logico", (id_usuario,))
            else:
                cursor.callproc("sp_empleado_eliminar_fisico", (id_usuario,))
            conexion.commit()
            return True
        except Exception as error:
            if conexion is not None and conexion.is_connected():
                conexion.rollback()
            texto = str(error)
            if "1451" in texto or "foreign key" in texto.lower():
                raise BibliotecaException(
                    "No se puede eliminar físicamente porque el empleado tiene "
                    "operaciones históricas vinculadas. Utiliza la baja lógica."
                )
            raise BibliotecaException(f"Error al eliminar colaborador: {error}")
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()

    @staticmethod
    def filtrar_multinivel(
        rol_id: int, turno: str, solo_activos: int, criterio: str
    ) -> List[Dict[str, Any]]:
        """Filtra los empleados en MySQL por rol, turno, estado y texto."""
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor(dictionary=True)
            parametros = (rol_id, turno, solo_activos, criterio)
            cursor.callproc("sp_empleados_filtrar_multinivel", parametros)
            for resultado in cursor.stored_results():
                return resultado.fetchall()
            return []
        except Exception as error:
            raise BibliotecaException(f"Error en filtro multinivel: {error}")
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()

    @staticmethod
    def listar(criterio: str = "") -> List[Dict[str, Any]]:
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor(dictionary=True)
            cursor.callproc("sp_empleados_listar", (criterio or "",))
            for resultado in cursor.stored_results():
                return resultado.fetchall()
            return []
        except Exception as error:
            raise BibliotecaException(f"Error al listar empleados: {error}")
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()
