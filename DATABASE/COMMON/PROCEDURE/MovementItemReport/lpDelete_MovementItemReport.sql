-- Function: lpDelete_MovementItemReport (Integer)

-- DROP FUNCTION lpDelete_MovementItemReport (Integer);

CREATE OR REPLACE FUNCTION lpDelete_MovementItemReport (inMovementId Integer)
  RETURNS void AS
$BODY$
BEGIN

    -- Удалить все проводки для отчета
    DELETE FROM MovementItemReport WHERE MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_MovementItemReport (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.13                                        * add lpDelete_MovementItemReport
*/
