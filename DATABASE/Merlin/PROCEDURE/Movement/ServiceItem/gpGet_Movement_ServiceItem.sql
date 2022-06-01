-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_Service (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Service(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer   ,    
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('movement_Service_seq') AS TVarChar)  AS InvNumber
           , CURRENT_DATE                    :: TDateTime     AS OperDate
      ;
     ELSE
     
     RETURN QUERY 
       SELECT
             inMovementId AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_service_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN CAST (CURRENT_DATE AS TDateTime) ELSE Movement.OperDate END ::TDateTime AS OperDate
       FROM Movement
       WHERE Movement.Id = inMovementId_Value;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.22         *
 */

-- тест
-- SELECT * FROM gpGet_Movement_Service (inMovementId:= 0, inOperDate:= NULL :: TDateTime, inSession:= zfCalc_UserAdmin());
