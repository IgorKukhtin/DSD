-- Function: gpSelect_SheetWorkTime_Period()

DROP FUNCTION IF EXISTS gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SheetWorkTime_Period(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, UnitId Integer, UnitName TVarChar, isComplete Boolean
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
     IF EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), 14473)) -- Персонал ввод справочников
     THEN vbMemberId:= 0;
     ELSE
         vbMemberId:= (SELECT ObjectLink_User_Member.ChildObjectId
                       FROM ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                         AND ObjectLink_User_Member.ObjectId = vbUserId
                         AND vbUserId NOT IN (439994 -- Опимах А.М.
                                            , 300527 -- Пономаренко А.Р.
                                            , 439923 -- Васильева Л.Я.
                                            , 439925 -- Новиков Д.В.
                                             )
                      UNION
                       SELECT ObjectLink_User_Member.ChildObjectId
                       FROM ObjectLink AS ObjectLink_User_Member
                       WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                         AND ObjectLink_User_Member.ObjectId = CASE WHEN vbUserId = 439994 -- Опимах А.М.
                                                                         THEN 439613 -- Шворников Р.И.
                                                                    WHEN vbUserId = 300527 -- Пономаренко А.Р.
                                                                         THEN 300523 -- Бабенко В.П.
                                                                    WHEN vbUserId IN (439923, 439925) -- Васильева Л.Я. + Новиков Д.В.
                                                                         THEN 439917 -- Маховская М.В.
                                                               END
                         AND vbUserId IN (439994 -- Опимах А.М.
                                        , 300527 -- Пономаренко А.Р.
                                        , 439923 -- Васильева Л.Я.
                                        , 439925 -- Новиков Д.В.
                                         )
                      );
     END IF;


     vbStartDate := date_trunc ('MONTH', inStartDate);    -- первое число месяца
     vbEndDate := date_trunc ('MONTH', inEndDate);        -- последнее число месяца
 
     RETURN QUERY 
       WITH tmpList AS (SELECT DISTINCT  Object_Personal_View.UnitId 
                        FROM Object_Personal_View
                        WHERE (Object_Personal_View.MemberId = vbMemberId OR vbMemberId = 0)
                       )
       SELECT
             Period.OperDate::TDateTime
           , Object_Unit.Id           AS UnitId
           , Object_Unit.ValueData    AS UnitName
           , ObjectLink_StaffList_Unit.isComplete
       FROM (SELECT generate_series(vbStartDate, vbEndDate, '1 MONTH'::interval) OperDate) AS Period
          , (/*SELECT DISTINCT ChildObjectId AS UnitId FROM ObjectLink WHERE DescId = zc_ObjectLink_StaffList_Unit() AND ChildObjectId > 0 AND vbMemberId = 0
            UNION
             */SELECT tmpList.UnitId, False AS isComplete  FROM tmpList
            UNION
             SELECT DISTINCT MovementLinkObject_Unit.ObjectId AS UnitId
                  , CASE WHEN COALESCE (Movement.Id,0) <> 0 THEN TRUE ELSE False END AS isComplete
             FROM Movement
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                  LEFT JOIN tmpList ON tmpList.UnitId = MovementLinkObject_Unit.ObjectId
             WHERE Movement.DescId = zc_Movement_SheetWorkTime()
               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
               AND (tmpList.UnitId > 0 OR vbMemberId = 0)
            ) AS ObjectLink_StaffList_Unit
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_StaffList_Unit.UnitId
      ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_SheetWorkTime_Period (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.03.16         * add isComplete
 28.12.13                                        * add zc_ObjectLink_StaffList_Unit
 01.10.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SheetWorkTime (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
-- SELECT * FROM gpSelect_SheetWorkTime_Period (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
