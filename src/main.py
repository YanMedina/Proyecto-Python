import sys

from PySide6.QtWidgets import QApplication, QDialog

from views.login_dialog import LoginDialog
from views.main_window import MainWindow


def principal():
    aplicacion = QApplication(sys.argv)
    cuadro_login = LoginDialog()

    if cuadro_login.exec() == QDialog.DialogCode.Accepted:
        ventana_principal = MainWindow()
        ventana_principal.show()
        sys.exit(aplicacion.exec())

    sys.exit(0)


if __name__ == "__main__":
    principal()
