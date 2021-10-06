-- Function: gpSelect_Movement_Send()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Send (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inisVip         Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , TotalSummFrom TFloat, TotalSummTo TFloat
             , FromId Integer, FromName TVarChar, ProvinceCityName_From TVarChar
             , ToId Integer, ToName TVarChar, ProvinceCityName_To TVarChar
             , PartionDateKindName TVarChar
             , Comment TVarChar
             , isAuto Boolean, MCSPeriod TFloat, MCSDay TFloat
             , Checked Boolean, isComplete Boolean
             , isDeferred Boolean
             , isSUN Boolean, isDefSUN Boolean, isSUN_v2 Boolean --, isSUN_over Boolean
             , isSUN_v3 Boolean, isSUN_v4 Boolean
             , isSent Boolean, isReceived Boolean, isOverdueSUN Boolean, isNotDisplaySUN Boolean
             , isVIP Boolean, isUrgently Boolean, isConfirmed Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , InsertDateDiff TFloat
             , UpdateDateDiff TFloat
             , MovementId_Report Integer, InvNumber_Report TVarChar, ReportInvNumber_full TVarChar
             , DriverSunId Integer, DriverSunName TVarChar
             , NumberSeats Integer
             , ConfirmedText TVarChar
             , isBanFiscalSale Boolean
             , isSendLoss Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
   DECLARE vbParentId Integer;
   DECLARE vbIsSUN_over Boolean;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
     vbParentId := 0;
     
     IF vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (308121)) -- Кассир аптеки
     THEN 
       vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
       IF vbUnitKey = '' THEN
          vbUnitKey := '0';
       END IF;   
       vbUnitId := vbUnitKey::Integer;
       
