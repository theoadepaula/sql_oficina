# Desafio DIO: Construa um Projeto Lógico de Banco de Dados do Zero

## Contexto do Desafio

Este projeto consiste na modelagem, implementação e consulta de um Banco de Dados Relacional para uma **Oficina Mecânica**. O objetivo foi aplicar as melhores práticas de Engenharia de Dados, transformando um modelo conceitual (ER) em um esquema lógico robusto (DDL) e, em seguida, desenvolver consultas analíticas complexas (DQL) que respondem a questões críticas do negócio.

O projeto foi implementado utilizando o **MySQL** e está totalmente contido na pasta `sql/`.

## Estrutura do Repositório

```
/sql_oficina
├── /sql
│   ├── schema.sql    (Criação das tabelas e constraints - DDL)
│   ├── inserts.sql   (População do banco de dados com dados de teste - DML)
│   └── queries.sql   (Consultas SQL complexas para análise - DQL)
└── README.md
```

## Modelo Lógico Implementado

O esquema relacional é composto pelas seguintes entidades principais:

| Tabela | Chave Primária | Relacionamentos Chave |
| :--- | :--- | :--- |
| **Cliente** | `idCliente` | 1:N com `Veiculo` |
| **Veiculo** | `idVeiculo` | N:1 com `Cliente`, 1:N com `OrdemServico` |
| **Mecanico** | `idMecanico` | N:M com `Equipe` |
| **Equipe** | `idEquipe` | 1:N com `OrdemServico` |
| **OrdemServico** (OS) | `idOS` | N:M com `TipoServico` e `Peca` |
| **TipoServico** | `idServico` | Catálogo de serviços |
| **Peca** | `idPeca` | Inventário de peças |

### Principais Relacionamentos (N:M)

* `Mecanico_Equipe`: Associa mecânicos a equipes.
* `Servico_OS`: Detalha quais serviços são realizados em cada OS.
* `Peca_OS`: Registra o uso de peças por Ordem de Serviço, incluindo a `QuantidadeUsada`.

## Queries SQL Analíticas (DQL)

As consultas demonstram o domínio das cláusulas obrigatórias do desafio, oferecendo visibilidade operacional para a oficina.

| Pergunta de Negócio | Cláusulas Utilizadas |
| :--- | :--- |
| **Valor total estimado de serviços por Ordem de Serviço?** | **EXPRESSÃO DERIVADA** (`SUM(ValorHora * TempoEstimado)`), `JOIN`, `GROUP BY` |
| **Quais equipes estão sobrecarregadas, tendo mais de 2 Ordens de Serviço ativas?** | **HAVING** (`COUNT > 2`), `WHERE`, `JOIN` |
| **Clientes com veículos antigos com OS aberta?** | **FILTRO** (`WHERE Ano < 2010`), `JOIN`, `ORDER BY` |
| **Qual a relação completa (serviços e peças) de uma OS específica?** | **JUNÇÕES MÚLTIPLAS**, `COALESCE` (Derivado), `CASE` |
| **Mecânicos com salário acima da média da sua especialidade?** | **SUBQUERY**, `WHERE`, `AVG` (Derivado) |
