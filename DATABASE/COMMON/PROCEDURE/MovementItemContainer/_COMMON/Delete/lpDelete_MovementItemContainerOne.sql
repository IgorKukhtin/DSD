-- Function: lpDelete_MovementItemContainerOne()

DROP FUNCTION IF EXISTS lpDelete_MovementItemContainerOne (Integer, Integer);

CREATE OR REPLACE FUNCTION lpDelete_MovementItemContainerOne (IN inMovementId Integer, IN inMovementItemId Integer)
  RETURNS VOID AS
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
        -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
        vbLock := 1;
        WHILE vbLock <> 0 LOOP
           BEGIN
               PERFORM Container.* FROM Container WHERE Container.Id IN (SELECT MovementItemContainer.ContainerId FROM MovementItemContainer
                 WHERE MovementItemContainer.MovementId = inMovementId
                   AND MovementItemContainer.MovementItemId = inMovementItemId) FOR UPDATE;
               PERFORM MovementItemContainer.* FROM MovementItemContainer WHERE MovementItemContainer.MovementId = inMovementId
                                                                            AND MovementItemContainer.MovementItemId = inMovementItemId FOR UPDATE;
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

                                      ELSE RAISE EXCEPTION 'Deadlock <%>', inMovementId;
                                      END IF;
                                      END IF;
                                      END IF;
            END;
        END LOOP;
    ELSE
        PERFORM Container.* FROM Container WHERE Container.Id IN (SELECT MovementItemContainer.ContainerId FROM MovementItemContainer
                                           WHERE MovementItemContainer.MovementId = inMovementId
                                             AND MovementItemContainer.MovementItemId = inMovementItemId) FOR UPDATE;
        PERFORM MovementItemContainer.* FROM MovementItemContainer WHERE MovementItemContainer.MovementId = inMovementId
                                                                     AND MovementItemContainer.MovementItemId = inMovementItemId FOR UPDATE;
    END IF;
    END IF;


    -- Изменить значение остатка
    UPDATE Container SET Amount = Container.Amount - _tmpMIContainer.Amount
    FROM (SELECT SUM (MIContainer.Amount) AS Amount
               , MIContainer.ContainerId
          FROM MovementItemContainer AS MIContainer
          WHERE MIContainer.MovementId = inMovementId
            AND MIContainer.MovementItemId = inMovementItemId
          GROUP BY MIContainer.ContainerId
         ) AS _tmpMIContainer
    WHERE Container.Id = _tmpMIContainer.ContainerId;

    -- Удалить все проводки
    DELETE FROM MovementItemContainer WHERE MovementId = inMovementId
                                        AND MovementItemId = inMovementItemId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_MovementItemContainerOne (Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 24.06.18         *
*/
