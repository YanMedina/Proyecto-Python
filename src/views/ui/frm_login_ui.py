# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'frm_login.ui'
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
from PySide6.QtWidgets import (QApplication, QLabel, QLineEdit, QPushButton,
    QSizePolicy, QWidget)

class Ui_Form(object):
    def setupUi(self, Form):
        if not Form.objectName():
            Form.setObjectName(u"Form")
        Form.resize(566, 256)
        self.label = QLabel(Form)
        self.label.setObjectName(u"label")
        self.label.setGeometry(QRect(120, 20, 331, 20))
        font = QFont()
        font.setPointSize(14)
        self.label.setFont(font)
        self.label_2 = QLabel(Form)
        self.label_2.setObjectName(u"label_2")
        self.label_2.setGeometry(QRect(30, 80, 141, 16))
        font1 = QFont()
        font1.setPointSize(11)
        self.label_2.setFont(font1)
        self.label_3 = QLabel(Form)
        self.label_3.setObjectName(u"label_3")
        self.label_3.setGeometry(QRect(30, 120, 131, 21))
        self.label_3.setFont(font1)
        self.txt_usuario = QLineEdit(Form)
        self.txt_usuario.setObjectName(u"txt_usuario")
        self.txt_usuario.setGeometry(QRect(170, 70, 301, 31))
        self.txt_password = QLineEdit(Form)
        self.txt_password.setObjectName(u"txt_password")
        self.txt_password.setGeometry(QRect(170, 115, 301, 31))
        self.txt_password.setEchoMode(QLineEdit.EchoMode.Password)
        self.btn_ingresar = QPushButton(Form)
        self.btn_ingresar.setObjectName(u"btn_ingresar")
        self.btn_ingresar.setGeometry(QRect(230, 190, 151, 31))

        self.retranslateUi(Form)

        QMetaObject.connectSlotsByName(Form)
    # setupUi

    def retranslateUi(self, Form):
        Form.setWindowTitle(QCoreApplication.translate("Form", u"Form", None))
        self.label.setText(QCoreApplication.translate("Form", u"SISTEMA DE GESTI\u00d3N DE BIBLIOTECA.", None))
        self.label_2.setText(QCoreApplication.translate("Form", u"Correo Institucional:", None))
        self.label_3.setText(QCoreApplication.translate("Form", u"Contrase\u00f1a:", None))
        self.txt_usuario.setText("")
        self.btn_ingresar.setText(QCoreApplication.translate("Form", u"Ingresar al Sistema", None))
    # retranslateUi

