INSERT INTO permissoes_cargo VALUES
(1, 1),
(2, 1),
(3, 1),
(2, 2),
(3, 3);

INSERT INTO status (nome) VALUES
('Agendado'),
('Confirmado'),
('Cancelado'),
('Finalizado');

INSERT INTO sala (descricao) VALUES
('Sala 1'),
('Sala 2'),
('Sala Online');

INSERT INTO especialidade (nome) VALUES
('Dor muscular'),
('Ansiedade'),
('Insônia');

INSERT INTO servico (nome, valor, descricao, tempoMedio) VALUES
('Sessão de Acupuntura', 120.00, 'Sessão padrão', 60),
('Auriculoterapia', 80.00, 'Tratamento auricular', 40);

INSERT INTO especialidade_servico VALUES
(1, 1),
(2, 1),
(3, 1),
(2, 2);