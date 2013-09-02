-- Function: lpInsertUpdate_MovementItemReport(Integer, Integer, Integer, TFloat, TDateTime)

-- DROP FUNCTION lpInsertUpdate_MovementItemReport(Integer, Integer, Integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemReport(
    IN inMovementId              Integer               , -- ключ Документа
    IN inMovementItemId          Integer               ,
    IN inReportContainerId       Integer               ,
    IN inAmount                  TFloat                ,
    IN inOperDate                TDateTime
)
  RETURNS void AS
$BODY$
BEGIN

     -- Проверка
     IF inAmount < 0 
     THEN
         RAISE EXCEPTION 'Невозможно Сформировать проводку для отчета с inAmount<0 : "%", "%", "%", "%", "%"', inMovementId, inMovementItemId, inReportContainerId, inAmount, inOperDate;
     END IF;

     -- сохранили "Проводка для отчета"
     INSERT INTO MovementItemReport (MovementId, MovementItemId, ReportContainerId, Amount, OperDate)
                             VALUES (inMovementId, inMovementItemId, inReportContainerId, COALESCE (inAmount, 0), inOperDate);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemReport (Integer, Integer, Integer, TFloat, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemReport (inMovementId  := 1, inMovementItemId := 2, )