/*       IF vbUserId in (12325076, 6406669, 3999086, 16175938, 4000094, 6002014, 6025400, 16411862)
       THEN
         SELECT ObjectLink_Unit_Parent.ChildObjectId
         INTO vbParentId
         FROM ObjectLink AS ObjectLink_Unit_Parent
         WHERE  ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
           AND ObjectLink_Unit_Parent.ObjectId = vbUnitId;
       END IF;*/
     ELSE
       vbUnitId := 0;
     END IF;
     
     -- Ограничение - если роль Кассир аптеки
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 308121 AND UserId = vbUserId)
     THEN
         vbIsSUN_over:= FALSE;
     ELSE
         vbIsSUN_over:= TRUE;
     END IF;


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        -- , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        -- , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         -- UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              -- )
        , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId      AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )
        , tmpProvinceCity AS (SELECT ObjectLink_Unit_ProvinceCity.ObjectId AS UnitId
                                   , Object_ProvinceCity.Id                AS ProvinceCityId
                                   , Object_ProvinceCity.ValueData         AS ProvinceCityName
                              FROM ObjectLink AS ObjectLink_Unit_ProvinceCity
                                   LEFT JOIN Object AS Object_ProvinceCity 
                                                    ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
                              WHERE ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                                AND COALESCE (ObjectLink_Unit_ProvinceCity.ChildObjectId,0) <> 0
                              )
       -- Результат
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm
           , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT
           , MovementFloat_TotalSummFrom.ValueData  AS TotalSummFrom
           , MovementFloat_TotalSummTo.ValueData    AS TotalSummTo
           , Object_From.Id                         AS FromId
           , Object_From.ValueData                  AS FromName
           , tmpProvinceCity_From.ProvinceCityName  AS ProvinceCityName_From
           , Object_To.Id                           AS ToId
           , Object_To.ValueData                    AS ToName
           , tmpProvinceCity_To.ProvinceCityName    AS ProvinceCityName_To
           , Object_PartionDateKind.ValueData                   :: TVarChar AS PartionDateKindName
           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment
           , COALESCE (MovementBoolean_isAuto.ValueData, FALSE) :: Boolean  AS isAuto
           , MovementFloat_MCSPeriod.ValueData      AS MCSPeriod
           , MovementFloat_MCSDay.ValueData         AS MCSDay
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE)  ::Boolean  AS Checked
           , COALESCE (MovementBoolean_Complete.ValueData, FALSE) ::Boolean  AS isComplete
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
           , COALESCE (MovementBoolean_SUN.ValueData, FALSE)      ::Boolean  AS isSUN
           , COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)   ::Boolean  AS isDefSUN
           , COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE)   ::Boolean  AS isSUN_v2
           , COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE)   ::Boolean  AS isSUN_v3
           , COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE)   ::Boolean  AS isSUN_v4
           , COALESCE (MovementBoolean_Sent.ValueData, FALSE)     ::Boolean  AS isSent
           , COALESCE (MovementBoolean_Received.ValueData, FALSE) ::Boolean  AS isReceived
           , CASE WHEN COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE
                   AND Movement.OperDate < CURRENT_DATE
                   AND Movement.StatusId = zc_Enum_Status_Erased() THEN TRUE ELSE FALSE END AS isOverdueSUN
           , COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE)::Boolean AS isNotDisplaySUN
           , COALESCE (MovementBoolean_VIP.ValueData, FALSE)          ::Boolean AS isVIP
           , COALESCE (MovementBoolean_Urgently.ValueData, FALSE)     ::Boolean AS isUrgently
           , COALESCE (MovementBoolean_Confirmed.ValueData, FALSE)    ::Boolean AS isConfirmed           

           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate

           , ( MovementDate_Insert.ValueData::Date - Movement.OperDate::Date) ::TFloat AS InsertDateDiff 
           , ( MovementDate_Update.ValueData::Date - Movement.OperDate::Date) ::TFloat AS UpdateDateDiff

           , Movement_ReportUnLiquid.Id                    AS MovementId_Report
           , Movement_ReportUnLiquid.InvNumber             AS InvNumber_Report
           , ('№ ' || Movement_ReportUnLiquid.InvNumber ||' от '||TO_CHAR(Movement_ReportUnLiquid.OperDate , 'DD.MM.YYYY') ) :: TVarChar AS ReportInvNumber_full
           
           , Object_DriverSun.Id                     AS DriverSunId
           , Object_DriverSun.ValueData  :: TVarChar AS DriverSunName
           
           , MovementFloat_NumberSeats.ValueData::Integer  AS NumberSeats

           , CASE WHEN COALESCE (MovementBoolean_VIP.ValueData, FALSE) = FALSE THEN Null   
                  WHEN MovementBoolean_Confirmed.ValueData IS NULL THEN 'Ожидает подтвержд.'   
                  WHEN MovementBoolean_Confirmed.ValueData = TRUE  THEN 'Подтвержден'   
                  ELSE 'Не подтвержден' END ::TVarChar          AS ConfirmedText
                  
           , COALESCE (MovementBoolean_BanFiscalSale.ValueData, FALSE)    ::Boolean AS isBanFiscalSale           
           , COALESCE (MovementBoolean_SendLoss.ValueData, FALSE)         ::Boolean AS isSendLoss           

           --, date_part('day', MovementDate_Insert.ValueData - Movement.OperDate) ::TFloat AS InsertDateDiff 
           --, date_part('day', MovementDate_Update.ValueData - Movement.OperDate) ::TFloat AS UpdateDateDiff
       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Send() AND Movement.StatusId = tmpStatus.StatusId
