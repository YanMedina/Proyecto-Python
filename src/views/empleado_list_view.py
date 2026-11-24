from PySide6.QtCore import Qt
from PySide6.QtWidgets import QDialog, QHeaderView, QMessageBox, QTableWidgetItem, QWidget

from controllers.empleado_controller import EmpleadoController
from exceptions.biblioteca_exceptions import BibliotecaException, ValidacionDatosError
from views.empleado_form_dialog import EmpleadoFormDialog
from views.ui.frm_empleado_list_ui import Ui_Form


class EmpleadoListView(QWidget, Ui_Form):
    """Catálogo de colaboradores con búsqueda reactiva, alta y edición."""

    def __init__(self, parent=None):
        super().__init__(parent)
        self.setupUi(self)
        self._controlador = EmpleadoController()
        self.txt_buscar.setClearButtonEnabled(True)

        self.btn_buscar.clicked.connect(self._cargar_grilla)
        self.txt_buscar.returnPressed.connect(self._cargar_grilla)
        self.txt_buscar.textChanged.connect(self._al_cambiar_texto_busqueda)
        self.btn_nuevo.clicked.connect(self._al_hacer_clic_nuevo)
        self.btn_editar.clicked.connect(self._al_hacer_clic_editar)
        self.btn_eliminar.clicked.connect(self._al_hacer_clic_eliminar)
        self.tbl_empleados.itemSelectionChanged.connect(self._al_cambiar_seleccion)

        self.btn_editar.setEnabled(False)
        self.btn_eliminar.setEnabled(False)
        self._configurar_tabla()
        self._cargar_grilla()

    def _configurar_tabla(self):
        cabecera = self.tbl_empleados.horizontalHeader()
        cabecera.setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        cabecera.setSectionResizeMode(1, QHeaderView.ResizeMode.ResizeToContents)
        cabecera.setSectionResizeMode(2, QHeaderView.ResizeMode.Stretch)
        for columna in (3, 4, 5):
            cabecera.setSectionResizeMode(columna, QHeaderView.ResizeMode.ResizeToContents)

    def _cargar_grilla(self):
        try:
            criterio = self.txt_buscar.text()
            lista = self._controlador.listar_empleados(criterio)
            self._renderizar_tabla(lista)
        except BibliotecaException as error:
            QMessageBox.critical(self, "Error", str(error))

    def _al_cambiar_texto_busqueda(self, texto: str):
        # Actualiza el filtro en cada cambio, incluso al borrar con la X.
        self._cargar_grilla()

    def _renderizar_tabla(self, lista):
        self.tbl_empleados.setRowCount(0)
        for fila_idx, emp in enumerate(lista):
            self.tbl_empleados.insertRow(fila_idx)
            item_cod = QTableWidgetItem(str(emp["codigo_empleado"]))
            item_cod.setData(99, emp["id_usuario"])
            item_cod.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
            item_dni = QTableWidgetItem(str(emp["numero_documento"]))
            item_dni.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
            item_nom = QTableWidgetItem(str(emp["nombre_completo"]))
            item_cargo = QTableWidgetItem(str(emp["cargo"]))
            item_turno = QTableWidgetItem(str(emp["turno"]))
            item_turno.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
            item_rol = QTableWidgetItem(str(emp["rol"]))
            for item in (item_cod, item_dni, item_nom, item_cargo, item_turno, item_rol):
                item.setFlags(item.flags() & ~Qt.ItemFlag.ItemIsEditable)
            for columna, item in enumerate((item_cod, item_dni, item_nom, item_cargo, item_turno, item_rol)):
                self.tbl_empleados.setItem(fila_idx, columna, item)
        self.label_conteo.setText(f"Se muestran {len(lista)} colaboradores (máximo 20)")

    def _al_cambiar_seleccion(self):
        seleccionado = bool(self.tbl_empleados.selectedItems())
        self.btn_editar.setEnabled(seleccionado)
        self.btn_eliminar.setEnabled(seleccionado)

    def _al_hacer_clic_nuevo(self):
        modal = EmpleadoFormDialog(parent=self)
        if modal.exec() == QDialog.DialogCode.Accepted:
            self._cargar_grilla()

    def _al_hacer_clic_editar(self):
        fila = self.tbl_empleados.currentRow()
        if fila < 0:
            QMessageBox.warning(self, "Selección requerida", "Selecciona un empleado para editar.")
            return
        celda_codigo = self.tbl_empleados.item(fila, 0)
        id_usuario = celda_codigo.data(99) if celda_codigo is not None else None
        if id_usuario is None:
            QMessageBox.warning(self, "Error de selección", "No se encontró el identificador del empleado.")
            return
        modal = EmpleadoFormDialog(parent=self, id_usuario_editar=id_usuario)
        if modal.exec() == QDialog.DialogCode.Accepted:
            self._cargar_grilla()

    def _al_hacer_clic_eliminar(self):
        fila = self.tbl_empleados.currentRow()
        if fila < 0:
            return
        celda_codigo = self.tbl_empleados.item(fila, 0)
        id_usuario = celda_codigo.data(99) if celda_codigo is not None else None
        nombre = self.tbl_empleados.item(fila, 2).text()
        respuesta = QMessageBox.question(
            self,
            "Confirmar Baja de Personal",
            f"¿Está seguro de dar de baja (desactivar) al colaborador:\n\n{nombre}?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No,
            QMessageBox.StandardButton.No,
        )
        if respuesta != QMessageBox.StandardButton.Yes:
            return
        try:
            self._controlador.eliminar_empleado(id_usuario, logico=True)
            QMessageBox.information(self, "Baja Confirmada", "El colaborador ha sido desactivado del sistema.")
            self._cargar_grilla()
        except ValidacionDatosError as advertencia:
            QMessageBox.warning(self, "Operación No Permitida", str(advertencia))
        except BibliotecaException as error:
            QMessageBox.critical(self, "Error de Integridad", str(error))
