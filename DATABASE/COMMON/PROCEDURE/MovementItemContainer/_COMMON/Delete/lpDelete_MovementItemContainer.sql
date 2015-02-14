-- Function: gpUnComplete_Movement()

-- DROP FUNCTION lpDelete_MovementItemContainer (Integer);

CREATE OR REPLACE FUNCTION lpDelete_MovementItemContainer (IN inMovementId Integer)
  RETURNS void AS
$BODY$
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

    -- Изменить значение остатка
    UPDATE Container SET Amount = Container.Amount - _tmpMIContainer.Amount
    FROM (SELECT SUM (MIContainer.Amount) AS Amount
               , MIContainer.ContainerId
          FROM MovementItemContainer AS MIContainer
          WHERE MIContainer.MovementId = inMovementId
          GROUP BY MIContainer.ContainerId
         ) AS _tmpMIContainer
    WHERE Container.Id = _tmpMIContainer.ContainerId;

    -- Удалить все проводки
    DELETE FROM MovementItemContainer WHERE MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_MovementItemContainer (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.15                        * add так так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
 24.08.13                                        * add так так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
 29.08.13                                        * 1251Cyr
*/
