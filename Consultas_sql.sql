-- Criação do esquema do banco de dados E-commerce

CREATE DATABASE ECommerce;
USE ECommerce;

-- Tabela de Clientes (PJ e PF)
CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL, -- Define se o cliente é PF ou PJ
    cpf_cnpj VARCHAR(14) UNIQUE, -- CPF para PF e CNPJ para PJ
    email VARCHAR(255) NOT NULL,
    telefone VARCHAR(20)
);

-- Tabela de Endereços (Relacionada a Clientes)
CREATE TABLE Enderecos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    cidade VARCHAR(100),
    estado VARCHAR(100),
    cep VARCHAR(20),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);

-- Tabela de Formas de Pagamento
CREATE TABLE FormasPagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

-- Tabela de Pedidos
CREATE TABLE Pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    forma_pagamento_id INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    status ENUM('Pendente', 'Pago', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id),
    FOREIGN KEY (forma_pagamento_id) REFERENCES FormasPagamento(id)
);

-- Tabela de Fornecedores
CREATE TABLE Fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    contato VARCHAR(255)
);

-- Tabela de Produtos
CREATE TABLE Produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    fornecedor_id INT NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT DEFAULT 0,
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(id)
);

-- Tabela de Itens de Pedido
CREATE TABLE ItensPedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);



-- Inserindo Clientes (Pessoa Física e Jurídica)
INSERT INTO Clientes (nome, tipo_cliente, cpf_cnpj, email, telefone)
VALUES ('João da Silva', 'PF', '12345678901', 'joao@email.com', '999999999'),
       ('Empresa ABC Ltda', 'PJ', '12345678000199', 'empresa@abc.com', '888888888');

-- Inserindo Endereços
INSERT INTO Enderecos (cliente_id, endereco, cidade, estado, cep)
VALUES (1, 'Rua A, 123', 'São Paulo', 'SP', '12345-678'),
       (2, 'Avenida B, 456', 'Rio de Janeiro', 'RJ', '98765-432');

-- Inserindo Formas de Pagamento
INSERT INTO FormasPagamento (descricao)
VALUES ('Cartão de Crédito'), ('Boleto Bancário'), ('PIX');

-- Inserindo Fornecedores
INSERT INTO Fornecedores (nome, contato)
VALUES ('Fornecedor A', 'contato@fornecedora.com'),
       ('Fornecedor B', 'contato@fornecedorb.com');

-- Inserindo Produtos
INSERT INTO Produtos (nome, fornecedor_id, preco, estoque)
VALUES ('Produto 1', 1, 100.00, 50),
       ('Produto 2', 2, 200.00, 30);

-- Inserindo Pedidos
INSERT INTO Pedidos (cliente_id, forma_pagamento_id, total, status, codigo_rastreio)
VALUES (1, 1, 150.00, 'Pago', 'BR123456789BR'),
       (2, 2, 400.00, 'Enviado', 'BR987654321BR');

-- Inserindo Itens de Pedido
INSERT INTO ItensPedido (pedido_id, produto_id, quantidade, preco_unitario)
VALUES (1, 1, 1, 100.00),
       (1, 2, 1, 50.00),
       (2, 2, 2, 200.00);


-- 1. Quantos pedidos foram feitos por cada cliente?

SELECT c.nome, COUNT(p.id) AS total_pedidos
FROM Clientes c
JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.nome
ORDER BY total_pedidos DESC;

-- 2. Algum vendedor também é fornecedor?
SELECT c.nome AS vendedor, f.nome AS fornecedor
FROM Clientes c
JOIN Fornecedores f ON c.nome = f.nome;

--3. Relação de produtos fornecedores e estoques

SELECT p.nome AS produto, f.nome AS fornecedor, p.estoque
FROM Produtos p
JOIN Fornecedores f ON p.fornecedor_id = f.id
ORDER BY p.estoque DESC;

-- 4. Relação de nomes dos fornecedores e nomes dos produtos
SELECT f.nome AS fornecedor, p.nome AS produto
FROM Fornecedores f
JOIN Produtos p ON f.id = p.fornecedor_id
ORDER BY f.nome, p.nome;

--5. Pedidos com total maior que 200 com filtro HAVING
SELECT p.id, c.nome, p.total
FROM Pedidos p
JOIN Clientes c ON p.cliente_id = c.id
GROUP BY p.id, c.nome
HAVING p.total > 200
ORDER BY p.total DESC;

