# Exercicio 45 - Verificador de Numero Binario
# Disciplina: Arquitetura e Organizacao de Computadores (AOC)

.data
    msg_pedir:    .asciiz "\nDigite um numero inteiro maior que zero: "
    msg_invalido: .asciiz "Valor invalido! O numero deve ser maior que zero.\n"
    msg_binario:  .asciiz "O numero EH binario.\n"
    msg_nao_bin:  .asciiz "O numero NAO eh binario.\n"

.text
.globl main

main:
ler_numero:
    # Exibe a mensagem solicitando o numero
    li $v0, 4
    la $a0, msg_pedir
    syscall

    # Le o numero inteiro digitado pelo usuario
    li $v0, 5
    syscall
    move $t0, $v0                  # Armazena o numero lido no registrador $t0

    # Garante que o numero seja maior que zero (se <= 0, solicita novamente)
    ble $t0, $zero, numero_invalido

    # Prepara os registradores auxiliares para separar os digitos
    li $t1, 10                     # Divisor 10 para extrair cada casa decimal
    li $t3, 1                      # Constante 1 para comparacao de digito binario

verifica_digitos:
    # Divide o numero por 10 para isolar o ultimo digito
    div $t0, $t1
    mfhi $t2                       # $t2 recebe o resto da divisao (ultimo digito)
    mflo $t0                       # $t0 recebe o quociente (restante do numero)

    # Verifica se o digito atual eh igual a 0 ou igual a 1
    beq $t2, $zero, digito_valido  # Se digito == 0, continua verificando
    beq $t2, $t3, digito_valido    # Se digito == 1, continua verificando
    j nao_eh_binario               # Se for diferente de 0 e 1, nao eh binario

digito_valido:
    # Enquanto ainda restarem digitos no numero ($t0 > 0), repete o laco
    bgt $t0, $zero, verifica_digitos

    # Se todos os digitos forem 0 ou 1, exibe que eh binario
    li $v0, 4
    la $a0, msg_binario
    syscall
    j fim

nao_eh_binario:
    # Exibe mensagem informando que o numero nao eh binario
    li $v0, 4
    la $a0, msg_nao_bin
    syscall
    j fim

numero_invalido:
    # Exibe mensagem de erro e volta para pedir o numero novamente
    li $v0, 4
    la $a0, msg_invalido
    syscall
    j ler_numero

fim:
    # Encerra o programa
    li $v0, 10
    syscall
