-- Function: gpInsertUpdate_UkraineAlarm()

DROP FUNCTION IF EXISTS gpInsertUpdate_UkraineAlarm (INTEGER, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_UkraineAlarm (
    IN inregionId             INTEGER,   -- Регион
    IN instartDate            TDateTime, -- Дата начала
    IN inendDate              TDateTime, -- Дата конца
    IN inalertType            TVarChar   -- Тип тревоги
)
RETURNS VOID
AS
$BODY$
BEGIN


    IF EXISTS (SELECT 1 FROM UkraineAlarm WHERE regionId = inregionId AND startDate = instartDate)
    THEN
      IF EXISTS (SELECT 1 FROM UkraineAlarm WHERE regionId = inregionId AND startDate = instartDate AND (endDate IS NULL OR endDate <> inendDate))
      THEN
        UPDATE  UkraineAlarm SET endDate = inendDate 
        WHERE regionId = inregionId AND startDate = instartDate;
      END IF;    
    ELSE
      INSERT INTO UkraineAlarm (regionId, startDate, endDate, alertType)
      VALUES (inregionId, instartDate, inendDate, inalertType);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-- тест

