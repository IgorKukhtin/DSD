-- Function: gpSelect_Movement_Inventory()

DROP FUNCTION IF EXISTS gpSelect_Movement_Inventory (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Inventory(
    IN inStartDate   TDateTime , --С даты
    IN inEndDate     TDateTime , --По дату
    IN inIsErased    Boolean ,   --Так же удаленные
    IN inSession     TVarChar    --сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , DeficitSumm TFloat, ProficitSumm TFloat, Diff TFloat, DiffSumm TFloat
             , UnitId Integer, UnitName TVarChar, FullInvent Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
       SELECT
             Movement.Id                                          AS Id
           , Movement.InvNumber                                   AS InvNumber
           , Movement.OperDate                                    AS OperDate
           , Object_Status.ObjectCode                             AS StatusCode
           , Object_Status.ValueData                              AS StatusName
           , MovementFloat_DeficitSumm.ValueData                  AS DeficitSumm
           , MovementFloat_ProficitSumm.ValueData                 AS ProficitSumm
           , MovementFloat_Diff.ValueData                         AS Diff
           , MovementFloat_DiffSumm.ValueData                     AS DiffSumm
           , Object_Unit.Id                                       AS UnitId
           , Object_Unit.ValueData                                AS UnitName
           , COALESCE(MovementBoolean_FullInvent.ValueData,False) AS FullInvent
       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate AND Movement.DescId = zc_Movement_Inventory() AND Movement.StatusId = tmpStatus.StatusId
            ) AS tmpMovement
            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                            ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                           AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()

            LEFT OUTER JOIN MovementFloat AS MovementFloat_DeficitSumm
                                          ON MovementFloat_DeficitSumm.MovementId = Movement.Id
                                         AND MovementFloat_DeficitSumm.DescId = zc_MovementFloat_TotalDeficitSumm()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProficitSumm
                                          ON MovementFloat_ProficitSumm.MovementId = Movement.Id
                                         AND MovementFloat_ProficitSumm.DescId = zc_MovementFloat_TotalProficitSumm()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_Diff
                                          ON MovementFloat_Diff.MovementId = Movement.Id
                                         AND MovementFloat_Diff.DescId = zc_MovementFloat_TotalDiff()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_DiffSumm
                                          ON MovementFloat_DiffSumm.MovementId = Movement.Id
                                         AND MovementFloat_DiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Inventory (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Воробкало А.А.
 16.09.15                                                                       * + FullInvent
 11.07.15                                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Inventory (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inIsErased:= FALSE, inSession:= '2')
