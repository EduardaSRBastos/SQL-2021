use master ;
--drop database BaseDados
create database BaseDados;
use BaseDados;

create table  Morada(

CodigoPostal char(12) not null,
Endereco_Localidade varchar(20) not null,
Primary key (CodigoPostal)
);
--DROP TABLE Morada

create table Paises(

ID int not null,
Nome varchar(40) not null, 
Produtor varchar(3) not null,
Primary key (ID)
);

create table Pessoas(

CartaoCidadao char(8) not null ,
Nome varchar(40) not null ,
telefone char(9) not null ,
Endereco_Morada varchar(30) not null,
CodigoMorada char(12) not null,
Primary key (CartaoCidadao),
FOREIGN KEY (CodigoMorada) references Morada(CodigoPostal),
CHECK (CartaoCidadao LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
CHECK (telefone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

create table Vacinas(

ID int not null,
Nome varchar(40) not null,
Validade int not null, --em meses
primary key (ID)
);

create table Farmaceuticas(

ID int not null, 
Nome varchar(40) not null,
Cidade varchar(30) not null,
Primary key (ID),
);

create table Venda(

PrecoUnitario float not null,
CodigoVacina int not null primary key,
CodigoFarmaceutica int not null,
FOREIGN KEY (CodigoVacina) references Vacinas(ID),
FOREIGN KEY (CodigoFarmaceutica) references Farmaceuticas(ID),
CHECK (PrecoUnitario >= 0)
);

create table Vender(

Quantidade int not null, --bilhoes
Data_vendido date not null,
CodigoPaises int not null, 
CodigoVacina int not null,
Primary key(Data_vendido, CodigoPaises, CodigoVacina),
FOREIGN KEY (CodigoPaises) references Paises(ID),
FOREIGN KEY (CodigoVacina) references Venda(CodigoVacina),
CHECK (Quantidade > 0),
);

create table Producao(

CustoUnitario float  not null,
CodigoVacina int not null primary key,
CodigoFarmaceutica int not null,
FOREIGN KEY (CodigoVacina) references Vacinas(ID),
FOREIGN KEY (CodigoFarmaceutica) references Farmaceuticas(ID),
CHECK (CustoUnitario >= 0)
);

create table Produzidas(

Quantidade int not null, --bilhoes
data_produzido date not null,
CodigoVacina int not null,
Primary key(data_produzido, CodigoVacina),
FOREIGN KEY (CodigoVacina) references Producao (CodigoVacina),
CHECK (Quantidade > 0)
);

create table FatorRisco(

CodigoFator int not null,
nome varchar(40) not null,
Primary key(CodigoFator)

);

create table PopulacaoGeral(

Idade int not null,
CodigoPopulacao char(8) not null PRIMARY KEY,
FOREIGN KEY (CodigoPopulacao) references Pessoas(cartaoCidadao),
CHECK (Idade >= 0)
);

create table PopulacaoFatorRisco(

CodigoPopulacao char(8) not null,
CodigoFator int not null,
primary key(CodigoPopulacao, CodigoFator),
FOREIGN KEY (CodigoPopulacao) references PopulacaoGeral(CodigoPopulacao), 
FOREIGN KEY (CodigoFator) references FatorRisco (CodigoFator)
);

create table PessoalMedico(

CodigoMedico char(8) not null PRIMARY KEY,
FOREIGN KEY (CodigoMedico) references Pessoas(CartaoCidadao),
);

create table EfeitosSecundarios(

CodigoEfeito int not null,
Nome varchar(40) not null,
primary key ( CodigoEfeito)
);

create table VacinaEfeitoSecundario(

CodigoVacina int not null,
CodigoEfeito int not null,
primary key(CodigoVacina, CodigoEfeito),
FOREIGN KEY (CodigoVacina) references Vacinas(ID), 
FOREIGN KEY (CodigoEfeito) references EfeitosSecundarios(CodigoEfeito), 
);

create table TipoDeFabricacao(

ID int not null,
Nome varchar(70) not null,
Descricao varchar(1000),
primary key(ID)
);

create table Pertencer(

CodigoPaises int not null ,
CodigoPessoas char(8) not null,
primary key(CodigoPessoas),
FOREIGN KEY (CodigoPaises) references Paises(ID),
FOREIGN KEY (CodigoPessoas) references Pessoas(CartaoCidadao)
);

create table Classificar(

CodigoTipoDeFabricacao int not null, 
CodigoVacina int not null,
primary key(CodigoTipoDeFabricacao, CodigoVacina),
FOREIGN KEY (CodigoTipoDeFabricacao) references TipoDeFabricacao(ID),
FOREIGN KEY (CodigoVacina) references Vacinas(ID)
);

create table Vacinar(

Data_vacinar date not null,
CodigoPopulacao char(8) not null,
CodigoVacina int not null,
CodigoMedico char(8) not null,
primary key (Data_vacinar, CodigoVacina, CodigoPopulacao, CodigoMedico),
FOREIGN KEY (CodigoPopulacao) references PopulacaoGeral(CodigoPopulacao),
FOREIGN KEY (CodigoVacina) references Vacinas(ID),
FOREIGN KEY (CodigoMedico) references PessoalMedico(CodigoMedico)
);


INSERT INTO Morada
VALUES ('4000-500', 'Porto'),('5000-001', 'Vila Real'), ('3800-001', 'Aveiro')
SELECT * FROM Morada

INSERT INTO Paises
VALUES ('351', 'Portugal', 'Nao'),('33', 'France', 'Sim'), ('1', 'United States', 'Nao')
SELECT * FROM Paises

INSERT INTO Pessoas
VALUES ('12345678', 'Ana', '912345678','Rua 1','4000-500'),('34567891', 'Antonio', '933456789','Rua 20','3800-001'),
('45678912', 'Simao', '921234567','Avenida Gelo','5000-001'),('30029348', 'Bela', '910181019','Rua Eclipse','3800-001'),
('56029385', 'Adriano', '919158966','Viela Milagre','4000-500'), ('12093859', 'Gertrudes', '914466789','Rua Santos','5000-001'),
('20032261', 'Priyanka', '256018239','Rua da Cidade','4000-500')
--DELETE FROM Pessoas
SELECT * FROM Pessoas

INSERT INTO Vacinas
VALUES (12, 'Sarampo', 9), (23, 'Tetano', 120), (9, 'VHB', 6)
SELECT * FROM Vacinas

INSERT INTO Farmaceuticas
VALUES (12, 'Johnson & Johnson', 'New Jersey'), (56, 'Sanofi ', 'Isle of France'), (110, 'Bial ', 'Trofa')
SELECT * FROM Farmaceuticas

INSERT INTO Venda
VALUES (11.64, 9, 12), (17.94, 12, 56), (4.27, 23, 110)
SELECT * FROM Venda

INSERT INTO Vender
VALUES (2, '2015-03-20', 1, 9), (10, '2016-05-12', 33, 12),(5, '2016-10-04', 1, 9),(20, '2021-05-21', 351, 23)
SELECT * FROM Vender

INSERT INTO Producao
VALUES (25.59, 9, 56),(10.40, 23, 12),(19.90, 12, 110)
SELECT * FROM Producao

INSERT INTO Produzidas
VALUES (12, '2014-05-10', 12), (56, '2015-06-25', 9), (110, '2020-04-01', 23), (12, '2015-10-07', 9)
SELECT * FROM Produzidas

INSERT INTO FatorRisco
VALUES (2, 'Amarelo'), (1, 'Verde'), (3, 'Vermelho')
SELECT * FROM FatorRisco

INSERT INTO PopulacaoGeral
VALUES (34, 12345678), (19, 30029348), (15, 56029385), (58, 12093859)		
SELECT * FROM PopulacaoGeral

INSERT INTO PopulacaoFatorRisco
VALUES (12345678, 2), (30029348, 1), (12093859, 3), (56029385, 1)
SELECT * FROM PopulacaoFatorRisco

INSERT INTO PessoalMedico
VALUES (34567891), (45678912), (20032261)
SELECT * FROM PessoalMedico

INSERT INTO EfeitosSecundarios
VALUES (1,'febre'), (2,'vomito'), (3,'cansaco'), (4,'dor'), (5,'nausea')
SELECT * FROM EfeitosSecundarios

INSERT INTO VacinaEfeitoSecundario
VALUES (9, 4), (9, 5), (9, 2), (9, 1), (12, 1), (12, 2), (12, 3), (23,1), (23, 2), (23, 4), (23, 3)
SELECT * FROM VacinaEfeitoSecundario

INSERT INTO TipoDeFabricacao
VALUES (1, 'Enfraquecimento Microrganismo', 'Enfraquecimento do microrganismo através de culturas sucessivas.'), 
(2, 'Enfraquecimento Toxina', 'Enfraquecimento da toxina que o microrganismo produz.'),
(3, 'Extração Partes Microrganismo', 'Extração das partes do microrganismo que desencadeiam a resposta imunitária.')
SELECT * FROM TipoDeFabricacao

INSERT INTO Pertencer
VALUES (1, 20032261), (33, 56029385), (351, 34567891), (351, 12093859), (351, 12345678), (1, 30029348), (351, 45678912)
SELECT * FROM Pertencer

INSERT INTO Classificar
VALUES (3, 9), (1, 12), (2, 23)
SELECT * FROM Classificar

INSERT INTO Vacinar
VALUES ('2016-12-23', 12093859, 23, 20032261), ('2016-01-06', 12345678, 9, 34567891), ('2016-10-14', 30029348, 12, 20032261),
('2021-05-02', 56029385, 12, 45678912), ('2016-05-23', 56029385, 23, 45678912), ('2021-05-15', 56029385, 9, 45678912), ('2021-05-6', 12093859, 12, 20032261)
SELECT * FROM Vacinar

--Que farmacêutica produziu a vacina mais recente? [FarmaceuticaNome, VacinaNome, Data]
SELECT Farmaceuticas.Nome as Farmaceutica, Vacinas.Nome as Vacina, Produzidas.data_produzido
FROM Produzidas, Farmaceuticas, Vacinas, Producao
WHERE Produzidas.CodigoVacina = Producao.CodigoVacina and Producao.CodigoFarmaceutica=Farmaceuticas.ID and Producao.CodigoVacina = Vacinas.ID
AND data_produzido = (SELECT MAX(data_produzido) FROM Produzidas)

--Quantas vacinas produziu cada farmacêutica nos últimos 3 anos? [FarmaceuticaNome, N_Vacinas]
SELECT Farmaceuticas.Nome as Farmaceutica, Sum(Produzidas.Quantidade) as N_Vacina 
FROM Produzidas, Farmaceuticas, Producao
WHERE Produzidas.CodigoVacina=Producao.CodigoVacina and Producao.CodigoFarmaceutica = Farmaceuticas.ID 
and Produzidas.data_produzido >= (select dateadd(yy,-3,getdate()))
group by Farmaceuticas.Nome

--Quais as duas primeiras Pessoas vacinadas em 2016? [Pessoas (nome), Vacina (nome), Data]
SELECT Pessoas.Nome as Nomes, Vacinas.Nome as Vacinas, vacinar.Data_vacinar as datas
from Pessoas, Vacinas, vacinar
where Pessoas.CartaoCidadao = vacinar.CodigoPopulacao and Vacinas.ID=vacinar.CodigoVacina and
(select datepart(year,vacinar.Data_vacinar)) = 2016 and (vacinar.Data_vacinar = (select min(vacinar.Data_vacinar)from vacinar)
or vacinar.Data_vacinar = (select min(vacinar.Data_vacinar)from vacinar where vacinar.Data_vacinar != (select min(vacinar.Data_vacinar)from vacinar )))

--Quais as pessoas com mais de 2 vacinas tomadas nos últimos 30 dias? Ordene-as alfabeticamente. [Pessoa (nome), N_Vacinas]
select Pessoas.Nome as Nome, count(vacinar.Data_vacinar) as N_Vacinas
from Pessoas, vacinar
where Pessoas.CartaoCidadao = vacinar.CodigoPopulacao  and vacinar.Data_vacinar >= (select dateadd(day,-30,getdate()))
group by Pessoas.Nome
having COUNT(vacinar.Data_vacinar)>=2

--Quais os dois países registados com menos pessoas? [Paises (nome), N_Pessoas]
select top 2 Paises.Nome as Nomes, count(Pertencer.CodigoPessoas) as N_Pessoas
from Paises, Pessoas, Pertencer
where Pertencer.CodigoPessoas = Pessoas.CartaoCidadao and Pertencer.CodigoPaises = Paises.ID
group by Paises.Nome
order by count(Pertencer.CodigoPessoas) asc

--Quais os tipos de fabricação de cada vacina? Ordene-os pelo nome das vacinas e pelo nome do tipo de fabricação. 
--[Vacina(Nome), Tipo de Fabricação (nome)]

select Vacinas.Nome as Nome_V, TipoDeFabricacao.Nome as Fabricação
from Vacinas, TipoDeFabricacao, Classificar
where Vacinas.ID = Classificar.CodigoVacina and TipoDeFabricacao.ID = Classificar.CodigoTipoDeFabricacao
order by Vacinas.Nome, TipoDeFabricacao.Nome desc

--Qual o valor total das vendas realizadas por cada farmaceutica no ano de 2016? Ordene-os pelo valor obtido do maior para o menor. 
--[Farmaceutica (Nome), Total_Vendas]
select Farmaceuticas.Nome as Nomes, sum(Vender.Quantidade) as Total_Vendas
from Farmaceuticas, Vender, venda
where Farmaceuticas.ID = Venda.CodigoFarmaceutica and Vender.CodigoVacina = venda.CodigoVacina and
(select datepart(year,Vender.Data_vendido)) = 2016
group by Farmaceuticas.Nome
order by sum(Vender.Quantidade) desc

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Crie um procedimento que, dados o telefone de uma Pessoa e o nome de uma vacina, verifique se a pessoa alguma vez tomou aquela vacina. 
--Em caso afirmativo apresente a lista das datas em que esta pessoa tomou esta vacina. 
CREATE PROC CheckVacina 
			@telefone char(9),
			@Nome varchar(40)
as
			if exists(select *
			from Pessoas, Vacinar, Vacinas
			where @telefone = Pessoas.telefone and @nome = vacinas.Nome 
			and Vacinar.CodigoPopulacao = Pessoas.CartaoCidadao and Vacinar.CodigoVacina = Vacinas.ID)
			begin
				select Vacinar.Data_vacinar
				from Pessoas, Vacinar, Vacinas
				where @telefone = Pessoas.telefone and @nome = vacinas.Nome 
				and Vacinar.CodigoPopulacao = Pessoas.CartaoCidadao and Vacinar.CodigoVacina = Vacinas.ID
			end
			else
				print 'A pessoa nunca tomou essa vacina'
--drop proc CheckVacina

execute CheckVacina '910181019', 'sarampo' 

--Assumindo que para cada vacina vendida a respetiva farmacêutica recebe 10% da venda  para  um  país  produtor  e  15%  da  venda  nos  restantes  países,  
--crie  um procedimento que, dado o ID de uma vacina, devolva quanto a Farmacêutica já ganhou com a mesma. 
CREATE PROC Moneycheck
			@ID int
as 
			declare cursor_total cursor
			for	select Paises.Produtor , Vender.Quantidade, Venda.PrecoUnitario
				from Paises, Farmaceuticas, Vender, Venda
				where Vender.CodigoPaises = Paises.ID and Venda.CodigoFarmaceutica = Farmaceuticas.ID and Venda.CodigoVacina = @id and Vender.CodigoVacina = @id
				and Venda.CodigoFarmaceutica = Farmaceuticas.ID
			declare @produtor varchar(3), @quantidade int, @preco float, @precototal float
			set @precototal = 0
			open cursor_total
			fetch next from cursor_total into @produtor, @quantidade, @preco
			IF (@@FETCH_STATUS = -1)
			BEGIN
				PRINT 'Nao foram encontrados valores'
				CLOSE cursor_total
				DEALLOCATE cursor_total
				RETURN
			END
			while (@@FETCH_STATUS = 0)
			begin
				if @produtor = 'Sim'
					set @preco = @preco * 0.10
				if @produtor = 'Nao'
					set @preco = @preco * 0.15
				set @precototal = @precototal + @preco * @quantidade
				fetch next from cursor_total into @produtor, @quantidade, @preco
			end
			close cursor_total
			deallocate cursor_total
			print (@precototal)
			return @precototal
--drop proc Moneycheck
execute Moneycheck 23

--Crie um trigger que previna que se insira um registo no relacionamento Vacinar caso a Vacina a administrar já tenha passado do prazo de validade.
create trigger VacinarValidade
on Vacinar
instead of insert
as
begin
	declare cursor_validade cursor local
	for select inserted.Data_vacinar, inserted.CodigoVacina from inserted
	declare	@id int,
			@date date,
			@validade int,
			@dataVacinar date
	open cursor_validade
	fetch next from cursor_validade into @dataVacinar, @id
	IF (@@FETCH_STATUS = -1)
	BEGIN
		PRINT 'Nao foram encontrados valores'
		CLOSE cursor_validade
		DEALLOCATE cursor_validade
		RETURN
	END
	while (@@FETCH_STATUS = 0)
	begin
		set @date = (select top 1 Produzidas.data_produzido
				from Produzidas
				where Produzidas.CodigoVacina = @id
				order by Produzidas.data_produzido desc)

		set @validade =(select  Vacinas.Validade
					from Vacinas
					where Vacinas.ID = @id)

		set @date = dateadd(MONTH,@validade,@date)

		if @date >= @dataVacinar 
		begin
			--insert into Vacinar default values 
			print 'possivel'
		end
		else
		begin
			print 'Não é possivel vacinar'
		end
		fetch next from cursor_validade into @dataVacinar, @id
	end
end

--drop trigger VacinarValidade
INSERT INTO Vacinar
VALUES ('2015-12-23', 56029385, 9, 20032261), (GETDATE(), 56029385, 23, 20032261)

