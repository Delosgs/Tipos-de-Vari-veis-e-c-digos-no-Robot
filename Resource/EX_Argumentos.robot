*** Settings ***
Documentation   Exemplo de uso de variáveis como argumentos em Keywords

*** Variable ***

&{PESSOA}       nome=Delano Silva   email=delanosilva@exemplo.com.br   idade=12   sexo=masculino



*** Test Cases ***
Caso de teste de exemplo 01
    Uma keyword qualquer 01



*** Keywords ***
Uma keyword qualquer 01
    Uma subkeyword com argumentos   ${PESSOA.nome}   ${PESSOA.email}  #01 
    # Primeira
    ${MENSAGEM_ALERTA}   Uma subkeyword com retorno   ${PESSOA.nome}   ${PESSOA.idade}    #02
                         # Segunda
    Log     ${MENSAGEM_ALERTA}

# Aqui é a primeira Keyword declarada lá em cima
Uma subkeyword com argumentos  #01
    [Arguments]     ${NOME_USUARIO}   ${EMAIL_USUARIO}
    Log             Nome Usuário: ${NOME_USUARIO}
    Log             Email: ${EMAIL_USUARIO}

# Aqui é a segunda Keyword declarada lá em cima
Uma subkeyword com retorno    #02
    [Arguments]     ${NOME_USUARIO}   ${IDADE_USUARIO}
    ${MENSAGEM}     Set Variable If    ${IDADE_USUARIO}<18    Não autorizado! O usuário ${NOME_USUARIO} é menor de idade!
    [Return]        ${MENSAGEM}
