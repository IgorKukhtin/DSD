-- Function: gpSelect_Movement_MarginCategoryUnit()

DROP FUNCTION IF EXISTS gpSelect_Movement_MarginCategoryUnit (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MarginCategoryUnit(
    IN inMovementId     Integer , --
    IN inIsErased       Boolean ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ObjectId Integer
             , ObjectCode Integer
             , ObjectName TVarChar
             , IsErased  Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

     SELECT Movement.Id         AS Id
          , Object.Id           AS ObjectId
          , Object.ObjectCode   AS ObjectCode
          , Object.ValueData    AS ObjectName
          , CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() THEN TRUE ELSE FALSE END AS IsErased
     FROM Movement 
        INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                     ON MovementLinkObject_Object.MovementId = Movement.Id
                                    AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
        LEFT JOIN Object ON Object.Id = MovementLinkObject_Object.ObjectId

     WHERE Movement.DescId = zc_Movement_MarginCategoryUnit()
       AND Movement.ParentId = inMovementId
     ORDER BY Object.ValueData;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.09.18         *
*/
--select * from gpSelect_Movement_MarginCategoryUnit(inMovementId := 0 , inIsErased:= true, inSession := '3');
