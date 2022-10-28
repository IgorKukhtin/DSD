
-- Function: gpReport_ApplicationAwardUser()

DROP FUNCTION IF EXISTS gpReport_ApplicationAwardUser (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ApplicationAwardUser(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserCode       Integer         
             , UserName       TVarChar
             , PositionName   TVarChar
             , UnitCode       Integer         
             , UnitName       TVarChar
             , CountCheck     Integer
             , CountCheckPrew Integer
             , DCountCheck    Integer
             , Color_Calc     Integer

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
     WITH tmpEmployeeScheduleDey AS (SELECT DISTINCT 
                                           MovementItemMaster.ObjectId              AS UserId
                                         , MILinkObject_Unit.ObjectId               AS UnitId
                                        FROM Movement

                                             INNER JOIN MovementItem AS MovementItemMaster
                                                                     ON MovementItemMaster.MovementId = Movement.Id
                                                                    AND MovementItemMaster.DescId = zc_MI_Master()

                                             INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                               ON MILinkObject_Unit.MovementItemId = MovementItemMaster.Id
                                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                        WHERE Movement.OperDate = date_trunc('Month', inStartDate)
                                          AND Movement.DescId = zc_Movement_EmployeeSchedule()
                                          AND Movement.StatusId <> zc_Enum_Status_Erased()),
         tmpMovement AS (SELECT Movement.OperDate
                              , Movement.Id
                              , MLO_UserReferals.ObjectId                           AS UserId
                              , MovementLinkObject_Unit.ObjectId                    AS UnitId
                         FROM Movement
                               
                              INNER JOIN MovementLinkObject AS MLO_UserReferals
                                                            ON MLO_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
                                                           AND MLO_UserReferals.MovementId = Movement.Id
                                                           AND COALESCE (MLO_UserReferals.ObjectId, 0) > 0

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

                              LEFT JOIN MovementFloat AS MovementFloat_ApplicationAward
                                                      ON MovementFloat_ApplicationAward.MovementId =  Movement.Id
                                                     AND MovementFloat_ApplicationAward.DescId = zc_MovementFloat_ApplicationAward()

                         WHERE Movement.DescId = zc_Movement_Check()
                           AND Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate) - INTERVAL '1 MONTH'
                           AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND COALESCE (MovementFloat_ApplicationAward.ValueData, 0) > 0),
         tmpUserReferals AS (SELECT Movement.OperDate
                                  , Movement.UserId
                             FROM tmpMovement AS Movement
                             
                             WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                             ),
         tmpUserReferalsUnit AS (SELECT tmpUserReferals.UserId
                                      , COUNT(*)::Integer                      AS CountCheck
                                 FROM tmpUserReferals
                                 GROUP BY tmpUserReferals.UserId),
         tmpUserReferalsPrew AS (SELECT Movement.OperDate
                                      , Movement.UserId
                                 FROM tmpMovement AS Movement
                                 
                                 WHERE DATE_TRUNC ('MONTH', inStartDate) = DATE_TRUNC ('MONTH', inEndDate)
                                   AND (Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) - INTERVAL '1 MONTH' + INTERVAL '1 DAY' OR 
                                        DATE_TRUNC ('DAY', inStartDate) + INTERVAL '1 MONTH' = DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY' AND
                                        Movement.OperDate < DATE_TRUNC ('DAY', inStartDate))
                                 ),
         tmpUserReferalsUnitPrew AS (SELECT tmpUserReferals.UserId
                                          , COUNT(*)::Integer                      AS CountCheck
                                     FROM tmpUserReferalsPrew AS tmpUserReferals
                                     GROUP BY tmpUserReferals.UserId),
         tmpCashSettings AS (SELECT COALESCE(ObjectFloat_CashSettings_NormNewMobileOrders.ValueData, 50)::TFloat   AS NormNewMobileOrders
                             FROM Object AS Object_CashSettings
                                  LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_NormNewMobileOrders
                                                        ON ObjectFloat_CashSettings_NormNewMobileOrders.ObjectId = Object_CashSettings.Id 
                                                       AND ObjectFloat_CashSettings_NormNewMobileOrders.DescId = zc_ObjectFloat_CashSettings_NormNewMobileOrders()
                             WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                             LIMIT 1) 
                                 
      SELECT Object_User.ObjectCode                           AS UserCode
           , Object_User.ValueData                            AS UserName
           , Object_Position.ValueData                        AS PositionName
           , Object_Unit.ObjectCode                           AS UnitCode
           , Object_Unit.ValueData                            AS UnitName
           , COALESCE(tmpUserReferalsUnit.CountCheck, 0)      AS CountCheck
           , COALESCE(tmpUserReferalsUnitPrew.CountCheck, 0)  AS CountCheckPrew
           , CASE WHEN DATE_TRUNC ('MONTH', inStartDate) <> DATE_TRUNC ('MONTH', inEndDate) THEN 0
                  WHEN COALESCE(tmpUserReferalsUnit.CountCheck, 0) > COALESCE(tmpUserReferalsUnitPrew.CountCheck, 0) THEN 1
                  WHEN COALESCE(tmpUserReferalsUnit.CountCheck, 0) < COALESCE(tmpUserReferalsUnitPrew.CountCheck, 0) THEN 2
                  ELSE 3 END::INTEGER                         AS DCountCheck
           , CASE WHEN COALESCE(tmpUserReferalsUnit.CountCheck, 0) >= tmpCashSettings.NormNewMobileOrders THEN zc_Color_Lime() 
                  ELSE zc_Color_White() END                   AS Color_Calc

      FROM tmpEmployeeScheduleDey AS tmp
        
           LEFT JOIN tmpUserReferalsUnit ON tmpUserReferalsUnit.UserId = tmp.UserId

           LEFT JOIN tmpUserReferalsUnitPrew ON tmpUserReferalsUnitPrew.UserId = tmp.UserId
             
           LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId
           
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId

           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                ON ObjectLink_User_Member.ObjectId = tmp.UserId
                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
    
           LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                               AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
           
           LEFT JOIN tmpCashSettings ON 1 = 1
             
      ORDER BY COALESCE(tmpUserReferalsUnit.CountCheck, 0)  DESC, COALESCE(tmpUserReferalsUnitPrew.CountCheck, 0)  DESC;

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


select * from gpReport_ApplicationAwardUser(inStartDate := ('01.10.2022')::TDateTime , inEndDate := ('31.10.2022')::TDateTime ,  inSession := '3');
