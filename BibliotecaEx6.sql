USE master;
USE Biblioteca;

--quais alunos inscritos
SELECT numero, nome FROM Aluno;

--aluno com nome começado por 'joão'
SELECT numero, nome FROM Aluno
WHERE nome LIKE 'João%'

--aluno com nome contém '2'
SELECT numero, nome FROM Aluno
WHERE nome LIKE '%2%'

--nome aluno com garantia >= 10€
SELECT nome, garantia FROM Aluno
WHERE (garantia >= 10)

--nome aluno com garantia entre 5 e 10€
SELECT nome, garantia FROM Aluno
WHERE (garantia BETWEEN 5 AND 10)

--livros existentes
SELECT * FROM Livro

--titulo escrito pelo autor 'manuel antonio'
SELECT Titulo, Autor FROM Livro
WHERE autor LIKE 'Manuel António'

--titulo escrito pelo autor 'manuel'
SELECT Titulo, Autor FROM Livro
WHERE autor = 'Manuel'

--estado que contem como titulo 'base de dados'
SELECT Titulo, estado FROM Livro
WHERE titulo LIKE '%base de dados%'

--valor total garantias
SELECT SUM(garantia) AS TotalGarantia FROM Aluno

--alterar nome coluna
SELECT numero AS 'Numero', nome AS 'Nome dos Alunos' FROM Aluno

--livros requisitados pelo 'joao pedro'
SELECT titulo, nome FROM Emprestimo, Livro, Aluno
WHERE nome = 'João Pedro' 
AND aluno.numero = num_aluno AND num_livro = livro.numero

--livros requisitados pelo '%1'
SELECT titulo, nome FROM Emprestimo E, Livro L, Aluno A
WHERE nome LIKE '%1' 
AND A.numero = num_aluno AND L.numero = num_livro  

--num livros requisitados em '2021-04-15'
SELECT COUNT(num_livro) AS SomaLivros
FROM Emprestimo
WHERE data_req LIKE '2021-04-15%'

--num livros requisitados mais de 5 dias
SELECT COUNT(num_livro) AS LivrosEmprest5Dias
FROM Emprestimo
WHERE DATEDIFF(DAY, data_req, GETDATE()) > 5

--num livros requisitados pelo 12345
SELECT COUNT(num_livro) AS LivrosReq12345
FROM Emprestimo
WHERE num_aluno=12345

--num livros diferentes requisitados
SELECT COUNT(DISTINCT(num_livro)) AS LivrosReq
FROM Emprestimo

--primeiro livro requisitado
SELECT titulo
FROM Emprestimo, Livro
WHERE num_livro = numero
AND data_req = (SELECT MIN(data_req) FROM EMPRESTIMO)