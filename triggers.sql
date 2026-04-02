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

