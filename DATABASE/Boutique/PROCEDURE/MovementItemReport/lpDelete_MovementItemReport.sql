-- Function: lpDelete_MovementItemReport (Integer)

-- DROP FUNCTION lpDelete_MovementItemReport (Integer);

CREATE OR REPLACE FUNCTION lpDelete_MovementItemReport (inMovementId Integer)
RETURNS VOID
AS
$BODY$
  DECLARE vbLock Boolean;
BEGIN

    -- так блокируем что б не было ОШИБКИ: обнаружена взаимоблокировка
    /*IF zc_IsLockTableCycle() = TRUE
    THEN
        vbLock := FALSE;
        WHILE NOT vbLock LOOP
            BEGIN
               PERFORM MovementItemReport.* FROM MovementItemReport WHERE MovementItemReport.MovementId = inMovementId FOR UPDATE;
               vbLock := TRUE;
            EXCEPTION 
                WHEN OTHERS THEN
            END;
        END LOOP;
    ELSE
    IF zc_IsLockTable() = FALSE
    THEN
        PERFORM MovementItemReport.* FROM MovementItemReport WHERE MovementItemReport.MovementId = inMovementId FOR UPDATE;
    END IF;
    END IF;*/


    -- Удалить все проводки для отчета
    -- DELETE FROM MovementItemReport WHERE MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_MovementItemReport (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.13                                        * add lpDelete_MovementItemReport
*/
