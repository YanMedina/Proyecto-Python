from PySide6.QtWidgets import QDialog, QLineEdit, QMessageBox

from controllers.auth_controller import AuthController
from exceptions.biblioteca_exceptions import BibliotecaException, ValidacionDatosError
from views.ui.frm_login_ui import Ui_Form


class LoginDialog(QDialog, Ui_Form):
    """Diálogo de inicio de sesión basado en la interfaz generada por PySide6."""

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setupUi(self)
        self._controlador_autenticacion = AuthController()
        self.txt_password.setEchoMode(QLineEdit.EchoMode.Password)
        self.btn_ingresar.clicked.connect(self._al_hacer_clic_ingresar)

    def _al_hacer_clic_ingresar(self):
        usuario = self.txt_usuario.text()
        clave = self.txt_password.text()
        try:
            self._controlador_autenticacion.iniciar_sesion(usuario, clave)
            self.accept()
        except ValidacionDatosError as advertencia:
            QMessageBox.warning(self, "Acceso Denegado", str(advertencia))
            self.txt_password.clear()
            self.txt_password.setFocus()
        except BibliotecaException as error_sistema:
            QMessageBox.critical(self, "Error de Sistema", str(error_sistema))
