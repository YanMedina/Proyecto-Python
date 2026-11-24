import subprocess
import os

# Ruta física relativa del ejecutable de Qt Designer dentro de tu entorno virtual
ruta_designer = os.path.join("venv", "Lib", "site-packages", "PySide6", "designer.exe")

# Subprocess abre el programa de forma independiente sin bloquear VS Code
print("[DEV TOOLS] -> Lanzando Qt Designer. Por favor, espera...")
subprocess.Popen([ruta_designer])