-- Function: lpInsertUpdate_MovementItemContainer

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer(
 INOUT ioId                      Integer               ,
    IN inDescId                  Integer               ,
    IN inMovementDescId          Integer               ,
    IN inMovementId              Integer               ,
    IN inMovementItemId          Integer               ,
    IN inParentId                Integer               ,
    IN inContainerId             Integer               ,
    IN inAccountId               Integer               ,
    IN inAnalyzerId              Integer               ,
    IN inObjectId_Analyzer       Integer               ,
    IN inWhereObjectId_Analyzer  Integer               ,
    IN inContainerId_Analyzer    Integer               ,
    IN inObjectIntId_Analyzer    Integer               ,
    IN inObjectExtId_Analyzer    Integer               ,
    IN inAmount                  TFloat                ,
    IN inOperDate                TDateTime             ,
    IN inIsActive                Boolean
)
AS
$BODY$
  DECLARE vbLock Boolean;
BEGIN
    IF zc_IsLockTable() = TRUE
    THEN
        -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
        LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
        -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
        /*vbLock := FALSE;
        WHILE NOT vbLock LOOP
            BEGIN
               LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
               vbLock := TRUE;
            EXCEPTION 
                WHEN OTHERS THEN
            END;
        END LOOP;*/
    ELSE
        PERFORM Container.* FROM Container WHERE Container.Id = inContainerId FOR UPDATE;
    END IF;


     -- меняем параметр
     IF inParentId = 0 THEN inParentId:= NULL; END IF;

     -- изменить значение остатка
     UPDATE Container SET Amount = Amount + COALESCE (inAmount, 0) WHERE Id = inContainerId;
     -- сохранили проводку
     INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                      , Amount, OperDate, IsActive)
                                VALUES (inDescId, inMovementDescId, inMovementId, inMovementItemId, inParentId, inContainerId
                                      , CASE WHEN inAccountId = 0 THEN NULL ELSE inAccountId END
                                      , CASE WHEN inAnalyzerId = 0 THEN NULL ELSE inAnalyzerId END
                                      , CASE WHEN inObjectId_Analyzer = 0 THEN NULL ELSE inObjectId_Analyzer END
                                      , CASE WHEN inWhereObjectId_Analyzer = 0 THEN NULL ELSE inWhereObjectId_Analyzer END
                                      , CASE WHEN inContainerId_Analyzer = 0 THEN NULL ELSE inContainerId_Analyzer END
                                      , CASE WHEN inObjectIntId_Analyzer = 0 THEN NULL ELSE inObjectIntId_Analyzer END
                                      , CASE WHEN inObjectExtId_Analyzer = 0 THEN NULL ELSE inObjectExtId_Analyzer END
                                      , COALESCE (inAmount, 0), inOperDate, inIsActive
                                       ) RETURNING Id INTO ioId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.15                                        * add inObjectIntId_Analyzer, inObjectExtId_Analyzer
 20.12.14                                        * add inAccountId, inObjectId_Analyzer, inWhereObjectId_Analyzer, inContainerId_Analyzer
 06.12.14                                        * add inAnalyzerId
 17.08.14                                        * add inMovementDescId
 13.08.14                                        * del так так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
 15.04.14                                        * add так так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
 07.08.13                                        * add inParentId and inIsActive
 25.07.13                                        * add inMovementItemId
 11.07.13                                        * !!! finich !!!
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemContainer (ioId:=0, inDescId:= zc_MIContainer_Count(), )