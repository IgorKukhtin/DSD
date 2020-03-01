-- Function: gpSelect_Movement_WagesTechnicalRediscountUnit()

DROP FUNCTION IF EXISTS gpSelect_Movement_WagesTechnicalRediscountUnit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WagesTechnicalRediscountUnit(
    IN inId          INTEGER,
    IN inSession     TVarChar    --сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , TotalDiff TFloat, TotalDiffSumm TFloat, SummWages TFloat
             , Comment TVarChar
             , Color_Calc Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbStartDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TechnicalRediscount());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT Movement.OperDate, MovementItem.ObjectId
     INTO vbStartDate, vbUnitId
     FROM MovementItem
          INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
     WHERE MovementItem.ID = inId;


       -- Результат
     RETURN QUERY
       SELECT
             Movement.Id                                          AS Id
           , Movement.InvNumber                                   AS InvNumber
           , Movement.OperDate                                    AS OperDate
           , Object_Status.ObjectCode                             AS StatusCode
           , Object_Status.ValueData                              AS StatusName

           , Object_Unit.Id                                       AS UnitId
           , Object_Unit.ValueData                                AS UnitName

           , MovementFloat_TotalDiff.ValueData                    AS TotalDiff
           , MovementFloat_TotalDiffSumm.ValueData                AS TotalDiffSumm
           , COALESCE (MIFloat_SummaManual.ValueData,
                  MovementFloat_TotalDiffSumm.ValueData)::TFloat  AS SummWages

           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment
           , CASE WHEN MIFloat_SummaManual.ValueData IS NULL
                  THEN zc_Color_Black() ELSE zc_Color_Yelow() END AS Color_Calc

       FROM (SELECT Movement.Id
                  , MovementLinkObject_Unit.ObjectId AS UnitId
             FROM Movement

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

             WHERE Movement.OperDate BETWEEN date_trunc('month', vbStartDate) AND date_trunc('month', vbStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
               AND Movement.DescId = zc_Movement_TechnicalRediscount()
               AND Movement.StatusId = zc_Enum_Status_UnComplete()
               AND MovementLinkObject_Unit.ObjectId  = vbUnitId) AS tmpMovement

            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiff
                                          ON MovementFloat_TotalDiff.MovementId = Movement.Id
                                         AND MovementFloat_TotalDiff.DescId = zc_MovementFloat_TotalDiff()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiffSumm
                                          ON MovementFloat_TotalDiffSumm.MovementId = Movement.Id
                                         AND MovementFloat_TotalDiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()
            LEFT OUTER JOIN MovementFloat AS MIFloat_SummaManual
                                          ON MIFloat_SummaManual.MovementId = Movement.Id
                                         AND MIFloat_SummaManual.DescId = zc_MIFloat_SummaManual()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                      ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                     AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()

       WHERE COALESCE (MovementBoolean_RedCheck.ValueData, False) = False;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_WagesTechnicalRediscountUnit (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_WagesTechnicalRediscountUnit (inId:= 316075544,  inSession := '3');