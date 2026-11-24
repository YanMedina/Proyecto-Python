from typing import List

from exceptions.biblioteca_exceptions import BibliotecaException, ValidacionDatosError
from models.entities.programa_estudio import ProgramaEstudio
from models.programa_model import ProgramaModel


class ProgramaController:
    """Valida las solicitudes y coordina el módulo de programas."""

    def __init__(self):
        self._modelo_programa = ProgramaModel()

    def obtener_todos(self) -> List[ProgramaEstudio]:
        """Obtiene la lista completa de programas registrados."""
        try:
            return self._modelo_programa.listar_todos()
        except BibliotecaException:
            raise
        except Exception as error:
            raise BibliotecaException(f"Falla inesperada al listar programas: {error}")

    def listar_programas(self) -> List[ProgramaEstudio]:
        """Alias conservado para la vista actual."""
        return self.obtener_todos()

    def buscar_programas(self, criterio_ingresado: str) -> List[ProgramaEstudio]:
        """Busca programas por parte del código o del nombre."""
        criterio = (criterio_ingresado or "").strip()
        try:
            return self._modelo_programa.buscar_por_criterio(criterio)
        except BibliotecaException:
            raise
        except Exception as error:
            raise BibliotecaException(f"Falla inesperada al buscar programas: {error}")

    def registrar_programa(self, codigo_input: str, nombre_input: str) -> bool:
        codigo = (codigo_input or "").strip().upper()
        nombre = (nombre_input or "").strip().upper()

        if len(codigo) < 3:
            raise ValidacionDatosError(
                "El código del programa debe tener al menos 3 caracteres."
            )
        if not nombre:
            raise ValidacionDatosError("El nombre del programa es obligatorio.")

        return self._modelo_programa.registrar(codigo, nombre)
