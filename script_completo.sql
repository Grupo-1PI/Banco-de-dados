CREATE DATABASE IF NOT EXISTS clinica_acupuntura;
USE clinica_acupuntura;

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
  UNIQUE INDEX email_UNIQUE (email ASC),
  CONSTRAINT fk_usuario_endereco1 FOREIGN KEY (fkEndereco) REFERENCES endereco (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS funcionario (
  id INT NOT NULL AUTO_INCREMENT,
  fkUsuario INT NOT NULL,
  fkCargo INT NOT NULL,
  PRIMARY KEY (id, fkUsuario),
  CONSTRAINT funcionario_ibfk_1 FOREIGN KEY (fkCargo) REFERENCES cargo (id) ON DELETE RESTRICT,
  CONSTRAINT fk_funcionario_usuario1 FOREIGN KEY (fkUsuario) REFERENCES usuario (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS agenda_excecao (
  id INT NOT NULL AUTO_INCREMENT,
  fkFuncionario INT NOT NULL,
  data DATE NOT NULL,
  hora_inicio TIME NULL DEFAULT NULL,
  hora_fim TIME NULL DEFAULT NULL,
  disponivel TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (id),
  CONSTRAINT agenda_excecao_ibfk_1 FOREIGN KEY (fkFuncionario) REFERENCES funcionario (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS agenda_funcionario (
  id INT NOT NULL AUTO_INCREMENT,
  fkFuncionario INT NOT NULL,
  dia_semana INT NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT agenda_funcionario_ibfk_1 FOREIGN KEY (fkFuncionario) REFERENCES funcionario (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS cliente (
  id INT NOT NULL AUTO_INCREMENT,
  fkUsuario INT NOT NULL,
  observacao VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (id, fkUsuario),
  CONSTRAINT fk_cliente_usuario1 FOREIGN KEY (fkUsuario) REFERENCES usuario (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS sala (
  id INT NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS servico (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  tempoMedio INT NULL DEFAULT NULL,
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
  fkFuncionario INT NOT NULL,
  fkSala INT NOT NULL,
  fkServico INT NOT NULL,
  fkStatus INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT agendamento_ibfk_1 FOREIGN KEY (fkCliente) REFERENCES cliente (id) ON DELETE RESTRICT,
  CONSTRAINT agendamento_ibfk_2 FOREIGN KEY (fkFuncionario) REFERENCES funcionario (id) ON DELETE RESTRICT,
  CONSTRAINT agendamento_ibfk_3 FOREIGN KEY (fkSala) REFERENCES sala (id) ON DELETE RESTRICT,
  CONSTRAINT agendamento_ibfk_4 FOREIGN KEY (fkServico) REFERENCES servico (id) ON DELETE RESTRICT,
  CONSTRAINT fk_agendamento_status1 FOREIGN KEY (fkStatus) REFERENCES status (id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS atendimento (
  id INT NOT NULL AUTO_INCREMENT,
  fkAgendamento INT NOT NULL,
  descricao VARCHAR(255) NULL DEFAULT NULL,
  observacoes VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (id),
  CONSTRAINT atendimento_ibfk_1 FOREIGN KEY (fkAgendamento) REFERENCES agendamento (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS atendimento_servico (
  id INT NOT NULL AUTO_INCREMENT,
  valor_unitario DECIMAL(10,2) NOT NULL,
  fkAtendimento INT NOT NULL,
  fkServico INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT atendimento_servico_ibfk_1 FOREIGN KEY (fkAtendimento) REFERENCES atendimento (id) ON DELETE CASCADE,
  CONSTRAINT atendimento_servico_ibfk_2 FOREIGN KEY (fkServico) REFERENCES servico (id) ON DELETE RESTRICT
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
  CONSTRAINT especialidadeservico_ibfk_1 FOREIGN KEY (fkEspecialidade) REFERENCES especialidade (id) ON DELETE CASCADE,
  CONSTRAINT especialidadeservico_ibfk_2 FOREIGN KEY (fkServico) REFERENCES servico (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS funcionario_especialidade (
  fkFuncionario INT NOT NULL,
  fkEspecialidade INT NOT NULL,
  PRIMARY KEY (fkFuncionario, fkEspecialidade),
  CONSTRAINT funcionario_especialidade_ibfk_1 FOREIGN KEY (fkFuncionario) REFERENCES funcionario (id) ON DELETE CASCADE,
  CONSTRAINT funcionario_especialidade_ibfk_2 FOREIGN KEY (fkEspecialidade) REFERENCES especialidade (id) ON DELETE CASCADE
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
  CONSTRAINT permissoescargo_ibfk_1 FOREIGN KEY (fkPermissoes) REFERENCES permissoes (id) ON DELETE CASCADE,
  CONSTRAINT permissoescargo_ibfk_2 FOREIGN KEY (fkCargo) REFERENCES cargo (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS sala_servico (
  fkSala INT NOT NULL,
  fkServico INT NOT NULL,
  PRIMARY KEY (fkSala, fkServico),
  CONSTRAINT fk_sala_has_servico_sala1 FOREIGN KEY (fkSala) REFERENCES sala (id) ON DELETE CASCADE,
  CONSTRAINT fk_sala_has_servico_servico1 FOREIGN KEY (fkServico) REFERENCES servico (id) ON DELETE CASCADE
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
(1,1),
(2,1),
(3,1),
(2,2),
(3,3);

INSERT INTO status (nome) VALUES
('Agendado'),
('Confirmado'),
('Cancelado'),
('Finalizado');

INSERT INTO sala (descricao) VALUES
('Sala 1'),
('Sala 2');

INSERT INTO especialidade (nome) VALUES
('Dor muscular'),
('Ansiedade'),
('Insônia');

INSERT INTO servico (nome, valor, descricao, tempoMedio) VALUES
('Sessão de Acupuntura', 120.00, 'Sessão padrão', 60),
('Auriculoterapia', 80.00, 'Tratamento auricular', 40);

INSERT INTO especialidade_servico VALUES
(1,1),
(2,1),
(3,1),
(2,2);

DELIMITER $$

CREATE TRIGGER before_insert_agendamento
BEFORE INSERT ON agendamento
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM agendamento
    WHERE fkFuncionario = NEW.fkFuncionario
    AND (
      (NEW.data_hora_inicio BETWEEN data_hora_inicio AND data_hora_fim)
      OR
      (NEW.data_hora_fim BETWEEN data_hora_inicio AND data_hora_fim)
    )
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Conflito de horário para o funcionário';
  END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER before_insert_agendamento_horario
BEFORE INSERT ON agendamento
FOR EACH ROW
BEGIN
  DECLARE dia INT;

  SET dia = DAYOFWEEK(NEW.data_hora_inicio);

  IF NOT EXISTS (
    SELECT 1 FROM agenda_funcionario
    WHERE fkFuncionario = NEW.fkFuncionario
    AND dia_semana = dia
    AND TIME(NEW.data_hora_inicio) BETWEEN hora_inicio AND hora_fim
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Fora do horário de trabalho';
  END IF;
END$$

DELIMITER ;

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
