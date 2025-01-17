# CloudFlare Acces Allow

Este repositorio contiene el escript **install.sh** que se encarga de actualizar el cortafuegos **ufw** para dar acceso solo a las direcciones IP de Cloudflare.


<img src="./images/logo-cloudflare-dark.svg" width="150" height="150" />
<img src="./images/digitalocean.svg" width="150" height="150" />
<hr>

Este escript descarga en el servidor las direcciones IP Versión 4 y 6 desde las cuales CloudFlare accede al servidor web.

## Motivación
Los ataques a los servidores desde internet está a la orden del día, reducir sigificativamente los puntos de entrada, tanto direcciones IP como a los puertos que se permite el ingreso, también ayuda a reducir las opciones que tienen los atacaten.

## Solución
1. Denegar el todos los accesos al servidor
1. Permitir solo las salidas
1. Permitir los accesos OpenSSH
1. Ejecutar el script ```install.sh```

## ¿Qué hace el script install.sh
Éste script descarga en el mismo directorio donde está ubicado, todas las IPs de la [Versión 4](https://www.cloudflare.com/ips-v4) y las IPs de la [Versión 6](https://www.cloudflare.com/ips-v6), luego las agrega al corta fuego **ufw** ejecutando el comando 

```bash
$ ufw allow from <ip>
```

## Uso
Para usar este script, descargue en el servidor web y siga los siguientes pasos:

1. Desactivo por defecto, todos los accesos al servidor
```bash
$ ufw default deny incoming
```

2. Active por defecto, todas las salidas del servidor
```bash
$ ufw default allow outgoing
```

3. Active el acceso ssh al servidor ejecutando
```bash
$ ufw allow OpenSSH
```

4. Habilite el cortafuegos
```bash
$ ufw enable
```

5. Ejecute el script
```bash
$ ./install.sh
```

## Recomendación

Se recomienda agrega un registro al **cron** del sistema que se ejecute a una hora de poco tráfico que se encarge de ejecutar el script **install.sh** con la finalidad de matener la lista de direcciones IPs de Cloudflare actualizadas con los últimos cambios que puedan llegar a aparecer.

ejemplo
```cron
0 4 * * * /var/scripts/cloudflare/install.sh
```
éste registro del **cron** lanzará el script todos los días a las 04:00.
