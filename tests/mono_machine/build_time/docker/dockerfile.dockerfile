FROM ubuntu:22.04

# Copiez le fichier source dans le conteneur
COPY main.c /

# Définissez le répertoire de travail
WORKDIR /

# Installez le compilateur GCC
RUN apt-get update && apt-get install -y gcc

# Compilez l'application
RUN gcc -o hello_world main.c

# Commande par défaut à exécuter lorsque le conteneur démarre
CMD ["/hello_world"]