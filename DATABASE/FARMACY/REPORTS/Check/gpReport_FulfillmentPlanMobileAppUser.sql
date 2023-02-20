-- Function: gpReport_FulfillmentPlanMobileAppUser()

DROP FUNCTION IF EXISTS gpReport_FulfillmentPlanMobileAppUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_FulfillmentPlanMobileAppUser(
    IN inOperDate     TDateTime , --
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , CountChech TFloat, CountSite TFloat, CountUser Integer, ProcPlan TFloat
             , UserId Integer, UserCode Integer, UserName TVarChar
             , CountChechUser TFloat, CountMobileUser TFloat, QuantityMobile Integer, ProcFact TFloat
             , PenaltiMobApp TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     IF inSession = '3'
     THEN
       vbUserId := 19769234;
     END IF;
     
          -- Результат
     RETURN QUERY
     SELECT FulfillmentPlanMobile.UnitId 
          , FulfillmentPlanMobile.UnitCode
          , FulfillmentPlanMobile.UnitName
          , FulfillmentPlanMobile.CountChech 
          , FulfillmentPlanMobile.CountSite 
          , FulfillmentPlanMobile.CountUser 
          , FulfillmentPlanMobile.ProcPlan 
          , FulfillmentPlanMobile.UserId 
          , FulfillmentPlanMobile.UserCode 
          , FulfillmentPlanMobile.UserName 
          , FulfillmentPlanMobile.CountChechUser 
          , FulfillmentPlanMobile.CountMobileUser
          , FulfillmentPlanMobile.QuantityMobile 
          , FulfillmentPlanMobile.ProcFact
          , FulfillmentPlanMobile.PenaltiMobApp 
     FROM gpReport_FulfillmentPlanMobileApp (('01.02.2023')::TDateTime, 0, vbUserId, inSession) AS FulfillmentPlanMobile;

         
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_FulfillmentPlanMobileAppUser (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 19.02.23                                                        * 
*/            

-- 

select * from gpReport_FulfillmentPlanMobileAppUser(inOperDate := ('19.02.2023')::TDateTime , inSession := '3');

