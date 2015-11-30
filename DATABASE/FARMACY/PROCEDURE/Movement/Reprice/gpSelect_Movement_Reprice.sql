-- Function: gpSelect_Movement_Reprice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Reprice (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Reprice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , TotalSumm TFloat
             , UnitId Integer
             , UnitName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        SELECT
            Movement_Reprice.Id
          , Movement_Reprice.InvNumber
          , Movement_Reprice.OperDate
          , Movement_Reprice.TotalSumm
          , Movement_Reprice.UnitId
          , Movement_Reprice.UnitName
        FROM
            Movement_Reprice_View AS Movement_Reprice
        WHERE
            DATE_TRUNC ('DAY', Movement_Reprice.OperDate) BETWEEN inStartDate AND inEndDate
        ORDER BY InvNumber;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Reprice (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 27.11.15                                                                        *
*/