
-- Function: gpReport_ApplicationAward()

DROP FUNCTION IF EXISTS gpReport_ApplicationAward (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ApplicationAward(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitCode       Integer         
             , UnitName       TVarChar
             , CountCheck     Integer
             , CountCheckPrew Integer
             , DCountCheck    Integer
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
     WITH tmpEmployeeSchedule AS (SELECT DISTINCT
                                         Movement.OperDate                        AS OperDate
                                       , MovementItemMaster.ObjectId              AS UserId
                                       , MILinkObject_Unit.ObjectId               AS UnitId
                                      FROM Movement

                                           INNER JOIN MovementItem AS MovementItemMaster
                                                                   ON MovementItemMaster.MovementId = Movement.Id
                                                                  AND MovementItemMaster.DescId = zc_MI_Master()

                                           INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                             ON MILinkObject_Unit.MovementItemId = MovementItemMaster.Id
                                                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                      WHERE Movement.OperDate BETWEEN date_trunc('Month', inStartDate) - INTERVAL '1 MONTH' AND date_trunc('Month', inEndDate)
                                        AND Movement.DescId = zc_Movement_EmployeeSchedule()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()),
         tmpEmployeeScheduleDey AS (SELECT Movement.OperDate + (((MovementItemChild.Amount - 1)::INTEGER)::TVarChar||' DAY')::INTERVAL AS OperDate
                                         , MovementItemMaster.ObjectId              AS UserId
                                         , MovementItemChild.ObjectId               AS UnitId
                                         , ROW_NUMBER() OVER (PARTITION BY Movement.OperDate + (((MovementItemChild.Amount - 1)::INTEGER)::TVarChar||' DAY')::INTERVAL
                                                            , MovementItemMaster.ObjectId ORDER BY (MIDate_End.ValueData::Time - MIDate_Start.ValueData::Time) DESC) AS ORD
                                        FROM Movement

                                             INNER JOIN MovementItem AS MovementItemMaster
                                                                     ON MovementItemMaster.MovementId = Movement.Id
                                                                    AND MovementItemMaster.DescId = zc_MI_Master()

                                             INNER JOIN MovementItem AS MovementItemChild
                                                                     ON MovementItemChild.MovementId = Movement.Id
                                                                    AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                                    AND MovementItemChild.DescId = zc_MI_Child()

                                             LEFT JOIN MovementItemDate AS MIDate_Start
                                                                        ON MIDate_Start.MovementItemId = MovementItemChild.Id
                                                                       AND MIDate_Start.DescId = zc_MIDate_Start()

                                             LEFT JOIN MovementItemDate AS MIDate_End
                                                                        ON MIDate_End.MovementItemId = MovementItemChild.Id
                                                                       AND MIDate_End.DescId = zc_MIDate_End()

                                        WHERE Movement.OperDate BETWEEN date_trunc('Month', inStartDate) AND date_trunc('Month', inEndDate)
                                          AND Movement.DescId = zc_Movement_EmployeeSchedule()
                                          AND Movement.StatusId <> zc_Enum_Status_Erased()),
         tmpCheckGoodsSpecial AS (SELECT MovementItemContainer.MovementId
                                         , SUM(ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price, 2))      AS Summa
                                         , SUM(CASE WHEN MovementItemContainer.OperDate >= '16.06.2021'
                                                     AND (COALESCE(MovementString_InvNumberOrder.ValueData, '') <> ''
                                                      OR COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0
                                                     AND MovementItemContainer.OperDate < '03.08.2021')
                                                    THEN ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price, 2) 
                                                    ELSE 0 END)                                                                AS SummaSite
                                    FROM MovementItemContainer

                                         LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                                      ON MovementLinkObject_CheckSourceKind.MovementId =  MovementItemContainer.MovementId
                                                                     AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

                                         LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                                  ON MovementString_InvNumberOrder.MovementId = MovementItemContainer.MovementId
                                                                 AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                                    WHERE MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate) - INTERVAL '1 MONTH'
                                      AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                      AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                      AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                      AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                                                      FROM Object_Goods_Retail
                                                                                      WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                                                                         OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0)
                                    GROUP BY MovementItemContainer.MovementId),                                          
         tmpMovement AS (SELECT Movement.OperDate
                              , Movement.Id
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

                              LEFT JOIN tmpCheckGoodsSpecial ON tmpCheckGoodsSpecial.MovementId = Movement.ID

                         WHERE Movement.DescId = zc_Movement_Check()
                           AND Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate) - INTERVAL '1 MONTH'
                           AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                           AND COALESCE (MovementLinkObject_DiscountExternal.ObjectId, 0) = 0 
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND (MovementFloat_TotalSumm.ValueData + COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0)) >= 199.50),
         tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                      , MIN(MovementProtocol.OperDate) AS OperDate
                                 FROM tmpMovement AS Movement

                                      INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                      
                                 GROUP BY MovementProtocol.MovementId
                                 ),
         tmpUserReferals AS (SELECT Movement.OperDate
                                  , Movement.UserId
                                  , COALESCE(tmpEmployeeSchedule.UnitId, tmpEmployeeScheduleDey.UnitId, Movement.UnitId) AS UnitId
                             FROM tmpMovement AS Movement
                             
                                  LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id

                                  LEFT JOIN tmpEmployeeSchedule ON tmpEmployeeSchedule.OperDate = date_trunc('Month', Movement.OperDate)
                                                               AND tmpEmployeeSchedule.UserId = Movement.UserId
                               
                                  LEFT JOIN tmpEmployeeScheduleDey ON tmpEmployeeScheduleDey.OperDate = date_trunc('DAY', Movement.OperDate)
                                                                  AND tmpEmployeeScheduleDey.UserId = Movement.UserId
                                                                  AND tmpEmployeeScheduleDey.ORD = 1
                                                                  
                             WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                             ),
         tmpUserReferalsUnit AS (SELECT tmpUserReferals.UnitId
                                      , COUNT(DISTINCT tmpUserReferals.UserId) AS CountUser
                                      , COUNT(*)::Integer                      AS CountCheck
                                 FROM tmpUserReferals
                                 GROUP BY tmpUserReferals.UnitId),
         tmpUserReferalsPrew AS (SELECT Movement.OperDate
                                      , Movement.UserId
                                      , COALESCE(tmpEmployeeSchedule.UnitId, tmpEmployeeScheduleDey.UnitId, Movement.UnitId) AS UnitId
                                 FROM tmpMovement AS Movement
                                 
                                      LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id

                                      LEFT JOIN tmpEmployeeSchedule ON tmpEmployeeSchedule.OperDate = date_trunc('Month', Movement.OperDate)
                                                                   AND tmpEmployeeSchedule.UserId = Movement.UserId
                                   
                                      LEFT JOIN tmpEmployeeScheduleDey ON tmpEmployeeScheduleDey.OperDate = date_trunc('DAY', Movement.OperDate)
                                                                      AND tmpEmployeeScheduleDey.UserId = Movement.UserId
                                                                      AND tmpEmployeeScheduleDey.ORD = 1
                                                                      
                                 WHERE DATE_TRUNC ('MONTH', inStartDate) = DATE_TRUNC ('MONTH', inEndDate)
                                   AND (Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) - INTERVAL '1 MONTH' + INTERVAL '1 DAY' OR 
                                        DATE_TRUNC ('DAY', inStartDate) + INTERVAL '1 MONTH' = DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY' AND
                                        Movement.OperDate < DATE_TRUNC ('DAY', inStartDate))
                                 ),
         tmpUserReferalsUnitPrew AS (SELECT tmpUserReferals.UnitId
                                          , COUNT(DISTINCT tmpUserReferals.UserId) AS CountUser
                                          , COUNT(*)::Integer                      AS CountCheck
                                     FROM tmpUserReferalsPrew AS tmpUserReferals
                                     GROUP BY tmpUserReferals.UnitId)
                                 
      SELECT Object_Unit.ObjectCode                           AS UnitCode
           , Object_Unit.ValueData                            AS UnitName
           , COALESCE(tmpUserReferalsUnit.CountCheck, 0)      AS CountCheck
           , COALESCE(tmpUserReferalsUnitPrew.CountCheck, 0)  AS CountCheckPrew
           , CASE WHEN DATE_TRUNC ('MONTH', inStartDate) <> DATE_TRUNC ('MONTH', inEndDate) THEN 0
                  WHEN COALESCE(tmpUserReferalsUnit.CountCheck, 0) > COALESCE(tmpUserReferalsUnitPrew.CountCheck, 0) THEN 1
                  WHEN COALESCE(tmpUserReferalsUnit.CountCheck, 0) < COALESCE(tmpUserReferalsUnitPrew.CountCheck, 0) THEN 2
                  ELSE 3 END::INTEGER                         AS DCountCheck
      FROM (SELECT tmp.ID AS UnitId FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp) AS tmpUnit
        
           LEFT JOIN tmpUserReferalsUnit ON tmpUserReferalsUnit.UnitId =  tmpUnit.UnitId

           LEFT JOIN tmpUserReferalsUnitPrew ON tmpUserReferalsUnitPrew.UnitId =  tmpUnit.UnitId
             
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId
             
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

select * from gpReport_ApplicationAward(inStartDate := ('01.10.2022')::TDateTime , inEndDate := ('14.10.2022')::TDateTime ,  inSession := '3');