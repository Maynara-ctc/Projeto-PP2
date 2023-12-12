﻿CREATE DATABASE teste
USE teste
GO

create table IMOBI.Cliente (
    cpf varchar(11) primary key NOT NULL,
    nome_cliente varchar(100) NOT NULL,
    telefone varchar(11) NOT NULL,
    email varchar(100) NOT NULL
)

create table IMOBI.Funcoes (
	id_funcao int primary key Identity NOT NULL,
	nome_funcao varchar(20) NOT NULL,
)

create table IMOBI.Situacao (
	id_situacao int primary key Identity NOT NULL,
	nome_situacao varchar(12) NOT NULL
)

create table IMOBI.Imovel (
    id_imovel int primary key Identity NOT NULL,
    endereco varchar(150) NOT NULL,
    id_situacao int references IMOBI.Situacao (id_situacao) NOT NULL, 
    cpf varchar(11) references IMOBI.Cliente (cpf),
    valor_aluguel int,
    valor_compra int
)


create table IMOBI.Funcionario (
    id_funcionario int primary key Identity NOT NULL,
    nome_funcionario varchar(100) NOT NULL,
    id_funcao int references IMOBI.Funcoes (id_funcao) NOT NULL
)


create table IMOBI.Agendamentos (
    id_agendamento int primary key Identity NOT NULL,
    dataAtendimento date NOT NULL,
    cpf varchar(11) references IMOBI.Cliente (cpf),
    id_funcionario int references IMOBI.Funcionario (id_funcionario),
    id_imovel int references IMOBI.Imovel (id_imovel)
)

create table IMOBI.EnderecosClientes (
	-- serve pra endereços dos clientes e não dos imóveis
	id_endereco int primary key Identity NOT NULL, 
    cpf varchar(11) references IMOBI.Cliente (cpf),
    rua varchar(100) NOT NULL,
    numero varchar(1000) NOT NULL,
    bairro varchar(70) NOT NULL,
    cidade varchar (15) NOT NULL,
    estado varchar (2) NOT NULL
)

create table IMOBI.Contrato (
	id_contrato int primary key Identity NOT NULL,
	cpf varchar(11) references IMOBI.Cliente (cpf),
	id_imovel int references IMOBI.Imovel (id_imovel),
	id_situacao int references IMOBI.Situacao (id_situacao),
	data_contrato date NOT NULL,
	data_expiracao date -- pode ser nulo caso o imóvel tenha sido comprado e não alugado
)

-- SPs:

-- StoredProcedure armazenada para inserir um novo cliente e seu endereço

CREATE PROCEDURE InserirClienteEndereco
    @cpf varchar(11),
    @nome_cliente varchar(100),
    @telefone int,
    @email varchar(100),
    @rua varchar(100),
    @numero varchar(1000),
    @bairro varchar(70),
    @cidade varchar(15),
    @estado varchar(2)
AS
BEGIN
    BEGIN TRANSACTION;

    INSERT INTO IMOBI.Cliente (cpf, nome_cliente, telefone, email)
    VALUES (@cpf, @nome_cliente, @telefone, @email);

    DECLARE @id_cliente int;
    SET @id_cliente = SCOPE_IDENTITY();

    INSERT INTO IMOBI.EnderecosClientes(cpf, rua, numero, bairro, cidade, estado)
    VALUES (@cpf, @rua, @numero, @bairro, @cidade, @estado);

    COMMIT;
END;

-- Stored Procedure para o funcion疵io inserir um novo imel

CREATE PROCEDURE InserirImovel
    @situacao int, 
	@endereco varchar(150),
    @cpf varchar(11),
    @valor_aluguel int,
    @valor_compra int
AS
BEGIN
	INSERT INTO IMOBI.Imovel (id_situacao, endereco, cpf, valor_aluguel, valor_compra)
	VALUES (@situacao, @endereco, @cpf, @valor_aluguel, @valor_compra)
END

-- Stored Procedure para criar um novo agendamento
CREATE PROCEDURE InserirAgendamento
	@dataAtendimento date,
	@cpf varchar(11),
	@id_funcionario int,
	@id_imovel int
AS
BEGIN
	INSERT INTO IMOBI.Agendamentos (dataAtendimento, cpf, id_funcionario, id_imovel)
	VALUES (@dataAtendimento, @cpf, @id_funcionario, @id_imovel) 
END

-- Stored Procedure para criar um novo contrato
CREATE PROCEDURE InserirContrato
	@cpf varchar(11),
	@id_imovel int,
	@id_situacao int,
	@data_contrato date, -- data de inicio do contrato
	@data_expiracao date -- data de término do contrato, caso n seja pago
AS
BEGIN
	INSERT INTO IMOBI.Contrato (cpf,id_imovel,id_situacao,data_contrato,data_expiracao)
	VALUES (@cpf, @id_imovel, @id_situacao, @data_contrato, @data_expiracao) 
END

-- Triggers:

-- Trigger para atualizar a tabela situacao de um imóvel após criar contrato
-- acho q n vai ser usado, pq n consigo pensar q nosso esquema precisa de triggers

-- Views:

-- Views para exibir agendamentos com detalhes de cliente e imel

CREATE VIEW vwVerAgendamentos AS
SELECT
    A.id_agendamento,
    A.dataAtendimento,
    C.cpf AS cpf_cliente,
    C.nome_cliente,
    I.id_imovel,
    I.endereco,
    I.id_situacao
FROM
    IMOBI.Agendamentos AS A
    JOIN IMOBI.Cliente C ON A.cpf = C.cpf
    JOIN IMOBI.Imovel I ON A.id_imovel = I.id_imovel;


--Views para ver ontratos com detalhes de cliente e mel

CREATE VIEW vwVerContratos AS
SELECT
    C.id_contrato,
    C.data_contrato,
    C.data_expiracao,
    Cl.cpf AS cpf_cliente,
    Cl.nome_cliente,
    I.id_imovel,
    I.endereco
FROM
    IMOBI.Contrato C
    JOIN IMOBI.Cliente Cl ON C.cpf = Cl.cpf
    JOIN IMOBI.Imovel I ON C.id_imovel = I.id_imovel;

-- Index

-- Index para ver imovel
USE teste
GO
CREATE INDEX inImoveis
ON IMOBI.Imovel (id_imovel, endereco, id_situacao, valor_compra, valor_aluguel)

CREATE INDEX inContratos
ON IMOBI.Contrato (id_contrato, data_contrato, data_expiracao)
