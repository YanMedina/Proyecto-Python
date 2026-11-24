from PyQt6.QtWidgets import QDialog, QMessageBox
from PyQt6 import uic

# 1. IMPORTAMOS EL CONTROLADOR
from controllers.proveedor_controller import ProveedorController

class ProveedorFormDialog(QDialog):
    def __init__(self, parent=None, modo="NUEVO", datos_proveedor=None):
        super().__init__(parent)
        uic.loadUi("src/views/ui/frm_proveedores_dialog.ui", self)
        
        # 2. INSTANCIAMOS EL CEREBRO DE NEGOCIO
        self._proveedor_controller = ProveedorController()

        self.btn_guardar.clicked.connect(self._on_btn_guardar_click)
        self.btn_cancelar.clicked.connect(self.reject)

    def _on_btn_guardar_click(self):
        """Captura datos, valida visualmente y DELÉGA el trabajo al Controlador."""
        ruc = self.txt_ruc.text().strip()
        razon_social = self.txt_razon_social.text().strip()
        telefono = self.txt_telefono.text().strip()

        # Validación básica de UI
        if len(ruc) != 11 or not razon_social:
            QMessageBox.warning(self, "Validación", "Complete el RUC (11 dígitos) y la Razón Social.")
            return

        # 3. LLAMADA AL CONTROLADOR (El estándar MVC en acción)
        exito = self._proveedor_controller.registrar_proveedor(ruc, razon_social, telefono)

        if exito:
            QMessageBox.information(
                self, 
                "Integración MVC", 
                "El Controlador recibió los datos correctamente.\n¡La Vista está 100% terminada!"
            )
            self.accept() # Cierra el modal y notifica éxito