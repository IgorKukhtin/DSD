-- Function: gpReport_FulfillmentPlanMobileAppAntiTOP()

DROP FUNCTION IF EXISTS gpReport_FulfillmentPlanMobileAppAntiTOP (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_FulfillmentPlanMobileAppAntiTOP(
    IN inOperDate     TDateTime , --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , CountChech TFloat, CountSite TFloat, CountUser Integer, ProcPlan TFloat
             , UserId Integer, UserCode Integer, UserName TVarChar
             , CountChechUser TFloat, CountMobileUser TFloat, CountShortage TFloat, QuantityMobile Integer, ProcFact TFloat
             , PenaltiMobApp TFloat, isShowPlanMobileAppUser Boolean
             , AntiTOPMP_Place Integer, SumPlace Integer, Place Integer, Color_Calc Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAntiTOPMP_SumFine TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     

     SELECT ObjectFloat_CashSettings_AntiTOPMP_SumFine.ValueData                     AS AntiTOPMP_SumFine
     INTO vbAntiTOPMP_SumFine
     FROM Object AS Object_CashSettings

          LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AntiTOPMP_SumFine
                                ON ObjectFloat_CashSettings_AntiTOPMP_SumFine.ObjectId = Object_CashSettings.Id 
                               AND ObjectFloat_CashSettings_AntiTOPMP_SumFine.DescId = zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine()

     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

     -- Результат
     RETURN QUERY
     SELECT T1.UnitId, T1.UnitCode, T1.UnitName
          , T1.CountChech, T1.CountSite, T1.CountUser, T1.ProcPlan
          , T1.UserId, T1.UserCode, T1.UserName
          , T1.CountChechUser, T1.CountMobileUser, T1.CountShortage, T1.QuantityMobile, T1.ProcFact 
          , CASE WHEN T1.Color_Calc = zfCalc_Color (255, 69, 0) THEN - vbAntiTOPMP_SumFine END::TFloat, T1.isShowPlanMobileAppUser
          , T1.AntiTOPMP_Place, T1.SumPlace, T1.Place, T1.Color_Calc 
     FROM gpReport_FulfillmentPlanMobileApp(inOperDate, 0, 0, inSession) AS T1
     WHERE COALESCE(T1.AntiTOPMP_Place, 0) > 0
     ORDER BY T1.AntiTOPMP_Place;     
      
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Check_TabletkiRecreate (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 14.02.23                                                        * 
*/            

-- 

select * from gpReport_FulfillmentPlanMobileAppAntiTOP(inOperDate := ('01.06.2023')::TDateTime , inSession := '3');     