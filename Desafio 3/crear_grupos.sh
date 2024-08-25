#!/bin/bash

# Crear los grupos
sudo groupadd Desarrollo
if [ $? -eq 0 ]; then
    logger "Grupo 'Desarrollo' creado exitosamente."
else
    logger "Error al crear el grupo 'Desarrollo'."
fi

sudo groupadd Operaciones
if [ $? -eq 0 ]; then
    logger "Grupo 'Operaciones' creado exitosamente."
else
    logger "Error al crear el grupo 'Operaciones'."
fi

sudo groupadd Ingeniería
if [ $? -eq 0 ]; then
    logger "Grupo 'Ingeniería' creado exitosamente."
else
    logger "Error al crear el grupo 'Ingeniería'."
fi

# Crear usuarios, asignar contraseñas y grupos
declare -A usuarios
usuarios=(
    ["usuario1"]="Desarrollo"
    ["usuario2"]="Desarrollo"
    ["usuario3"]="Operaciones"
    ["usuario4"]="Operaciones"
    ["usuario5"]="Ingeniería"
    ["usuario6"]="Ingeniería"
)

for usuario in "${!usuarios[@]}"; do
    grupo="${usuarios[$usuario]}"
    
    # Crear el usuario con su grupo
    sudo useradd -m -G $grupo $usuario
    if [ $? -eq 0 ]; then
        logger "Usuario '$usuario' creado y asignado al grupo '$grupo'."
    else
        logger "Error al crear el usuario '$usuario' o asignarlo al grupo '$grupo'."
    fi

    # Asignar contraseña al usuario
    echo "$usuario:P*ssw0rd123" | sudo chpasswd
    if [ $? -eq 0 ]; then
        logger "Contraseña asignada al usuario '$usuario'."
    else
        logger "Error al asignar la contraseña al usuario '$usuario'."
    fi

    # Crear carpeta específica en /home
    sudo mkdir -p /home/$usuario/especifico
    if [ $? -eq 0 ]; then
        # Cambiar el ownership de la carpeta
        sudo chown $usuario:$grupo /home/$usuario/especifico
        if [ $? -eq 0 ]; then
            logger "Ownership de la carpeta '/home/$usuario/especifico' cambiado a '$usuario:$grupo'."
        else
            logger "Error al cambiar el ownership de la carpeta '/home/$usuario/especifico'."
        fi

        # Configurar permisos específicos
        sudo chmod 750 /home/$usuario/especifico
        if [ $? -eq 0 ]; then
            logger "Permisos de la carpeta '/home/$usuario/especifico' configurados a 750."
        else
            logger "Error al configurar los permisos de la carpeta '/home/$usuario/especifico'."
        fi
    else
        logger "Error al crear la carpeta específica para '$usuario'."
    fi
done
