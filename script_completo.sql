CREATE DATABASE IF NOT EXISTS taotenshin;
USE taotenshin;

CREATE TABLE IF NOT EXISTS cargo (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS endereco (
  id INT NOT NULL AUTO_INCREMENT,
  cep VARCHAR(9) NOT NULL,
  logradouro VARCHAR(120) NOT NULL,
  bairro VARCHAR(80) NOT NULL,
  cidade VARCHAR(80) NOT NULL,
  uf VARCHAR(2) NOT NULL,
  numero VARCHAR(10) NOT NULL,
  complemento VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS usuario (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(120) NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  email VARCHAR(120) NOT NULL,
  senha VARCHAR(255) NOT NULL,
  data_nascimento DATE NOT NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  fkEndereco INT NOT NULL,

  PRIMARY KEY (id),

  INDEX fk_usuario_endereco1_idx (fkEndereco ASC) VISIBLE,
  UNIQUE INDEX email_UNIQUE (email ASC) VISIBLE,

  CONSTRAINT fk_usuario_endereco1
    FOREIGN KEY (fkEndereco)
    REFERENCES endereco (id)
);

CREATE TABLE IF NOT EXISTS funcionario (
  id INT NOT NULL AUTO_INCREMENT,
  fkUsuario INT NOT NULL,
  fkCargo INT NOT NULL,

  PRIMARY KEY (id, fkUsuario),

  INDEX fkCargo (fkCargo ASC) VISIBLE,
  INDEX fk_funcionario_usuario1_idx (fkUsuario ASC) VISIBLE,

  CONSTRAINT funcionario_ibfk_1
    FOREIGN KEY (fkCargo)
    REFERENCES cargo (id),

  CONSTRAINT fk_funcionario_usuario1
    FOREIGN KEY (fkUsuario)
    REFERENCES usuario (id)
);

CREATE TABLE IF NOT EXISTS agenda_excecao (
  id INT NOT NULL AUTO_INCREMENT,
  fkFuncionario INT NOT NULL,
  data DATE NOT NULL,
  hora_inicio TIME NULL DEFAULT NULL,
  hora_fim TIME NULL DEFAULT NULL,
  disponivel TINYINT(1) NULL DEFAULT '1',

  PRIMARY KEY (id),

  INDEX fkFuncionario (fkFuncionario ASC) VISIBLE,

  CONSTRAINT agenda_excecao_ibfk_1
    FOREIGN KEY (fkFuncionario)
    REFERENCES funcionario (id)
);

CREATE TABLE IF NOT EXISTS agenda_funcionario (
  id INT NOT NULL AUTO_INCREMENT,
  fkFuncionario INT NOT NULL,
  dia_semana INT NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,

  PRIMARY KEY (id),

  INDEX fkFuncionario (fkFuncionario ASC) VISIBLE,

  CONSTRAINT agenda_funcionario_ibfk_1
    FOREIGN KEY (fkFuncionario)
    REFERENCES funcionario (id)
);

CREATE TABLE IF NOT EXISTS cliente (
  id INT NOT NULL AUTO_INCREMENT,
  fkUsuario INT NOT NULL,
  observacao VARCHAR(255) NULL DEFAULT NULL,

  PRIMARY KEY (id, fkUsuario),

  INDEX fk_cliente_usuario1_idx (fkUsuario ASC) VISIBLE,

  CONSTRAINT fk_cliente_usuario1
    FOREIGN KEY (fkUsuario)
    REFERENCES usuario (id)
);

CREATE TABLE IF NOT EXISTS sala (
  id INT NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(45) NULL DEFAULT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS status (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS agendamento (
  id INT NOT NULL AUTO_INCREMENT,
  data_hora_inicio DATETIME NOT NULL,
  data_hora_fim DATETIME NOT NULL,
  observacao VARCHAR(255) NULL DEFAULT NULL,
  fkCliente INT NOT NULL,
  fkSala INT NOT NULL,
  fkStatus INT NOT NULL,

  PRIMARY KEY (id),

  INDEX fkCliente (fkCliente ASC) VISIBLE,
  INDEX fkSala (fkSala ASC) VISIBLE,
  INDEX fk_agendamento_status1_idx (fkStatus ASC) VISIBLE,

  CONSTRAINT agendamento_ibfk_1
    FOREIGN KEY (fkCliente)
    REFERENCES cliente (id),

  CONSTRAINT agendamento_ibfk_3
    FOREIGN KEY (fkSala)
    REFERENCES sala (id),

  CONSTRAINT fk_agendamento_status1
    FOREIGN KEY (fkStatus)
    REFERENCES status (id)
);

CREATE TABLE IF NOT EXISTS funcionario_agendamento (
  fkFuncionario INT NOT NULL,
  fkAgendamento INT NOT NULL,

  PRIMARY KEY (fkFuncionario, fkAgendamento),

  INDEX fk_funcionario_agendamento_funcionario_idx (fkFuncionario ASC) VISIBLE,
  INDEX fk_funcionario_agendamento_agendamento_idx (fkAgendamento ASC) VISIBLE,

  CONSTRAINT fk_funcionario_agendamento_funcionario
    FOREIGN KEY (fkFuncionario)
    REFERENCES funcionario (id),

  CONSTRAINT fk_funcionario_agendamento_agendamento
    FOREIGN KEY (fkAgendamento)
    REFERENCES agendamento (id)
);

CREATE TABLE IF NOT EXISTS servico (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  tempoMedio INT NULL DEFAULT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS atendimento_servico (
  id INT NOT NULL AUTO_INCREMENT,
  valor_unitario DECIMAL(10,2) NOT NULL,
  fkServico INT NOT NULL,
  fkAgendamento INT NOT NULL,
  descricao VARCHAR(255) NULL DEFAULT NULL,
  observacoes VARCHAR(255) NULL DEFAULT NULL,

  PRIMARY KEY (id),

  INDEX fkServico (fkServico ASC) VISIBLE,
  INDEX fk_atendimento_servico_agendamento1_idx (fkAgendamento ASC) VISIBLE,

  CONSTRAINT atendimento_servico_ibfk_2
    FOREIGN KEY (fkServico)
    REFERENCES servico (id),

  CONSTRAINT fk_atendimento_servico_agendamento1
    FOREIGN KEY (fkAgendamento)
    REFERENCES agendamento (id)
);

CREATE TABLE IF NOT EXISTS especialidade (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(60) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS especialidade_servico (
  fkEspecialidade INT NOT NULL,
  fkServico INT NOT NULL,

  PRIMARY KEY (fkEspecialidade, fkServico),

  INDEX fkServico (fkServico ASC) VISIBLE,

  CONSTRAINT especialidadeservico_ibfk_1
    FOREIGN KEY (fkEspecialidade)
    REFERENCES especialidade (id),

  CONSTRAINT especialidadeservico_ibfk_2
    FOREIGN KEY (fkServico)
    REFERENCES servico (id)
);

CREATE TABLE IF NOT EXISTS funcionario_especialidade (
  fkFuncionario INT NOT NULL,
  fkEspecialidade INT NOT NULL,

  PRIMARY KEY (fkFuncionario, fkEspecialidade),

  INDEX fkEspecialidade (fkEspecialidade ASC) VISIBLE,

  CONSTRAINT funcionario_especialidade_ibfk_1
    FOREIGN KEY (fkFuncionario)
    REFERENCES funcionario (id),

  CONSTRAINT funcionario_especialidade_ibfk_2
    FOREIGN KEY (fkEspecialidade)
    REFERENCES especialidade (id)
);

CREATE TABLE IF NOT EXISTS permissoes (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(45) NOT NULL,
  descricao VARCHAR(45) NOT NULL,

  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS permissoes_cargo (
  fkPermissoes INT NOT NULL,
  fkCargo INT NOT NULL,

  PRIMARY KEY (fkPermissoes, fkCargo),

  INDEX fkCargo (fkCargo ASC) VISIBLE,

  CONSTRAINT permissoescargo_ibfk_1
    FOREIGN KEY (fkPermissoes)
    REFERENCES permissoes (id),

  CONSTRAINT permissoescargo_ibfk_2
    FOREIGN KEY (fkCargo)
    REFERENCES cargo (id)
);

CREATE TABLE IF NOT EXISTS sala_servico (
  fkSala INT NOT NULL,
  fkServico INT NOT NULL,

  PRIMARY KEY (fkSala, fkServico),

  INDEX fk_sala_has_servico_servico1_idx (fkServico ASC) VISIBLE,
  INDEX fk_sala_has_servico_sala1_idx (fkSala ASC) VISIBLE,

  CONSTRAINT fk_sala_has_servico_sala1
    FOREIGN KEY (fkSala)
    REFERENCES sala (id),

  CONSTRAINT fk_sala_has_servico_servico1
    FOREIGN KEY (fkServico)
    REFERENCES servico (id)
);

INSERT INTO cargo (nome, descricao) VALUES
('Administrador', 'Acesso total ao sistema'),
('Recepcionista', 'Gerencia agendamentos'),
('Acupunturista', 'Realiza atendimentos');

INSERT INTO permissoes (nome, descricao) VALUES
('CRUD_USUARIO', 'Gerenciar usuários'),
('CRUD_AGENDAMENTO', 'Gerenciar agendamentos'),
('REALIZAR_ATENDIMENTO', 'Executar atendimentos');

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

DELIMITER $$

CREATE TRIGGER before_insert_agendamento
BEFORE INSERT ON agendamento
FOR EACH ROW
BEGIN

  IF EXISTS (
    SELECT 1
    FROM agendamento
    WHERE fkSala = NEW.fkSala
      AND NEW.data_hora_inicio < data_hora_fim
      AND NEW.data_hora_fim > data_hora_inicio
  ) THEN

    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Conflito de horário para a sala';

  END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_insert_agendamento_horario
BEFORE INSERT ON funcionario_agendamento
FOR EACH ROW
BEGIN

  DECLARE dia INT;
  DECLARE inicioNovo DATETIME;
  DECLARE fimNovo DATETIME;

  SELECT
    data_hora_inicio,
    data_hora_fim
  INTO
    inicioNovo,
    fimNovo
  FROM agendamento
  WHERE id = NEW.fkAgendamento;

  SET dia = DAYOFWEEK(inicioNovo);

  IF NOT EXISTS (
    SELECT 1
    FROM agenda_funcionario
    WHERE fkFuncionario = NEW.fkFuncionario
      AND dia_semana = dia
      AND TIME(inicioNovo) >= hora_inicio
      AND TIME(fimNovo) <= hora_fim
  ) THEN

    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Fora do horário de trabalho';

  END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_insert_funcionario_agendamento
BEFORE INSERT ON funcionario_agendamento
FOR EACH ROW
BEGIN

  DECLARE inicioNovo DATETIME;
  DECLARE fimNovo DATETIME;

  SELECT
    data_hora_inicio,
    data_hora_fim
  INTO
    inicioNovo,
    fimNovo
  FROM agendamento
  WHERE id = NEW.fkAgendamento;

  IF EXISTS (
    SELECT 1
    FROM funcionario_agendamento fa
    JOIN agendamento a
      ON a.id = fa.fkAgendamento
    WHERE fa.fkFuncionario = NEW.fkFuncionario
      AND inicioNovo < a.data_hora_fim
      AND fimNovo > a.data_hora_inicio
  ) THEN

    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Conflito de horário para o funcionário';

  END IF;

END$$

DELIMITER ;

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