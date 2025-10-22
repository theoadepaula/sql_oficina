-- DML - Data Manipulation Language
USE oficina_db;

-- ------------------------
-- CLIENTE (5 Clientes)
-- ------------------------
INSERT INTO Cliente (Nome, CPF, Telefone, Endereco) VALUES 
('João Silva', '11111111111', '31998887777', 'Rua Alfa, 100, BH'),
('Maria Santos', '22222222222', '11995554444', 'Av. Beta, 200, SP'),
('Pedro Oliveira', '33333333333', '21991112222', 'Travessa Gama, 300, RJ'),
('Ana Paula', '44444444444', '31988889999', 'Rua Delta, 400, BH'),
('Carlos Souza', '55555555555', '11977776666', 'Av. Epsilon, 500, SP');

-- ------------------------
-- VEICULO (5 Veículos)
-- ------------------------
INSERT INTO Veiculo (Placa, Marca, Modelo, Ano, FK_idCliente) VALUES 
('ABC1234', 'Fiat', 'Palio', 2010, 1), -- João
('XYZ5678', 'Chevrolet', 'Onix', 2020, 2), -- Maria
('QWE9012', 'Honda', 'Civic', 2018, 3), -- Pedro
('RTY3456', 'Fiat', 'Palio', 2005, 4), -- Ana (Veículo Antigo)
('ASD7890', 'Ford', 'Ka', 2019, 5); -- Carlos

-- ------------------------
-- MECANICO (4 Mecânicos)
-- ------------------------
INSERT INTO Mecanico (Nome, Especialidade, Endereco, Salario) VALUES 
('Marcelo Dutra', 'Motor', 'Rua A, 1', 3500.00), -- idMecanico = 1
('Paula Assis', 'Eletrica', 'Rua B, 2', 3200.00), -- idMecanico = 2
('Ricardo Neves', 'Suspensao', 'Rua C, 3', 3800.00), -- idMecanico = 3
('Felipe Gomes', 'Motor', 'Rua D, 4', 3500.00); -- idMecanico = 4

-- ------------------------
-- EQUIPE (2 Equipes)
-- ------------------------
INSERT INTO Equipe (Descricao) VALUES 
('Time A - Revisão Geral'), -- idEquipe = 1
('Time B - Reparos Pesados'); -- idEquipe = 2

-- ------------------------
-- MECANICO_EQUIPE
-- ------------------------
INSERT INTO Mecanico_Equipe (FK_idMecanico, FK_idEquipe) VALUES 
(1, 1), -- Marcelo (Motor) no Time A
(2, 1), -- Paula (Eletrica) no Time A
(3, 2), -- Ricardo (Suspensão) no Time B
(4, 2); -- Felipe (Motor) no Time B

-- ------------------------
-- TIPO DE SERVIÇO
-- ------------------------
INSERT INTO TipoServico (Descricao, ValorHora, TempoEstimadoHoras) VALUES 
('Troca de Óleo e Filtro', 80.00, 1.0),    -- idServico = 1
('Revisão Completa', 120.00, 4.0),         -- idServico = 2
('Reparo de Suspensão', 150.00, 5.0),      -- idServico = 3
('Diagnóstico Elétrico', 100.00, 2.0);    -- idServico = 4

-- ------------------------
-- PEÇA (Inventário)
-- ------------------------
INSERT INTO Peca (Descricao, ValorUnitario, QtdEstoque) VALUES 
('Óleo 5W-30', 45.00, 100),       -- idPeca = 1
('Filtro de Óleo', 20.00, 80),     -- idPeca = 2
('Pastilha de Freio', 120.00, 50), -- idPeca = 3
('Amortecedor Dianteiro', 350.00, 20); -- idPeca = 4

-- ------------------------
-- ORDEM DE SERVIÇO (4 OS)
-- ------------------------
INSERT INTO OrdemServico (DataEmissao, StatusOS, DataConclusaoEstimada, FK_idVeiculo, FK_idEquipe) VALUES 
(CURDATE(), 'Em execução', DATE_ADD(CURDATE(), INTERVAL 2 DAY), 1, 1), -- OS 1: Palio (João), Time A. (Fará 2 serviços: 1 e 2)
(CURDATE(), 'Concluída', CURDATE(), 2, 1), -- OS 2: Onix (Maria), Time A. (Fará 1 serviço: 1)
(DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Aberta', DATE_ADD(CURDATE(), INTERVAL 1 DAY), 3, 2), -- OS 3: Civic (Pedro), Time B. (Fará 1 serviço: 3)
(CURDATE(), 'Aguardando Peça', DATE_ADD(CURDATE(), INTERVAL 7 DAY), 4, 2); -- OS 4: Palio (Ana), Time B. (Fará 1 serviço: 4)

-- ------------------------
-- SERVICO_OS (Serviços aplicados a cada OS)
-- ------------------------
INSERT INTO Servico_OS (FK_idOS, FK_idServico, StatusServico) VALUES 
(1, 1, 'Em andamento'), -- OS 1: Troca de Óleo
(1, 2, 'Em andamento'), -- OS 1: Revisão Completa (Múltiplos serviços na OS 1)
(2, 1, 'Finalizado'), -- OS 2: Troca de Óleo
(3, 3, 'Em andamento'), -- OS 3: Reparo Suspensão
(4, 4, 'Em andamento'); -- OS 4: Diagnóstico Elétrico

-- ------------------------
-- PECA_OS (Peças utilizadas nas OS)
-- ------------------------
INSERT INTO Peca_OS (FK_idOS, FK_idPeca, QuantidadeUsada) VALUES 
(1, 1, 1), -- OS 1: 1 Óleo
(1, 2, 1), -- OS 1: 1 Filtro
(2, 1, 1), -- OS 2: 1 Óleo
(3, 4, 2); -- OS 3: 2 Amortecedores

-- *********************************************************************************
-- Atualização do Valor Total na OS (Este é um passo DML opcional, mas útil)
-- *********************************************************************************
-- A OS 3 tem Reparo Suspensão (5h * R$150) + 2 Amortecedores (2 * R$350)
-- Total OS 3 = R$ 750 (serviço) + R$ 700 (peças) = R$ 1450.00

UPDATE OrdemServico SET ValorTotal = 1450.00 WHERE idOS = 3;
UPDATE OrdemServico SET ValorTotal = 145.00 WHERE idOS = 2; -- Troca Óleo + Filtro
