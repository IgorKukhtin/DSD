-- Function: gpSelect_Object_Member_BirthDay(tvarchar)

DROP FUNCTION IF EXISTS gpSelect_Object_Member_BirthDay (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Member_BirthDay(
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (MemberName      TVarChar
             , UnitName        TVarChar
             , PositionName    TVarChar
             , Day             TVarChar
             , Month           TVarChar
             , Anniversary     TVarChar
               )
AS

$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Email_Send());
     vbUserId := lpGetUserBySession (inSession);

/*

1. Колонка "ПІБ" береться із довідника "Физические лица" - поле "ФИО" 
2. Колонка "Підрозділ" 
3. Колонка "Посада" береться із довідника "Физические лица" - поле "Должность"
4. Колонка "Дата народження" - только дата
5. Колонка "Місяць народження" - название месяца
6. "Ювіляр" - да/нет, если "тек год" - "год рождения" делится на 5 без остатка

*/

     -- Таблица для результата
     --CREATE TEMP TABLE _Result (RowData TBlob) ON COMMIT DROP;

     RETURN QUERY
     WITH
     tmpPersonal AS (SELECT lfSelect.MemberId
                          , lfSelect.PersonalId
                          , lfSelect.UnitId
                          , lfSelect.PositionId
                          , lfSelect.BranchId
                          , lfSelect.isDateOut
                          , lfSelect.Ord
                     FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                     WHERE lfSelect.Ord = 1
                    )

   , tmpMember AS (SELECT Object_Member.ValueData    AS MemberName
                        , Object_Unit.ValueData      AS UnitName
                        , Object_Position.ValueData  AS PositionName 
                        , COALESCE(ObjectDate_Birthday.ValueData, Null)   ::TDateTime  AS Birthday_Date
                        , CASE WHEN EXTRACT (DAY FROM ObjectDate_Birthday.ValueData) < 10 THEN '0' ELSE '' END || EXTRACT (DAY FROM ObjectDate_Birthday.ValueData)     :: TVarChar AS Birthday_Day
                        , CASE WHEN EXTRACT (Month FROM ObjectDate_Birthday.ValueData) < 10 THEN '0' ELSE '' END || EXTRACT (Month FROM ObjectDate_Birthday.ValueData) :: TVarChar AS Month_ord
                        , zfCalc_MonthNameUkr (ObjectDate_Birthday.ValueData) :: TVarChar AS Birthday_Month
                        , CASE WHEN (EXTRACT (YEAR FROM Current_Date) ::Integer - EXTRACT (YEAR FROM ObjectDate_Birthday.ValueData)::Integer) % 5 <> 0 THEN '' ELSE 'Ювіляр' END :: TVarChar AS Anniversary
                   FROM Object AS Object_Member
                        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_Member.Id AND tmpPersonal.Ord = 1
                        LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId
                        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId

                        LEFT JOIN ObjectDate AS ObjectDate_Birthday
                                             ON ObjectDate_Birthday.ObjectId = Object_Member.Id
                                            AND ObjectDate_Birthday.DescId = zc_ObjectDate_Member_Birthday()
                   WHERE Object_Member.DescId = zc_Object_Member()
                     AND Object_Member.isErased = FALSE
                     AND ObjectDate_Birthday.ValueData IS NOT NULL
                   )

      --Результат
     SELECT tmpMember.MemberName     ::TVarChar
          , tmpMember.UnitName       ::TVarChar
          , tmpMember.PositionName   ::TVarChar
          , tmpMember.Birthday_Day   ::TVarChar
          , tmpMember.Birthday_Month ::TVarChar
          , tmpMember.Anniversary    ::TVarChar
          FROM tmpMember  
          --LIMIT 2
          ORDER BY tmpMember.Month_ord
                  ,tmpMember.Birthday_Day
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.25         *
 */

-- тест
-- SELECT * FROM gpSelect_Object_Member_BirthDay (inSession:= zfCalc_UserAdmin()) 