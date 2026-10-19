-- ============================================================
-- PROJETO: Análise operacional de uma clínica médica (ClinicaVida)
-- Banco: MySQL 8 | Schema: banco_clinica
-- Pré-requisito: rodar antes o arquivo banco_clinica.sql
-- (No DB Fiddle, remova a linha USE abaixo.)
-- ============================================================

-- ------------------------------------------------------------
-- Como estão distribuídas as consultas por status?
-- ------------------------------------------------------------
SELECT status, 
		COUNT(status) as qt_consultas
FROM banco_clinica.consultas
GROUP BY status
ORDER BY qt_consultas desc
;
-- ------------------------------------------------------------
-- Como a receita evolui mês a mês? (somente consultas realizadas)
-- ------------------------------------------------------------

SELECT DATE_FORMAT(data_consulta, '%Y-%m') AS Ano_mes,
       SUM(valor) AS receita_mensal
FROM banco_clinica.consultas
WHERE status = 'Realizada'
GROUP BY Ano_mes
ORDER BY Ano_mes
;

-- ------------------------------------------------------------
-- Quais especialidades geram mais receita?
-- ------------------------------------------------------------

SELECT e.nome as nome_especialidade, 
		SUM(c.valor) as receita
FROM banco_clinica.consultas as c
JOIN banco_clinica.medicos as m
ON c.medico_id = m.id
JOIN banco_clinica.especialidades as e
ON m.especialidade_id = e.id
WHERE c.status = "Realizada"
GROUP BY e.nome
ORDER BY receita desc
;
-- ------------------------------------------------------------
-- Quantos pacientes há por convênio?
-- ------------------------------------------------------------

SELECT COALESCE(c.nome, 'Particular') AS convenio,
       COUNT(p.id) AS qtd_pacientes
FROM banco_clinica.pacientes AS p
LEFT JOIN banco_clinica.convenios AS c 
ON p.convenio_id = c.id
GROUP BY convenio
ORDER BY qtd_pacientes DESC
;

-- ------------------------------------------------------------
-- Quais exames são mais solicitados e quanto geram de receita?
-- ------------------------------------------------------------
SELECT e.nome as nome_exame, 
		COUNT(exame_id) as qtd_solicitada, 
        SUM(e.valor) as receita_total
FROM banco_clinica.consulta_exames as c
JOIN banco_clinica.exames as e
ON c.exame_id = e.id
GROUP BY nome_exame
ORDER BY qtd_solicitada desc
;

-- ------------------------------------------------------------
-- Qual o perfil dos pacientes por faixa etária?
-- ------------------------------------------------------------

SELECT CASE
         WHEN TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) < 14 THEN 'Criança'
         WHEN TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) < 60 THEN 'Adulto'
         ELSE 'Idoso'
       END AS faixa_etaria,
       COUNT(*) AS pacientes
FROM banco_clinica.pacientes
GROUP BY faixa_etaria;

