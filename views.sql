CREATE VIEW vw_agendamentos_completo AS
SELECT 
  a.id,
  u.nome AS cliente,
  f.id AS funcionario_id,
  uf.nome AS funcionario,
  s.nome AS servico,
  sa.descricao AS sala,
  st.nome AS status,
  a.data_hora_inicio,
  a.data_hora_fim
FROM agendamento a
JOIN cliente c ON a.fkCliente = c.id
JOIN usuario u ON c.fkUsuario = u.id
JOIN funcionario f ON a.fkFuncionario = f.id
JOIN usuario uf ON f.fkUsuario = uf.id
JOIN servico s ON a.fkServico = s.id
JOIN sala sa ON a.fkSala = sa.id
JOIN status st ON a.fkStatus = st.id;


CREATE VIEW vw_faturamento AS
SELECT 
  DATE(a.data_hora_inicio) AS data,
  SUM(s.valor) AS total
FROM agendamento a
JOIN servico s ON a.fkServico = s.id
WHERE a.fkStatus = 4
GROUP BY DATE(a.data_hora_inicio);

CREATE VIEW vw_agenda_funcionario AS
SELECT 
  f.id AS funcionario_id,
  u.nome,
  af.dia_semana,
  af.hora_inicio,
  af.hora_fim
FROM funcionario f
JOIN usuario u ON f.fkUsuario = u.id
JOIN agenda_funcionario af ON af.fkFuncionario = f.id;