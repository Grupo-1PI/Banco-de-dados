CREATE OR REPLACE VIEW vw_agendamentos_completo AS
SELECT
  a.id,

  u.nome AS cliente,

  GROUP_CONCAT(DISTINCT uf.nome ORDER BY uf.nome SEPARATOR ', ') AS funcionarios,

  GROUP_CONCAT(DISTINCT s.nome ORDER BY s.nome SEPARATOR ', ') AS servicos,

  sa.descricao AS sala,

  st.nome AS status,

  a.data_hora_inicio,
  a.data_hora_fim

FROM agendamento a

JOIN cliente c
  ON a.fkCliente = c.id

JOIN usuario u
  ON c.fkUsuario = u.id

LEFT JOIN funcionario_agendamento fa
  ON fa.fkAgendamento = a.id

LEFT JOIN funcionario f
  ON fa.fkFuncionario = f.id

LEFT JOIN usuario uf
  ON f.fkUsuario = uf.id

LEFT JOIN atendimento_servico ats
  ON ats.fkAgendamento = a.id

LEFT JOIN servico s
  ON ats.fkServico = s.id

JOIN sala sa
  ON a.fkSala = sa.id

JOIN status st
  ON a.fkStatus = st.id

GROUP BY
  a.id,
  u.nome,
  sa.descricao,
  st.nome,
  a.data_hora_inicio,
  a.data_hora_fim;

CREATE OR REPLACE VIEW vw_faturamento AS
SELECT
  DATE(a.data_hora_inicio) AS data,
  SUM(ats.valor_unitario) AS total
FROM agendamento a
JOIN atendimento_servico ats
  ON ats.fkAgendamento = a.id
WHERE a.fkStatus = 4
GROUP BY DATE(a.data_hora_inicio);

CREATE OR REPLACE VIEW vw_agenda_funcionario AS
SELECT
  f.id AS funcionario_id,
  u.nome,
  af.dia_semana,
  af.hora_inicio,
  af.hora_fim
FROM funcionario f
JOIN usuario u
  ON f.fkUsuario = u.id
JOIN agenda_funcionario af
  ON af.fkFuncionario = f.id;