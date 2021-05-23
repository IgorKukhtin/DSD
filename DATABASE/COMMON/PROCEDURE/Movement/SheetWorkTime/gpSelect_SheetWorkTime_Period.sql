-- Function: gpSelect_SheetWorkTime_Period()

-- DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period22 (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SheetWorkTime_Period22(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- гл. юр.лицо
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, UnitId Integer, UnitName TVarChar, isComplete Boolean, MovementId Integer
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


     -- поиск сотрудник
     IF EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), 14473, 447972)) -- Персонал ввод справочников + Просмотр СБ
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

          , tmpMovement AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId AS UnitId, DATE_TRUNC ('MONTH', Movement.OperDate) AS OperDate
                                          , CASE WHEN vbUserId = zfCalc_UserAdmin() :: Integer THEN Movement.Id ELSE 0 END AS MovementId
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 LEFT JOIN tmpList ON tmpList.UnitId = MovementLinkObject_Unit.ObjectId
                            WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND (tmpList.UnitId > 0 OR vbMemberId = 0)
                           )
          , tmpPeriod AS (SELECT tmp.OperDate, tmpList.UnitId
                          FROM (SELECT generate_series (vbStartDate, vbEndDate, '1 MONTH' :: INTERVAL) AS OperDate) AS tmp
                               LEFT JOIN tmpList ON 1 =1 
                         )
       -- Результат
       SELECT COALESCE (tmpPeriod.OperDate, tmpMovement.OperDate) :: TDateTime AS OperDate
           , Object_Unit.Id           AS UnitId
           , Object_Unit.ValueData    AS UnitName
           , CASE WHEN tmpMovement.UnitId IS NOT NULL THEN TRUE ELSE FALSE END :: Boolean AS isComplete
           , tmpMovement.MovementId
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
 07.10.16         * add inJuridicalBasisId
 23.03.16                                        * all
 01.03.16         * add isComplete
 28.12.13                                        * add zc_ObjectLink_StaffList_Unit
01.10.13         *
*/

-- тест
-- SELECT * FROM gpSelect_SheetWorkTime_Period (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inJuridicalBasisId:= 0, inSession:= '5')
