-- Function: lpInsertUpdate_MovementFloat_TotalSummPaymentExactly (Integer)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementFloat_TotalSummPayment (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementFloat_TotalSummPayment (Integer, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementFloat_TotalSummPayment(
    IN inMovementId Integer, -- Ключ объекта <Документ>
    IN inSession TVarChar -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
BEGIN

    PERFORM lpInsertUpdate_MovementFloat_TotalSummPayment (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementFloat_TotalSummPayment (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 10.12.15                                                         * 
*/
