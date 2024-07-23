-- Function: gpSelect_SheetWorkTime_Period()

DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period22 (TDateTime, TDateTime, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SheetWorkTime_Period(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- гл. юр.лицо
    IN inIsDetail          Boolean   , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , InvNumber_detail Integer
             , OperDate_detail TDateTime
             , UnitId Integer, UnitName TVarChar, isComplete Boolean, MovementId Integer
             , CheckedHeadId Integer, CheckedHeadName TVarChar
             , CheckedPersonalId Integer, CheckedPersonalName TVarChar
             , CheckedHead_date TDateTime
             , CheckedPersonal_date TDateTime
             , isCheckedHead Boolean
             , isCheckedPersonal Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- поиск сотрудник
     IF EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), 6879542, 14473, 447972, 10597056)) -- Персонал - табель учета р. времени (полный доступ) + Персонал ввод справочников + Просмотр СБ + Только просмотр Аудитор
     THEN vbMemberId:= 0;
     ELSE
         vbMemberId:= (SELECT ObjectLink_User_Member.ChildObjectId
                       FROM ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                         AND ObjectLink_User_Member.ObjectId = vbUserId
                         /*AND vbUserId NOT IN (/ *439994 -- Опимах А.М.
                                            , * /
                                              300527  -- Пономаренко А.Р.
                                            , 1147527 -- Бондаренко Ю.А.
                                            -- , 439923  -- Васильева Л.Я.
                                            -- , 439925  -- Новиков Д.В.
                                            -- , 1998523 -- Кувалдина И.В.
                                             )*/
                      /*UNION
                       SELECT ObjectLink_User_Member.ChildObjectId
                       FROM ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                         AND ObjectLink_User_Member.ObjectId = CASE / *WHEN vbUserId = 439994 -- Опимах А.М.
                                                                         THEN 439613 -- Шворников Р.И.* /
                                                                    WHEN vbUserId IN (300527  -- Пономаренко А.Р.
                                                                                    , 1147527 -- Бондаренко Ю.А.
                                                                                     )
                                                                         THEN 300523 -- Бабенко В.П.
                                                                    -- WHEN vbUserId IN (439923, 439925) -- Васильева Л.Я. + Новиков Д.В.
                                                                    --     THEN 439917 -- Маховская М.В.
                                                                    -- WHEN vbUserId = 1998523 -- Кувалдина И.В.
                                                                         -- THEN 1998663  -- Лобода В.В.
                                                                    --     THEN 929721 -- Решетова И.А.
                                                               END
                         AND vbUserId IN (439994  -- Опимах А.М.
                                        , 300527  -- Пономаренко А.Р.
                                        , 1147527 -- Бондаренко Ю.А.
                                        -- , 439923  -- Васильева Л.Я.
                                        -- , 439925  -- Новиков Д.В.
                                        -- , 1998523 -- Кувалдина И.В.
                                         )*/
                      );
     END IF;


     -- первое число месяца
     vbStartDate := DATE_TRUNC ('MONTH', inStartDate);
     -- последнее число месяца
     vbEndDate := DATE_TRUNC ('MONTH', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';


     -- Результат
     RETURN QUERY
       WITH tmpList AS (/*SELECT DISTINCT ObjectLink.ObjectId AS UnitId
                        FROM ObjectLink
                             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                  ON ObjectLink_Personal_Member.ObjectId = ObjectLink.ChildObjectId
                                                 AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                        WHERE ObjectLink.DescId = zc_ObjectLink_Unit_PersonalSheetWorkTime()
                          AND (ObjectLink_Personal_Member.ChildObjectId = vbMemberId OR vbMemberId = 0)
                       UNION*/
                        SELECT DISTINCT ObjectLink_Unit.ChildObjectId AS UnitId
                        FROM ObjectLink
                             INNER JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = ObjectLink.ObjectId
                                                  AND ObjectLink_Unit.DescId   = zc_ObjectLink_MemberSheetWorkTime_Unit()
                             INNER JOIN Object ON Object.Id       = ObjectLink.ObjectId
                                              AND Object.isErased = FALSE
                        WHERE ObjectLink.DescId        = zc_ObjectLink_MemberSheetWorkTime_Member()
                          AND (ObjectLink.ChildObjectId = vbMemberId OR vbMemberId = 0)
                          AND ObjectLink_Unit.ChildObjectId > 0
                       )
             /*tmpList AS (SELECT DISTINCT Object_Personal_View.UnitId
                        FROM Object_Personal_View
                        WHERE (Object_Personal_View.MemberId = vbMemberId OR vbMemberId = 0)
                       )*/

          , tmpMovement AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId, DATE_TRUNC ('MONTH', Movement.OperDate) AS OperDate
                                 , CASE WHEN inIsDetail = TRUE THEN Movement.InvNumber  ELSE ''   END :: TVarChar  AS InvNumber_detail
                                 , CASE WHEN inIsDetail = TRUE THEN Movement.OperDate   ELSE NULL END :: TDateTime AS OperDate_detail
                                 , (Object_Insert.ValueData)             AS InsertName
                                 , (MovementDate_Insert.ValueData)       AS InsertDate
                                 , (Object_Update.ValueData)             AS UpdateName
                                 , (MovementDate_Update.ValueData)       AS UpdateDate
                                 , CASE WHEN inIsDetail = TRUE THEN Movement.Id ELSE 0 END AS MovementId

                                 , MAX (Object_CheckedHead.Id)                     AS CheckedHeadId
                                 , MAX (Object_CheckedHead.ValueData)              AS CheckedHeadName
                                 , MAX (Object_CheckedPersonal.Id)                 AS CheckedPersonalId
                                 , MAX (Object_CheckedPersonal.ValueData)          AS CheckedPersonalName

                                 , MAX (MovementDate_CheckedHead.ValueData)        :: TDateTime AS CheckedHead_date
                                 , MAX (MovementDate_CheckedPersonal.ValueData)    :: TDateTime AS CheckedPersonal_date
                                 , MAX (CASE WHEN COALESCE (MovementBoolean_CheckedHead.ValueData, FALSE)     = TRUE THEN 1 ELSE 0 END)  AS isCheckedHead
                                 , MAX (CASE WHEN COALESCE (MovementBoolean_CheckedPersonal.ValueData, FALSE) = TRUE THEN 1 ELSE 0 END)  AS isCheckedPersonal


                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 LEFT JOIN MovementDate AS MovementDate_Insert
                                                        ON MovementDate_Insert.MovementId = Movement.Id
                                                       AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                                                       AND inIsDetail = TRUE
                                 LEFT JOIN MovementDate AS MovementDate_Update
                                                        ON MovementDate_Update.MovementId = Movement.Id
                                                       AND MovementDate_Update.DescId = zc_MovementDate_Update()
                                                       AND inIsDetail = TRUE

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                              ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                             AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                                                             AND inIsDetail = TRUE
                                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                                              ON MovementLinkObject_Update.MovementId = Movement.Id
                                                             AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
                                                             AND inIsDetail = TRUE
                                 LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

                                 LEFT JOIN MovementDate AS MovementDate_CheckedHead
                                                        ON MovementDate_CheckedHead.MovementId = Movement.Id
                                                       AND MovementDate_CheckedHead.DescId = zc_MovementDate_CheckedHead()
                                 LEFT JOIN MovementDate AS MovementDate_CheckedPersonal
                                                        ON MovementDate_CheckedPersonal.MovementId = Movement.Id
                                                       AND MovementDate_CheckedPersonal.DescId = zc_MovementDate_CheckedPersonal()

                                 LEFT JOIN MovementBoolean AS MovementBoolean_CheckedHead
                                                           ON MovementBoolean_CheckedHead.MovementId = Movement.Id
                                                          AND MovementBoolean_CheckedHead.DescId = zc_MovementBoolean_CheckedHead()
                                 LEFT JOIN MovementBoolean AS MovementBoolean_CheckedPersonal
                                                           ON MovementBoolean_CheckedPersonal.MovementId = Movement.Id
                                                          AND MovementBoolean_CheckedPersonal.DescId = zc_MovementBoolean_CheckedPersonal()

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckedHead
                                                              ON MovementLinkObject_CheckedHead.MovementId = Movement.Id
                                                             AND MovementLinkObject_CheckedHead.DescId = zc_MovementLinkObject_CheckedHead()
                                 LEFT JOIN Object AS Object_CheckedHead ON Object_CheckedHead.Id = MovementLinkObject_CheckedHead.ObjectId

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckedPersonal
                                                              ON MovementLinkObject_CheckedPersonal.MovementId = Movement.Id
                                                             AND MovementLinkObject_CheckedPersonal.DescId = zc_MovementLinkObject_CheckedPersonal()
                                 LEFT JOIN Object AS Object_CheckedPersonal ON Object_CheckedPersonal.Id = MovementLinkObject_CheckedPersonal.ObjectId

                                 LEFT JOIN tmpList ON tmpList.UnitId = MovementLinkObject_Unit.ObjectId
                            WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.StatusId <> zc_Enum_Status_Erased()
                              AND (tmpList.UnitId > 0 OR vbMemberId = 0)

                            GROUP BY MovementLinkObject_Unit.ObjectId
                                   , DATE_TRUNC ('MONTH', Movement.OperDate)
                                   , CASE WHEN inIsDetail = TRUE THEN Movement.InvNumber  ELSE ''   END :: TVarChar
                                   , CASE WHEN inIsDetail = TRUE THEN Movement.OperDate   ELSE NULL END :: TDateTime
                                   , (Object_Insert.ValueData)
                                   , (MovementDate_Insert.ValueData)
                                   , (Object_Update.ValueData)
                                   , (MovementDate_Update.ValueData)
                                   , CASE WHEN inIsDetail = TRUE THEN Movement.Id ELSE 0 END

                                   /*,  (Object_CheckedHead.Id)
                                   ,  (Object_CheckedHead.ValueData)
                                   ,  (Object_CheckedPersonal.Id)
                                   ,  (Object_CheckedPersonal.ValueData)

                                   ,  (MovementDate_CheckedHead.ValueData)        :: TDateTime
                                   ,  (MovementDate_CheckedPersonal.ValueData)    :: TDateTime
                                   ,  (CASE WHEN COALESCE (MovementBoolean_CheckedHead.ValueData, FALSE)     = TRUE THEN 1 ELSE 0 END)
                                   ,  (CASE WHEN COALESCE (MovementBoolean_CheckedPersonal.ValueData, FALSE) = TRUE THEN 1 ELSE 0 END)*/
                           )
          , tmpPeriod AS (SELECT tmp.OperDate, tmpList.UnitId
                          FROM (SELECT generate_series (vbStartDate, vbEndDate, '1 MONTH' :: INTERVAL) AS OperDate) AS tmp
                               LEFT JOIN tmpList ON 1 =1
                         )
       -- Результат
       SELECT COALESCE (tmpPeriod.OperDate, tmpMovement.OperDate) :: TDateTime AS OperDate
           , zfConvert_StringToNumber (tmpMovement.InvNumber_detail) AS InvNumber_detail
           , COALESCE (tmpMovement.OperDate_detail, tmpPeriod.OperDate) :: TDateTime AS OperDate_detail
           , Object_Unit.Id           AS UnitId
           , Object_Unit.ValueData    AS UnitName
           , CASE WHEN tmpMovement.UnitId IS NOT NULL THEN TRUE ELSE FALSE END :: Boolean AS isComplete
           , tmpMovement.MovementId

           , tmpMovement.CheckedHeadId        :: Integer
           , tmpMovement.CheckedHeadName      :: TVarChar
           , tmpMovement.CheckedPersonalId    :: Integer
           , tmpMovement.CheckedPersonalName  :: TVarChar

           , tmpMovement.CheckedHead_date     :: TDateTime
           , tmpMovement.CheckedPersonal_date :: TDateTime
           , CASE WHEN tmpMovement.isCheckedHead     = 1 THEN TRUE ELSE FALSE END :: Boolean AS isCheckedHead
           , CASE WHEN tmpMovement.isCheckedPersonal = 1 THEN TRUE ELSE FALSE END :: Boolean AS isCheckedPersonal

           , tmpMovement.InsertName
           , tmpMovement.InsertDate
           , tmpMovement.UpdateName
           , tmpMovement.UpdateDate

       FROM tmpPeriod
            FULL JOIN tmpMovement ON tmpMovement.UnitId   = tmpPeriod.UnitId
                                 AND tmpMovement.OperDate = tmpPeriod.OperDate
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (tmpPeriod.UnitId, tmpMovement.UnitId)
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.21         *
 07.10.16         * add inJuridicalBasisId
 23.03.16                                        * all
 01.03.16         * add isComplete
 28.12.13                                        * add zc_ObjectLink_StaffList_Unit
 01.10.13         *
