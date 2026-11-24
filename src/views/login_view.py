# src/views/login_view.py

from PyQt6.QtWidgets import QWidget, QMessageBox
from PyQt6 import uic

from controllers.auth_controller import AuthController
from exceptions.biblioteca_exceptions import BibliotecaException

class LoginView(QWidget):
    def __init__(self):
        super().__init__()
        uic.loadUi("src/views/ui/frm_login.ui", self)
        
        self._auth_controller = AuthController()
        self.btn_ingresar.clicked.connect(self._on_btn_ingresar_click)

    def _on_btn_ingresar_click(self):
        correo = self.txt_correo.text()
        clave = self.txt_clave.text()

        try:
            # 1. Autenticación exitosa
            usuario = self._auth_controller.iniciar_sesion(correo, clave)

            # 2. Mensaje de bienvenida
            QMessageBox.information(
                self, 
                "Bienvenido", 
                f"¡Acceso concedido!\n\n"
                f"Bienvenido(a): {usuario.nombre_completo}\n"
                f"Rol: {usuario.nombre_rol}"
            )

            # 3. Transición al Dashboard (Ahora sí existe la función)
            self._abrir_dashboard_principal(usuario)

        except BibliotecaException as ex:
            # Captura de reglas de negocio (Credenciales erróneas, correo no institucional, etc.)
            QMessageBox.warning(self, "Validación de Acceso", str(ex))
        except Exception as ex:
            # Captura de errores no previstos en Python
            QMessageBox.critical(self, "Error de Sistema", f"Ocurrió un error en la aplicación: {ex}")

    def _abrir_dashboard_principal(self, usuario):
        """
        MÉTODO DE RUTEO DE INTERFAZ:
        Recibe al objeto Usuario autenticado y evalúa su Rol para dar paso a la vista correspondiente.
        """
        print(f"\n[DEBUG GUI] -> Sesión activa para: {usuario.nombre_completo}")
        print(f"[DEBUG GUI] -> Rol detectado: {usuario.nombre_rol}")

        if usuario.nombre_rol == "Estudiante":
            print("[DEBUG GUI] -> Modo Lectura/Búsqueda activado (PC Estudiante)")
            # Próxima fase: Abrir ventana de Búsqueda de Libros / Pre-préstamos
        else:
            print("[DEBUG GUI] -> Modo Gestión activado (Dashboard Bibliotecario / Monitoreo PCs)")
            # Próxima fase: Abrir Dashboard con monitoreo de Equipos en tiempo real
        
        # Limpiamos las cajas de texto tras ingresar
        self.txt_correo.clear()
        self.txt_clave.clear()