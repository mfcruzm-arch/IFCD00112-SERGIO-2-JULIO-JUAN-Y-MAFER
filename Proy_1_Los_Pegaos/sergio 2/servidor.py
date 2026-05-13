#!/usr/bin/env python3
# ==============================================================================
# MISIÓN ARTEMIS - RETO: Servidor de Ground Control Dinámico (Python)
# ==============================================================================
# Autor: Alumno IFCD0112 & Antigravity Space Program
# Descripción: Servidor HTTP dinámico nativo en Python que:
#              - Atiende peticiones GET /go para servir el script 'mision_final.sh'
#                reemplazando dinámicamente la IP local por la del servidor.
#              - Atiende peticiones POST /upload para recibir la telemetría del
#                cliente en RAM y almacenarla localmente en disco.
# ==============================================================================

import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

PORT = 8000
UPLOAD_DIR = "reportes_recibidos"
CLIENT_SCRIPT = "mision_final.sh"

class ServidorMisionDinamic(SimpleHTTPRequestHandler):
    def do_GET(self):
        """Maneja las peticiones GET para descargar archivos y la ruta dinámica /go"""
        if self.path == "/go":
            # 1. Responder con éxito HTTP 200 y tipo texto plano UTF-8
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.end_headers()
            
            # 2. Verificar si el script orquestador existe localmente
            if os.path.exists(CLIENT_SCRIPT):
                print(f"\n  [DESCARGA] Cliente {self.client_address[0]} solicitó iniciar la misión.")
                with open(CLIENT_SCRIPT, "r", encoding="utf-8") as f:
                    codigo_bash = f.read()
                
                # 3. Detectar la IP del host por la que nos llamaron
                # (Se extrae de la cabecera 'Host' para que sea autodetectada en bridge)
                host_cabecera = self.headers.get('Host', f"127.0.0.1:{PORT}")
                server_ip = host_cabecera.split(':')[0]
                
                # 4. Parchear dinámicamente la IP del servidor en el script Bash
                codigo_parcheado = codigo_bash.replace('SERVER_IP="127.0.0.1"', f'SERVER_IP="{server_ip}"')
                
                # Enviar el código modificado directamente al terminal del cliente
                self.wfile.write(codigo_parcheado.encode("utf-8"))
                print(f"  [ÉXITO] Script '{CLIENT_SCRIPT}' servido con SERVER_IP='{server_ip}'")
            else:
                # Si no se encuentra, enviar un script mínimo informando del error
                error_script = f"#!/bin/bash\necho -e '\\033[0;31m[ERROR] El script {CLIENT_SCRIPT} no existe en el servidor.\\033[0m'\n"
                self.wfile.write(error_script.encode("utf-8"))
                print(f"  [ALERTA] Se solicitó /go pero no existe el archivo '{CLIENT_SCRIPT}' en este directorio.")
        else:
            # Comportamiento heredado por defecto para cualquier otra ruta (servir archivos normales)
            super().do_GET()

    def do_POST(self):
        """Maneja la recepción de telemetría por POST /upload"""
        if self.path == "/upload":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            
            # Crear directorio si no existe
            os.makedirs(UPLOAD_DIR, exist_ok=True)
            
            # Guardar reporte recibido
            filename = f"{UPLOAD_DIR}/reporte_{self.client_address[0]}.txt"
            with open(filename, "wb") as f:
                f.write(post_data)
                
            # Responder al cliente indicando éxito
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.end_headers()
            self.wfile.write(b"OK - Telemetria recibida y guardada.\n")
            
            print(f"  [TELEMETRÍA] Reporte recibido de la IP {self.client_address[0]}")
            print(f"  [SISTEMA] Reporte almacenado con éxito en: {filename}")
        else:
            self.send_error(404, "Endpoint no válido")

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", PORT), ServidorMisionDinamic)
    print(f"\n==================================================")
    print(f"  SISTEMA DINDÁMICO GROUND CONTROL ACTIVO")
    print(f"  Puerto de escucha: {PORT}")
    print(f"  Directorio actual: {os.getcwd()}")
    print(f"==================================================")
    print(f"  Listo para servir a tus compañeros en modo Bridge...")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nServidor cerrado de forma controlada.")
        sys.exit(0)
