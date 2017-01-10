DROP VIEW IF EXISTS Object_ReportPromoParams_View;

CREATE OR REPLACE VIEW Object_ReportPromoParams_View 
AS
    SELECT
        Object_ReportPromoParams.Id             AS Id
      , Object_Unit.Id                          AS UnitId
      , Object_Unit.ObjectCode                  AS UnitCode
      , Object_Unit.ValueData                   AS UnitName

      , ReportPromoParams_PlanDate.ValueData    AS PlanDate
      , ReportPromoParams_PlanAmount.ValueData  AS PlanAmount
      
    FROM Object AS Object_ReportPromoParams
        LEFT JOIN ObjectDate AS ReportPromoParams_PlanDate
                             ON ReportPromoParams_PlanDate.ObjectId = Object_ReportPromoParams.Id
                            AND ReportPromoParams_PlanDate.DescId = zc_ObjectDate_ReportPromoParams_PlanDate()
        LEFT JOIN ObjectFloat AS ReportPromoParams_PlanAmount
                              ON ReportPromoParams_PlanAmount.ObjectId = Object_ReportPromoParams.Id
                             AND ReportPromoParams_PlanAmount.DescId = zc_ObjectFloat_ReportPromoParams_PlanAmount()
        
        LEFT JOIN ObjectLink AS ObjectLink_ReportPromoParams_Unit
                             ON ObjectLink_ReportPromoParams_Unit.ObjectId = Object_ReportPromoParams.Id
                            AND ObjectLink_ReportPromoParams_Unit.DescId = zc_ObjectLink_ReportPromoParams_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_ReportPromoParams_Unit.ChildObjectId
    WHERE Object_ReportPromoParams.DescId = zc_Object_ReportPromoParams();

ALTER TABLE Object_ReportPromoParams_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 09.01.17         *
*/

-- тест
-- SELECT * FROM Object_ReportPromoParams_View
