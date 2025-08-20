# Imagen base
FROM python:3.9.16-buster

# Variables de usuario
ARG uid=1000
ARG gid=1000

# Crear grupo y usuario
RUN groupadd -g ${gid} appuser && \
    useradd -m -u ${uid} -g ${gid} appuser

# ---------------------------
# Copiar los entrypoints al root del contenedor
COPY web_entrypoint.sh /web_entrypoint.sh
COPY worker_entrypoint.sh /worker_entrypoint.sh

# Dar permisos de ejecución
RUN chmod +x /web_entrypoint.sh /worker_entrypoint.sh
# ---------------------------

# Crear directorio /app en el contenedor
RUN mkdir /app

# Copiar todo el código a /app
COPY . /app

# Usar /app como directorio de trabajo
WORKDIR /app

# Instalar dependencias
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Configuración de encoding
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV PYTHONIOENCODING utf8

# Logs
RUN mkdir -p app/logs && touch app/logs/debug.log

# RabbitMQ directory
RUN mkdir -p rabbitmq/logs

# Permisos al usuario
RUN chown -R ${uid}:${gid} /app

# Ejecutar como usuario no root
USER ${uid}

# Exponer el puerto 8000
EXPOSE 8000


