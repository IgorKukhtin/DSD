-- Function: gpSelect_Movement_TransportChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cost (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cost(
    IN inParentId    Integer   ,
    IN inIsErased    Boolean   ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )

          SELECT Movement.Id AS MovementId
               , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
               , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
               , Movement.OperDate
               , Object_Status.ObjectCode                      AS StatusCode
               , Object_Status.ValueData                       AS StatusName
          FROM Movement
             INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
             LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpList.StatusId
          WHERE Movement.Id = inParentId
          
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cost (inParentId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
