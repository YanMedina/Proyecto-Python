class BibliotecaException(Exception):
    """Excepción base para los errores de la aplicación de biblioteca."""
    pass

class CredencialesInvalidasError(BibliotecaException):
    """Se dispara cuando el correo o contraseña son incorrectos."""
    def __init__(self, mensaje: str = "Correo o contraseña de acceso incorrectos."):
        super().__init__(mensaje)

class UsuarioInactivoError(BibliotecaException):
    """Se dispara cuando una cuenta de usuario ha sido desactivada."""
    def __init__(self, mensaje: str = "Su cuenta se encuentra inhabilitada en el sistema."):
        super().__init__(mensaje)

class ValidacionDatosError(BibliotecaException):
    """Se dispara cuando los datos ingresados no cumplen el formato o rango requerido."""
    pass

class LibroYaExisteError(BibliotecaException):
    """Se dispara cuando se intenta registrar un ISBN que ya existe en la BD."""
    pass
