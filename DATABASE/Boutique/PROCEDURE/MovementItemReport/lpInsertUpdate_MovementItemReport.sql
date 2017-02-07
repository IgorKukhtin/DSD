-- Function: lpInsertUpdate_MovementItemReport(Integer, Integer, Integer, TFloat, TDateTime)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemReport (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemReport(
    IN inMovementDescId          Integer               ,
    IN inMovementId              Integer               , -- ключ Документа
    IN inMovementItemId          Integer               ,
    IN inActiveContainerId       Integer               ,
    IN inPassiveContainerId      Integer               ,
    IN inActiveAccountId         Integer               ,
    IN inPassiveAccountId        Integer               ,
    IN inReportContainerId       Integer               ,
    IN inChildReportContainerId  Integer               ,
    IN inAmount                  TFloat                ,
    IN inOperDate                TDateTime
)
  RETURNS void AS
$BODY$
BEGIN
     -- !!!Выход, т.к. больше не нужны!!!
     RETURN;


     -- меняем параметр
     IF inChildReportContainerId = 0 THEN inChildReportContainerId := NULL; END IF;
     -- меняем параметр
     inAmount := COALESCE (inAmount, 0);

     -- Проверка
     IF inAmount < 0 
     THEN
         RAISE EXCEPTION 'Невозможно Сформировать проводку для отчета с inAmount<0 : "%", "%", "%", "%", "%", "%", "%", "%", "%", "%"', inMovementId, inMovementItemId, inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId, inReportContainerId, inChildReportContainerId, inAmount, inOperDate;
     END IF;

     -- Проверка
     IF inActiveAccountId = zc_Enum_Account_100301() AND inPassiveAccountId = zc_Enum_Account_100301()
     THEN
         RAISE EXCEPTION 'Невозможно Сформировать проводку для отчета с одинаковым счетом ОПиУ : "%", "%", "%", "%", "%", "%", "%", "%", "%", "%"', inMovementId, inMovementItemId, inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId, inReportContainerId, inChildReportContainerId, inAmount, inOperDate;
     END IF;

     -- сохранили "Проводка для отчета"
     INSERT INTO MovementItemReport (MovementDescId, MovementId, MovementItemId, ActiveContainerId, PassiveContainerId, ActiveAccountId, PassiveAccountId, ReportContainerId, ChildReportContainerId, Amount, OperDate)
                             VALUES (inMovementDescId, inMovementId, inMovementItemId, inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId, inReportContainerId, inChildReportContainerId, inAmount, inOperDate);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemReport (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.08.14                                        * add inMovementDescId
 03.11.13                                        * add zc_Enum_Account_100301
 29.08.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemReport (inMovementId  := 1, inMovementItemId := 2, )
