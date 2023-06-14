-- Function: gpReport_FulfillmentPlanMobileApp()

DROP FUNCTION IF EXISTS gpReport_FulfillmentPlanMobileApp (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_FulfillmentPlanMobileApp(
    IN inOperDate     TDateTime , --
    IN inUnitId       Integer,    -- Подразделение
    IN inUserId       Integer,    -- Подразделение
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
   DECLARE vbPenMobApp TFloat;
   DECLARE vbDateStart TDateTime;
   DECLARE vbAntiTOPMP_Count Integer;
   DECLARE vbAntiTOPMP_CountFine Integer;
   DECLARE vbAntiTOPMP_SumFine TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     vbDateStart := date_trunc('month', inOperDate);
     
     vbPenMobApp := COALESCE ((SELECT History_CashSettings.PenMobApp 
                               FROM gpSelect_ObjectHistory_CashSettings (0, inSession) AS History_CashSettings
                               WHERE History_CashSettings.StartDate <= date_trunc('MONTH', inOperDate)
                                 AND History_CashSettings.EndDate > date_trunc('MONTH', inOperDate)), 0);
     

   SELECT ObjectFloat_CashSettings_AntiTOPMP_Count.ValueData::Integer              AS AntiTOPMP_Count
        , ObjectFloat_CashSettings_AntiTOPMP_CountFine.ValueData::Integer          AS AntiTOPMP_CountFine
        , ObjectFloat_CashSettings_AntiTOPMP_SumFine.ValueData                     AS AntiTOPMP_SumFine
   INTO vbAntiTOPMP_Count , vbAntiTOPMP_CountFine , vbAntiTOPMP_SumFine
   FROM Object AS Object_CashSettings

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AntiTOPMP_Count
                              ON ObjectFloat_CashSettings_AntiTOPMP_Count.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_AntiTOPMP_Count.DescId = zc_ObjectFloat_CashSettings_AntiTOPMP_Count()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AntiTOPMP_CountFine
                              ON ObjectFloat_CashSettings_AntiTOPMP_CountFine.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_AntiTOPMP_CountFine.DescId = zc_ObjectFloat_CashSettings_AntiTOPMP_CountFine()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AntiTOPMP_SumFine
                              ON ObjectFloat_CashSettings_AntiTOPMP_SumFine.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_AntiTOPMP_SumFine.DescId = zc_ObjectFloat_CashSettings_AntiTOPMP_SumFine()

   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
   LIMIT 1;
     
     -- raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMov ON COMMIT DROP AS 
     SELECT Movement.*
          , MovementLinkObject_Unit.ObjectId                                     AS UnitId
          , MovementFloat_TotalSumm.ValueData                                    AS TotalSumm
          , (COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0 OR
            COALESCE(MovementString_InvNumberOrder.ValueData, '') <> '') AND
            COALESCE(MovementBoolean_MobileApplication.ValueData, False) = FALSE AS isSite
          , COALESCE(MovementBoolean_MobileApplication.ValueData, False)         AS isMobileApplication
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                       AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE(inUnitId, 0) = 0)
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                       ON MovementLinkObject_CheckSourceKind.MovementId = Movement.Id
                                      AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                                      AND MovementLinkObject_CheckSourceKind.ObjectId = zc_Enum_CheckSourceKind_Tabletki()  
          LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                   ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                  AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()                                   
          LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                    ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                   AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()

          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

     WHERE Movement.DescId = zc_Movement_Check()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.OperDate >= date_trunc('MONTH', inOperDate) - INTERVAL '1 MONTH'
       AND Movement.OperDate < date_trunc('MONTH', inOperDate) + INTERVAL '1 MONTH';
        
     ANALYSE tmpMov;
     
     -- raise notice 'Value 2: %', CLOCK_TIMESTAMP();
     
     CREATE TEMP TABLE tmpESCount ON COMMIT DROP AS 
     SELECT MILinkObject_Unit.ObjectId                                              AS UnitId
          , COALESCE(NULLIF(MAX(MovementItemUser.Amount), 0), COUNT(*))::Integer   AS CountUser        
     FROM Movement

           INNER JOIN MovementItem AS MovementItemMaster
                                   ON MovementItemMaster.MovementId = Movement.Id
                                  AND MovementItemMaster.DescId = zc_MI_Master()

           INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItemMaster.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

           LEFT JOIN MovementItem AS MovementItemUser
                                  ON MovementItemUser.MovementId = Movement.Id
                                 AND MovementItemUser.ObjectId  = MILinkObject_Unit.ObjectId 
                                 AND MovementItemUser.DescId = zc_MI_Second()

           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                ON ObjectLink_User_Member.ObjectId = MovementItemMaster.ObjectId
                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

           LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                               AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()

     WHERE Movement.OperDate = date_trunc('MONTH', inOperDate) - INTERVAL '1 MONTH'
       AND Movement.DescId = zc_Movement_EmployeeSchedule()
       AND Movement.StatusId <> zc_Enum_Status_Erased()
       AND ObjectLink_Member_Position.ChildObjectId = 1672498
     GROUP BY MILinkObject_Unit.ObjectId;
          
     ANALYSE tmpESCount;
     
     -- raise notice 'Value 3: %', CLOCK_TIMESTAMP();
     
     CREATE TEMP TABLE tmpEmployeeSchedule ON COMMIT DROP AS 
     SELECT DISTINCT
            MILinkObject_Unit.ObjectId               AS UnitId
          , MovementItemMaster.ObjectId              AS UserId           
     FROM Movement

           INNER JOIN MovementItem AS MovementItemMaster
                                   ON MovementItemMaster.MovementId = Movement.Id
                                  AND MovementItemMaster.DescId = zc_MI_Master()

           INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItemMaster.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

     WHERE Movement.OperDate = date_trunc('MONTH', inOperDate)
       AND Movement.DescId = zc_Movement_EmployeeSchedule()
       AND Movement.StatusId <> zc_Enum_Status_Erased();
          
     ANALYSE tmpEmployeeSchedule;
     
     -- raise notice 'Value 4: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMovementProtocol ON COMMIT DROP AS 
     SELECT MovementProtocol.MovementId
          , MovementProtocol.UserId   
          , MovementProtocol.OperDate          
          , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate) AS ord
     FROM MovementProtocol 
     WHERE MovementProtocol.OperDate >= date_trunc('MONTH', inOperDate)
       AND MovementProtocol.OperDate <  date_trunc('MONTH', inOperDate) + INTERVAL '1 MONTH' + INTERVAL '3 DAY'
       AND MovementProtocol.ProtocolData ILIKE '%Статус" FieldValue = "Проведен%'
       AND (MovementProtocol.UserId  = inUserId OR COALESCE (inUserId, 0) = 0);
          
     ANALYSE tmpMovementProtocol;
     
     -- raise notice 'Value 5: %', CLOCK_TIMESTAMP(); 
     

     -- Результат
     RETURN QUERY
       WITH tmpUser AS (SELECT MIMaster.ObjectId                                                                     AS UserId
                             , MIN(Movement.OperDate + ((MIChild.Amount - 1)::Integer::tvarchar||' DAY')::INTERVAL)  AS DateIn
                        FROM Movement
                        
                             INNER JOIN MovementItem AS MIMaster
                                                     ON MIMaster.MovementId = Movement.ID
                                                    AND MIMaster.DescId = zc_MI_Master()
                             
                             INNER JOIN MovementItem AS MIChild
                                                     ON MIChild.MovementId = Movement.ID
                                                    AND MIChild.ParentId = MIMaster.ID
                                                    AND MIChild.DescId = zc_MI_Child()
                                                     
                        WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                        GROUP BY MIMaster.ObjectId),
            tmpMovPlan AS (SELECT Movement.UnitId
                                , SUM(Movement.TotalSumm)::TFloat                                             AS CountChech
                                , SUM(CASE WHEN Movement.isSite THEN Movement.TotalSumm ELSE 0 END)::TFloat   AS CountSite
                           FROM tmpMov AS Movement
                           WHERE Movement.OperDate < date_trunc('MONTH', inOperDate)
                             AND Movement.isMobileApplication = False
                           GROUP BY Movement.UnitId
                           ),
            tmpMovFact AS (SELECT tmpEmployeeSchedule.UnitId
                                , tmpMovementProtocol.UserId
                                , SUM(CASE WHEN Movement.isMobileApplication = FALSE
                                            AND Movement.isSite = False THEN Movement.TotalSumm ELSE 0 END)::TFloat      AS CountChech
                                , SUM(CASE WHEN Movement.isMobileApplication THEN Movement.TotalSumm ELSE 0 END)::TFloat AS CountMobile
                                , SUM(CASE WHEN Movement.isMobileApplication THEN 1 ELSE 0 END)::Integer                 AS QuantityMobile
                           FROM tmpMov AS Movement
                           
                                INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id
                                                              AND tmpMovementProtocol.Ord = 1 
                                                              
                                INNER JOIN tmpEmployeeSchedule ON tmpEmployeeSchedule.UserId = tmpMovementProtocol.UserId
                           
                           WHERE Movement.OperDate >= date_trunc('MONTH', inOperDate)
                           GROUP BY tmpEmployeeSchedule.UnitId
                                  , tmpMovementProtocol.UserId
                           ),
            tmpData AS (SELECT       
                               MovPlan.UnitId
                             , MovPlan.CountChech                                    AS CountSite
                             , MovPlan.CountSite                                     AS TotalSumm
                             , tmpESCount.CountUser                                  AS CountUser
                             , Round(1.0 * MovPlan.CountSite / MovPlan.CountChech * 100 /
                               COALESCE(NULLIF(COALESCE(tmpESCount.CountUser, 0), 0), 1), 1)::TFloat AS ProcPlan
                             , 1.0 * MovPlan.CountSite / MovPlan.CountChech * 100 /
                               COALESCE(NULLIF(COALESCE(tmpESCount.CountUser, 0), 0), 1)             AS ProcPlanFull
                             , tmpMovFact.UserId
                             , tmpMovFact.CountChech                                 AS CountChechUser
                             , tmpMovFact.CountMobile                                AS CountMobileUser
                             
                             , CASE WHEN (Round(1.0 * MovPlan.CountSite / MovPlan.CountChech * 100 /
                                         COALESCE(NULLIF(COALESCE(tmpESCount.CountUser, 0), 0), 1), 1) > 
                                         Round(1.0 * tmpMovFact.CountMobile / 
                                         NullIf(tmpMovFact.CountChech, 0) * 100, 1))
                                    THEN Round(tmpMovFact.CountChech * Round(1.0 * MovPlan.CountSite / MovPlan.CountChech * 100 /
                                         COALESCE(NULLIF(COALESCE(tmpESCount.CountUser, 0), 0), 1), 1) / 100 - tmpMovFact.CountMobile, 2) END::TFloat AS CountShortage
                                
                             , tmpMovFact.QuantityMobile                             AS QuantityMobile
                             , Round(1.0 * tmpMovFact.CountMobile / 
                               NullIf(tmpMovFact.CountChech, 0) * 100, 1)::TFloat    AS ProcFact
                             , date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER <= 90           AS isNewUser
                             , CASE WHEN Round(1.0 * MovPlan.CountSite / MovPlan.CountChech * 100 /
                                               COALESCE(NULLIF(COALESCE(tmpESCount.CountUser, 0), 0), 1), 1) - 
                                         Round(1.0 * tmpMovFact.CountMobile / 
                                               NullIf(tmpMovFact.CountChech, 0) * 100, 1) > 0
                                    THEN Round((Round(1.0 * MovPlan.CountSite / MovPlan.CountChech * 100 /
                                                COALESCE(NULLIF(COALESCE(tmpESCount.CountUser, 0), 0), 1), 1) -
                                                Round(1.0 * tmpMovFact.CountMobile / 
                                               NullIf(tmpMovFact.CountChech, 0) * 100, 1)) * vbPenMobApp, 2)                              
                                    ELSE 0 END::TFLoat                               AS PenaltiMobApp
                             , COALESCE (ObjectBoolean_ShowPlanMobileAppUser.ValueData, FALSE):: Boolean         AS isShowPlanMobileAppUser
                             , ROW_NUMBER() OVER (PARTITION BY date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER <= 90 AND 
                                                               NOT COALESCE (ObjectBoolean_ShowPlanMobileAppUser.ValueData, FALSE) 
                                                  ORDER BY Round(1.0 * tmpMovFact.CountMobile / 
                                                           NullIf(tmpMovFact.CountChech, 0) * 100, 1)::TFloat)::Integer AS ORD
                             , ROW_NUMBER() OVER (PARTITION BY date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER <= 90 OR 
                                                               COALESCE (ObjectBoolean_ShowPlanMobileAppUser.ValueData, FALSE) = FALSE
                                                  ORDER BY Round(1.0 * tmpMovFact.CountMobile / 
                                                           NullIf(tmpMovFact.CountChech, 0) * 100, 1)::TFloat,
                                                           1.0 * MovPlan.CountSite / MovPlan.CountChech * 100 /
                                                           COALESCE(NULLIF(COALESCE(tmpESCount.CountUser, 0), 0), 1))::Integer AS Place
                          FROM tmpMovPlan AS MovPlan 
                          
                               
                               LEFT JOIN tmpESCount ON tmpESCount.UnitId = MovPlan.UnitId
                               
                               LEFT JOIN tmpMovFact ON tmpMovFact.UnitId = MovPlan.UnitId

                               LEFT JOIN tmpUser ON tmpUser.UserID = tmpMovFact.UserId

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_ShowPlanMobileAppUser
                                                       ON ObjectBoolean_ShowPlanMobileAppUser.ObjectId = MovPlan.UnitId
                                                      AND ObjectBoolean_ShowPlanMobileAppUser.DescId = zc_ObjectBoolean_Unit_ShowPlanMobileAppUser()

                          WHERE (tmpMovFact.UserId  = inUserId OR COALESCE (inUserId, 0) = 0)    
                            AND tmpMovFact.UserId IN (SELECT ObjectLink_User_Member.ObjectId AS UserID
                                                      FROM ObjectLink AS ObjectLink_User_Member

                                                           INNER JOIN  ObjectLink AS ObjectLink_Member_Position
                                                                                  ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                                                 AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                                                                                 AND ObjectLink_Member_Position.ChildObjectId = 1672498
                                                      WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member())),
            tmpSumProcFact AS (SELECT MovPlan.ProcFact 
                                    , MovPlan.ProcPlanFull
                                    , COUNT(*)          AS CountUser
                               FROM tmpData AS MovPlan 
                               WHERE MovPlan.isNewUser = False AND MovPlan.isShowPlanMobileAppUser = TRUE
                               GROUP BY MovPlan.ProcFact
                                      , MovPlan.ProcPlanFull),
            tmpSumTop AS (SELECT MovPlan.ProcFact
                               , MovPlan.ProcPlanFull
                               , ROW_NUMBER() OVER (ORDER BY MovPlan.ProcFact, MovPlan.ProcPlanFull)::Integer             AS Place
                               , SUM(MovPlan.CountUser) OVER (ORDER BY MovPlan.ProcFact, MovPlan.ProcPlanFull)::Integer   AS SumPlace
                          FROM tmpSumProcFact AS MovPlan)
            

         SELECT       
             Object_Unit.Id                                        AS UnitId
           , Object_Unit.ObjectCode                                AS UnitCode
           , Object_Unit.ValueData                                 AS UserName
           , MovPlan.CountSite 
           , MovPlan.TotalSumm 
           , MovPlan.CountUser 
           , MovPlan.ProcPlan
           , Object_User.Id                                        AS UserId
           , Object_User.ObjectCode                                AS UserCode
           , Object_User.ValueData                                 AS UserName
           , MovPlan.CountChechUser
           , MovPlan.CountMobileUser
           
           , MovPlan.CountShortage
              
           , MovPlan.QuantityMobile 
           , MovPlan.ProcFact
           , CASE WHEN not MovPlan.isNewUser
                  THEN MovPlan.PenaltiMobApp                        
                  ELSE 0 END::TFLoat                               AS PenaltiMobApp
           , MovPlan.isShowPlanMobileAppUser
           
           , CASE WHEN not MovPlan.isNewUser AND MovPlan.isShowPlanMobileAppUser AND 
                       COALESCE(inUnitId, 0) = 0 AND COALESCE (inUserId, 0) = 0 AND           
                       tmpSumTop.SumPlace <= (SELECT MIN(tmpSumTop.SumPlace) FROM tmpSumTop WHERE tmpSumTop.SumPlace >= vbAntiTOPMP_Count)
                  THEN MovPlan.Place END                             AS AntiTOPMP_Place
                  
           , tmpSumTop.SumPlace
           , MovPlan.Place
           , CASE WHEN not MovPlan.isNewUser AND MovPlan.isShowPlanMobileAppUser AND 
                       tmpSumTop.SumPlace <= (SELECT MIN(tmpSumTop.SumPlace) FROM tmpSumTop WHERE tmpSumTop.SumPlace >= vbAntiTOPMP_CountFine)
                  THEN zfCalc_Color (255, 69, 0)
                  WHEN not MovPlan.isNewUser AND MovPlan.isShowPlanMobileAppUser AND 
                       COALESCE(inUnitId, 0) = 0 AND COALESCE (inUserId, 0) = 0 AND           
                       tmpSumTop.SumPlace <= (SELECT MIN(tmpSumTop.SumPlace) FROM tmpSumTop WHERE tmpSumTop.SumPlace >= vbAntiTOPMP_Count)
                  THEN zfCalc_Color (255, 165, 0)
                  ELSE zc_Color_White()
             END  AS Color_Calc

        FROM tmpData AS MovPlan 
        
             LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = MovPlan.UnitId
             
             LEFT JOIN Object AS Object_User ON Object_User.Id = MovPlan.UserId
             
             LEFT JOIN tmpSumTop ON tmpSumTop.ProcFact     = MovPlan.ProcFact
                                AND tmpSumTop.ProcPlanFull = MovPlan.ProcPlanFull  

        ORDER BY Object_Unit.ValueData , Object_User.ValueData
        ;

         
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

select * from gpReport_FulfillmentPlanMobileApp(inOperDate := ('01.06.2023')::TDateTime , inUnitId := 0 , inUserId := 0 ,  inSession := '3');