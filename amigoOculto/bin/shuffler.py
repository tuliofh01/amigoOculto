#!/bin/python3
import random, sys
from numpy import arange

# Nomes no amigo oculto devem ser passados como parametros
usuarios = sys.argv[1 : len(sys.argv)]

# Array ordenada(sera guardada para comparacao no final)
arrayOrdenada = list()

# Array alvo (sera misturada)
for usuario in usuarios:
    arrayOrdenada.append(usuario)
arrayAlvo = arrayOrdenada.copy()

# Mistura de elementos
for i in arange(len(arrayAlvo) - 1):
    # Delimita subarray (decresce progressivamente)
    subArray = arrayAlvo[i + 1 : len(arrayAlvo)]
    # Faz o sorteio e prepara variaveis para troca
    targetVar = random.choice(subArray); targetIndex = arrayAlvo.index(targetVar)
    sourceVar = arrayAlvo[i]; sourceIndex = arrayAlvo.index(sourceVar)
    # Faz a troca
    arrayAlvo[sourceIndex] = targetVar; arrayAlvo[targetIndex] = sourceVar

# Lista ordenaçao final
for i in arrayAlvo:
    print(str(i) + ' ',end = '')
print('\n',end = '')

