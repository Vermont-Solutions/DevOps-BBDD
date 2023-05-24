# Usa la imagen base de Oracle
FROM vermontjc/oracle19

# Copia tus scripts a la imagen
# COPY ./scripts/ /docker-entrypoint-initdb.d/

# Ejecuta los scripts cuando se inicia el contenedor
# Necesitarás modificar esta línea para que se ajuste a tu configuración
# CMD ["/bin/bash", "-c", "source /home/oracle/.bashrc; sqlplus /nolog @/docker-entrypoint-initdb.d/your-script.sql"]
