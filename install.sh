#!/bin/sh

# Función para manejar errores y salir limpiamente
error_exit() {
    echo "Error: $1" >&2
    rm -f ips-v6 ips-v4  # Limpiar archivos temporales si existen
    exit 1
}

# Descargar las IPs de Cloudflare (con manejo de errores)
wget -O ips-v6 https://www.cloudflare.com/ips-v6 -q || error_exit "No se pudo descargar ips-v6"
wget -O ips-v4 https://www.cloudflare.com/ips-v4 -q || error_exit "No se pudo descargar ips-v4"

# Verificar que los archivos no estén vacíos (descarga válida)
if [ ! -s ips-v6 ] || [ ! -s ips-v4 ]; then
    error_exit "Archivos IPs descargados están vacíos o son inválidos"
fi

# Restablecer UFW a valores predeterminados (elimina todas las reglas)
ufw --force reset > /dev/null || error_exit "Falló el reset de UFW"

# Configurar políticas predeterminadas (denegar entrada, permitir salida)
ufw default deny incoming || error_exit "Falló configurar 'deny incoming'"
ufw default allow outgoing || error_exit "Falló configurar 'allow outgoing'"

# Permitir acceso SSH desde cualquier IP en el puerto 22
ufw allow proto tcp from any to any port 22 || error_exit "Falló permitir SSH"

# Permitir IPs IPv6 de Cloudflare
while read -r ip; do
    ufw allow from "$ip" > /dev/null || error_exit "Falló permitir IP $ip (IPv6)"
done < ips-v6

# Permitir IPs IPv4 de Cloudflare
while read -r ip; do
    ufw allow from "$ip" > /dev/null || error_exit "Falló permitir IP $ip (IPv4)"
done < ips-v4

# Habilitar y recargar UFW
ufw --force enable > /dev/null || error_exit "Falló habilitar UFW"
ufw reload > /dev/null || error_exit "Falló recargar UFW"

# Eliminar archivos temporales
rm -f ips-v6 ips-v4

echo "Configuración completada exitosamente."
exit 0
