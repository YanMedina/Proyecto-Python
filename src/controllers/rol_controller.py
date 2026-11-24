from typing import List

from models.entities.rol import Rol
from models.rol_model import RolModel


class RolController:
    """Provee al formulario el catálogo de roles disponibles."""

    def __init__(self):
        self._modelo = RolModel()

    def obtener_roles(self) -> List[Rol]:
        return self._modelo.listar()
