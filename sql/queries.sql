-- DQL - Data Query Language
-- Consultas complexas para análise de dados da Oficina

USE oficina_db;

-- --------------------------------------------------------------------------------------
-- 1. Clientes com veículos antigos (antes de 2010) e as OS abertas que possuem.
-- Requisitos: SELECT, FILTRO (WHERE), JUNÇÃO (JOIN) e ORDENAÇÃO (ORDER BY)
-- --------------------------------------------------------------------------------------
SELECT
    C.Nome AS Cliente,
    V.Marca,
    V.Modelo,
    V.Ano,
    OS.idOS AS Ordem_Servico,
    OS.StatusOS
FROM Cliente C
JOIN Veiculo V ON C.idCliente = V.FK_idCliente
LEFT JOIN OrdemServico OS ON V.idVeiculo = OS.FK_idVeiculo
WHERE V.Ano < 2010 AND OS.StatusOS = 'Aberta'
ORDER BY C.Nome;
-- Pergunta: Quais clientes têm veículos antigos (ano < 2010) e possuem Ordens de Serviço ainda abertas?


-- --------------------------------------------------------------------------------------
-- 2. Valor total estimado de serviços por Ordem de Serviço (sem contar peças).
-- Requisitos: EXPRESSÃO DERIVADA, JUNÇÃO (JOIN), AGREGAÇÃO (SUM)
-- --------------------------------------------------------------------------------------
SELECT
    OS.idOS AS Ordem_Servico,
    V.Placa,
    -- Expressão Derivada: Soma do Valor por Hora * Tempo Estimado para todos os serviços na OS
    SUM(TS.ValorHora * TS.TempoEstimadoHoras) AS Valor_Servicos_Estimado
FROM OrdemServico OS
JOIN Veiculo V ON OS.FK_idVeiculo = V.idVeiculo
JOIN Servico_OS SO ON OS.idOS = SO.FK_idOS
JOIN TipoServico TS ON SO.FK_idServico = TS.idServico
GROUP BY OS.idOS, V.Placa
ORDER BY Valor_Servicos_Estimado DESC;
-- Pergunta: Qual é o valor total estimado (apenas mão de obra) de cada Ordem de Serviço em execução?


-- --------------------------------------------------------------------------------------
-- 3. Mecânicos com salário acima da média da sua especialidade.
-- Requisitos: SUBQUERY, FILTRO (WHERE), ATRIBUTO DERIVADO (AVG)
-- --------------------------------------------------------------------------------------
SELECT
    M.Nome,
    M.Especialidade,
    M.Salario
FROM Mecanico M
WHERE M.Salario > (
    -- Subquery para calcular a média salarial da especialidade do mecânico
    SELECT AVG(M2.Salario)
    FROM Mecanico M2
    WHERE M2.Especialidade = M.Especialidade
    GROUP BY M2.Especialidade
)
ORDER BY M.Salario DESC;
-- Pergunta: Quais mecânicos têm um salário que supera a média salarial de sua própria área de especialidade?


-- --------------------------------------------------------------------------------------
-- 4. Equipes que possuem mais de 2 OS em status 'Em execução' ou 'Aguardando Peça'.
-- Requisitos: FILTRO EM GRUPOS (HAVING), JUNÇÃO (JOIN), AGREGAÇÃO (COUNT)
-- --------------------------------------------------------------------------------------
SELECT
    E.Descricao AS Equipe,
    COUNT(OS.idOS) AS OS_Em_Aberto
FROM Equipe E
JOIN OrdemServico OS ON E.idEquipe = OS.FK_idEquipe
WHERE OS.StatusOS IN ('Em execução', 'Aguardando Peça')
GROUP BY E.Descricao
HAVING OS_Em_Aberto > 2
ORDER BY OS_Em_Aberto DESC;
-- Pergunta: Quais equipes estão sobrecarregadas, tendo mais de 2 Ordens de Serviço ativas (em execução ou esperando peças)?


-- --------------------------------------------------------------------------------------
-- 5. Relação completa de serviços, peças, valores e status de uma OS específica (Ex: OS 1).
-- Requisitos: SELECT, JUNÇÕES MÚLTIPLAS, FILTRO (WHERE)
-- --------------------------------------------------------------------------------------
SELECT
    OS.idOS,
    V.Placa,
    COALESCE(TS.Descricao, P.Descricao) AS Item, -- Atributo Derivado: Nome do item (Serviço ou Peça)
    CASE 
        WHEN TS.Descricao IS NOT NULL THEN 'Serviço'
        ELSE 'Peça'
    END AS Tipo,
    COALESCE(TS.ValorHora * TS.TempoEstimadoHoras, PO.QuantidadeUsada * P.ValorUnitario) AS Valor_Subtotal
FROM OrdemServico OS
JOIN Veiculo V ON OS.FK_idVeiculo = V.idVeiculo
LEFT JOIN Servico_OS SO ON OS.idOS = SO.FK_idOS
LEFT JOIN TipoServico TS ON SO.FK_idServico = TS.idServico
LEFT JOIN Peca_OS PO ON OS.idOS = PO.FK_idOS
LEFT JOIN Peca P ON PO.FK_idPeca = P.idPeca
WHERE OS.idOS = 1;
-- Pergunta: Detalhe todos os serviços e peças utilizados na Ordem de Serviço de número 1, mostrando o subtotal de custo de cada item.
