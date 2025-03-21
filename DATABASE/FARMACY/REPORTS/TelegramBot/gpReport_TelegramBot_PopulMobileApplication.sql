-- Function: gpReport_TelegramBot_PopulMobileApplication()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_PopulMobileApplication (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_PopulMobileApplication(
    IN inSession       TVarChar    -- ������ ������������
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
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     IF date_part('DAY',  CURRENT_DATE)::Integer = 1
     THEN

       -- ���������
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
           tmpUserReferals AS (SELECT Movement.OperDate
                                    , MLO_UserReferals.ObjectId                           AS UserId
                                    , tmpBoard.UnitId                                     AS UnitId
                                    , tmpBoard.PositionCode                               AS PositionCode
                                    , MovementFloat_ApplicationAward.ValueData            AS ApplicationAward
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
 
                                    LEFT JOIN MovementFloat AS MovementFloat_ApplicationAward
                                                            ON MovementFloat_ApplicationAward.MovementId =  Movement.Id
                                                           AND MovementFloat_ApplicationAward.DescId = zc_MovementFloat_ApplicationAward()
 
                               WHERE Movement.DescId = zc_Movement_Check()
                                 AND Movement.OperDate >= DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY')
                                 AND Movement.OperDate < DATE_TRUNC ('month', CURRENT_DATE) 
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                 AND COALESCE (MovementFloat_ApplicationAward.ValueData, 0) > 0),
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
             , (COALESCE (tmpUserReferalsUnit.CountUser, 0)::Text||' �� '||COALESCE (tmpBoardUser.CountUser, 0)::Text ||
               CASE WHEN tmpBoardUser.CountUser1 > COALESCE (tmpUserReferalsUnit.CountUser1, 0) OR tmpBoardUser.CountUser2 > COALESCE (tmpUserReferalsUnit.CountUser2, 0)
                    THEN ' (����� ' || CASE WHEN tmpBoardUser.CountUser1 > COALESCE (tmpUserReferalsUnit.CountUser1, 0)
                                            THEN COALESCE (tmpBoardUser.CountUser1 - COALESCE (tmpUserReferalsUnit.CountUser1, 0), 0)::Text||'�'
                                            ELSE '' 
                                            END ||
                                       CASE WHEN tmpBoardUser.CountUser1 > COALESCE (tmpUserReferalsUnit.CountUser1, 0) AND tmpBoardUser.CountUser2 > COALESCE (tmpUserReferalsUnit.CountUser2, 0)
                                            THEN ' � '
                                            ELSE '' 
                                            END ||
                                       CASE WHEN tmpBoardUser.CountUser2 > COALESCE (tmpUserReferalsUnit.CountUser2, 0)
                                            THEN COALESCE (tmpBoardUser.CountUser2 - COALESCE (tmpUserReferalsUnit.CountUser2, 0), 0)::Text||'�'
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.21                                                       * 
*/

-- ����

select * from gpReport_TelegramBot_PopulMobileApplication(inSession := '3');     