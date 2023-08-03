-- Function: gpReport_ImplementationPeriodTotal

--DROP FUNCTION IF EXISTS gpReport_ImplementationPeriodTotal (Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_ImplementationPeriodTotal (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_ImplementationPeriodTotal (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_ImplementationPeriodTotal (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ImplementationPeriodTotal (
       IN inUnitId Integer,
       IN inOperDate TDateTime,
       IN inTotalExecutionLine TFloat,
       IN inTotalExecutionFixed TFloat,
       IN inAmountTheFineTab TFloat,
       IN inBonusAmountTab TFloat,
       IN inBonusPercentSum TFloat,
       IN inBonusPercentAddSum TFloat,
       IN inisNewUser Boolean,
       IN inisCashier Boolean,
      OUT outTotal TFloat,
       IN inSession       TVarChar    -- сессия пользователя
       )
RETURNS TFloat
AS
$BODY$
  DECLARE vbScaleCalcMarketingPlanID integer;
  DECLARE vbisAdmin Boolean;
BEGIN

  vbScaleCalcMarketingPlanID := COALESCE((SELECT ObjectLink_UnitCategory_ScaleCalcMarketingPlan.ChildObjectId AS ScaleCalcMarketingPlanID
                                           FROM Object AS Object_UnitCategory

                                               INNER JOIN ObjectLink AS ObjectLink_Unit_Category
                                                                     ON ObjectLink_Unit_Category.ChildObjectId = Object_UnitCategory.Id
                                                                    AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()

                                               LEFT JOIN ObjectLink AS ObjectLink_UnitCategory_ScaleCalcMarketingPlan
                                                                    ON ObjectLink_UnitCategory_ScaleCalcMarketingPlan.ObjectId = Object_UnitCategory.Id
                                                                   AND ObjectLink_UnitCategory_ScaleCalcMarketingPlan.DescId = zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan()

                                           WHERE Object_UnitCategory.DescId = zc_Object_UnitCategory()
                                             AND ObjectLink_Unit_Category.ObjectId = inUnitId), 0);

    vbisAdmin := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE ObjectLink_UserRole_View.UserId = inSession::Integer 
                                                                   AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin()) 
                 OR inSession::Integer = 298786;
              
  outTotal := zfCalc_MarketingPlan_Scale (vbScaleCalcMarketingPlanID
                                        , inOperDate
                                        , inUnitId
                                        , inTotalExecutionLine
                                        , inTotalExecutionFixed
                                        , inAmountTheFineTab
                                        , inBonusAmountTab
                                        , inBonusPercentSum
                                        , inBonusPercentAddSum
                                        , inisNewUser
                                        , inisCashier
                                        , vbisAdmin); 

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION gpReport_ImplementationPeriodTotal (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.06.21                                                       *
*/

-- тест 
SELECT * FROM gpReport_ImplementationPeriodTotal (183292  , '01.06.2021', 10, 10, 20, 0, 0, 0, FALSE, TRUE, '3')