--                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                    ON MovementFloat_TotalSummFrom.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummTo
                                    ON MovementFloat_TotalSummTo.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummTo.DescId = zc_MovementFloat_TotalSummTo()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN tmpUnit AS tmpUnit_From ON tmpUnit_From.UnitId = MovementLinkObject_From.ObjectId
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN tmpProvinceCity AS tmpProvinceCity_From ON tmpProvinceCity_From.UnitId = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MovementLinkObject_To.ObjectId
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN tmpProvinceCity AS tmpProvinceCity_To ON tmpProvinceCity_To.UnitId = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_Complete
                                      ON MovementBoolean_Complete.MovementId = Movement.Id
                                     AND MovementBoolean_Complete.DescId = zc_MovementBoolean_Complete()
            LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
            LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                      ON MovementBoolean_SUN.MovementId = Movement.Id
                                     AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
            LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                      ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                     AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
            LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                      ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                     AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()
            LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                      ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                     AND MovementBoolean_SUN_v4.DescId = zc_MovementBoolean_SUN_v4()

            LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                      ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                     AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                      ON MovementBoolean_Sent.MovementId = Movement.Id
                                     AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
            LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                      ON MovementBoolean_Received.MovementId = Movement.Id
                                     AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
            LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                      ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                     AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                      ON MovementBoolean_VIP.MovementId = Movement.Id
                                     AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()
            LEFT JOIN MovementBoolean AS MovementBoolean_Urgently
                                      ON MovementBoolean_Urgently.MovementId = Movement.Id
                                     AND MovementBoolean_Urgently.DescId = zc_MovementBoolean_Urgently()
            LEFT JOIN MovementBoolean AS MovementBoolean_Confirmed
                                      ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                     AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()

            LEFT JOIN MovementBoolean AS MovementBoolean_BanFiscalSale
                                      ON MovementBoolean_BanFiscalSale.MovementId = Movement.Id
                                     AND MovementBoolean_BanFiscalSale.DescId = zc_MovementBoolean_BanFiscalSale()
            LEFT JOIN MovementBoolean AS MovementBoolean_SendLoss
                                      ON MovementBoolean_SendLoss.MovementId = Movement.Id
                                     AND MovementBoolean_SendLoss.DescId = zc_MovementBoolean_SendLoss()

            LEFT JOIN MovementFloat AS MovementFloat_MCSPeriod
                                    ON MovementFloat_MCSPeriod.MovementId =  Movement.Id
                                   AND MovementFloat_MCSPeriod.DescId = zc_MovementFloat_MCSPeriod()
            LEFT JOIN MovementFloat AS MovementFloat_MCSDay
                                    ON MovementFloat_MCSDay.MovementId =  Movement.Id
                                   AND MovementFloat_MCSDay.DescId = zc_MovementFloat_MCSDay()

            LEFT JOIN MovementFloat AS MovementFloat_NumberSeats
                                    ON MovementFloat_NumberSeats.MovementId =  Movement.Id
                                   AND MovementFloat_NumberSeats.DescId = zc_MovementFloat_NumberSeats()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId 

            LEFT JOIN MovementLinkMovement AS MLM_ReportUnLiquid
                                           ON MLM_ReportUnLiquid.MovementId = Movement.Id
                                          AND MLM_ReportUnLiquid.DescId = zc_MovementLinkMovement_ReportUnLiquid()
            LEFT JOIN Movement AS Movement_ReportUnLiquid ON Movement_ReportUnLiquid.Id = MLM_ReportUnLiquid.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DriverSun
                                         ON MovementLinkObject_DriverSun.MovementId = Movement.Id
                                        AND MovementLinkObject_DriverSun.DescId = zc_MovementLinkObject_DriverSun()
            LEFT JOIN Object AS Object_DriverSun ON Object_DriverSun.Id = MovementLinkObject_DriverSun.ObjectId 

       WHERE (COALESCE (tmpUnit_To.UnitId,0) <> 0 OR COALESCE (tmpUnit_FROM.UnitId,0) <> 0)
         AND (vbUnitId = 0 OR tmpUnit_To.UnitId = vbUnitId OR tmpUnit_FROM.UnitId = vbUnitId OR 
              COALESCE(vbParentId, 0) <> 0 AND (tmpUnit_To.UnitId = vbParentId OR tmpUnit_FROM.UnitId = vbParentId))
         AND (COALESCE (MovementBoolean_VIP.ValueData, FALSE) = TRUE OR inisVip = FALSE)
/*         AND (vbIsSUN_over = TRUE
           OR COALESCE (MovementBoolean_SUN.ValueData, FALSE) = FALSE
           OR COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = FALSE
           OR Movement.StatusId <> zc_Enum_Status_Erased()
             )
*/        
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Send (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 21.04.20         * isSUN_v4
 31.03.20         * isSUN_v3
 05.03.20                                                                                      * zc_MovementLinkObject_DriverSun
 09.12.19         * isSUN_v2 вместо isSUN_over 
 23.09.19         * zc_MovementLinkObject_Driver
 06.08.19                                                                                      * zc_MovementBoolean_Received
 24.07.19         * zc_MovementBoolean_DefSUN
 11.07.19         * zc_MovementBoolean_SUN
 09.06.19         *
 27.02.19                                                                                      * vbUnitId
 08.11.17         * Deferred
 21.03.17         * add zc_MovementFloat_TotalSummFrom
                        zc_MovementFloat_TotalSummTo
 15.11.16         * add isComplete
 28.06.16         *
 05.05.16         *
 29.07.15                                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_Send (inStartDate:= '01.08.2019', inEndDate:= '01.08.2019', inIsErased := FALSE, inisVip := FALSE,  inSession:= '2')

select * from gpSelect_Movement_Send(instartdate := ('01.09.2021')::TDateTime , inenddate := ('17.09.2021')::TDateTime , inIsErased := 'False' , inisVip := 'False' ,  inSession := '12325076');