class ProveedorController:
    """
    CONTROLADOR - Módulo Proveedores.
    Actúa como intermediario entre la Vista y la Base de Datos.
    """
    def __init__(self):
        pass

    def registrar_proveedor(self, ruc: str, razon_social: str, telefono: str) -> bool:
        """
        MÉTODO STUB (Simulador): Recibe los datos de la vista, pero aún no 
        los envía a MySQL. Eso se hará en la Sesión 15.
        """
        # Simulamos que todo salió bien y mostramos qué datos llegaron
        print(f"[CONTROLADOR] -> Recibido: {ruc} | {razon_social} | {telefono}")
        return True