*/

/*
with tmp AS (select Movement.Id AS MovementId
     , ROW_NUMBER() OVER (PARTITION BY Movement.Id ORDER BY MovementItemProtocol.Id ASC)  AS Ord_ins
     , ROW_NUMBER() OVER (PARTITION BY Movement.Id ORDER BY MovementItemProtocol.Id DESC) AS Ord_upd
, MovementItemProtocol.*

       FROM Movement
            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
            JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id

       WHERE Movement.DescId = zc_Movement_SheetWorkTime()
         AND Movement.OperDate BETWEEN '01.01.2021' AND '01.01.2022'
     )
, res as (
select distinct tmp.MovementId
, tmp_ins.OperDate as OperDate_ins
, tmp_upd.OperDate as OperDate_upd
, tmp_ins.UserId   AS UserId_ins
, tmp_upd.UserId   AS UserId_upd
, tmp_ins.Id       AS Id_ins
, tmp_upd.Id       AS Id_upd
from tmp
     join tmp as tmp_ins on tmp_ins.MovementId = tmp.MovementId AND tmp_ins.Ord_ins = 1
     join tmp as tmp_upd on tmp_upd.MovementId = tmp.MovementId AND tmp_upd.Ord_upd = 1
)

select res.*
         -- сохранили свойство
--         , lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), res.MovementId, OperDate_ins)
         -- сохранили свойство
--         , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), res.MovementId, UserId_ins)
         -- сохранили свойство
--         , case when Id_ins < Id_upd then lpInsertUpdate_MovementDate (zc_MovementDate_Update(), res.MovementId, OperDate_upd) else null end
         -- сохранили свойство
--         , case when Id_ins < Id_upd then lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), res.MovementId, UserId_upd) else null end

from res
-- where Id_ins < Id_upd
*/
-- тест
-- SELECT * FROM gpSelect_SheetWorkTime_Period (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inJuridicalBasisId:= 0, inIsDetail:= FALSE, inSession:= '5')
