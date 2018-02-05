-- Function: gpGet_Movement_CheckState()

DROP FUNCTION IF EXISTS gpGet_Movement_CheckState (Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_Movement_CheckState (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_CheckState(
    IN inMovementId        Integer  , -- ключ Документа
   OUT outState            Integer  , -- состояние документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
BEGIN

    SELECT
        Object.ObjectCode
    INTO
        outState
    FROM Movement
        Inner Join Object ON Movement.StatusId = Object.ID
    WHERE Movement.Id =  inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Check (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.05.15                         *                 
*/

-- тест
-- SELECT * FROM gpGet_Movement_Check (inMovementId:= 1, inSession:= '9818')