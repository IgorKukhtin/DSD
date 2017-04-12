DROP FUNCTION IF EXISTS zfReCalc_ScheduleOrDelivery (TVarChar, TVarChar, Boolean);

CREATE OR REPLACE FUNCTION zfReCalc_ScheduleOrDelivery (
    IN inSchedule   TVarChar, -- График посещения ТТ, по каким дням недели - в строчке 7 символов разделенных ";" t значит true и f значит false
    IN inDelivery   TVarChar, -- График завоза на ТТ, по каким дням недели - в строчке 7 символов разделенных ";" t значит true и f значит false
    IN inisDelivery Boolean   -- Если true, вернуть пересчитанное значение графика завоза, иначе вернуть значение графика посещения
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbSchedule TVarChar; 
   DECLARE vbDelivery TVarChar; 
   DECLARE vbisDelivery Boolean;
BEGIN
      vbisDelivery:= COALESCE (inisDelivery, false)::Boolean;

      IF (inSchedule IS NULL) AND (inDelivery IS NULL)
      THEN -- если оба графика NULL, то возвращаем значения по-умолчанию
           vbSchedule:= 't;t;t;t;t;t;t';
           vbDelivery:= vbSchedule;
      ELSIF (inSchedule IS NOT NULL) AND (inDelivery IS NULL)
      THEN -- если график посещения задан, а график завоза NULL, тогда рассчитываем график завоза на основании 
           -- графика посещения со сдвигом вперед по дням
           vbSchedule:= REPLACE (REPLACE (LOWER (inSchedule), 'true', 't'), 'false', 'f')::TVarChar;
           IF CHAR_LENGTH (vbSchedule) > 12
           THEN
                vbDelivery:= SUBSTRING (vbSchedule FROM 13 FOR 1) || ';' || SUBSTRING (vbSchedule FROM 1 FOR 11);
           ELSIF (CHAR_LENGTH (vbSchedule) > 0) AND (CHAR_LENGTH (vbSchedule) < 12)
           THEN 
                vbDelivery:= 'f;' || SUBSTRING (vbSchedule FROM 1 FOR CHAR_LENGTH (vbSchedule));
           ELSE
                vbDelivery:= 'f;f;f;f;f;f;f'; 
           END IF; 
      ELSIF (inSchedule IS NULL) AND (inDelivery IS NOT NULL)
      THEN -- если график посещения NULL, а график завоза задан, тогда график посещения возвращаем 
           -- с значением по-умолчанию, а график завоза, если надо, приводим к корректному виду
           vbSchedule:= 't;t;t;t;t;t;t';
           vbDelivery:= REPLACE (REPLACE (LOWER (inDelivery), 'true', 't'), 'false', 'f')::TVarChar;
      ELSE -- иначе, если надо, приводим все к корректному виду
           vbSchedule:= REPLACE (REPLACE (LOWER (inSchedule), 'true', 't'), 'false', 'f')::TVarChar;
           vbDelivery:= REPLACE (REPLACE (LOWER (inDelivery), 'true', 't'), 'false', 'f')::TVarChar;
      END IF;

      -- Результат 
      IF vbisDelivery
      THEN
           RETURN vbDelivery;
      ELSE
           RETURN vbSchedule;
      END IF; 
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 12.04.17                                                        *   
*/

-- тест
/* 
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= NULL, inDelivery:= NULL, inisDelivery:= false)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= '', inDelivery:= NULL, inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f', inDelivery:= NULL, inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f;t;f', inDelivery:= NULL, inisDelivery:= true)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= 't;f;t;t;f;t;f;t;f', inDelivery:= NULL, inisDelivery:= false)
   UNION ALL
   SELECT * FROM zfReCalc_ScheduleOrDelivery (inSchedule:= NULL, inDelivery:= 't;f;t;true;false;t;f', inisDelivery:= true)
*/