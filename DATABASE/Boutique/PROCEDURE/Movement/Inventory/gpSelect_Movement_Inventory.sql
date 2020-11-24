-- Function: gpSelect_Movement_Inventory()

DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Inventory(
    IN inStartDate         TDateTime , -- Дата нач. периода
    IN inEndDate           TDateTime , -- Дата оконч. периода
    IN inIsErased          Boolean   , -- показывать удаленные Да/Нет
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalCountRemains TFloat
             , TotalSummPriceList TFloat, TotalSummRemainsPriceList TFloat
             , FromName TVarChar, ToName TVarChar
             , Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     --vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                          AS StatusCode
           , Object_Status.ValueData                           AS StatusName

           , MovementFloat_TotalCount.ValueData                AS TotalCount
           , MovementFloat_TotalCountRemains.ValueData         AS TotalCountRemains

           , MovementFloat_TotalSummPriceList.ValueData        AS TotalSummPriceList
           , MovementFloat_TotalSummRemainsPriceList.ValueData AS TotalSummRemainsPriceList

           , Object_From.ValueData                             AS FromName
           , Object_To.ValueData                               AS ToName
           , MovementString_Comment.ValueData                  AS Comment
         
       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                               AND Movement.DescId = zc_Movement_Inventory()
                               AND Movement.StatusId = tmpStatus.StatusId
             ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountRemains
                                    ON MovementFloat_TotalCountRemains.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountRemains.DescId = zc_MovementFloat_TotalCountRemains()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId = zc_MovementFloat_TotalSummPriceList()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummRemainsPriceList
                                    ON MovementFloat_TotalSummRemainsPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummRemainsPriceList.DescId = zc_MovementFloat_TotalSummRemainsPriceList()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.17         * add To
 02.05.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Inventory (inStartDate:= '01.01.2020', inEndDate:= '01.02.2021', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
