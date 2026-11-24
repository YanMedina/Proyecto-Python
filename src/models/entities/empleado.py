class Empleado:
    """Entidad de dominio para los datos de una persona empleada."""

    def __init__(
        self,
        id_usuario=None,
        numero_documento="",
        nombres="",
        apellidos="",
        nombre_usuario="",
        clave_hash="",
        rol_id=None,
        codigo_empleado="",
        cargo="",
        turno="",
    ):
        self.id_usuario = id_usuario
        self.numero_documento = numero_documento
        self.nombres = nombres
        self.apellidos = apellidos
        self.nombre_usuario = nombre_usuario
        self.clave_hash = clave_hash
        self.rol_id = rol_id
        self.codigo_empleado = codigo_empleado
        self.cargo = cargo
        self.turno = turno

    def __repr__(self) -> str:
        return (
            f"<Empleado id={self.id_usuario} codigo='{self.codigo_empleado}' "
            f"nombre='{self.nombres} {self.apellidos}'>"
        )
