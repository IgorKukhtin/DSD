-- Function: gpSelect_Movement_SendingDelaySNU()

DROP FUNCTION IF EXISTS gpSelect_Movement_SendingDelaySNU (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendingDelaySNU(
    IN inDate          TDateTime , --
    IN inIterval       Integer,    --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , TotalSummFrom TFloat, TotalSummTo TFloat
             , FromId Integer, FromName TVarChar, ProvinceCityId_From integer, ProvinceCityName_From TVarChar
             , ToId Integer, ToName TVarChar, ProvinceCityId_To integer, ProvinceCityName_To TVarChar
             , PartionDateKindName TVarChar
             , Comment TVarChar
             , isAuto Boolean, MCSPeriod TFloat, MCSDay TFloat
             , Checked Boolean, isComplete Boolean
             , isDeferred Boolean
             , isSUN Boolean, isDefSUN Boolean, isSent Boolean, isReceived Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , InsertDateDiff TFloat
             , UpdateDateDiff TFloat
             , MovementId_Report Integer, InvNumber_Report TVarChar, ReportInvNumber_full TVarChar
             , DatSent TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     RETURN QUERY
     WITH tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
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
           , tmpProvinceCity_From.ProvinceCityId    AS ProvinceCityId_From
           , tmpProvinceCity_From.ProvinceCityName  AS ProvinceCityName_From
           , Object_To.Id                           AS ToId
           , Object_To.ValueData                    AS ToName
           , tmpProvinceCity_To.ProvinceCityId      AS ProvinceCityId_To
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
           , COALESCE (MovementBoolean_Sent.ValueData, FALSE)    ::Boolean AS isSent
           , COALESCE (MovementBoolean_Received.ValueData, FALSE) ::Boolean  AS isReceived

           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate

           , ( MovementDate_Insert.ValueData::Date - Movement.OperDate::Date) ::TFloat AS InsertDateDiff
           , ( MovementDate_Update.ValueData::Date - Movement.OperDate::Date) ::TFloat AS UpdateDateDiff

           , Movement_ReportUnLiquid.Id                    AS MovementId_Report
           , Movement_ReportUnLiquid.InvNumber             AS InvNumber_Report
           , ('№ ' || Movement_ReportUnLiquid.InvNumber ||' от '||TO_CHAR(Movement_ReportUnLiquid.OperDate , 'DD.MM.YYYY') ) :: TVarChar AS ReportInvNumber_full
           , tmpMovement.DatSent

       FROM (SELECT Movement.id
                  , MovementDate_Sent.ValueData  AS DatSent
             FROM Movement
                  INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                             ON MovementBoolean_SUN.MovementId = Movement.Id
                                            AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                            AND MovementBoolean_SUN.ValueData = True
                  INNER JOIN MovementBoolean AS MovementBoolean_Sent
                                            ON MovementBoolean_Sent.MovementId = Movement.Id
                                           AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
                                           AND MovementBoolean_Sent.ValueData = True
                  LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                            AND MovementBoolean_Deferred.ValueData = True
                  LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                            ON MovementBoolean_Received.MovementId = Movement.Id
                                           AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
                  LEFT JOIN MovementDate AS MovementDate_Sent
                                         ON MovementDate_Sent.MovementId = Movement.Id
                                        AND MovementDate_Sent.DescId = zc_MovementDate_Sent()
             WHERE  Movement.DescId = zc_Movement_Send()
                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                AND COALESCE (MovementBoolean_Received.ValueData, FALSE) = False
                AND MovementDate_Sent.ValueData <= CURRENT_TIMESTAMP - (inIterval::TVarChar||' DAY')::INTERVAL
                AND (MovementDate_Sent.ValueData > CURRENT_TIMESTAMP - ((inIterval + 1)::TVarChar||' DAY')::INTERVAL OR inIterval = 3)
                AND MovementDate_Sent.ValueData > inDate - ((inIterval)::TVarChar||' DAY')::INTERVAL
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
            LEFT JOIN ObjectLink AS ObjectLink_Driver
                                 ON ObjectLink_Driver.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Driver.DescId = zc_ObjectLink_Unit_Driver()

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

            LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                      ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                     AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()

            LEFT JOIN MovementBoolean AS MovementBoolean_Sent
                                      ON MovementBoolean_Sent.MovementId = Movement.Id
                                     AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
            LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                      ON MovementBoolean_Received.MovementId = Movement.Id
                                     AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()

            LEFT JOIN MovementFloat AS MovementFloat_MCSPeriod
                                    ON MovementFloat_MCSPeriod.MovementId =  Movement.Id
                                   AND MovementFloat_MCSPeriod.DescId = zc_MovementFloat_MCSPeriod()
            LEFT JOIN MovementFloat AS MovementFloat_MCSDay
                                    ON MovementFloat_MCSDay.MovementId =  Movement.Id
                                   AND MovementFloat_MCSDay.DescId = zc_MovementFloat_MCSDay()

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

       WHERE tmpProvinceCity_From.ProvinceCityId NOT IN (7214807, 7214813, 7214810)
         AND tmpProvinceCity_To.ProvinceCityId NOT IN (7214807, 7214813, 7214810)

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_SendingDelaySNU (TDateTime, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 09.03.20                                                                     *

*/

-- тест
--SELECT * FROM gpSelect_Movement_SendingDelaySNU (inDate := '11.03.2020 00:00:00', inIterval := 3, inSession:= '3')