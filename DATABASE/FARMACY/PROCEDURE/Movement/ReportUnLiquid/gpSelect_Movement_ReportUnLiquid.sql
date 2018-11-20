-- Function: gpSelect_Movement_ReportUnLiquid()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReportUnLiquid (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ReportUnLiquid (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReportUnLiquid(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsPeriod      Boolean ,   -- выбираем период по датам нач. и оконч. отчета
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartSale        TDateTime   --Дата начала отчета
             , EndSale          TDateTime   --Дата окончания отчета
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpMovement AS (SELECT Movement.*
                               , MovementDate_StartSale.ValueData            AS StartSale
                               , MovementDate_EndSale.ValueData              AS EndSale
                          FROM Movement
                               INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
 
                               LEFT JOIN MovementDate AS MovementDate_StartSale
                                                      ON MovementDate_StartSale.MovementId = Movement.Id
                                                     AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                               LEFT JOIN MovementDate AS MovementDate_EndSale
                                                      ON MovementDate_EndSale.MovementId = Movement.Id
                                                     AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                          
                          WHERE Movement.DescId = zc_Movement_ReportUnLiquid()
                            AND ( (inIsPeriod = FALSE AND Movement.OperDate BETWEEN inStartDate AND inEndDate)
                               OR (inIsPeriod = TRUE AND (MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                                                       OR inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                                                          )
                                   )
                                )
                          )

       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Movement.StartSale                   AS StartSale
           , Movement.EndSale                     AS EndSale
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , MovementString_Comment.ValueData     AS Comment
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
       FROM tmpMovement AS Movement 

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.18         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ReportUnLiquid (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsPeriod := FALSE, inIsErased := FALSE, inSession:= '2')