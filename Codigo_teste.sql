USE master
GO

CREATE DATABASE teste
GO

USE teste 
GO

CREATE TABLE Alunos(
	Numero INTEGER     NOT NULL,
	Nome   VARCHAR(50) NOT NULL,
	Curso  VARCHAR(50) NOT NULL,
	PRIMARY KEY(Numero)
)

INSERT INTO Alunos (Numero, Nome, Curso)
VALUES (500, 'António', 'Engenharia Informática')

INSERT INTO Alunos (Numero, Nome, Curso)
VALUES (1000, 'Maria', 'TIC')

INSERT INTO Alunos (Numero, Nome, Curso)
VALUES (1500, 'Manuel', 'Gestão')

SELECT * FROM Alunos

CREATE TRIGGER AlunosEliminados
ON Alunos
AFTER DELETE
AS
	PRINT 'Foram apagados ' + CAST(@@ROWCOUNT AS VARCHAR) +
             ' registos'
	SELECT * FROM DELETED

DELETE FROM Alunos

CREATE TRIGGER AlunosEmMaiusculas
ON Alunos
AFTER UPDATE
AS
	IF UPDATE(Curso)
		UPDATE Alunos
		SET Nome = UPPER(Nome)
		WHERE Numero IN (SELECT Numero FROM INSERTED)

UPDATE Alunos
SET Curso = 'Engenharia Informática'
WHERE Numero = 1500

UPDATE Alunos
SET Curso = Curso

CREATE TRIGGER PrevineApagar
ON Alunos
INSTEAD OF DELETE
AS
	PRINT 'Não é permitido eliminar registos na tabela Alunos'

CREATE TRIGGER PrevineApagarCondicionado
ON Alunos
INSTEAD OF DELETE
AS
	IF EXISTS (SELECT *
		   FROM DELETED
		   WHERE Numero < 1000)
	BEGIN
		DELETE Alunos
		WHERE Numero IN (SELECT Numero
				 FROM DELETED
				 WHERE Numero >= 1000)
		PRINT 'Alguns alunos não foram apagados (Numero < 1000)'
	END
	ELSE
		DELETE Alunos
		WHERE Numero IN (SELECT Numero
				 FROM DELETED)

DELETE FROM Alunos
WHERE Numero = 1500

DELETE FROM Alunos
WHERE Numero = 500