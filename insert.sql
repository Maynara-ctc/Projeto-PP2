insert into IMOBI.Cliente
(cpf, nome_cliente, telefone, email)
values
(12345678911, 'Joao', '19999999999', 'joao@gmail.com')

INSERT INTO IMOBI.Funcoes
(nome_funcao)
VALUES ('Dono'), ('Atendente')

INSERT INTO IMOBI.Situacao
(nome_situacao)
VALUES ('Venda'), ('Aluguel'), ('Vendido'), ('Alugado'), ('Indisponível')

INSERT INTO IMOBI.Imovel 
(endereco, id_situacao, valor_aluguel, valor_compra)
VALUES 
('Rua A n.1 Bairro A', 1, 3000, 10000),
('Rua B n.2 Bairro B', 2, 1000, 5000),
('Rua C n.3 Bairro C', 3, 2000, null), 
('Rua D, n.4 Bairro D', 4, 15000, null),
('Rua E, n.5 Bairro E', 5, null, null)

INSERT INTO IMOBI.Funcionario 
(nome_funcionario, id_funcao)
VALUES
('Fernando da Silva', 1),
('Maria dos Santos', 2)

INSERT INTO IMOBI.EnderecosClientes
(cpf, rua, numero, bairro, cidade, estado)
VALUES 
(12345678911, 'Rua Manuel da Nobrega', 1065, 'Vila Mariana', 'São Paulo', 'São Paulo')