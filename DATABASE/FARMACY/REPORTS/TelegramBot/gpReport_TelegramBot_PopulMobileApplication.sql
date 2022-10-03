-- Function: gpReport_TelegramBot_PopulMobileApplication()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_PopulMobileApplication (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_PopulMobileApplication(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitCode   Integer         
             , UnitName   TVarChar
             , Users      TVarChar
             , Summa      TFloat
             , CountChech Integer
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
     
     IF date_part('DAY',  CURRENT_DATE)::Integer = 1
     THEN

       -- Результат
       RETURN QUERY
       WITH tmpBoard AS (SELECT
                                MIMaster.ObjectId                          AS UserID
                              , MILinkObject_Unit.ObjectId                 AS UnitId
                              , ObjectLink_Member_Position.ChildObjectId   AS PositionId
                              , Object_Position.ObjectCode                 AS PositionCode
                              , Object_Position.ValueData                  AS PositionName
                         FROM Movement


                              INNER JOIN MovementItem AS MIMaster
                                                      ON MIMaster.MovementId = Movement.id
                                                     AND MIMaster.isErased = False
                                                     AND MIMaster.DescId = zc_MI_Master()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                               ON MILinkObject_Unit.MovementItemId = MIMaster.Id
                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                              LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                   ON ObjectLink_User_Member.ObjectId = MIMaster.ObjectId
                                                  AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                              LEFT JOIN Object AS Object_Member ON Object_Member.Id =ObjectLink_User_Member.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                   ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                  AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                              LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                                                  
                         WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                            AND Movement.OperDate = DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY')
                            -- AND ObjectLink_Member_Position.ChildObjectId = 1672498
                         ),
           tmpBoardUser AS (SELECT tmpBoard.UnitId
                                 , COUNT(*) AS CountUser
                                 , SUM(CASE WHEN tmpBoard.PositionCode = 1 THEN 1 ELSE 0 END)  AS CountUser1
                                 , SUM(CASE WHEN tmpBoard.PositionCode <> 1 THEN 1 ELSE 0 END) AS CountUser2
                            FROM tmpBoard
                            GROUP BY tmpBoard.UnitId),
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

                                      WHERE MovementItemContainer.OperDate >= DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY')
                                        AND MovementItemContainer.OperDate < DATE_TRUNC ('month', CURRENT_DATE) 
                                        AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                        AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                        AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                                                        FROM Object_Goods_Retail
                                                                                        WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                                                                           OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0)
                                      GROUP BY MovementItemContainer.MovementId),
           tmpUserReferals AS (SELECT Movement.OperDate
                                    , MLO_UserReferals.ObjectId                           AS UserId
                                    , tmpBoard.UnitId                                     AS UnitId
                                    , tmpBoard.PositionCode                               AS PositionCode
                                    , CASE WHEN MovementFloat_TotalSumm.ValueData - COALESCE(tmpCheckGoodsSpecial.Summa, 0) > 1000 
                                           THEN ROUND((MovementFloat_TotalSumm.ValueData - COALESCE(tmpCheckGoodsSpecial.Summa, 0)) * 0.02, 2)
                                           ELSE 20 END::TFloat  AS ApplicationAward
                               FROM Movement
                               
                                    INNER JOIN MovementLinkObject AS MLO_UserReferals
                                                                  ON MLO_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
                                                                 AND MLO_UserReferals.MovementId = Movement.Id

                                    INNER JOIN MovementBoolean AS MovementBoolean_MobileFirstOrder
                                                               ON MovementBoolean_MobileFirstOrder.MovementId = Movement.Id
                                                              AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()
                                                              AND MovementBoolean_MobileFirstOrder.ValueData = True

                                    INNER JOIN (SELECT DISTINCT
                                                       tmpBoard.UserID
                                                     , tmpBoard.UnitId
                                                     , tmpBoard.PositionCode
                                                FROM tmpBoard) AS tmpBoard ON tmpBoard.UserID = MLO_UserReferals.ObjectId  
                                                       
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
                                 AND Movement.OperDate >= DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY')
                                 AND Movement.OperDate < DATE_TRUNC ('month', CURRENT_DATE) 
                                 AND COALESCE (MovementLinkObject_DiscountExternal.ObjectId, 0) = 0 
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                 AND (MovementFloat_TotalSumm.ValueData + COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) - 
                                      COALESCE(tmpCheckGoodsSpecial.Summa, 0)) >= 199.50),
           tmpUserReferalsUnit AS (SELECT tmpUserReferals.UnitId
                                        , COUNT(*)                               AS CountChech
                                        , COUNT(DISTINCT tmpUserReferals.UserId) AS CountUser
                                        , COUNT(DISTINCT CASE WHEN tmpUserReferals.PositionCode = 1 THEN tmpUserReferals.UserId END) AS CountUser1
                                        , COUNT(DISTINCT CASE WHEN tmpUserReferals.PositionCode <> 1 THEN tmpUserReferals.UserId END) AS CountUser2
                                        , SUM(tmpUserReferals.ApplicationAward)::TFloat                AS Summa
                                   FROM tmpUserReferals
                                   GROUP BY tmpUserReferals.UnitId)
                                 
        SELECT Object_Unit.ObjectCode      AS UnitCode
             , Object_Unit.ValueData       AS UnitName
             , (COALESCE (tmpUserReferalsUnit.CountUser, 0)::Text||' из '||COALESCE (tmpBoardUser.CountUser, 0)::Text ||
               CASE WHEN tmpBoardUser.CountUser1 > COALESCE (tmpUserReferalsUnit.CountUser1, 0) OR tmpBoardUser.CountUser2 > COALESCE (tmpUserReferalsUnit.CountUser2, 0)
                    THEN ' (кроме ' || CASE WHEN tmpBoardUser.CountUser1 > COALESCE (tmpUserReferalsUnit.CountUser1, 0)
                                            THEN COALESCE (tmpBoardUser.CountUser1 - COALESCE (tmpUserReferalsUnit.CountUser1, 0), 0)::Text||'Ф'
                                            ELSE '' 
                                            END ||
                                       CASE WHEN tmpBoardUser.CountUser1 > COALESCE (tmpUserReferalsUnit.CountUser1, 0) AND tmpBoardUser.CountUser2 > COALESCE (tmpUserReferalsUnit.CountUser2, 0)
                                            THEN ' и '
                                            ELSE '' 
                                            END ||
                                       CASE WHEN tmpBoardUser.CountUser2 > COALESCE (tmpUserReferalsUnit.CountUser2, 0)
                                            THEN COALESCE (tmpBoardUser.CountUser2 - COALESCE (tmpUserReferalsUnit.CountUser2, 0), 0)::Text||'К'
                                            ELSE '' 
                                            END ||
                                            
                          ')'
                    ELSE '' END)::TVArChar AS Users
             , tmpUserReferalsUnit.Summa      AS Summa
             , tmpUserReferalsUnit.CountChech::Integer AS CountChech
        FROM tmpBoardUser
        
             LEFT JOIN tmpUserReferalsUnit ON tmpUserReferalsUnit.UnitId =  tmpBoardUser.UnitId
             
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpBoardUser.UnitId
             
        ORDER BY COALESCE(tmpUserReferalsUnit.Summa, 0)  DESC;
        
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_TelegramBot_PopulMobileApplication (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.06.21                                                       * 
*/

-- тест

select * from gpReport_TelegramBot_PopulMobileApplication(inSession := '3');     