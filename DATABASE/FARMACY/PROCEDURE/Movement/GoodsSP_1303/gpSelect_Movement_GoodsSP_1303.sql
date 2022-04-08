-- Function: gpSelect_Movement_GoodsSP_1303()

DROP FUNCTION IF EXISTS gpSelect_Movement_GoodsSP_1303 (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GoodsSP_1303(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_GoodsSP_1303());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
 
       SELECT Movement.Id                           AS Id
            , Movement.InvNumber                    AS InvNumber
            , Movement.OperDate                     AS OperDate
            , Object_Status.ObjectCode              AS StatusCode
            , Object_Status.ValueData               AS StatusName

       FROM tmpStatus
            INNER JOIN Movement ON Movement.DescId = zc_Movement_GoodsSP_1303()
                               AND Movement.StatusId = tmpStatus.StatusId
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate 
                              
            INNER JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.22                                                       *
*/

-- тест
-- 
select * from gpSelect_Movement_GoodsSP_1303(instartdate := ('01.04.2022')::TDateTime , inenddate := ('08.04.2022')::TDateTime , inIsErased := 'False' ,  inSession := '3');