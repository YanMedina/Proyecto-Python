# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'frm_empleado_reporte.ui'
##
## Created by: Qt User Interface Compiler version 6.12.0
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QBrush, QColor, QConicalGradient, QCursor,
    QFont, QFontDatabase, QGradient, QIcon,
    QImage, QKeySequence, QLinearGradient, QPainter,
    QPalette, QPixmap, QRadialGradient, QTransform)
from PySide6.QtWidgets import (QAbstractItemView, QApplication, QCheckBox, QComboBox,
    QHBoxLayout, QHeaderView, QLabel, QLineEdit,
    QSizePolicy, QTableWidget, QTableWidgetItem, QVBoxLayout,
    QWidget)

class Ui_Form(object):
    def setupUi(self, Form):
        if not Form.objectName():
            Form.setObjectName(u"Form")
        Form.resize(1040, 650)
        self.verticalLayout = QVBoxLayout(Form)
        self.verticalLayout.setSpacing(12)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.verticalLayout.setContentsMargins(16, 16, 16, 16)
        self.layout_filtros = QHBoxLayout()
        self.layout_filtros.setObjectName(u"layout_filtros")
        self.lbl_rol = QLabel(Form)
        self.lbl_rol.setObjectName(u"lbl_rol")

        self.layout_filtros.addWidget(self.lbl_rol)

        self.cbo_rol = QComboBox(Form)
        self.cbo_rol.setObjectName(u"cbo_rol")

        self.layout_filtros.addWidget(self.cbo_rol)

        self.lbl_turno = QLabel(Form)
        self.lbl_turno.setObjectName(u"lbl_turno")

        self.layout_filtros.addWidget(self.lbl_turno)

        self.cbo_turno = QComboBox(Form)
        self.cbo_turno.addItem("")
        self.cbo_turno.addItem("")
        self.cbo_turno.addItem("")
        self.cbo_turno.addItem("")
        self.cbo_turno.setObjectName(u"cbo_turno")

        self.layout_filtros.addWidget(self.cbo_turno)

        self.chk_activos = QCheckBox(Form)
        self.chk_activos.setObjectName(u"chk_activos")

        self.layout_filtros.addWidget(self.chk_activos)

        self.txt_buscar = QLineEdit(Form)
        self.txt_buscar.setObjectName(u"txt_buscar")

        self.layout_filtros.addWidget(self.txt_buscar)


        self.verticalLayout.addLayout(self.layout_filtros)

        self.tbl_reporte = QTableWidget(Form)
        if (self.tbl_reporte.columnCount() < 7):
            self.tbl_reporte.setColumnCount(7)
        __qtablewidgetitem = QTableWidgetItem()
        self.tbl_reporte.setHorizontalHeaderItem(0, __qtablewidgetitem)
        __qtablewidgetitem1 = QTableWidgetItem()
        self.tbl_reporte.setHorizontalHeaderItem(1, __qtablewidgetitem1)
        __qtablewidgetitem2 = QTableWidgetItem()
        self.tbl_reporte.setHorizontalHeaderItem(2, __qtablewidgetitem2)
        __qtablewidgetitem3 = QTableWidgetItem()
        self.tbl_reporte.setHorizontalHeaderItem(3, __qtablewidgetitem3)
        __qtablewidgetitem4 = QTableWidgetItem()
        self.tbl_reporte.setHorizontalHeaderItem(4, __qtablewidgetitem4)
        __qtablewidgetitem5 = QTableWidgetItem()
        self.tbl_reporte.setHorizontalHeaderItem(5, __qtablewidgetitem5)
        __qtablewidgetitem6 = QTableWidgetItem()
        self.tbl_reporte.setHorizontalHeaderItem(6, __qtablewidgetitem6)
        self.tbl_reporte.setObjectName(u"tbl_reporte")
        self.tbl_reporte.setEditTriggers(QAbstractItemView.EditTrigger.NoEditTriggers)
        self.tbl_reporte.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        self.tbl_reporte.setColumnCount(7)

        self.verticalLayout.addWidget(self.tbl_reporte)


        self.retranslateUi(Form)

        QMetaObject.connectSlotsByName(Form)
    # setupUi

    def retranslateUi(self, Form):
        Form.setWindowTitle(QCoreApplication.translate("Form", u"Consulta de Personal", None))
        self.lbl_rol.setText(QCoreApplication.translate("Form", u"Rol:", None))
        self.lbl_turno.setText(QCoreApplication.translate("Form", u"Turno:", None))
        self.cbo_turno.setItemText(0, QCoreApplication.translate("Form", u"TODOS", None))
        self.cbo_turno.setItemText(1, QCoreApplication.translate("Form", u"Ma\u00f1ana", None))
        self.cbo_turno.setItemText(2, QCoreApplication.translate("Form", u"Tarde", None))
        self.cbo_turno.setItemText(3, QCoreApplication.translate("Form", u"Noche", None))

        self.chk_activos.setText(QCoreApplication.translate("Form", u"Mostrar solo personal activo", None))
        self.txt_buscar.setPlaceholderText(QCoreApplication.translate("Form", u"Buscar por DNI o Apellidos...", None))
        ___qtablewidgetitem = self.tbl_reporte.horizontalHeaderItem(0)
        ___qtablewidgetitem.setText(QCoreApplication.translate("Form", u"C\u00f3digo", None))
        ___qtablewidgetitem1 = self.tbl_reporte.horizontalHeaderItem(1)
        ___qtablewidgetitem1.setText(QCoreApplication.translate("Form", u"DNI", None))
        ___qtablewidgetitem2 = self.tbl_reporte.horizontalHeaderItem(2)
        ___qtablewidgetitem2.setText(QCoreApplication.translate("Form", u"Apellidos y Nombres", None))
        ___qtablewidgetitem3 = self.tbl_reporte.horizontalHeaderItem(3)
        ___qtablewidgetitem3.setText(QCoreApplication.translate("Form", u"Cargo", None))
        ___qtablewidgetitem4 = self.tbl_reporte.horizontalHeaderItem(4)
        ___qtablewidgetitem4.setText(QCoreApplication.translate("Form", u"Turno", None))
        ___qtablewidgetitem5 = self.tbl_reporte.horizontalHeaderItem(5)
        ___qtablewidgetitem5.setText(QCoreApplication.translate("Form", u"Rol", None))
        ___qtablewidgetitem6 = self.tbl_reporte.horizontalHeaderItem(6)
        ___qtablewidgetitem6.setText(QCoreApplication.translate("Form", u"Estado", None))
    # retranslateUi

