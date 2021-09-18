#!/bin/bash


# Descrição:
# Este script é um simples instalador para o programa sorteador de amigo oculto.


# Verifica se o usuário rodado é root
userStatus=$(whoami)

if ! [[ $userStatus == "root" ]]; then
	echo "Por favor, execute o instalador como root!"
	exit 1
fi


# Tenta instalar repositórios python necessários
if which pip > /dev/null 2>&1; then
	pip install numpy
else
	echo "Erro: por favor instale o pip!"
	exit 1
fi


# Cria diretórios necessários
mkdir bin data results


# Move arquivos para os diretórios corretos
mv ./files/shuffler.py ./bin/shuffler.py
mv ./files/art.txt ./bin/art.txt
mv ./files/amigoOculto.sh ./amigoOculto.sh


# Remove diretório container original
rmdir ./files
