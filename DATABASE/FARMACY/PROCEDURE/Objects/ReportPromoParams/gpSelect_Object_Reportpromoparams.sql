-- Function: gpSelect_Object_ReportPromoParams(tdatetime, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpSelect_Object_ReportPromoParams(TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportPromoParams(
    IN inplandate tdatetime,
    IN inshowall boolean,
    IN insession tvarchar
 )
  RETURNS TABLE(id integer, unitid integer, unitcode integer, unitname tvarchar
              , plandate tdatetime, planamount tfloat
                ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    -- Результат
    IF  inShowAll = True
    THEN
        RETURN QUERY
            SELECT Object_ReportPromoParams.Id                AS Id
                 , Object_Unit.Id                             AS UnitId
                 , Object_Unit.ObjectCode                     AS UnitCode
                 , Object_Unit.ValueData                      AS UnitName
                 , Date_trunc('month', inPlanDate)::TDateTime AS PlanDate
                 , Object_ReportPromoParams.PlanAmount        AS PlanAmount
            FROM Object AS Object_Unit
                LEFT JOIN Object_ReportPromoParams_View AS Object_ReportPromoParams
                                                        ON Object_ReportPromoParams.UnitId = Object_Unit.Id
                                                       AND Object_ReportPromoParams.PlanDate = Date_trunc('month', inPlanDate)::TDateTime
            WHERE Object_Unit.DescId = zc_Object_Unit()
            ORDER BY UnitName;
    ELSE
        RETURN QUERY
            SELECT Object_ReportPromoParams.Id         AS Id
                 , Object_ReportPromoParams.UnitId     AS UnitId
                 , Object_ReportPromoParams.UnitCode   AS UnitCode
                 , Object_ReportPromoParams.UnitName   AS UnitName
                 , Object_ReportPromoParams.PlanDate   AS PlanDate
                 , Object_ReportPromoParams.PlanAmount AS PlanAmount
            FROM Object_ReportPromoParams_View AS Object_ReportPromoParams
            WHERE Object_ReportPromoParams.PlanDate = Date_trunc('month', inPlanDate)::TDateTime
            ORDER BY UnitName;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А. 
 09.01.17         *
*/