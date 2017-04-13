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
      vbisDelivery:= COALESCE (inisDelivery, false);
      vbSchedule:= CASE WHEN COALESCE (inSchedule, '') = '' THEN 't;t;t;t;t;t;t' ELSE inSchedule END;

      IF inDelivery IS NULL
      THEN -- если график посещения задан, а график завоза NULL, тогда рассчитываем график завоза на основании 
           -- графика посещения со сдвигом вперед по дням
           IF CHAR_LENGTH (vbSchedule) > 12
           THEN
                vbDelivery:= SUBSTRING (vbSchedule FROM 13 FOR 1) || ';' || SUBSTRING (vbSchedule FROM 1 FOR 11);
           ELSE
                vbDelivery:= 'f;' || SUBSTRING (vbSchedule FROM 1 FOR CHAR_LENGTH (vbSchedule));
           END IF; 
      END IF;

      -- Результат 
      RETURN CASE WHEN vbisDelivery THEN vbDelivery ELSE vbSchedule END;
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
*/