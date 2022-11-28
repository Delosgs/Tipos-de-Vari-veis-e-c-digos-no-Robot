
*** Settings ***

Documentation    Documentação da API:     https://fakerestapi.azurewebsites.net/swagger/ui/index#!/Books
Library          RequestsLibrary
Library          Collections
#Library          Builtln

*** Variables ***
${URL_API}      https://fakerestapi.azurewebsites.net/api/v1    #Simples
&{BOOK_15}      Id=15   # Aqui no &{BOOK_15} são as variaveis do tipo dicionario, com valores fixos que podem ser passadas no test case tbm
...             Title=Book 15    
...             PageCount=1500  
&{BOOK_201}     ID=201    #Tipo Dicionário
...             Title=QA Delano Silva
...             Description=Automação API
...             PageCount=523
...             Excerpt=Teste de API
...             PublishDate=2018-04-26T17:58:14.765Z  
&{BOOK_150}     ID=150    #Tipo Dicionário
...             Title=Book 150 alterado
...             Description=Descrição do book 150 alterada
...             PageCount=600
...             Excerpt=Resumo do book 150 alteado
...             PublishDate=2017-04-26T15:58:14.765Z



*** Keywords ***

################# SETUP E TEARDOWNS ##########

Conectar a minha API   #Create Session, criar uma sessão HTTP para um servidor
    Create Session     TesteAPI    ${URL_API} 
                       #TesteAPI = Nome alias 
    # ${HEADERS}     Create Dictionary    content-type=application/json
    # Set Suite Variable    ${HEADERS}

#01 GET All
Requisitar todos os livros    #${RESPOSTA} = um nome dado ao Get on session
    ${RESPOSTA}          GET On Session   TesteAPI    Books
    Log                  ${RESPOSTA.text}    # Aqui eu pego o texto que vem de responta
    Set Test Variable    ${RESPOSTA}    #Aqui defino a variavel teste = RESPOSTA, para ser usada em outras KeyWords dentro do teste
    Log To Console       ${RESPOSTA.json}   # Com a KeyWord "Log To Console" o resultado tbm aparece no terminal

#02 GET ID
Requisitar o livro "${ID_LIVROS}"  # ${ID_LIVROS} = ao numero 15 no test case
    ${RESPOSTA}        GET On Session   TesteAPI    Books/${ID_LIVROS}
    Log                ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}     # "Set Test Variable" é da lib 'String"

#03 POST
Cadastrar um livro novo
    ${HEADERS}         Create Dictionary        content-type=application/json
    ${RESPOSTA}        POST On Session          TesteAPI    Books       # Books é o endpoint da API
    ...                                         data={"ID": ${BOOK_201.ID},"Title": "${BOOK_201.Title}","Description": "${BOOK_201.Description}","PageCount": ${BOOK_201.PageCount},"Excerpt": "${BOOK_201.Excerpt}","PublishDate": "${BOOK_201.PublishDate}"}
    ...                                         headers=${HEADERS} 
    Log                  ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA} 

Alterar um livro "${ID_LIVRO}"  # ${ID_LIVRO} = ao numero 150 no test case
    ${HEADERS}         Create Dictionary        content-type=application/json
    ${RESPOSTA}        PUT On Session   TesteAPI    Books/${ID_LIVRO}
    ...                                 data={"ID": ${BOOK_150.ID},"Title": "${BOOK_150.Title}","Description": "${BOOK_150.Description}","PageCount": ${BOOK_150.PageCount},"Excerpt": "${BOOK_150.Excerpt}","PublishDate": "${BOOK_150.PublishDate}"}
    ...                                 headers=${HEADERS}
    Log                  ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA} 

#05 DELETE
Excluir o livro "${ID_LIVRO}"
    ${RESPOSTA}    DELETE On Session    TesteAPI    Books/${ID_LIVRO}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}


################## CONFERÊNCIAS ################

# All
Conferir o status code
    [Arguments]    ${STATUSCODE_DESEJADO}     # Uma forma de enviar informações é passar um argumento e ele sera = 200 que esta no test case
    Should Be Equal As Strings    ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}
# All
Conferir o reason 
    [Arguments]    ${REASON_DESEJADO}  # = OK que esta no test case
    Should Be Equal As Strings      ${RESPOSTA.reason}    ${REASON_DESEJADO}

#01 GET All
Conferir se retorna uma lista com "${QDT_LIVROS}" livros    # Aqui o argumento esta imbutido e ele é igual a 200 como esta no test case 01
    Length Should Be    ${RESPOSTA.json()}    ${QDT_LIVROS}   #Essa KeyWord = "Length Should Be" vem Builtln Library
                            # item            # Tamanho

#02 GET ID
Conferir se retorna todos os dados corretos do livro 15
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id             ${BOOK_15.Id}    #Aqui são aequivos estaticos                                                        
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title          ${BOOK_15.Title}    #Aqui são aequivos estaticos
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount      ${BOOK_15.PageCount}   #Aqui são aequivos estaticos
                                        #dictionary           #key             #value

    Should Not Be Empty    ${RESPOSTA.json()["description"]}    
    Should Not Be Empty    ${RESPOSTA.json()["excerpt"]} 
    Should Not Be Empty    ${RESPOSTA.json()["publishDate"]} 
                                #item da Lib Builtln
    #Aqui a variavel muda em cada requisição, por isso foi usado a Keyword "Should Not BE Empty" para não retornar vazio

# 03 e 04
Conferir livro    # Keyword unica com os paramentros para a chamada
    [Arguments]    ${ID_LIVRO}
    Dictionary Should Contain Item    ${RESPOSTA.json}    ID             ${BOOK_${ID_LIVRO}.ID}
    Dictionary Should Contain Item    ${RESPOSTA.json}    Title          ${BOOK_${ID_LIVRO}.Title}
    Dictionary Should Contain Item    ${RESPOSTA.json}    Description    ${BOOK_${ID_LIVRO}.Description}
    Dictionary Should Contain Item    ${RESPOSTA.json}    PageCount      ${BOOK_${ID_LIVRO}.PageCount}
    Dictionary Should Contain Item    ${RESPOSTA.json}    Excerpt        ${BOOK_${ID_LIVRO}.Excerpt}
    Dictionary Should Contain Item    ${RESPOSTA.json}    PublishDate    ${BOOK_${ID_LIVRO}.PublishDate}

#03 POST 
Conferir se retorna todos os dados cadastradados do livro "${ID_LIVRO}"
    Conferir livro     ${ID_LIVRO}
   
#04 PUT
Conferir se retorna todos os dados alterados do livro "${ID_LIVRO}"
    Conferir livro     ${ID_LIVRO}

#05 Delete
Conferir se excluiu o livro "${ID_LIVRO}"
    Should Be Empty     ${RESPOSTA.content}