-- Function: gpGet_MovementCheck()

DROP FUNCTION IF EXISTS gpGet_MovementCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementCheck(
    IN inMovementId         Integer   , 
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN

     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не определен.';
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.06.22         *
*/

-- тест
--