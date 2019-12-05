-- Function: gpReport_PercentageOverdueSUN()

DROP FUNCTION IF EXISTS gpReport_PercentageOverdueSUN (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PercentageOverdueSUN(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitCode Integer, UnitName TVarChar
             , CountAll Integer, CountSend Integer, CountOverdue Integer, Procent TFloat
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);

  -- Результат
  RETURN QUERY
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.StatusId
                            , Movement.OperDate
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.DescId = zc_Movement_Send())
     , tmpResult AS (SELECT Object_From.ObjectCode                                                         AS UnitCode
                          , Object_From.ValueData                                                          AS UnitName
                          , Count(*)                                                                       AS CountAll
                          , Sum(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN 1 ELSE 0 END) AS CountSend
                          , Sum(CASE WHEN Movement.StatusId <> zc_Enum_Status_Complete()
                                AND Movement.OperDate < CURRENT_DATE THEN 1 ELSE 0 END)                    AS CountOverdue
                          , 1.0 * Sum(CASE WHEN Movement.StatusId <> zc_Enum_Status_Complete()
                                AND Movement.OperDate < CURRENT_DATE THEN 1 ELSE 0 END) / Count(*) * 100   AS Procent
                     FROM tmpMovement AS Movement
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                     GROUP BY Object_From.ID, Object_From.ObjectCode, Object_From.ValueData)

  SELECT ROW_NUMBER() OVER (ORDER BY tmpResult.Procent DESC)::Integer AS Id
       , tmpResult.UnitCode
       , tmpResult.UnitName
       , tmpResult.CountAll::Integer
       , tmpResult.CountSend::Integer
       , tmpResult.CountOverdue::Integer
       , tmpResult.Procent::TFloat
  FROM tmpResult;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_PercentageOverdueSUN (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/

-- тест
-- SELECT * FROM gpReport_PercentageOverdueSUN (inStartDate:= '01.10.2019', inEndDate:= '30.10.2019', inSession:= '3')

