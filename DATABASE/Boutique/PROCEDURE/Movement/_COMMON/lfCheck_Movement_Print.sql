-- Function: lfCheck_Movement_Print (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lfCheck_Movement_Print (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lfCheck_Movement_Print(
    IN inMovementDescId Integer ,
    IN inMovementId     Integer ,
    IN inStatusId       Integer 
)
RETURNS VOID
AS
$BODY$
BEGIN
     -- !!!Временно - ОТКЛЮЧИЛИ!!!
     RETURN;


     -- очень важная проверка
     IF COALESCE (inStatusId, 0) <> zc_Enum_Status_Complete()
     THEN
         IF inStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF inStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
        -- RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = inMovementDescId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.17                                        *
*/

-- тест
-- SELECT * FROM lfCheck_Movement_Print (0, 0)
