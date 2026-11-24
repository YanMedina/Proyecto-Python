from PySide6.QtWidgets import QDialog, QMessageBox

from controllers.programa_controller import ProgramaController
from exceptions.biblioteca_exceptions import BibliotecaException, ValidacionDatosError
from views.ui.frm_programa_dialog_ui import Ui_frm_programa_dialog


class ProgramaFormDialog(QDialog, Ui_frm_programa_dialog):
    """Diálogo para registrar un programa de estudio."""

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setupUi(self)
        self._controller = ProgramaController()
        self.btn_guardar.clicked.connect(self._on_btn_guardar_click)
        self.btn_cancelar.clicked.connect(self.reject)

    def _on_btn_guardar_click(self):
        codigo = self.txt_codigo.text()
        nombre = self.txt_nombre.text()
        try:
            self._controller.registrar_programa(codigo, nombre)
            QMessageBox.information(self, "Éxito", "Programa registrado correctamente.")
            self.accept()
        except ValidacionDatosError as error:
            QMessageBox.warning(self, "Atención", str(error))
            self.txt_codigo.setFocus()
        except BibliotecaException as error:
            QMessageBox.critical(self, "Error Interno", str(error))
