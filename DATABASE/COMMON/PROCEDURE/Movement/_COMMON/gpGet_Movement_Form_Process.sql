-- Function: gpGet_Movement_Form_Process()

DROP FUNCTION IF EXISTS gpGet_Movement_Form_Process (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Form_Process(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (FormName TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Form_Process());
     
     RETURN QUERY 
       SELECT
            COALESCE (Object_Form.ValueData, '')::TVarChar    AS FromName

       FROM Movement                          
            JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN Object AS Object_Form ON Object_Form.Id = MovementDesc.FormId
       WHERE Movement.Id = inMovementId;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.01.14                        *

*/

-- тест
-- SELECT * FROM gpGet_Movement_Form (inMovementId:= 40874, inSession:= zfCalc_UserAdmin())
