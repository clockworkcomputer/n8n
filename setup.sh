#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Creando archivo .env para n8n..."

# --- Detectar IP local ---
HOST_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
if [[ -z "$HOST_IP" ]]; then
  HOST_IP="127.0.0.1"
fi

# --- Generar contraseñas y claves ---
POSTGRES_PASSWORD=$(openssl rand -base64 16)
BASIC_AUTH_PASSWORD=$(openssl rand -base64 12)
ENCRYPTION_KEY=$(openssl rand -hex 32)

# --- Variables fijas / comunes ---
POSTGRES_USER="n8n"
POSTGRES_DB="n8n"
BASIC_AUTH_USER="clockworker"
TZ="Europe/Madrid"
N8N_PORT="5678"
N8N_PROTOCOL="http"

# --- Escribir .env ---
cat > .env <<EOF
# ===== Archivo .env generado automáticamente =====
TZ=${TZ}

# Base de datos
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_DB=${POSTGRES_DB}

# n8n / red
N8N_HOST=${HOST_IP}
N8N_PORT=${N8N_PORT}
N8N_PROTOCOL=${N8N_PROTOCOL}
WEBHOOK_URL=${N8N_PROTOCOL}://${HOST_IP}:${N8N_PORT}/

# Seguridad n8n
N8N_ENCRYPTION_KEY=${ENCRYPTION_KEY}

# Auth básica
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=${BASIC_AUTH_USER}
N8N_BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASSWORD}

# Entorno local (sin HTTPS)
N8N_SECURE_COOKIE=false
EOF

chmod 600 .env

echo ""
echo "✅ Archivo .env creado con éxito."
echo "   IP detectada:         ${HOST_IP}"
echo "   Usuario PostgreSQL:   ${POSTGRES_USER}"
echo "   Contraseña PostgreSQL: ${POSTGRES_PASSWORD}"
echo "   Usuario n8n:          ${BASIC_AUTH_USER}"
echo "   Contraseña n8n:       ${BASIC_AUTH_PASSWORD}"
echo ""
echo "Ahora puedes ejecutar:  docker compose up -d"
