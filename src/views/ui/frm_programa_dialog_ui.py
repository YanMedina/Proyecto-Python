# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'frm_programa_dialog.ui'
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
from PySide6.QtWidgets import (QApplication, QDialog, QLabel, QLineEdit,
    QPushButton, QSizePolicy, QWidget)

class Ui_frm_programa_dialog(object):
    def setupUi(self, frm_programa_dialog):
        if not frm_programa_dialog.objectName():
            frm_programa_dialog.setObjectName(u"frm_programa_dialog")
        frm_programa_dialog.resize(493, 170)
        self.label = QLabel(frm_programa_dialog)
        self.label.setObjectName(u"label")
        self.label.setGeometry(QRect(20, 40, 131, 16))
        font = QFont()
        font.setPointSize(10)
        font.setBold(True)
        self.label.setFont(font)
        self.label_2 = QLabel(frm_programa_dialog)
        self.label_2.setObjectName(u"label_2")
        self.label_2.setGeometry(QRect(20, 70, 141, 16))
        self.label_2.setFont(font)
        self.txt_codigo = QLineEdit(frm_programa_dialog)
        self.txt_codigo.setObjectName(u"txt_codigo")
        self.txt_codigo.setGeometry(QRect(160, 30, 311, 26))
        self.txt_nombre = QLineEdit(frm_programa_dialog)
        self.txt_nombre.setObjectName(u"txt_nombre")
        self.txt_nombre.setGeometry(QRect(160, 60, 311, 26))
        self.btn_guardar = QPushButton(frm_programa_dialog)
        self.btn_guardar.setObjectName(u"btn_guardar")
        self.btn_guardar.setGeometry(QRect(200, 115, 101, 31))
        self.btn_guardar.setFont(font)
        self.btn_cancelar = QPushButton(frm_programa_dialog)
        self.btn_cancelar.setObjectName(u"btn_cancelar")
        self.btn_cancelar.setGeometry(QRect(320, 115, 111, 31))
        self.btn_cancelar.setFont(font)

        self.retranslateUi(frm_programa_dialog)

        QMetaObject.connectSlotsByName(frm_programa_dialog)
    # setupUi

    def retranslateUi(self, frm_programa_dialog):
        frm_programa_dialog.setWindowTitle(QCoreApplication.translate("frm_programa_dialog", u"Dialog", None))
        self.label.setText(QCoreApplication.translate("frm_programa_dialog", u"C\u00f3digo de progrma", None))
        self.label_2.setText(QCoreApplication.translate("frm_programa_dialog", u"Nombre de Progrma", None))
        self.btn_guardar.setText(QCoreApplication.translate("frm_programa_dialog", u"Guardar", None))
        self.btn_cancelar.setText(QCoreApplication.translate("frm_programa_dialog", u"Cancelar", None))
    # retranslateUi

