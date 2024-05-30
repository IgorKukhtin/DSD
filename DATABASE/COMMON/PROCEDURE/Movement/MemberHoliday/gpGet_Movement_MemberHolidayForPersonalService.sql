-- Function: gpGet_Movement_MemberHolidayForPersonalService()

DROP FUNCTION IF EXISTS gpGet_Movement_MemberHolidayForPersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_MemberHolidayForPersonalService(
    IN inMovementId       Integer  , -- ключ Документа
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MemberId Integer, MemberName TVarChar, PersonalId Integer
             , Day_holiday TFloat
             , Day_holiday1 TFloat
             , Day_holiday2 TFloat
             , AmountCompensation TFloat
             , SummHoliday1_calc  TFloat
             , SummHoliday2_calc  TFloat
             , SummHoliday1  TFloat
             , SummHoliday2  TFloat
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , MovementId_PersonalService1 Integer
             , MovementId_PersonalService2 Integer
             , InvNumber_Full1 TVarChar, InvNumber_Full2 TVarChar
             , Color_SummHoliday1 Integer
             , Color_SummHoliday2 Integer
             , ServiceDateStart TDateTime
             , ServiceDateEnd   TDateTime
             , PositionId Integer
             , UnitId     Integer
             , IsMain     Boolean
              )
