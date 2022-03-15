use master;

CREATE DATABASE Biblioteca;
USE Biblioteca;

CREATE TABLE Aluno(
	numero INTEGER NOT NULL, -- PRIMARY KEY
	nome VARCHAR(30) NOT NULL,
	garantia MONEY NOT NULL DEFAULT 0,
	end_morada VARCHAR(50) NOT NULL,
	end_cp VARCHAR(8) NOT NULL,
	end_localidade VARCHAR(20) NOT NULL
	PRIMARY KEY(numero),
	CHECK (garantia >= 0)
);
--DROP TABLE Aluno;
CREATE TABLE Livro(
	numero INTEGER NOT NULL,
	titulo VARCHAR(30) NOT NULL,
	autor VARCHAR(30) NOT NULL,
	editor VARCHAR(20) NOT NULL,
	data_compra DATE NOT NULL,
	estado BIT NOT NULL DEFAULT 0,
	PRIMARY KEY (numero)
);

CREATE TABLE Emprestimo(
	num_aluno INT NOT NULL,
	num_livro INT NOT NULL,
	data_req DATE NOT NULL DEFAULT GETDATE(),
	data_ent DATE,
	PRIMARY KEY (num_aluno, num_livro, data_req),
	FOREIGN KEY (num_aluno) REFERENCES Aluno (numero),
	FOREIGN KEY (num_livro) REFERENCES Livro (numero),
	CHECK (data_ent > data_req)
);

SELECT * FROM Aluno;
INSERT INTO Aluno(numero, nome, garantia, end_morada, end_cp, end_localidade)
VALUES (12, 'João Pedro', 10, 'Morada 1', '5000-001', 'Vila Real'),
	(12345, 'Nome do Aluno 2', 10, 'Morada 2', '5000-001', 'Vila Real')

DELETE FROM Aluno
WHERE numero = 12346

UPDATE Aluno
SET garantia = 15
WHERE numero =12345
SELECT * FROM Aluno;

INSERT INTO Livro(numero, titulo, autor, editor, data_compra, estado)
VALUES (3200, 'Livroide', 'Manuel', 'Editor 1', '2021/04/15',1)

INSERT INTO Livro(numero, titulo, autor, editor, data_compra, estado)
VALUES (300, 'Livroide 5', 'Manuel A', 'Editor 5', '2021/04/25',0)
SELECT * FROM Livro;

INSERT INTO Emprestimo (num_aluno, num_livro, data_req)
VALUES (12345, 3200, '2021/04/20')
SELECT *FROM Emprestimo;
SELECT * FROM Livro;
SELECT * FROM Aluno;

INSERT INTO Emprestimo (num_aluno, num_livro, data_req)
VALUES (12345, 300, '2021/04/25')

INSERT INTO Emprestimo (num_aluno, num_livro, data_req)
VALUES (12, 300, '2021/04/15')

SELECT * FROM Aluno
WHERE nome LIKE 'João%'

SELECT * FROM Aluno WHERE garantia >= 10

SELECT * FROM Livro

SELECT titulo FROM Livro WHERE autor = 'Manuel'

SELECT estado, titulo FROM Livro WHERE titulo like '%Livroide%'

SELECT SUM(garantia) FROM Aluno

SELECT titulo FROM Livro L, Aluno A, Emprestimo E
WHERE A.nome = 'João Pedro' AND E.num_aluno = A.numero AND E.num_livro = L.numero

SELECT COUNT(*) as Total FROM Emprestimo E
WHERE data_req = '2021/04/20'

SELECT COUNT(*) as Quantidade FROM Emprestimo
WHERE DATEDIFF(DAY, data_req,GETDATE()) >= 5

SELECT  data_req, titulo FROM Emprestimo, Livro
WHERE num_livro = numero AND data_req= (SELECT MIN(data_req) FROM Emprestimo)

SELECT  MIN(data_req) as Primeiro FROM Emprestimo, Livro
WHERE num_livro = numero 

CREATE PROCEDURE setEstado (@codLivro INTEGER, @estado BIT)
AS
BEGIN
	UPDATE Livro
	SET Estado = @estado
	WHERE Numero = @codLivro
END
SELECT * FROM Livro
EXECUTE setEstado 300, 1

CREATE PROCEDURE checkEstado (@codLivro INTEGER)
AS
BEGIN
SELECT Estado FROM Livro WHERE numero = @codLivro
END
EXECUTE checkEstado 300

--DROP PROCEDURE Verifica
CREATE PROCEDURE Verifica (@numero INTEGER, @NUMLIV INTEGER)
AS
BEGIN
DECLARE @ESTADO INTEGER
EXECUTE @ESTADO = checkEstado @NUMLIV
IF(@ESTADO = 1)
BEGIN
	PRINT('LIVRO JA REQUISITADO')
	RETURN -1
END
DECLARE @numReq INTEGER
SELECT @numReq = COUNT(E.num_livro) FROM Aluno, Emprestimo E
WHERE numero = @numero AND numero = E.num_aluno AND E.data_ent != NULL

SELECT @numReq = (FLOOR (garantia/5) - @numReq)
FROM Aluno WHERE numero = @numero RETURN @numReq
END
DECLARE @NREQ INTEGER
EXECUTE @NREQ = Verifica 12
PRINT @NREQ

