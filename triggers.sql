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