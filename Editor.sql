USE master;

CREATE DATABASE Editor;
USE Editor;

CREATE TABLE Livro(
ISBN CHAR(17) PRIMARY KEY,
titulo VARCHAR(25) NOT NULL,
ed_numero INTEGER NOT NULL DEFAULT 1,
ed_data DATETIME NOT NULL,
ed_exemplares INTEGER NOT NULL,
preco_venda MONEY NOT NULL,
CHECK (ed_numero > 0),
CHECK (ed_exemplares >0),
CHECK (preco_venda >=0),
CHECK (ISBN LIKE '[0-9][0-9][0-9]-[0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]')
);
INSERT INTO Livro(ISBN, titulo, ed_data, ed_exemplares, preco_venda)
VALUES ('000-0-00-000000-0', 'abc', getdate(), 100, 10);
SELECT * FROM Livro;

CREATE TABLE Livreiro(
cod_livreiro INTEGER IDENTITY(1,1) PRIMARY KEY, --IDENTITY AUTO
nome VARCHAR(40) NOT NULL,
endereco VARCHAR(50) NOT NULL
)
INSERT INTO Livreiro(nome, endereco)
VALUES('Ana', 'Rua 20'),
('Joana', 'Rua 32'), ('Maria', 'Rua 2');
SELECT * FROM Livreiro;

CREATE TABLE Autor(
cod_autor INTEGER IDENTITY(1,1) PRIMARY KEY,
nome VARCHAR(15) NOT NULL,
apelido VARCHAR(15) NOT NULL,
pseudonimo VARCHAR(20)
)
INSERT INTO Autor(nome, apelido)
VALUES ('Ana', 'Silva'), ('Carlos', 'Terra');
INSERT INTO Autor(nome, apelido, pseudonimo)
VALUES ('Maria', 'Real', 'MariaGunter');
SELECT * FROM Autor;

CREATE TABLE Comprar(
cod_livreiro INTEGER NOT NULL,
ISBN CHAR(17) NOT NULL,
quantidade INTEGER NOT NULL DEFAULT 1,
data_compra DATETIME NOT NULL DEFAULT  getdate(),
CHECK (quantidade > 0),
PRIMARY KEY (cod_livreiro, ISBN, data_compra),
FOREIGN KEY (cod_livreiro) REFERENCES Livreiro(cod_livreiro),
FOREIGN KEY (ISBN) REFERENCES Livro(ISBN)
)
--DROP TABLE Comprar
SELECT * FROM Livro;
SELECT * FROM Livreiro;
SELECT * FROM Comprar;

INSERT INTO Comprar(cod_livreiro, ISBN, data_compra, quantidade)
VALUES(1,'000-0-00-000000-0', getdate(), 12),
(3,'000-0-00-000000-0', '2021/04/12', 8);

CREATE TABLE Escrever(
cod_autor INTEGER NOT NULL,
ISBN CHAR(17) NOT NULL,
royalty FLOAT NOT NULL DEFAULT 0.1,
PRIMARY KEY (cod_autor, ISBN),
FOREIGN KEY (cod_autor) REFERENCES Autor(cod_autor),
FOREIGN KEY (ISBN) REFERENCES Livro(ISBN),
CHECK (royalty >= 0 AND royalty <=1)
);
--DROP TABLE Escrever
INSERT INTO Escrever(cod_autor, ISBN, royalty)
VALUES(2,'000-0-00-000000-0', 0.2),
(3,'000-0-00-000000-0', 0.4);
SELECT * FROM Livro;
SELECT * FROM Livreiro;
SELECT * FROM Autor;
SELECT * FROM Comprar;
SELECT * FROM Escrever;

SELECT nome, pseudonimo FROM Autor
WHERE pseudonimo <> ''

SELECT nome, pseudonimo FROM Autor
WHERE pseudonimo like '%'

SELECT COUNT(*) as Numero FROM Livro

SELECT COUNT(*) as Numero FROM Autor
WHERE nome = 'Ana'

SELECT titulo, LI.nome as Livreiro FROM Livreiro LI, Livro L, Comprar C
WHERE C.ISBN = L.ISBN and C.cod_livreiro= LI.cod_livreiro
AND LI.nome = 'Ana'

SELECT DISTINCT A.nome as Autor, LI.nome as Livreiro, L.titulo
FROM Livreiro LI, Autor A, Comprar C, Escrever E, Livro L
WHERE C.cod_livreiro= LI.cod_livreiro AND LI.nome = 'Ana' 
AND A.cod_autor = E.cod_autor AND C.ISBN = L.ISBN AND E.ISBN=L.ISBN

SELECT SUM(royalty * preco_venda * C.quantidade) as Total, titulo
FROM Escrever E, Autor A, Livro L, Comprar C
WHERE A.nome = 'Maria' AND L.ISBN = C.ISBN AND L.ISBN = E.ISBN
and A.cod_autor = E.cod_autor GROUP BY titulo

SELECT ISBN, SUM (quantidade) As Total FROM Comprar GROUP BY ISBN

--SELECT L.ISBN, L.titulo FROM Livro L, 
--	(SELECT cod_livreiro, ISBN SUM (quantidade) AS Total
--	FROM Comprar Group BY cod_livreiro, ISBN) SQ1, 
--	(SELECT MAX(Total) AS Maior
--	FROM (SELECT cod_livreiro, ISBN SUM (quantidade) AS Total
--	FROM Comprar Group BY cod_livreiro, ISBN) SQ2) SQ3
--WHERE SQ1.Total = SQ3.Maior;