-- DDL - Data Definition Language
-- Criação do esquema de banco de dados para o cenário de Oficina Mecânica (MySQL)

DROP DATABASE IF EXISTS oficina_db;
CREATE DATABASE oficina_db;
USE oficina_db;

-- --------------------------------------------------------
-- 1. TABELA CLIENTE
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF CHAR(11) UNIQUE NOT NULL,
    Telefone VARCHAR(15),
    Endereco VARCHAR(255)
);

-- --------------------------------------------------------
-- 2. TABELA VEICULO
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    Placa CHAR(7) UNIQUE NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    Ano INT,
    FK_idCliente INT NOT NULL,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (FK_idCliente) REFERENCES Cliente(idCliente)
);

-- --------------------------------------------------------
-- 3. TABELA MECANICO
CREATE TABLE Mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Especialidade ENUM('Motor', 'Eletrica', 'Suspensao', 'Freios', 'Funilaria') NOT NULL,
    Endereco VARCHAR(255),
    Salario DECIMAL(10, 2)
);

-- --------------------------------------------------------
-- 4. TABELA EQUIPE (Agrupamento de Mecânicos)
CREATE TABLE Equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(100) NOT NULL
);

-- --------------------------------------------------------
-- 5. TABELA DE RELACIONAMENTO MECANICO_EQUIPE (N:M)
CREATE TABLE Mecanico_Equipe (
    FK_idMecanico INT NOT NULL,
    FK_idEquipe INT NOT NULL,
    PRIMARY KEY (FK_idMecanico, FK_idEquipe),
    CONSTRAINT fk_me_mecanico FOREIGN KEY (FK_idMecanico) REFERENCES Mecanico(idMecanico),
    CONSTRAINT fk_me_equipe FOREIGN KEY (FK_idEquipe) REFERENCES Equipe(idEquipe)
);

-- --------------------------------------------------------
-- 6. TABELA ORDEM DE SERVIÇO (OS)
CREATE TABLE OrdemServico (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    DataEmissao DATE NOT NULL,
    ValorTotal DECIMAL(10, 2) DEFAULT 0.00,
    StatusOS ENUM('Aberta', 'Em execução', 'Aguardando Peça', 'Concluída', 'Cancelada') DEFAULT 'Aberta',
    DataConclusaoEstimada DATE,
    FK_idVeiculo INT NOT NULL,
    FK_idEquipe INT NOT NULL,
    CONSTRAINT fk_os_veiculo FOREIGN KEY (FK_idVeiculo) REFERENCES Veiculo(idVeiculo),
    CONSTRAINT fk_os_equipe FOREIGN KEY (FK_idEquipe) REFERENCES Equipe(idEquipe)
);

-- --------------------------------------------------------
-- 7. TABELA TIPO DE SERVIÇO
CREATE TABLE TipoServico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(100) NOT NULL,
    ValorHora DECIMAL(10, 2) NOT NULL,
    TempoEstimadoHoras FLOAT NOT NULL
);

-- --------------------------------------------------------
-- 8. TABELA DE RELACIONAMENTO SERVICO_OS (N:M)
CREATE TABLE Servico_OS (
    FK_idOS INT NOT NULL,
    FK_idServico INT NOT NULL,
    PRIMARY KEY (FK_idOS, FK_idServico),
    StatusServico ENUM('Em andamento', 'Finalizado') DEFAULT 'Em andamento',
    DataInicio DATETIME,
    DataFim DATETIME,
    CONSTRAINT fk_so_os FOREIGN KEY (FK_idOS) REFERENCES OrdemServico(idOS),
    CONSTRAINT fk_so_servico FOREIGN KEY (FK_idServico) REFERENCES TipoServico(idServico)
);

-- --------------------------------------------------------
-- 9. TABELA PEÇA (Inventário)
CREATE TABLE Peca (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(100) NOT NULL,
    ValorUnitario DECIMAL(10, 2) NOT NULL,
    QtdEstoque INT DEFAULT 0
);

-- --------------------------------------------------------
-- 10. TABELA DE RELACIONAMENTO PECA_OS (N:M)
CREATE TABLE Peca_OS (
    FK_idOS INT NOT NULL,
    FK_idPeca INT NOT NULL,
    PRIMARY KEY (FK_idOS, FK_idPeca),
    QuantidadeUsada INT NOT NULL,
    CONSTRAINT fk_po_os FOREIGN KEY (FK_idOS) REFERENCES OrdemServico(idOS),
    CONSTRAINT fk_po_peca FOREIGN KEY (FK_idPeca) REFERENCES Peca(idPeca)
);
