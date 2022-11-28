*** Settings ***

Documentation    Documentação da API:     https://fakerestapi.azurewebsites.net/api/v1
Resource         ../Resource/ResourceAPI.robot
Suite Setup      Conectar a minha API

*** Test Cases ***
#01
Buscar a listagem de todos os livros (GET em todos os livros)
    Requisitar todos os livros
    Conferir o status code    200
    Conferir o reason    OK
    Conferir se retorna uma lista com "200" livros 
#02
Buscar um livro especifico (GET em um livro especifico)
    Requisitar o livro "15"
    Conferir o status code    200
    Conferir o reason    OK
    Conferir se retorna todos os dados corretos do livro 15

#03
Cadastrar um livro novo (POST)
    Cadastrar um livro novo
    Conferir o status code    200
    Conferir o reason    OK
    Conferir se retorna todos os dados cadastradados do livro "201"

#04
Alterar um livro (PUT)
    Alterar um livro "150"
    Conferir o status code    200
    Conferir o reason    OK


#05
Deletar um livro (DELETE)
    Excluir o livro "200"
    Conferir o status code    200
    Conferir o reason   OK
#   (o response body deve ser vazio)
    Conferir se excluiu o livro "200"