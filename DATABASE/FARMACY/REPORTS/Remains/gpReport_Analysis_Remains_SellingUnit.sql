-- Function: gpReport_IncomeConsumptionBalanceUnit()

DROP FUNCTION IF EXISTS gpReport_Analysis_Remains_SellingUnit (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Analysis_Remains_SellingUnit(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer
             , JuridicalName TVarChar
             , UnitName TVarChar 
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());


  RETURN QUERY
  WITH
    tmpUnit AS (SELECT DISTINCT AnalysisContainer.UnitID   AS UnitID
                FROM AnalysisContainer AS AnalysisContainer)
    
  SELECT Unit.UnitID                                                      AS UnitID
       , Object_Juridical.ValueData
       , Object_Unit.ValueData 
  FROM tmpUnit AS Unit
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Unit.UnitId
       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                            ON ObjectLink_Unit_Juridical.ObjectId = Unit.UnitId
                           AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
  ORDER BY Object_Juridical.ValueData, Object_Unit.ValueData;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
             Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 07.01.20                                                      *
*/

-- тест
--
-- 
select * from gpReport_Analysis_Remains_SellingUnit(inSession := '3');