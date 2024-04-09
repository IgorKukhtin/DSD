-- Function: gpSelect_HolidayCompensation_zp ()

DROP FUNCTION IF EXISTS gpSelect_HolidayCompensation_zp (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_HolidayCompensation_zp(
    IN inStartDate                 TDateTime, --дата начала периода
    IN inUnitId                    Integer,   --подразделение
    IN inMemberId                  Integer,   --сотрудник
    IN inPersonalServiceListId     Integer,   -- ведомость начисления(главная)
    IN inSession                   TVarChar   --сессия пользователя
)
RETURNS TABLE(MovementId  Integer
            , InvNumber   TVarChar
            , OperDate    TDateTime
            , ServiceDate TDateTime
            , StatusCode  Integer
            , PersonalServiceListId Integer, PersonalServiceListName TVarChar
            , PersonalServiceListId_doc Integer, PersonalServiceListName_doc TVarChar
            , MemberId    Integer, MemberCode  Integer, MemberName  TVarChar
            , SummService TFloat
            , SummHoliday TFloat
            , SummHospOth TFloat
            , Summa       TFloat
            )
AS
$BODY$
    DECLARE vbUserId       Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inStartDate, NULL, NULL, NULL, vbUserId);

    RETURN QUERY
    WITH
     tmpUserAll AS (SELECT UserId FROM Constant_User_LevelMax01_View WHERE UserId = vbUserId /*AND UserId <> 9464*/) -- Документы-меню (управленцы) AND <> Рудик Н.В. + ЗП просмотр ВСЕ
   , tmpMemberPersonalServiceList AS (SELECT Object_PersonalServiceList.Id AS PersonalServiceListId

                                     FROM ObjectLink AS ObjectLink_User_Member
                                          INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList
                                                                ON ObjectLink_MemberPersonalServiceList.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                               AND ObjectLink_MemberPersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
                                          INNER JOIN Object AS Object_MemberPersonalServiceList
                                                            ON Object_MemberPersonalServiceList.Id       = ObjectLink_MemberPersonalServiceList.ObjectId
                                                           AND Object_MemberPersonalServiceList.isErased = FALSE
                                          LEFT JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                                 AND ObjectBoolean.DescId   = zc_ObjectBoolean_MemberPersonalServiceList_All()
                                          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                                               ON ObjectLink_PersonalServiceList.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                              AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                                          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                                        AND (Object_PersonalServiceList.Id    = ObjectLink_PersonalServiceList.ChildObjectId
                                                                                          OR ObjectBoolean.ValueData          = TRUE)
                                     WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                       AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                       AND (Object_PersonalServiceList.Id = inPersonalServiceListId OR inPersonalServiceListId = 0)
                                    UNION
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM ObjectLink AS ObjectLink_User_Member
                                          INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                                ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                               AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
                                          LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                                        AND Object_PersonalServiceList.Id     = ObjectLink_PersonalServiceList_Member.ObjectId
                                     WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                       AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                       AND (Object_PersonalServiceList.Id = inPersonalServiceListId OR inPersonalServiceListId = 0)
                                    UNION
                                     -- Админ и другие видят ВСЕХ
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM Object AS Object_PersonalServiceList
                                     WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                       AND EXISTS (SELECT 1 FROM tmpUserAll)
                                       AND (Object_PersonalServiceList.Id = inPersonalServiceListId OR inPersonalServiceListId = 0)
                                    UNION
                                     -- Админ и другие видят ВСЕХ
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM Object AS Object_PersonalServiceList
                                     WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                       AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin())
                                       AND (Object_PersonalServiceList.Id = inPersonalServiceListId OR inPersonalServiceListId = 0)
                                    /*UNION
                                     -- "ЗП филиалов" видят "Галат Е.Н."
                                     SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                                     FROM Object AS Object_PersonalServiceList
                                     WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                       AND vbUserId = 106593*/
                                    )

 , tmpMember_day AS (SELECT tmp.MemberId
                          , tmp.DateIn
                     FROM gpReport_HolidayPersonal (inStartDate:= inStartDate, inUnitId:= inUnitId, inMemberId:= inMemberId, inPersonalServiceListId := inPersonalServiceListId, inisDetail:= FALSE, inSession:= inSession) AS tmp
                    )
  , tmpMovement AS (SELECT Movement.*
                         , MovementDate.ValueData AS ServiceDate
                    FROM MovementDate
                         INNER JOIN Movement ON Movement.Id       = MovementDate.MovementId
                                            AND Movement.DescId   = zc_Movement_PersonalService()
                                            AND Movement.StatusId = zc_Enum_Status_Complete()
                    WHERE MovementDate.ValueData BETWEEN inStartDate - INTERVAL '1 YEAR' + INTERVAL '1 DAY' AND inStartDate
                      AND MovementDate.DescId = zc_MIDate_ServiceDate()
                   )
  , tmpPersonalService AS (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                , Movement.Id AS MovementId
                                , Movement.InvNumber
                                , Movement.OperDate
                                , Movement.ServiceDate
                                , Movement.StatusId
                                , MovementLinkObject_PersonalServiceList.ObjectId AS PersonalServiceListId_doc
                                , ObjectLink_Personal_PersonalServiceList.ChildObjectId AS PersonalServiceListId
                                , SUM (CASE WHEN DATE_TRUNC ('MONTH', tmpMember_day.DateIn) <= DATE_TRUNC ('MONTH', Movement.ServiceDate)
                                                 THEN COALESCE (MIFloat_SummService.ValueData, 0)
                                            ELSE 0
                                       END) AS SummService
                                , SUM (CASE WHEN DATE_TRUNC ('MONTH', tmpMember_day.DateIn) <= DATE_TRUNC ('MONTH', Movement.ServiceDate)
                                                 THEN COALESCE (MIFloat_SummHoliday.ValueData, 0)
                                            ELSE 0
                                       END) AS SummHoliday
                                , SUM (CASE WHEN DATE_TRUNC ('MONTH', tmpMember_day.DateIn) <= DATE_TRUNC ('MONTH', Movement.ServiceDate)
                                                 THEN COALESCE (MIFloat_SummHospOth.ValueData, 0)
                                            ELSE 0
                                       END) AS SummHospOth
                                , SUM (CASE WHEN DATE_TRUNC ('MONTH', tmpMember_day.DateIn) <= DATE_TRUNC ('MONTH', Movement.ServiceDate)
                                                 THEN COALESCE (MIFloat_SummService.ValueData, 0) + COALESCE (MIFloat_SummHoliday.ValueData, 0) + COALESCE (MIFloat_SummHospOth.ValueData, 0)
                                            ELSE 0
                                       END) AS Summa
                           FROM tmpMovement AS Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                             ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                                            AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_CompensationNot
                                                        ON ObjectBoolean_CompensationNot.ObjectId  = MovementLinkObject_PersonalServiceList.ObjectId
                                                       AND ObjectBoolean_CompensationNot.DescId    = zc_ObjectBoolean_PersonalServiceList_CompensationNot()
                                                       AND ObjectBoolean_CompensationNot.ValueData = TRUE

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE

                                INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                                 AND (MILinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                                INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                     AND (ObjectLink_Personal_Member.ChildObjectId = inMemberId OR inMemberId = 0)

                                LEFT JOIN tmpMember_day ON tmpMember_day.MemberId = ObjectLink_Personal_Member.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                     ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementItem.ObjectId
                                                    AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()

                                LEFT JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = ObjectLink_Personal_PersonalServiceList.ChildObjectId

                                LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                            ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
                                LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                            ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
                                LEFT JOIN MovementItemFloat AS MIFloat_SummHospOth
                                                            ON MIFloat_SummHospOth.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummHospOth.DescId = zc_MIFloat_SummHospOth()
                           WHERE tmpMemberPersonalServiceList.PersonalServiceListId > 0
                             AND (ObjectLink_Personal_PersonalServiceList.ChildObjectId = inPersonalServiceListId OR inPersonalServiceListId = 0)
                             -- Исключить из расчета компенсации для отпуска
                             AND ObjectBoolean_CompensationNot.ObjectId IS NULL

                           GROUP BY ObjectLink_Personal_Member.ChildObjectId
                                  , Movement.Id
                                  , Movement.InvNumber
                                  , Movement.OperDate
                                  , Movement.ServiceDate
                                  , Movement.StatusId
                                  , MovementLinkObject_PersonalServiceList.ObjectId
                                  , ObjectLink_Personal_PersonalServiceList.ChildObjectId
                           HAVING SUM (COALESCE (MIFloat_SummService.ValueData, 0) + COALESCE (MIFloat_SummHoliday.ValueData, 0)) <> 0
                          )
    -- Результат
    SELECT tmpPersonalService.MovementId
         , tmpPersonalService.InvNumber
         , tmpPersonalService.OperDate
         , tmpPersonalService.ServiceDate
         , Object_Status.ObjectCode                 AS StatusCode
         , Object_PersonalServiceList.Id            AS PersonalServiceListId
         , Object_PersonalServiceList.ValueData     AS PersonalServiceListName
         , Object_PersonalServiceList_doc.Id        AS PersonalServiceListId_doc
         , Object_PersonalServiceList_doc.ValueData AS PersonalServiceListName_doc

         , Object_Member.Id             AS MemberId
         , Object_Member.ObjectCode     AS MemberCode
         , Object_Member.ValueData      AS MemberName
         , tmpPersonalService.SummService     :: TFloat
         , tmpPersonalService.SummHoliday     :: TFloat
         , tmpPersonalService.SummHospOth     :: TFloat
         , tmpPersonalService.Summa           :: TFloat
    FROM tmpPersonalService
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpPersonalService.MemberId
         LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpPersonalService.StatusId
         LEFT JOIN Object AS Object_PersonalServiceList     ON Object_PersonalServiceList.Id     = tmpPersonalService.PersonalServiceListId
         LEFT JOIN Object AS Object_PersonalServiceList_doc ON Object_PersonalServiceList_doc.Id = tmpPersonalService.PersonalServiceListId_doc
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.23         *
*/
-- тест
-- SELECT * FROM gpSelect_HolidayCompensation_zp(inStartDate := ('01.01.2024')::TDateTime , inUnitId := 8384 , inMemberId := 442269 , inPersonalServiceListId:=0,  inSession := '5');
