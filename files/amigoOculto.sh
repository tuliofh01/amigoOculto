#!/bin/bash


# Boas vindas ao usuario
printf "Bem vindo, $USER, ao sorteador de amigo oculto!\n"
cat ./bin/art.txt


# Listar/cadastrar festas
function cadastrarFesta {
	echo -n "Insira o nome da festa:"
	read festa; mkdir "./data/$festa"
	echo "Festa cadastrada com sucesso!"
}

userInput=0
while [[ $userInput == 0 ]]; do
	# Registra festas cadastradas (subdiretorios do diretorio data)
	festasCadastradas=($(find ./data/ -mindepth 1 -type d))
	# Lista festas cadastradas		
	printf "\nFestas cadastradas:\n"	
	for festa in "${festasCadastradas[@]}"; do		
		echo $festa | sed "s/^\.\/.*\///"
	done
	# Abre a possibilidade de cadastrar mais festas
	echo -n "Deseja cadastrar uma nova festa?(s/n):"; read aux		
	if [[ $aux == "s" ]]; then
		cadastrarFesta
	elif [[ $aux == "n" ]]; then
		userInput=$((userInput+1))
	else
		echo "Erro: opção inválida!"
	fi
done


# Seleciona festa e verifica se ela existe
echo -n "Digite o nome de uma festa cadastrada:"; read festaAlvo
diretorioFesta="./data/$festaAlvo"

if ! [ -e $diretorioFesta ]; then
	echo Festa invalida!
	exit 1
fi	 


# Listar/cadastrar usuários em uma festa
function cadastrarUsuario {
	echo -n "Insira o nome do usuário:"
	read usuarioAlvo
	touch "$diretorioFesta/$usuarioAlvo.csv"
	echo -n "Quantos presentes deseja cadastrar?"
	read contador; contador_2=0
	while [[ $contador_2 < $contador ]]; do
		echo -n "Insira um titulo:"; read titulo
		echo -n "Insira um valor:"; read valor
		echo $titulo,$valor >> "$diretorioFesta/$usuarioAlvo.csv"
		contador_2=$((contador_2+1))
	done
}

userInput=0
while [[ $userInput == 0 ]]; do
	usuariosCadastrados=($(find $diretorioFesta -type f))
	# Lista usuarios cadastrados		
	printf "\nUsuarios cadastrados:\n"	
	for usuario in "${usuariosCadastrados[@]}"; do		
		echo $usuario | sed "s/^\.\/.*\///" | sed "s/.csv$//"
	done
	# Abre a possibilidade de cadastrar mais usuários
	echo -n "Deseja cadastrar um usuário?(s/n):"
	read aux		
	if [[ $aux == "s" ]]; then
		cadastrarUsuario
	elif [[ $aux == "n" ]]; then
		userInput=$((userInput+1))
	else
		echo "Erro: opção inválida!"
	fi
done


# Sorteia usuários (arquivos)
arquivosUsuariosOrdenados=($(find ./data/$festaAlvo/ -type f));
arquivosUsuariosDesordenados=($(python ./bin/shuffler.py ${arquivosUsuariosOrdenados[@]}))


# Cria e preenche arquivo de texto formatado com os resultados
diretorioResultados=$(echo "./results/$festaAlvo/$(date +%d-%m-%Y\(%H:%M\))")
mkdir -p $diretorioResultados

contador=0
for usuario in "${arquivosUsuariosOrdenados[@]}"; do		
	file=$(echo $usuario | sed "s/^\.\/.*\///" | sed "s/.csv$//")
	touch "$diretorioResultados/$file.txt"
	
	sorteado=$(echo ${arquivosUsuariosDesordenados[$contador]} | sed "s/^\.\/.*\///" | sed "s/.csv$//")	
	echo "O seu sorteado foi: $sorteado." >> "$diretorioResultados/$file.txt"
	echo "Segue abaixo uma lista com os presentes solicitados por $sorteado:" >> "$diretorioResultados/$file.txt"
	awk -F ',' '{print NR "- Presente: " $1 ", Valor: " $2}' ./data/$festaAlvo/$sorteado.csv >> "$diretorioResultados/$file.txt"
	
	contador=$((contador+1))			
done


# Sinaliza o fim do sorteio
echo "Fim do sorteio! Conferir os resultados na pasta results!"

