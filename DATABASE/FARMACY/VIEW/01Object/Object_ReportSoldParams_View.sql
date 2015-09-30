DROP VIEW IF EXISTS Object_ReportSoldParams_View;

CREATE OR REPLACE VIEW Object_ReportSoldParams_View 
AS
    SELECT
        Object_ReportSoldParams.Id              AS Id
      , Object_Unit.Id                          AS UnitId
      , Object_Unit.ObjectCode                  AS UnitCode
      , Object_Unit.ValueData                   AS UnitName

      , ReportSoldParams_PlanDate.ValueData         AS PlanDate
      , ReportSoldParams_PlanAmount.ValueData       AS PlanAmount
      
    FROM Object AS Object_ReportSoldParams
        LEFT JOIN ObjectDate        AS ReportSoldParams_PlanDate
                                    ON ReportSoldParams_PlanDate.ObjectId = Object_ReportSoldParams.Id
                                   AND ReportSoldParams_PlanDate.DescId = zc_ObjectDate_ReportSoldParams_PlanDate()
        LEFT JOIN ObjectFloat       AS ReportSoldParams_PlanAmount
                                    ON ReportSoldParams_PlanAmount.ObjectId = Object_ReportSoldParams.Id
                                   AND ReportSoldParams_PlanAmount.DescId = zc_ObjectFloat_ReportSoldParams_PlanAmount()
        
        LEFT JOIN ObjectLink        AS ObjectLink_ReportSoldParams_Unit
                                    ON ObjectLink_ReportSoldParams_Unit.ObjectId = Object_ReportSoldParams.Id
                                   AND ObjectLink_ReportSoldParams_Unit.DescId = zc_ObjectLink_ReportSoldParams_Unit()
        LEFT JOIN Object            AS Object_Unit 
                                    ON Object_Unit.Id = ObjectLink_ReportSoldParams_Unit.ChildObjectId
    WHERE 
        Object_ReportSoldParams.DescId = zc_Object_ReportSoldParams();

ALTER TABLE Object_ReportSoldParams_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 07.09.14                                                         *
*/

-- тест
-- SELECT * FROM Object_ReportSoldParams_View
