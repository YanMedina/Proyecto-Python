# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'frm_programa_list.ui'
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
from PySide6.QtWidgets import (QAbstractItemView, QApplication, QHeaderView, QLabel,
    QLineEdit, QPushButton, QSizePolicy, QTableWidget,
    QTableWidgetItem, QWidget)

class Ui_Form(object):
    def setupUi(self, Form):
        if not Form.objectName():
            Form.setObjectName(u"Form")
        Form.resize(777, 585)
        self.label = QLabel(Form)
        self.label.setObjectName(u"label")
        self.label.setGeometry(QRect(20, 20, 201, 16))
        font = QFont()
        font.setPointSize(11)
        font.setBold(True)
        self.label.setFont(font)
        self.txt_buscar = QLineEdit(Form)
        self.txt_buscar.setObjectName(u"txt_buscar")
        self.txt_buscar.setGeometry(QRect(20, 40, 471, 26))
        self.btn_buscar = QPushButton(Form)
        self.btn_buscar.setObjectName(u"btn_buscar")
        self.btn_buscar.setGeometry(QRect(520, 35, 191, 31))
        font1 = QFont()
        font1.setBold(True)
        self.btn_buscar.setFont(font1)
        self.btn_nuevo = QPushButton(Form)
        self.btn_nuevo.setObjectName(u"btn_nuevo")
        self.btn_nuevo.setGeometry(QRect(20, 75, 191, 31))
        self.btn_nuevo.setFont(font1)
        self.btn_editar = QPushButton(Form)
        self.btn_editar.setObjectName(u"btn_editar")
        self.btn_editar.setGeometry(QRect(220, 75, 171, 31))
        self.btn_editar.setFont(font1)
        self.btn_eliminar = QPushButton(Form)
        self.btn_eliminar.setObjectName(u"btn_eliminar")
        self.btn_eliminar.setGeometry(QRect(410, 75, 171, 31))
        self.btn_eliminar.setFont(font1)
        self.tbl_programas = QTableWidget(Form)
        if (self.tbl_programas.columnCount() < 4):
            self.tbl_programas.setColumnCount(4)
        __qtablewidgetitem = QTableWidgetItem()
        self.tbl_programas.setHorizontalHeaderItem(0, __qtablewidgetitem)
        __qtablewidgetitem1 = QTableWidgetItem()
        self.tbl_programas.setHorizontalHeaderItem(1, __qtablewidgetitem1)
        __qtablewidgetitem2 = QTableWidgetItem()
        self.tbl_programas.setHorizontalHeaderItem(2, __qtablewidgetitem2)
        __qtablewidgetitem3 = QTableWidgetItem()
        self.tbl_programas.setHorizontalHeaderItem(3, __qtablewidgetitem3)
        self.tbl_programas.setObjectName(u"tbl_programas")
        self.tbl_programas.setGeometry(QRect(20, 130, 731, 391))
        self.tbl_programas.setFont(font)
        self.tbl_programas.setEditTriggers(QAbstractItemView.EditTrigger.NoEditTriggers)
        self.tbl_programas.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        self.tbl_programas.setSortingEnabled(True)
        self.tbl_programas.setColumnCount(4)
        self.label_2 = QLabel(Form)
        self.label_2.setObjectName(u"label_2")
        self.label_2.setGeometry(QRect(20, 540, 321, 16))

        self.retranslateUi(Form)

        QMetaObject.connectSlotsByName(Form)
    # setupUi

    def retranslateUi(self, Form):
        Form.setWindowTitle(QCoreApplication.translate("Form", u"Form", None))
        self.label.setText(QCoreApplication.translate("Form", u"Buscar Por Nombre o C\u00f3digo", None))
        self.btn_buscar.setText(QCoreApplication.translate("Form", u"Buscar Programa", None))
        self.btn_nuevo.setText(QCoreApplication.translate("Form", u"Nuevo Programa", None))
        self.btn_editar.setText(QCoreApplication.translate("Form", u"Editar Programa", None))
        self.btn_eliminar.setText(QCoreApplication.translate("Form", u"Eliminar Programa", None))
        ___qtablewidgetitem = self.tbl_programas.horizontalHeaderItem(0)
        ___qtablewidgetitem.setText(QCoreApplication.translate("Form", u"C\u00f3digo", None))
        ___qtablewidgetitem1 = self.tbl_programas.horizontalHeaderItem(1)
        ___qtablewidgetitem1.setText(QCoreApplication.translate("Form", u"Estado", None))
        ___qtablewidgetitem2 = self.tbl_programas.horizontalHeaderItem(2)
        ___qtablewidgetitem2.setText(QCoreApplication.translate("Form", u"Nombre", None))
        ___qtablewidgetitem3 = self.tbl_programas.horizontalHeaderItem(3)
        ___qtablewidgetitem3.setText(QCoreApplication.translate("Form", u"Creaci\u00f3n", None))
        self.label_2.setText(QCoreApplication.translate("Form", u"Se muestra los \u00faltimos (Top 20)", None))
    # retranslateUi

