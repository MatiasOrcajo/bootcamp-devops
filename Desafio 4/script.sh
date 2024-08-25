#!/bin/bash

# Detectar la distribución
distro=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')

# Función para crear el archivo index.html
crear_index_html() {
    echo "Creando archivo index.html en el directorio raíz del servidor web."
    echo "<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Botcamp DevOps</title>
</head>
<body>
<h1>Bootcamp DevOps Engineer</h1>
</body>
</html>" | sudo tee /var/www/html/index.html > /dev/null
}

# Ejecutar comandos según la distribución detectada
if [[ "$distro" == "ubuntu" || "$distro" == "debian" ]]; then
    echo "Detectado Ubuntu/Debian. Usando apt para actualizar, mejorar el sistema e instalar Apache."
    sudo apt update && sudo apt upgrade -y
    sudo apt install apache2 -y
    crear_index_html
    sudo systemctl start apache2
    sudo systemctl enable apache2

elif [[ "$distro" == "fedora" ]]; then
    echo "Detectado Fedora. Usando dnf para actualizar, mejorar el sistema e instalar Apache."
    sudo dnf check-update && sudo dnf upgrade -y
    sudo dnf install httpd -y
    crear_index_html
    sudo systemctl start httpd
    sudo systemctl enable httpd

elif [[ "$distro" == "centos" ]]; then
    echo "Detectado CentOS. Usando yum para actualizar, mejorar el sistema e instalar Apache."
    sudo yum check-update && sudo yum upgrade -y
    sudo yum install httpd -y
    crear_index_html
    sudo systemctl start httpd
    sudo systemctl enable httpd

elif [[ "$distro" == "arch" ]]; then
    echo "Detectado Arch Linux. Usando pacman para actualizar, mejorar el sistema e instalar Apache."
    sudo pacman -Syu --noconfirm
    sudo pacman -S apache --noconfirm
    crear_index_html
    sudo systemctl start httpd
    sudo systemctl enable httpd

else
    echo "Distribución no soportada o desconocida: $distro"
fi
