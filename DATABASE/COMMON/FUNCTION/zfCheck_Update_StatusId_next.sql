-- Function: zfCheck_Update_StatusId_next - Виды Документов, если StatusId НЕ меняется на zc_Enum_Status_UnComplete

DROP FUNCTION IF EXISTS zfCheck_Update_StatusId_next (Integer, Integer);

CREATE OR REPLACE FUNCTION zfCheck_Update_StatusId_next(
    IN inStatusId_old    Integer,
    IN inMovementDescId  Integer
)
RETURNS Boolean
AS
$BODY$
BEGIN

    -- Схема - StatusId_next только для таких
    IF inMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()
                          , zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_Loss()
                          , zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()
                          , zc_Movement_Sale(), zc_Movement_ReturnIn()
                          , zc_Movement_Inventory()
                           )
       -- если был проведен
       AND inStatusId_old = zc_Enum_Status_Complete()
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END;
$BODY$
LANGUAGE PLPGSQL IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.25                                        *
*/

-- тест
-- SELECT * FROM zfCheck_Update_StatusId_next (zc_Enum_Status_Complete(), zc_Movement_Sale())
