from PySide6.QtCore import Qt
from PySide6.QtWidgets import QHeaderView, QMessageBox, QTableWidgetItem, QWidget

from controllers.empleado_controller import EmpleadoController
from controllers.rol_controller import RolController
from exceptions.biblioteca_exceptions import BibliotecaException
from views.ui.frm_empleado_reporte_ui import Ui_Form


class EmpleadoReporteView(QWidget, Ui_Form):
    """Ventana de consulta y reporte multinivel de personal."""

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setupUi(self)
        self._controlador_emp = EmpleadoController()
        self._controlador_rol = RolController()
        self._configurar_cabeceras()
        self._cargar_combo_roles()

        self.cbo_rol.currentIndexChanged.connect(lambda *_: self._aplicar_filtros())
        self.cbo_turno.currentIndexChanged.connect(lambda *_: self._aplicar_filtros())
        self.chk_activos.stateChanged.connect(lambda *_: self._aplicar_filtros())
        self.txt_buscar.textChanged.connect(lambda *_: self._aplicar_filtros())
        self._aplicar_filtros()

    def _configurar_cabeceras(self):
        cabecera = self.tbl_reporte.horizontalHeader()
        cabecera.setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        cabecera.setSectionResizeMode(1, QHeaderView.ResizeMode.ResizeToContents)
        cabecera.setSectionResizeMode(2, QHeaderView.ResizeMode.Stretch)
        for columna in (3, 4, 5, 6):
            cabecera.setSectionResizeMode(columna, QHeaderView.ResizeMode.ResizeToContents)

    def _cargar_combo_roles(self):
        try:
            roles = self._controlador_rol.obtener_roles()
            self.cbo_rol.blockSignals(True)
            self.cbo_rol.clear()
            self.cbo_rol.addItem("-- Todos los Roles --", 0)
            for rol in roles:
                self.cbo_rol.addItem(rol.nombre_rol, rol.id_rol)
        except BibliotecaException as error:
            QMessageBox.critical(self, "Error", f"No se pudieron cargar los roles: {error}")
        finally:
            self.cbo_rol.blockSignals(False)

    def _aplicar_filtros(self):
        try:
            rol_id = self.cbo_rol.currentData()
            if rol_id is None:
                rol_id = 0
            turno = self.cbo_turno.currentText() or "TODOS"
            solo_activos = self.chk_activos.isChecked()
            criterio = self.txt_buscar.text()
            filas = self._controlador_emp.filtrar_reporte(
                rol_id, turno, solo_activos, criterio
            )
            self._renderizar_tabla(filas)
        except BibliotecaException as error:
            print(f"Error de filtro de empleados: {error}")

    def _renderizar_tabla(self, lista):
        self.tbl_reporte.setRowCount(0)
        for fila_idx, empleado in enumerate(lista):
            self.tbl_reporte.insertRow(fila_idx)
            valores = (
                empleado["codigo_empleado"],
                empleado["numero_documento"],
                empleado["nombre_completo"],
                empleado["cargo"],
                empleado["turno"],
                empleado["rol"],
                empleado["estado"],
            )
            for columna, valor in enumerate(valores):
                item = QTableWidgetItem(str(valor if valor is not None else ""))
                item.setFlags(item.flags() & ~Qt.ItemFlag.ItemIsEditable)
                if columna in (0, 1, 4, 6):
                    item.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
                self.tbl_reporte.setItem(fila_idx, columna, item)
