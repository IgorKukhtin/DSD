DROP FUNCTION IF EXISTS gpGet_Object_ReportSoldParams(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReportSoldParams(
    IN inId       Integer,     -- ID плана
    IN inSession  TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer
             , UnitCode Integer
             , UnitName TVarChar
             , PlanDate TDateTime
             , PlanAmount TFloat
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
BEGIN
    -- Результат
    IF  inId = 0
    THEN
        RETURN QUERY
            SELECT
                0                AS Id
               ,NULL::Integer    AS UnitId
               ,NULL::Integer    AS UnitCode
               ,NULL::TVarChar   AS UnitName
               ,NULL::TDateTime  AS PlanDate
               ,NULL::TFloat     AS PlanAmount
            ;
    ELSE
        RETURN QUERY
            SELECT
                Object_ReportSoldParams.Id         AS Id
               ,Object_ReportSoldParams.UnitId     AS UnitId
               ,Object_ReportSoldParams.UnitCode   AS UnitCode
               ,Object_ReportSoldParams.UnitName   AS UnitName
               ,Object_ReportSoldParams.PlanDate   AS PlanDate
               ,Object_ReportSoldParams.PlanAmount AS PlanAmount
            FROM 
                Object_ReportSoldParams_View AS Object_ReportSoldParams
            WHERE
                Object_ReportSoldParams.Id = inId;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ReportSoldParams(Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А. 
 29.08.15                                                         *
*/