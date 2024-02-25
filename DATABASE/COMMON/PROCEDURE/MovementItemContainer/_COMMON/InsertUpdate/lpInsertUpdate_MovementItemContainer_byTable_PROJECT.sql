-- Function: lpInsertUpdate_MovementItemContainer_byTable ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer_byTable ();
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemContainer_byTable (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer_byTable (IN inUserId Integer DEFAULT 0)
RETURNS VOID
AS
$BODY$
   DECLARE vbLock Integer;
   DECLARE vbTmp Integer;
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
               PERFORM Container.* FROM Container WHERE Container.Id IN (SELECT DISTINCT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert) FOR UPDATE;
               vbLock := 0;
            EXCEPTION 
                     WHEN OTHERS THEN vbLock := vbLock + 1;
                                      vbTmp:= (SELECT _tmpMIContainer_insert.MovementId FROM _tmpMIContainer_insert LIMIT 1);
                                      vbSec:= CASE WHEN 0 <> SUBSTR (vbTmp :: TVarChar,  0 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbTmp :: TVarChar,  0 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbTmp :: TVarChar, -1 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbTmp :: TVarChar, -1 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbTmp :: TVarChar, -2 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbTmp :: TVarChar, -2 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                   WHEN 0 <> SUBSTR (vbTmp :: TVarChar, -3 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                        THEN SUBSTR (vbTmp :: TVarChar, -3 + LENGTH (vbTmp :: TVarChar), 1) :: Integer
                                                   ELSE SUBSTR (vbTmp :: TVarChar, 1, 1) :: Integer
                                               END;
                                      --
                                      IF vbLock <= 5
                                      THEN PERFORM pg_sleep (zc_IsLockTableSecond());

                                      ELSE IF vbLock <= 10
                                      THEN PERFORM pg_sleep (vbLock - 5 + vbSec);

                                      ELSE IF vbLock <= 15
                                      THEN PERFORM pg_sleep (vbLock - 5 + vbSec);

                                      ELSE RAISE EXCEPTION 'Deadlock <%>', vbTmp;
                                      END IF;
                                      END IF;
                                      END IF;
            END;
        END LOOP;
    ELSE
        PERFORM Container.* FROM Container WHERE Container.Id IN (SELECT DISTINCT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert) FOR UPDATE;
    END IF;
    END IF;
    
     -- изменить значение остатка
     UPDATE Container SET Amount = Container.Amount + _tmpMIContainer.Amount
     FROM (SELECT ContainerId, SUM (COALESCE (_tmpMIContainer_insert.Amount, 0)) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId) AS _tmpMIContainer
     WHERE Container.Id = _tmpMIContainer.ContainerId;

     -- сохранили проводки
     INSERT INTO MovementItemContainer (DescId, MovementDescId, MovementId, MovementItemId, ParentId, ContainerId
                                      , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                      , Amount, OperDate, IsActive)
        SELECT DescId, MovementDescId, MovementId
             , CASE WHEN MovementItemId = 0          THEN NULL ELSE MovementItemId END
             , CASE WHEN ParentId = 0                THEN NULL ELSE ParentId END
             , ContainerId
             , CASE WHEN AccountId = 0               THEN NULL ELSE AccountId END
             , CASE WHEN AnalyzerId = 0              THEN NULL ELSE AnalyzerId END
             , CASE WHEN ObjectId_Analyzer = 0       THEN NULL ELSE ObjectId_Analyzer END
             , CASE WHEN WhereObjectId_Analyzer = 0  THEN NULL ELSE WhereObjectId_Analyzer END
             , CASE WHEN ContainerId_Analyzer = 0    THEN NULL ELSE ContainerId_Analyzer END
             , CASE WHEN AccountId_Analyzer = 0      THEN NULL ELSE AccountId_Analyzer END
             , CASE WHEN ObjectIntId_Analyzer = 0    THEN NULL ELSE ObjectIntId_Analyzer END
             , CASE WHEN ObjectExtId_Analyzer = 0    THEN NULL ELSE ObjectExtId_Analyzer END
             , CASE WHEN ContainerIntId_Analyzer = 0 THEN NULL ELSE ContainerIntId_Analyzer END
             , COALESCE (Amount, 0)
             , OperDate
             , IsActive
        FROM _tmpMIContainer_insert;
     

     -- Проверка
     IF EXISTS (SELECT 1 FROM _tmpMIContainer_insert WHERE _tmpMIContainer_insert.MovementDescId = zc_Movement_ProductionUnion())
        AND inUserId = 5
     THEN
         vbTmp:= (SELECT _tmpMIContainer_insert.MovementId FROM _tmpMIContainer_insert LIMIT 1);
         -- Проверка
         IF EXISTS (SELECT SUM (MIContainer.Amount)
                    FROM MovementItemContainer AS MIContainer
                    WHERE MIContainer.MovementId = vbTmp
                      AND MIContainer.DescId = zc_MIContainer_Summ()
                    HAVING SUM (MIContainer.Amount) <> 0
                   )
         THEN
             RAISE EXCEPTION 'Ошибка.В проводке отличаются сумма <Дебет> и сумма <Кредит> :% (%)  + (%) = (%) %OR: (%)  + (%)'
                           , CHR (13)
                           , (SELECT SUM (MIContainer.Amount) FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = vbTmp AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.isActive = TRUE)
                           , (SELECT SUM (MIContainer.Amount) FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = vbTmp AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.isActive = FALSE)
                           , (SELECT SUM (MIContainer.Amount) FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = vbTmp AND MIContainer.DescId = zc_MIContainer_Summ())
                           , CHR (13)
                           , (SELECT SUM (MIContainer.Amount) FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = vbTmp AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.Amount > 0)
                           , (SELECT SUM (MIContainer.Amount) FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementId = vbTmp AND MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.Amount < 0)
                            ;
         END IF;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.15                                        * add ObjectIntId_Analyzer, ObjectExtId_Analyzer
 20.12.14                                        * add AccountId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer
 06.12.14                                        * add AnalyzerId
 17.08.14                                        * add MovementDescId
 13.08.14                                        * del так так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
 14.04.14                                        * add так так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
 02.09.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemContainer_byTable ()
