-- Function: gpSelect_Movement_PromoUnit()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoUnit (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoUnit(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat, TotalSummAdd TFloat
             , UnitId Integer, UnitName TVarChar
             , UnitCategoryId Integer, UnitCategoryName TVarChar
             , PersonalId Integer,  PersonalName TVarChar
             , Comment TVarChar
             )
             
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PromoUnit());
     vbUserId:= lpGetUserBySession (inSession);
     
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

      SELECT Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementFloat_TotalSumm.ValueData          AS TotalSum
           , MovementFloat_TotalSummAdd.ValueData       AS TotalSummAdd
           , Object_Unit.Id                             AS UnitId
           , Object_Unit.ValueData                      AS UnitName
           , Object_UnitCategory.Id                     AS UnitCategoryId
           , Object_UnitCategory.ValueData              AS UnitCategoryName
           , Object_Personal.Id                         AS PersonalId
           , Object_Personal.ValueData                  AS PersonalName
           , MovementString_Comment.ValueData           AS Comment

      FROM tmpStatus
            INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                               AND Movement.DescId = zc_Movement_PromoUnit()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummAdd
                                    ON MovementFloat_TotalSummAdd.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummAdd.DescId = zc_MovementFloat_TotalSummAdd()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                         ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
            LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = MovementLinkObject_UnitCategory.ObjectId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 08.05.18                                                                     *                   
 04.02.17         *
*/

-- тест
-- select * from gpSelect_Movement_PromoUnit(inStartDate := ('01.04.2017')::TDateTime , inEndDate := ('30.04.2017')::TDateTime , inIsErased := 'False' ,  inSession := '3');