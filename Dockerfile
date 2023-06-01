# Usa la imagen base de Oracle
FROM oracleinanutshell/oracle-xe-11g:latest

# Instala unzip
RUN apt-get update && apt-get install -y unzip

# Descarga el cliente SQL*Plus instantáneo
ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip /tmp/instantclient.zip

# Descomprime el archivo zip
RUN unzip /tmp/instantclient.zip -d /opt && \
    rm /tmp/instantclient.zip && \
    mv /opt/instantclient_21_1 /opt/instantclient

# Configura las variables de entorno necesarias
ENV LD_LIBRARY_PATH=/opt/instantclient
ENV PATH=/opt/instantclient:$PATH

# Establece las variables de entorno necesarias para Oracle XE
ENV ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE


# Copia tus scripts a la imagen
# COPY ./scripts/ /docker-entrypoint-initdb.d/

# Ejecuta los scripts cuando se inicia el contenedor
# Necesitarás modificar esta línea para que se ajuste a tu configuración
# CMD ["/bin/bash", "-c", "source /home/oracle/.bashrc; sqlplus /nolog @/docker-entrypoint-initdb.d/your-script.sql"]
