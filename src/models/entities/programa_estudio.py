class ProgramaEstudio:
    """Entidad de dominio que representa un programa de estudio."""

    def __init__(
        self,
        id_programa: int = None,
        codigo_programa: str = "",
        nombre_programa: str = "",
        estado: str = "Activo",
        creado_en=None,
    ):
        self.id_programa = id_programa
        self.codigo_programa = codigo_programa
        self.nombre_programa = nombre_programa
        self.estado = estado
        self.creado_en = creado_en

    @property
    def es_activo(self) -> bool:
        """Indica si el programa se encuentra operativo."""
        return self.estado == "Activo"

    def __repr__(self) -> str:
        return (
            f"<ProgramaEstudio id={self.id_programa} "
            f"codigo='{self.codigo_programa}'>"
        )
