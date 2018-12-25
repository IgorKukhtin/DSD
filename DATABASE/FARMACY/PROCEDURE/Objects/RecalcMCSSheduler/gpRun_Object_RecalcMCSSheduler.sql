-- Function: gpRun_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpRun_Object_RecalcMCSSheduler(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Object_RecalcMCSSheduler(
    IN InJuridicalID Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
  DECLARE vbHolidays Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

  IF EXISTS(SELECT
                 TRUE       AS Holidays
            FROM
                Object AS Object_RecalcMCSSheduler

                 INNER JOIN ObjectDate AS ObjectDate_BeginHolidays
                                       ON ObjectDate_BeginHolidays.ObjectId = Object_RecalcMCSSheduler.Id
                                      AND ObjectDate_BeginHolidays.DescId = zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays()
                 INNER JOIN ObjectDate AS ObjectDate_EndHolidays
                                       ON ObjectDate_EndHolidays.ObjectId = Object_RecalcMCSSheduler.Id
                                      AND ObjectDate_EndHolidays.DescId = zc_ObjectFloat_RecalcMCSSheduler_EndHolidays()
            WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()
               AND ObjectDate_BeginHolidays.ValueData <= ObjectDate_EndHolidays.ValueData  
               AND ObjectDate_BeginHolidays.ValueData <= current_date
               AND current_date <= ObjectDate_EndHolidays.ValueData  
            ORDER BY ID LIMIT 1)
  THEN
    vbHolidays := TRUE;
  ELSE
    vbHolidays := FALSE;  
  END IF;

  PERFORM  gpRecalcMCS(inUnitId := ObjectLink_Unit.ChildObjectId,
                       inPeriod := ObjectFloat_Period.ValueData::Integer,
                       inDay := ObjectFloat_Day.ValueData::Integer,
                       inSession := COALESCE (ObjectLink_User.ChildObjectId::TVarChar, inSession))
  FROM Object AS Object_RecalcMCSSheduler

           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()

           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_PharmacyItem
                                   ON ObjectBoolean_PharmacyItem.ObjectId = ObjectLink_Unit.ChildObjectId
                                  AND ObjectBoolean_PharmacyItem.DescId = zc_ObjectBoolean_Unit_PharmacyItem()

           LEFT JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_RecalcMCSSheduler.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_RecalcMCSSheduler_User()

           LEFT JOIN ObjectFloat AS ObjectFloat_Period
                                 ON ObjectFloat_Period.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectFloat_Period.DescId = CASE WHEN COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) = FALSE AND vbHolidays
                                                                THEN zc_ObjectFloat_Unit_Period()
                                                                ELSE
                                                                  CASE to_char(clock_timestamp(), 'ID')::Integer
                                                                  WHEN 1 THEN zc_ObjectFloat_Unit_Period1()
                                                                  WHEN 2 THEN zc_ObjectFloat_Unit_Period2()
                                                                  WHEN 3 THEN zc_ObjectFloat_Unit_Period3()
                                                                  WHEN 4 THEN zc_ObjectFloat_Unit_Period4()
                                                                  WHEN 5 THEN zc_ObjectFloat_Unit_Period5()
                                                                  WHEN 6 THEN zc_ObjectFloat_Unit_Period6()
                                                                  WHEN 7 THEN zc_ObjectFloat_Unit_Period7() END END

           LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                 ON ObjectFloat_Day.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectFloat_Day.DescId = CASE WHEN COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) = FALSE AND vbHolidays
                                                             THEN zc_ObjectFloat_Unit_Day()
                                                             ELSE
                                                               CASE to_char(clock_timestamp(), 'ID')::Integer
                                                               WHEN 1 THEN zc_ObjectFloat_Unit_Day1()
                                                               WHEN 2 THEN zc_ObjectFloat_Unit_Day2()
                                                               WHEN 3 THEN zc_ObjectFloat_Unit_Day3()
                                                               WHEN 4 THEN zc_ObjectFloat_Unit_Day4()
                                                               WHEN 5 THEN zc_ObjectFloat_Unit_Day5()
                                                               WHEN 6 THEN zc_ObjectFloat_Unit_Day6()
                                                               WHEN 7 THEN zc_ObjectFloat_Unit_Day7() END END

  WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()
    AND Object_RecalcMCSSheduler.isErased = FALSE
    AND (ObjectLink_Unit_Juridical.ChildObjectId = InJuridicalID OR InJuridicalID = 0)
    AND COALESCE (ObjectFloat_Period.ValueData::Integer, 0) <> 0
    AND COALESCE (ObjectFloat_Day.ValueData::Integer, 0) <> 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpRun_Object_RecalcMCSSheduler(Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 23.12.18        *
*/

-- тест
-- SELECT * FROM gpRun_Object_RecalcMCSSheduler (0, '3')