from typing import List

from database.conexion_bd import ConexionBD
from exceptions.biblioteca_exceptions import BibliotecaException
from models.entities.programa_estudio import ProgramaEstudio


class ProgramaModel:
    """Capa DAO para consultar y guardar programas de estudio en MySQL."""

    @staticmethod
    def _mapear_resultados(cursor) -> List[ProgramaEstudio]:
        programas = []
        for resultado in cursor.stored_results():
            for fila in resultado.fetchall():
                programas.append(
                    ProgramaEstudio(
                        id_programa=fila["id_programa"],
                        codigo_programa=fila["codigo_programa"],
                        nombre_programa=fila["nombre_programa"],
                        estado=fila["estado"],
                        creado_en=fila["creado_en"],
                    )
                )
        return programas

    @staticmethod
    def listar_todos() -> List[ProgramaEstudio]:
        """Ejecuta sp_programas_listar y devuelve los programas registrados."""
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor(dictionary=True)
            cursor.callproc("sp_programas_listar")
            return ProgramaModel._mapear_resultados(cursor)
        except Exception as error_persistencia:
            raise BibliotecaException(
                f"Error en la capa DAO al listar programas: {error_persistencia}"
            )
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()

    @staticmethod
    def buscar_por_criterio(criterio: str) -> List[ProgramaEstudio]:
        """Busca por coincidencia parcial de código o nombre."""
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor(dictionary=True)
            cursor.callproc("sp_programas_buscar", (criterio or "",))
            return ProgramaModel._mapear_resultados(cursor)
        except Exception as error_persistencia:
            raise BibliotecaException(
                f"Error en la capa DAO al buscar programas: {error_persistencia}"
            )
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()

    @staticmethod
    def registrar(codigo: str, nombre: str) -> bool:
        """Registra un programa mediante el procedimiento almacenado."""
        conexion = cursor = None
        try:
            conexion = ConexionBD.obtener_conexion()
            cursor = conexion.cursor()
            cursor.callproc("sp_registrar_programa", (codigo, nombre))
            conexion.commit()
            return True
        except Exception as error_persistencia:
            if conexion is not None and conexion.is_connected():
                conexion.rollback()
            raise BibliotecaException(
                f"Error al registrar el programa en BD: {error_persistencia}"
            )
        finally:
            if cursor is not None:
                cursor.close()
            if conexion is not None and conexion.is_connected():
                conexion.close()
