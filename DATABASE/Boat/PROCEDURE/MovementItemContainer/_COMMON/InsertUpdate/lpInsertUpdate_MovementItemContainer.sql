-- Function: lpInsertUpdate_MovementItemContainer

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer (BigInt, Integer, Integer, Integer, Integer, Integer, BigInt, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer(
 INOUT ioId                      BigInt    ,
    IN inDescId                  Integer   , -- Вид документа
    IN inMovementDescId          Integer   , --
    IN inMovementId              Integer   , --
    IN inMovementItemId          Integer   , --
    IN inContainerId             Integer   , --
    IN inParentId                BigInt    , --

    IN inAccountId               Integer   , -- Счет
    IN inAnalyzerId              Integer   , -- Типы аналитик (проводки)
    IN inObjectId_Analyzer       Integer   , -- MovementItem.ObjectId
    IN inPartionId               Integer   , -- MovementItem.PartionId
    IN inWhereObjectId_Analyzer  Integer   , -- Место учета

    IN inAccountId_Analyzer      Integer   , -- Счет - корреспондент
    
    IN inContainerId_Analyzer    Integer   , -- Контейнер ОПиУ - статья ОПиУ или Покупатель в продаже/возврат
    IN inContainerIntId_Analyzer Integer   , -- Контейнер - Корреспондент
 
    IN inObjectIntId_Analyzer    Integer   , -- Аналитический справочник (Размер, УП статья или что-то особенное - т.е. все то что не вписалось в аналитики выше)
    IN inObjectExtId_Analyzer    Integer   , -- Аналитический справочник (Подразделение - корреспондент, Подразделение ЗП, ФИО, Контрагент и т.д. - т.е. все то что не вписалось в аналитики выше)

    IN inAmount                  TFloat    , --
    IN inOperDate                TDateTime , --
    IN inIsActive                Boolean     --
)
AS
$BODY$
   DECLARE vbLock Integer;
   DECLARE vbSec Integer;
BEGIN
    -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
    IF zc_IsLockTable() = TRUE
    THEN
        -- LOCK TABLE Container IN SHARE UPDATE EXCLUSIVE MODE;
        LOCK TABLE LockProtocol IN SHARE UPDATE EXCLUSIVE MODE;
    ELSE
    IF zc_IsLockTableCycle() = TRUE
    THEN
        vbLock := 1;
        WHILE vbLock <> 0 LOOP
            BEGIN
               PERFORM Container.* FROM Container WHERE Container.Id = inContainerId FOR UPDATE;
               vbLock := 0;
            EXCEPTION 
                     WHEN OTHERS THEN vbLock := vbLock + 1;
                                      vbSec:= CASE WHEN 0 <> SUBSTR (inMovementId :: TVarChar,  0 + LENGTH (inMovementId :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (inMovementId :: TVarChar,  0 + LENGTH (inMovementId :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (inMovementId :: TVarChar, -1 + LENGTH (inMovementId :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (inMovementId :: TVarChar, -1 + LENGTH (inMovementId :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (inMovementId :: TVarChar, -2 + LENGTH (inMovementId :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (inMovementId :: TVarChar, -2 + LENGTH (inMovementId :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (inMovementId :: TVarChar, -3 + LENGTH (inMovementId :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (inMovementId :: TVarChar, -3 + LENGTH (inMovementId :: TVarChar), 1) :: Integer
                                                   ELSE SUBSTR (inMovementId :: TVarChar, 1, 1) :: Integer
                                               END;
                                      --
                                      IF vbLock <= 5
                                      THEN PERFORM pg_sleep (zc_IsLockTableSecond());

                                      ELSE IF vbLock <= 10
                                      THEN PERFORM pg_sleep (vbLock - 5 + vbSec);

                                      ELSE IF vbLock <= 15
                                      THEN PERFORM pg_sleep (vbLock - 5 + vbSec);

                                      ELSE RAISE EXCEPTION 'Deadlock <%>', inContainerId;
                                      END IF;
                                      END IF;
                                      END IF;
            END;
        END LOOP;
    ELSE
        PERFORM Container.* FROM Container WHERE Container.Id = inContainerId FOR UPDATE;
    END IF;
    END IF;


     -- изменить значение остатка
     UPDATE Container SET Amount = Amount + COALESCE (inAmount, 0) WHERE Id = inContainerId;

     -- сохранили проводку
     INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId
                                      , MovementItemId, ContainerId, ParentId

                                      , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer

                                      , AccountId_Analyzer

                                      , ContainerId_Analyzer, ContainerIntId_Analyzer

                                      , ObjectIntId_Analyzer, ObjectExtId_Analyzer

                                      , Amount, OperDate, IsActive)

                                VALUES (inDescId, inMovementDescId, inMovementId
                                      , inMovementItemId, inContainerId
                                      , CASE WHEN inParentId                = 0 THEN NULL ELSE inParentId END

                                      , CASE WHEN inAccountId               = 0 THEN NULL ELSE inAccountId END
                                      , CASE WHEN inAnalyzerId              = 0 THEN NULL ELSE inAnalyzerId END
                                      , CASE WHEN inObjectId_Analyzer       = 0 THEN NULL ELSE inObjectId_Analyzer END
                                      , CASE WHEN inPartionId               = 0 THEN NULL ELSE inPartionId END
                                      , CASE WHEN inWhereObjectId_Analyzer  = 0 THEN NULL ELSE inWhereObjectId_Analyzer END

                                     , CASE WHEN inAccountId_Analyzer       = 0 THEN NULL ELSE inAccountId_Analyzer END

                                      , CASE WHEN inContainerId_Analyzer    = 0 THEN NULL ELSE inContainerId_Analyzer END
                                      , CASE WHEN inObjectIntId_Analyzer    = 0 THEN NULL ELSE inObjectIntId_Analyzer END

                                      , CASE WHEN inObjectExtId_Analyzer    = 0 THEN NULL ELSE inObjectExtId_Analyzer END
                                      , CASE WHEN inContainerIntId_Analyzer = 0 THEN NULL ELSE inContainerIntId_Analyzer END

                                      , COALESCE (inAmount, 0)
                                      , inOperDate
                                      , inIsActive
                                       )
                                RETURNING Id INTO ioId;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemContainer (ioId:=0, inDescId:= zc_MIContainer_Count(), )
