DELIMITER $$

CREATE TRIGGER before_insert_agendamento
BEFORE INSERT ON agendamento
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1
    FROM agendamento
    WHERE fkFuncionario = NEW.fkFuncionario
      AND NEW.data_hora_inicio < data_hora_fim
      AND NEW.data_hora_fim > data_hora_inicio
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
    SELECT 1
    FROM agenda_funcionario
    WHERE fkFuncionario = NEW.fkFuncionario
      AND dia_semana = dia
      AND TIME(NEW.data_hora_inicio) >= hora_inicio
      AND TIME(NEW.data_hora_fim) <= hora_fim
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Fora do horário de trabalho';
  END IF;
END$$

DELIMITER ;
