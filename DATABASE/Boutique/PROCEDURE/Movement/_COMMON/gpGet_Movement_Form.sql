-- Function: gpGet_Movement_ZakazInternal()

DROP FUNCTION IF EXISTS gpGet_Movement_Form (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Form(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (FormName TVarChar)
AS
$BODY$
     DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Form());

     RETURN QUERY 
       SELECT
            COALESCE(Object_Form.ValueData, '')::TVarChar    AS FromName

       FROM Movement                          
            JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN Object AS Object_Form ON Object_Form.Id = MovementDesc.FormId
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Form (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18         * 
 24.01.14                        *

*/

-- тест
-- SELECT * FROM gpGet_Movement_ZakazInternal (inMovementId:= 1, inSession:= '2')
