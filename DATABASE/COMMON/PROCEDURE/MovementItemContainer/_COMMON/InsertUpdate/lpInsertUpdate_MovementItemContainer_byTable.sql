-- Function: lpInsertUpdate_MovementItemContainer_byTable ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer_byTable ();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer_byTable ()
RETURNS VOID
AS
$BODY$
   DECLARE vbCount Integer;
   DECLARE vbLock Boolean;
BEGIN
    -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
    --***LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
    -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
    vbLock := FALSE;
    WHILE NOT vbLock LOOP
        BEGIN
           LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
           vbLock := TRUE;
        EXCEPTION 
            WHEN OTHERS THEN
        END;
    END LOOP;

     -- изменить значение остатка
     UPDATE Container SET Amount = Container.Amount + _tmpMIContainer.Amount
     FROM (SELECT ContainerId, SUM (COALESCE (_tmpMIContainer_insert.Amount, 0)) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId) AS _tmpMIContainer
     WHERE Container.Id = _tmpMIContainer.ContainerId;

     -- сохранили проводки
     INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
                                      , Amount, OperDate, IsActive)
        SELECT DescId, MovementDescId, MovementId
             , CASE WHEN MovementItemId = 0 THEN NULL ELSE MovementItemId END
             , CASE WHEN ParentId = 0 THEN NULL ELSE ParentId END
             , ContainerId
             , CASE WHEN AccountId = 0 THEN NULL ELSE AccountId END
             , CASE WHEN AnalyzerId = 0 THEN NULL ELSE AnalyzerId END
             , CASE WHEN ObjectId_Analyzer = 0 THEN NULL ELSE ObjectId_Analyzer END
             , CASE WHEN WhereObjectId_Analyzer = 0 THEN NULL ELSE WhereObjectId_Analyzer END
             , CASE WHEN ContainerId_Analyzer = 0 THEN NULL ELSE ContainerId_Analyzer END
             , COALESCE (Amount, 0)
             , OperDate
             , IsActive
        FROM _tmpMIContainer_insert;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer_byTable () OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.14                                        * add AccountId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
 06.12.14                                        * add AnalyzerId
 17.08.14                                        * add MovementDescId
 13.08.14                                        * del так так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
 14.04.14                                        * add так так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
 02.09.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemContainer_byTable ()
