# Usa la imagen base de Oracle
FROM oracleinanutshell/oracle-xe-11g:latest

# Instala el cliente de Oracle (sqlplus)
RUN apt-get update && apt-get install -y sqlplus

# Establece las variables de entorno necesarias
ENV ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE
# Copia tus scripts a la imagen
# COPY ./scripts/ /docker-entrypoint-initdb.d/

# Ejecuta los scripts cuando se inicia el contenedor
# Necesitarás modificar esta línea para que se ajuste a tu configuración
# CMD ["/bin/bash", "-c", "source /home/oracle/.bashrc; sqlplus /nolog @/docker-entrypoint-initdb.d/your-script.sql"]
