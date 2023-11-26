-- Function: gpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementFloat_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId  Integer, -- Ключ объекта <Документ>
    IN inSession     TVarChar -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
BEGIN

    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementFloat_TotalSumm (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 24.11.23                                                      * 
*/