AS
$BODY$
   DECLARE vbUserId                Integer;
   DECLARE vbPersonalServiceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_AccessKey_MemberHoliday());


     -- Проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END  IF;


     -- Поиск
     vbPersonalServiceListId:= (SELECT gpGet.PersonalServiceListId FROM gpGet_Object_Member (inId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Member())
                                                                                           , inSession:= inSession
                                                                                             ) AS gpGet);

     -- Проверка
     IF COALESCE (vbPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Для сотрудника <%> не найдена главная ведомость.', lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Member()));
     END  IF;


     -- Результат
     RETURN QUERY
       WITH
          tmpMember AS (SELECT lfSelect.MemberId
                             , lfSelect.PersonalId
                             , lfSelect.UnitId
                             , lfSelect.PositionId
                             , lfSelect.BranchId
                             , lfSelect.IsMain
                        FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                        WHERE lfSelect.Ord = 1
                        )

        , tmpMovement AS (SELECT Movement.*
                               , CASE WHEN Movement_find.StatusId     <> zc_Enum_Status_Erased() THEN MovementFloat_MovementId.ValueData     ELSE 0 END  ::Integer  AS MovementId_1
                               , CASE WHEN Movement_find_two.StatusId <> zc_Enum_Status_Erased() THEN MovementFloat_MovementItemId.ValueData ELSE 0 END :: Integer  AS MovementId_2
                          FROM Movement
                               LEFT JOIN MovementFloat AS MovementFloat_MovementId
                                                       ON MovementFloat_MovementId.MovementId = Movement.Id
                                                      AND MovementFloat_MovementId.DescId = zc_MovementFloat_MovementId()
                               LEFT JOIN Movement AS Movement_find ON Movement_find.Id = MovementFloat_MovementId.ValueData :: Integer

                               LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                       ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                                      AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                               LEFT JOIN Movement AS Movement_find_two ON Movement_find_two.Id = MovementFloat_MovementItemId.ValueData :: Integer

                          WHERE Movement.DescId = zc_Movement_MemberHoliday()
                            AND Movement.Id = inMovementId
                         )

        , tmpSummHoliday AS (SELECT MovementItem.MovementId AS MovementId
                                  , MovementItem.ObjectId   AS PersonalId
                                  , SUM (COALESCE (MIFloat_SummHoliday.ValueData,0) ) AS SummHoliday
                             FROM (SELECT DISTINCT tmpMovement.MovementId_1 AS MovementId FROM tmpMovement
                                UNION
                                   SELECT DISTINCT tmpMovement.MovementId_2 AS MovementId FROM tmpMovement
                                   ) AS tmp
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                                   INNER JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                                ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                               AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()

                             GROUP BY MovementItem.MovementId
                                    , MovementItem.ObjectId
                             )
        , tmpData AS (SELECT
                             Movement.Id
                           , MovementDate_OperDateStart.ValueData  AS OperDateStart     --период начисления
                           , MovementDate_OperDateEnd.ValueData    AS OperDateEnd

                           , MovementDate_BeginDateStart.ValueData AS BeginDateStart    -- период отпуска
                           , MovementDate_BeginDateEnd.ValueData   AS BeginDateEnd
                           , DATE_TRUNC ('Month', MovementDate_BeginDateStart.ValueData) AS ServiceDateStart
                           , (DATE_TRUNC ('Month', MovementDate_BeginDateEnd.ValueData) + INTERVAL '1 Month' - INTERVAL '1 Day') AS  ServiceDateEnd

                           , Object_Member.Id                      AS MemberId
                           , Object_Member.ValueData               AS MemberName
                           , tmpMember.PersonalId
                           , tmpMember.PositionId
                           , tmpMember.IsMain
                           , tmpMember.UnitId

                           , Object_WorkTimeKind.Id                AS WorkTimeKindId
                           , Object_WorkTimeKind.ValueData         AS WorkTimeKindName

                           , ObjectDate_DateIn.ValueData           AS DateIn
                           , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_DateOut.ValueData END :: TDateTime AS DateOut

                           , (DATE_PART ('DAY', MovementDate_OperDateEnd.ValueData  :: TIMESTAMP - MovementDate_OperDateStart.ValueData  :: TIMESTAMP) + 1) :: TFloat AS Day_work
                           , (DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData :: TIMESTAMP - MovementDate_BeginDateStart.ValueData :: TIMESTAMP) + 1) :: TFloat AS Day_holiday

                           , CASE WHEN DATE_TRUNC ('Month', MovementDate_BeginDateEnd.ValueData) <> DATE_TRUNC ('Month', MovementDate_BeginDateStart.ValueData)
                                  THEN 0 + DATE_PART ('DAY', DATE_TRUNC ('Month',MovementDate_BeginDateEnd.ValueData) :: TIMESTAMP
                                                           - MovementDate_BeginDateStart.ValueData :: TIMESTAMP
                                                     )
                                  ELSE (DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData :: TIMESTAMP - MovementDate_BeginDateStart.ValueData :: TIMESTAMP) + 1)
                             END AS Day_holiday1

                           , CASE WHEN DATE_TRUNC ('Month', MovementDate_BeginDateEnd.ValueData) <> DATE_TRUNC ('Month', MovementDate_BeginDateStart.ValueData)
                                  THEN 1 + DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData :: TIMESTAMP
                                                           - DATE_TRUNC ('Month', MovementDate_BeginDateEnd.ValueData) :: TIMESTAMP
                                                     )
                                  ELSE 0
                             END AS Day_holiday2

                           , Object_PersonalServiceList.Id            AS PersonalServiceListId
                           , Object_PersonalServiceList.ValueData     AS PersonalServiceListName

                           , Movement.MovementId_1 AS MovementId_PersonalService1
                           , Movement.MovementId_2 AS MovementId_PersonalService2
                           , tmpSummHoliday1.SummHoliday ::TFloat AS SummHoliday1
                           , tmpSummHoliday2.SummHoliday ::TFloat AS SummHoliday2
                           , (COALESCE (tmpSummHoliday1.SummHoliday,0) + COALESCE (tmpSummHoliday2.SummHoliday,0)) ::TFloat AS TotalSummHoliday
                           , (MovementFloat_Amount.ValueData * (DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData :: TIMESTAMP - MovementDate_BeginDateStart.ValueData :: TIMESTAMP) + 1)) ::TFloat AS SummHoliday_calc
                           , MovementFloat_Amount.ValueData                     :: TFloat AS Amount  --Ср.ЗП за день
                           , spReport_HolidayCompensation.AmountCompensation    :: TFloat            --Ср.ЗП за день (отчет)

                           , CASE WHEN (MovementFloat_Amount.ValueData * (DATE_PART ('DAY', MovementDate_BeginDateEnd.ValueData :: TIMESTAMP - MovementDate_BeginDateStart.ValueData :: TIMESTAMP) + 1))
                                    <> (COALESCE (tmpSummHoliday1.SummHoliday,0) + COALESCE (tmpSummHoliday2.SummHoliday,0))
                                  THEN  zc_Color_Pink() --фон
                                  ELSE zc_Color_White()
                             END ::Integer AS Color_SummHoliday
                       FROM tmpMovement AS Movement
                            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                                   ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

                            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                                   ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                            LEFT JOIN MovementDate AS MovementDate_BeginDateStart
                                                   ON MovementDate_BeginDateStart.MovementId = Movement.Id
                                                  AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()

                            LEFT JOIN MovementDate AS MovementDate_BeginDateEnd
                                                   ON MovementDate_BeginDateEnd.MovementId = Movement.Id
                                                  AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()

                            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberMain
                                                         ON MovementLinkObject_MemberMain.MovementId = Movement.Id
                                                        AND MovementLinkObject_MemberMain.DescId = zc_MovementLinkObject_MemberMain()
                            LEFT JOIN Object AS Object_MemberMain ON Object_MemberMain.Id = MovementLinkObject_MemberMain.ObjectId

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_WorkTimeKind
                                                         ON MovementLinkObject_WorkTimeKind.MovementId = Movement.Id
                                                        AND MovementLinkObject_WorkTimeKind.DescId = zc_MovementLinkObject_WorkTimeKind()
                            LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = MovementLinkObject_WorkTimeKind.ObjectId
                            --
                            LEFT JOIN tmpMember ON tmpMember.MemberId = MovementLinkObject_Member.ObjectId

                            LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                                 ON ObjectDate_DateIn.ObjectId = tmpMember.PersonalId
                                                AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
                            LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                 ON ObjectDate_DateOut.ObjectId = tmpMember.PersonalId
                                                AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()

                            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                 ON ObjectLink_Personal_PersonalServiceList.ObjectId = tmpMember.PersonalId
                                                AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId

                            --
                            LEFT JOIN tmpSummHoliday AS tmpSummHoliday1
                                                     ON tmpSummHoliday1.MovementId = Movement.MovementId_1
                                                    AND tmpSummHoliday1.PersonalId = tmpMember.PersonalId
                            LEFT JOIN tmpSummHoliday AS tmpSummHoliday2
                                                     ON tmpSummHoliday2.MovementId = Movement.MovementId_2
                                                    AND tmpSummHoliday2.PersonalId = tmpMember.PersonalId

                             LEFT JOIN gpReport_HolidayCompensation(DATE_TRUNC ('Month', MovementDate_BeginDateStart.ValueData) - INTERVAL '1 Day'
                                                                  , 0 -- tmpMember.UnitId
                                                                  , Object_Member.Id
                                                                  , 0
                                                                  , inSession) AS spReport_HolidayCompensation ON 1 = 1
                     )
         -- ищем уже сохраненные док.начисления
       , tmpMovementPersonalService AS (SELECT Movement.Id
                                             , MovementDate.ValueData AS ServiceDate
                                        FROM MovementDate
                                             INNER JOIN Movement ON Movement.Id       = MovementDate.MovementId
                                                                AND Movement.DescId   = zc_Movement_PersonalService()
                                                                AND Movement.StatusId <> zc_Enum_Status_Erased()

                                             INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                           ON MLO_PersonalServiceList.MovementId = MovementDate.MovementId
                                                                          AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                                          AND MLO_PersonalServiceList.ObjectId   = vbPersonalServiceListId

                                        WHERE MovementDate.ValueData BETWEEN (SELECT MIN (tmpData.ServiceDateStart) FROM tmpData) AND (SELECT MAX (tmpData.ServiceDateEnd) FROM tmpData)
                                          AND MovementDate.DescId = zc_MIDate_ServiceDate()
                                       )
       , tmpPersonalService AS (SELECT MIN (Movement.Id) AS MovementId
                                     , Movement.ServiceDate
                                     , SUM (CASE WHEN MILinkObject_Unit.ObjectId               = tmpData.UnitId
                                                  AND ObjectLink_Personal_Member.ChildObjectId = tmpData.MemberId
                                                 THEN COALESCE (MIFloat_SummHoliday.ValueData, 0)
                                                 ELSE 0
                                            END) AS Amount
                                FROM tmpData
                                     LEFT JOIN tmpMovementPersonalService AS Movement ON 1 = 1

                                     LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId = zc_MI_Master()
                                                           AND MovementItem.isErased = FALSE
                                                           AND MovementItem.ObjectId = tmpData.PersonalId

                                     LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                                 ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                                AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                       ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                          ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                GROUP BY Movement.ServiceDate
                               )

       SELECT  tmpData.MemberId
             , tmpData.MemberName
             , tmpData.PersonalId
             , tmpData.Day_holiday
             , (tmpData.Day_holiday1 ) ::TFloat AS Day_holiday1
             , (tmpData.Day_holiday2 ) ::TFloat AS Day_holiday2
             , CAST (tmpData.AmountCompensation AS NUMERIC(16,2))  ::TFloat           --Ср.ЗП за день (отчет)
             , (tmpData.Day_holiday1 * CAST (tmpData.AmountCompensation AS NUMERIC(16,2))) ::TFloat AS SummHoliday1_calc
             , (tmpData.Day_holiday2 * CAST (tmpData.AmountCompensation AS NUMERIC(16,2))) ::TFloat AS SummHoliday2_calc
             , tmpPersonalService1.Amount ::TFloat AS SummHoliday1
             , tmpPersonalService2.Amount ::TFloat AS SummHoliday2


             , tmpData.PersonalServiceListId
             , tmpData.PersonalServiceListName

             , Movement_PersonalService1.Id AS MovementId_PersonalService1
             , Movement_PersonalService2.Id AS MovementId_PersonalService2

             , zfCalc_InvNumber_isErased (MovementDesc1.ItemName, Movement_PersonalService1.InvNumber, Movement_PersonalService1.OperDate, Movement_PersonalService1.StatusId) ::TVarChar AS InvNumber_Full1
             , zfCalc_InvNumber_isErased (MovementDesc2.ItemName, Movement_PersonalService2.InvNumber, Movement_PersonalService2.OperDate, Movement_PersonalService2.StatusId) ::TVarChar AS InvNumber_Full2

             , CASE WHEN (tmpData.Day_holiday1 * CAST (tmpData.AmountCompensation AS NUMERIC(16,2))) <> tmpPersonalService1.Amount
                    THEN  zc_Color_Pink() --фон
                    ELSE zc_Color_White()
               END::Integer AS Color_SummHoliday1
             , CASE WHEN (tmpData.Day_holiday2 * CAST (tmpData.AmountCompensation AS NUMERIC(16,2))) <> tmpPersonalService2.Amount
                    THEN  zc_Color_Pink() --фон
                    ELSE zc_Color_White()
               END::Integer AS Color_SummHoliday2

             , tmpData.ServiceDateStart ::TDateTime
             , tmpData.ServiceDateEnd   ::TDateTime
             , tmpData.PositionId
             , tmpData.UnitId
             , tmpData.IsMain ::Boolean

       FROM tmpData
            LEFT JOIN tmpPersonalService AS tmpPersonalService1
                                         ON DATE_TRUNC ('MONTH', tmpPersonalService1.ServiceDate) = DATE_TRUNC ('MONTH', tmpData.ServiceDateStart)
            LEFT JOIN tmpPersonalService AS tmpPersonalService2
                                         ON DATE_TRUNC ('MONTH', tmpPersonalService2.ServiceDate) = DATE_TRUNC ('MONTH', tmpData.ServiceDateEnd)
                                        AND DATE_TRUNC ('MONTH', tmpData.ServiceDateEnd)         <> DATE_TRUNC ('MONTH', tmpData.ServiceDateStart)

            LEFT JOIN Movement AS Movement_PersonalService1 ON Movement_PersonalService1.Id = COALESCE (tmpPersonalService1.MovementId, tmpData.MovementId_PersonalService1)
            LEFT JOIN MovementDesc AS MovementDesc1 ON MovementDesc1.Id = Movement_PersonalService1.DescId

            LEFT JOIN Movement AS Movement_PersonalService2 ON Movement_PersonalService2.Id = COALESCE (tmpPersonalService2.MovementId, tmpData.MovementId_PersonalService2)
            LEFT JOIN MovementDesc AS MovementDesc2 ON MovementDesc2.Id = Movement_PersonalService2.DescId
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.07.23         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_MemberHolidayForPersonalService(inMovementId := 25589775 ,  inSession := '9457');
