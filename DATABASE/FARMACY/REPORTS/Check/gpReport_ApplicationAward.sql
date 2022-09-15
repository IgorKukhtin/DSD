-- Function: gpReport_ApplicationAward()

DROP FUNCTION IF EXISTS gpReport_ApplicationAward (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ApplicationAward(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitCode      Integer         
             , UnitName      TVarChar
             , CountCheck    Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbCountPrevM Integer;
   DECLARE vbCountCurrM Integer;
   DECLARE vbSummCurrM TFloat;
   DECLARE vbTextSite Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Результат
     RETURN QUERY
     WITH tmpUserReferals AS (SELECT Movement.OperDate
                                  , MLO_UserReferals.ObjectId                           AS UserId
                                  , MovementLinkObject_Unit.ObjectId                    AS UnitId
                             FROM Movement
                               
                                  INNER JOIN MovementLinkObject AS MLO_UserReferals
                                                                ON MLO_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
                                                               AND MLO_UserReferals.MovementId = Movement.Id

                                  INNER JOIN MovementBoolean AS MovementBoolean_MobileFirstOrder
                                                             ON MovementBoolean_MobileFirstOrder.MovementId = Movement.Id
                                                            AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()
                                                            AND MovementBoolean_MobileFirstOrder.ValueData = True

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                  LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                          ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                          ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                                         AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountExternal
                                                               ON MovementLinkObject_DiscountExternal.MovementId = Movement.Id
                                                              AND MovementLinkObject_DiscountExternal.DescId = zc_MILinkObject_DiscountExternal()

                             WHERE Movement.DescId = zc_Movement_Check()
                               AND Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                               AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                               AND COALESCE (MovementLinkObject_DiscountExternal.ObjectId, 0) = 0 
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND (MovementFloat_TotalSumm.ValueData + COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0)) >= 199.50),
         tmpUserReferalsUnit AS (SELECT tmpUserReferals.UnitId
                                      , COUNT(DISTINCT tmpUserReferals.UserId) AS CountUser
                                      , COUNT(*)::Integer                      AS CountCheck
                                 FROM tmpUserReferals
                                 GROUP BY tmpUserReferals.UnitId)
                                 
      SELECT Object_Unit.ObjectCode                       AS UnitCode
           , Object_Unit.ValueData                        AS UnitName
           , COALESCE(tmpUserReferalsUnit.CountCheck, 0)  AS CountCheck
      FROM (SELECT tmp.ID AS UnitId FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp) AS tmpUnit
        
           LEFT JOIN tmpUserReferalsUnit ON tmpUserReferalsUnit.UnitId =  tmpUnit.UnitId
             
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId
             
      ORDER BY COALESCE(tmpUserReferalsUnit.CountCheck, 0)  DESC;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_TelegramBot_PopulMobileApplication (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.09.22                                                       * 
*/

-- тест

select * from gpReport_ApplicationAward(inStartDate := ('01.08.2022')::TDateTime, inEndDate := ('30.09.2022')::TDateTime, inSession := '3');     