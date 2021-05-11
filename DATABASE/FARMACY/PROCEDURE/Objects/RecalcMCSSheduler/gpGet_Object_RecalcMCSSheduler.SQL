DROP FUNCTION IF EXISTS gpGet_Object_RecalcMCSSheduler(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RecalcMCSSheduler(
    IN inId       Integer,       -- ID
    IN inUnitId   Integer,       -- ID
    IN inSession  TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , UnitId Integer
             , UnitCode Integer
             , UnitName TVarChar

             , PharmacyItem Boolean
             , Comment TVarChar
             , AllRetail Boolean

             , Period Integer
             , Period1 Integer
             , Period2 Integer
             , Period3 Integer
             , Period4 Integer
             , Period5 Integer
             , Period6 Integer
             , Period7 Integer
             , Day Integer
             , Day1 Integer
             , Day2 Integer
             , Day3 Integer
             , Day4 Integer
             , Day5 Integer
             , Day6 Integer
             , Day7 Integer

             , PeriodSun1 Integer
             , PeriodSun2 Integer
             , PeriodSun3 Integer
             , PeriodSun4 Integer
             , PeriodSun5 Integer
             , PeriodSun6 Integer
             , PeriodSun7 Integer
             , DaySun1 Integer
             , DaySun2 Integer
             , DaySun3 Integer
             , DaySun4 Integer
             , DaySun5 Integer
             , DaySun6 Integer
             , DaySun7 Integer

             , UserId Integer
             , UserCode Integer
             , UserName TVarChar
             , IsErased Boolean
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
BEGIN
    -- Результат

    IF COALESCE (inId, 0) = 0
    THEN
      IF EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                                            AND ChildObjectId = inUnitId)
      THEN
        SELECT ObjectId
        INTO inId
        FROM ObjectLink
        WHERE DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
          AND ChildObjectId = inUnitId;
      END IF;
    END IF;

    IF  inId = 0
    THEN
        RETURN QUERY
            SELECT
                0                AS Id
               ,lfGet_ObjectCode(0, zc_Object_RecalcMCSSheduler()) AS Code
               ,Object_Unit.Id                      AS UnitId
               ,Object_Unit.ObjectCode              AS UnitCode
               ,Object_Unit.ValueData               AS UnitName

               , COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) AS PharmacyItem
               , ''::TVarChar                       AS Comment
               , False                              AS AllRetail

               , ObjectFloat_Period.ValueData        :: Integer     AS Period
               , ObjectFloat_Period1.ValueData       :: Integer     AS Period1
               , ObjectFloat_Period2.ValueData       :: Integer     AS Period2
               , ObjectFloat_Period3.ValueData       :: Integer     AS Period3
               , ObjectFloat_Period4.ValueData       :: Integer     AS Period4
               , ObjectFloat_Period5.ValueData       :: Integer     AS Period5
               , ObjectFloat_Period6.ValueData       :: Integer     AS Period6
               , ObjectFloat_Period7.ValueData       :: Integer     AS Period7

               , ObjectFloat_Day.ValueData           :: Integer     AS Day
               , ObjectFloat_Day1.ValueData          :: Integer     AS Day1
               , ObjectFloat_Day2.ValueData          :: Integer     AS Day2
               , ObjectFloat_Day3.ValueData          :: Integer     AS Day3
               , ObjectFloat_Day4.ValueData          :: Integer     AS Day4
               , ObjectFloat_Day5.ValueData          :: Integer     AS Day5
               , ObjectFloat_Day6.ValueData          :: Integer     AS Day6
               , ObjectFloat_Day7.ValueData          :: Integer     AS Day7

               , ObjectFloat_PeriodSun1.ValueData    :: Integer     AS PeriodSun1
               , ObjectFloat_PeriodSun2.ValueData    :: Integer     AS PeriodSun2
               , ObjectFloat_PeriodSun3.ValueData    :: Integer     AS PeriodSun3
               , ObjectFloat_PeriodSun4.ValueData    :: Integer     AS PeriodSun4
               , ObjectFloat_PeriodSun5.ValueData    :: Integer     AS PeriodSun5
               , ObjectFloat_PeriodSun6.ValueData    :: Integer     AS PeriodSun6
               , ObjectFloat_PeriodSun7.ValueData    :: Integer     AS PeriodSun7

               , ObjectFloat_DaySun1.ValueData       :: Integer     AS DaySun1
               , ObjectFloat_DaySun2.ValueData       :: Integer     AS DaySun2
               , ObjectFloat_DaySun3.ValueData       :: Integer     AS DaySun3
               , ObjectFloat_DaySun4.ValueData       :: Integer     AS DaySun4
               , ObjectFloat_DaySun5.ValueData       :: Integer     AS DaySun5
               , ObjectFloat_DaySun6.ValueData       :: Integer     AS DaySun6
               , ObjectFloat_DaySun7.ValueData       :: Integer     AS DaySun7

               ,NULL::Integer    AS UserId
               ,NULL::Integer    AS UserCode
               ,NULL::TVarChar   AS UserName
               ,FALSE            AS IsErased
            FROM Object AS Object_Unit

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PharmacyItem
                                         ON ObjectBoolean_PharmacyItem.ObjectId = Object_Unit.Id
                                        AND ObjectBoolean_PharmacyItem.DescId = zc_ObjectBoolean_Unit_PharmacyItem()

                 LEFT JOIN ObjectString AS ObjectString_Comment
                                        ON ObjectString_Comment.ObjectId = Object_RecalcMCSSheduler.Id
                                       AND ObjectString_Comment.DescId = zc_ObjectString_RecalcMCSSheduler_Comment()

                 LEFT JOIN ObjectFloat AS ObjectFloat_Period
                                       ON ObjectFloat_Period.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period.DescId = zc_ObjectFloat_Unit_Period()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period1
                                       ON ObjectFloat_Period1.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period1.DescId = zc_ObjectFloat_Unit_Period1()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period2
                                       ON ObjectFloat_Period2.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period2.DescId = zc_ObjectFloat_Unit_Period2()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period3
                                       ON ObjectFloat_Period3.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period3.DescId = zc_ObjectFloat_Unit_Period3()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period4
                                       ON ObjectFloat_Period4.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period4.DescId = zc_ObjectFloat_Unit_Period4()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period5
                                       ON ObjectFloat_Period5.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period5.DescId = zc_ObjectFloat_Unit_Period5()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period6
                                       ON ObjectFloat_Period6.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period6.DescId = zc_ObjectFloat_Unit_Period6()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period7
                                       ON ObjectFloat_Period7.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period7.DescId = zc_ObjectFloat_Unit_Period7()

                 LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                       ON ObjectFloat_Day.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day.DescId = zc_ObjectFloat_Unit_Day()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day1
                                       ON ObjectFloat_Day1.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day1.DescId = zc_ObjectFloat_Unit_Day1()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day2
                                       ON ObjectFloat_Day2.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day2.DescId = zc_ObjectFloat_Unit_Day2()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day3
                                       ON ObjectFloat_Day3.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day3.DescId = zc_ObjectFloat_Unit_Day3()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day4
                                       ON ObjectFloat_Day4.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day4.DescId = zc_ObjectFloat_Unit_Day4()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day5
                                       ON ObjectFloat_Day5.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day5.DescId = zc_ObjectFloat_Unit_Day5()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day6
                                       ON ObjectFloat_Day6.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day6.DescId = zc_ObjectFloat_Unit_Day6()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day7
                                       ON ObjectFloat_Day7.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day7.DescId = zc_ObjectFloat_Unit_Day7()

                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun1
                                       ON ObjectFloat_PeriodSun1.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun1.DescId = zc_ObjectFloat_Unit_PeriodSun1()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun2
                                       ON ObjectFloat_PeriodSun2.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun2.DescId = zc_ObjectFloat_Unit_PeriodSun2()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun3
                                       ON ObjectFloat_PeriodSun3.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun3.DescId = zc_ObjectFloat_Unit_PeriodSun3()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun4
                                       ON ObjectFloat_PeriodSun4.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun4.DescId = zc_ObjectFloat_Unit_PeriodSun4()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun5
                                       ON ObjectFloat_PeriodSun5.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun5.DescId = zc_ObjectFloat_Unit_PeriodSun5()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun6
                                       ON ObjectFloat_PeriodSun6.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun6.DescId = zc_ObjectFloat_Unit_PeriodSun6()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun7
                                       ON ObjectFloat_PeriodSun7.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun7.DescId = zc_ObjectFloat_Unit_PeriodSun7()

                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun1
                                       ON ObjectFloat_DaySun1.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun1.DescId = zc_ObjectFloat_Unit_DaySun1()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun2
                                       ON ObjectFloat_DaySun2.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun2.DescId = zc_ObjectFloat_Unit_DaySun2()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun3
                                       ON ObjectFloat_DaySun3.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun3.DescId = zc_ObjectFloat_Unit_DaySun3()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun4
                                       ON ObjectFloat_DaySun4.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun4.DescId = zc_ObjectFloat_Unit_DaySun4()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun5
                                       ON ObjectFloat_DaySun5.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun5.DescId = zc_ObjectFloat_Unit_DaySun5()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun6
                                       ON ObjectFloat_DaySun6.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun6.DescId = zc_ObjectFloat_Unit_DaySun6()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun7
                                       ON ObjectFloat_DaySun7.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun7.DescId = zc_ObjectFloat_Unit_DaySun7()

            WHERE Object_Unit.Id = inUnitId
            ;
    ELSE
        RETURN QUERY
            SELECT
                Object_RecalcMCSSheduler.Id         AS Id
               ,Object_RecalcMCSSheduler.ObjectCode AS Code
               ,Object_Unit.Id                      AS UnitId
               ,Object_Unit.ObjectCode              AS UnitCode
               ,Object_Unit.ValueData               AS UnitName

               , COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) AS PharmacyItem
               , ObjectString_Comment.ValueData                   AS Comment
               , COALESCE(ObjectBoolean_AllRetail.ValueData, False) AS AllRetail

               , ObjectFloat_Period.ValueData        :: Integer     AS Period
               , ObjectFloat_Period1.ValueData       :: Integer     AS Period1
               , ObjectFloat_Period2.ValueData       :: Integer     AS Period2
               , ObjectFloat_Period3.ValueData       :: Integer     AS Period3
               , ObjectFloat_Period4.ValueData       :: Integer     AS Period4
               , ObjectFloat_Period5.ValueData       :: Integer     AS Period5
               , ObjectFloat_Period6.ValueData       :: Integer     AS Period6
               , ObjectFloat_Period7.ValueData       :: Integer     AS Period7

               , ObjectFloat_Day.ValueData           :: Integer     AS Day
               , ObjectFloat_Day1.ValueData          :: Integer     AS Day1
               , ObjectFloat_Day2.ValueData          :: Integer     AS Day2
               , ObjectFloat_Day3.ValueData          :: Integer     AS Day3
               , ObjectFloat_Day4.ValueData          :: Integer     AS Day4
               , ObjectFloat_Day5.ValueData          :: Integer     AS Day5
               , ObjectFloat_Day6.ValueData          :: Integer     AS Day6
               , ObjectFloat_Day7.ValueData          :: Integer     AS Day7

               , ObjectFloat_PeriodSun1.ValueData    :: Integer     AS PeriodSun1
               , ObjectFloat_PeriodSun2.ValueData    :: Integer     AS PeriodSun2
               , ObjectFloat_PeriodSun3.ValueData    :: Integer     AS PeriodSun3
               , ObjectFloat_PeriodSun4.ValueData    :: Integer     AS PeriodSun4
               , ObjectFloat_PeriodSun5.ValueData    :: Integer     AS PeriodSun5
               , ObjectFloat_PeriodSun6.ValueData    :: Integer     AS PeriodSun6
               , ObjectFloat_PeriodSun7.ValueData    :: Integer     AS PeriodSun7

               , ObjectFloat_DaySun1.ValueData       :: Integer     AS DaySun1
               , ObjectFloat_DaySun2.ValueData       :: Integer     AS DaySun2
               , ObjectFloat_DaySun3.ValueData       :: Integer     AS DaySun3
               , ObjectFloat_DaySun4.ValueData       :: Integer     AS DaySun4
               , ObjectFloat_DaySun5.ValueData       :: Integer     AS DaySun5
               , ObjectFloat_DaySun6.ValueData       :: Integer     AS DaySun6
               , ObjectFloat_DaySun7.ValueData       :: Integer     AS DaySun7

               ,Object_User.Id                      AS UserId
               ,Object_User.ObjectCode              AS UserCode
               ,Object_User.ValueData               AS UserName
               ,Object_RecalcMCSSheduler.IsErased   AS IsErased
            FROM
                Object AS Object_RecalcMCSSheduler
                 LEFT JOIN ObjectLink AS ObjectLink_Unit
                                      ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                     AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                 LEFT JOIN Object AS Object_Unit
                                  ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PharmacyItem
                                         ON ObjectBoolean_PharmacyItem.ObjectId = Object_Unit.Id
                                        AND ObjectBoolean_PharmacyItem.DescId = zc_ObjectBoolean_Unit_PharmacyItem()

                 LEFT JOIN ObjectString AS ObjectString_Comment
                                        ON ObjectString_Comment.ObjectId = Object_RecalcMCSSheduler.Id
                                       AND ObjectString_Comment.DescId = zc_ObjectString_RecalcMCSSheduler_Comment()

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_AllRetail
                                         ON ObjectBoolean_AllRetail.ObjectId = Object_RecalcMCSSheduler.Id
                                        AND ObjectBoolean_AllRetail.DescId = zc_ObjectBoolean_RecalcMCSSheduler_AllRetail()

                 LEFT JOIN ObjectFloat AS ObjectFloat_Period
                                       ON ObjectFloat_Period.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period.DescId = zc_ObjectFloat_Unit_Period()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period1
                                       ON ObjectFloat_Period1.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period1.DescId = zc_ObjectFloat_Unit_Period1()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period2
                                       ON ObjectFloat_Period2.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period2.DescId = zc_ObjectFloat_Unit_Period2()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period3
                                       ON ObjectFloat_Period3.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period3.DescId = zc_ObjectFloat_Unit_Period3()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period4
                                       ON ObjectFloat_Period4.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period4.DescId = zc_ObjectFloat_Unit_Period4()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period5
                                       ON ObjectFloat_Period5.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period5.DescId = zc_ObjectFloat_Unit_Period5()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period6
                                       ON ObjectFloat_Period6.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period6.DescId = zc_ObjectFloat_Unit_Period6()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Period7
                                       ON ObjectFloat_Period7.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Period7.DescId = zc_ObjectFloat_Unit_Period7()

                 LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                       ON ObjectFloat_Day.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day.DescId = zc_ObjectFloat_Unit_Day()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day1
                                       ON ObjectFloat_Day1.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day1.DescId = zc_ObjectFloat_Unit_Day1()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day2
                                       ON ObjectFloat_Day2.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day2.DescId = zc_ObjectFloat_Unit_Day2()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day3
                                       ON ObjectFloat_Day3.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day3.DescId = zc_ObjectFloat_Unit_Day3()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day4
                                       ON ObjectFloat_Day4.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day4.DescId = zc_ObjectFloat_Unit_Day4()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day5
                                       ON ObjectFloat_Day5.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day5.DescId = zc_ObjectFloat_Unit_Day5()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day6
                                       ON ObjectFloat_Day6.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day6.DescId = zc_ObjectFloat_Unit_Day6()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Day7
                                       ON ObjectFloat_Day7.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_Day7.DescId = zc_ObjectFloat_Unit_Day7()

                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun1
                                       ON ObjectFloat_PeriodSun1.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun1.DescId = zc_ObjectFloat_Unit_PeriodSun1()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun2
                                       ON ObjectFloat_PeriodSun2.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun2.DescId = zc_ObjectFloat_Unit_PeriodSun2()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun3
                                       ON ObjectFloat_PeriodSun3.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun3.DescId = zc_ObjectFloat_Unit_PeriodSun3()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun4
                                       ON ObjectFloat_PeriodSun4.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun4.DescId = zc_ObjectFloat_Unit_PeriodSun4()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun5
                                       ON ObjectFloat_PeriodSun5.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun5.DescId = zc_ObjectFloat_Unit_PeriodSun5()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun6
                                       ON ObjectFloat_PeriodSun6.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun6.DescId = zc_ObjectFloat_Unit_PeriodSun6()
                 LEFT JOIN ObjectFloat AS ObjectFloat_PeriodSun7
                                       ON ObjectFloat_PeriodSun7.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_PeriodSun7.DescId = zc_ObjectFloat_Unit_PeriodSun7()

                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun1
                                       ON ObjectFloat_DaySun1.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun1.DescId = zc_ObjectFloat_Unit_DaySun1()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun2
                                       ON ObjectFloat_DaySun2.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun2.DescId = zc_ObjectFloat_Unit_DaySun2()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun3
                                       ON ObjectFloat_DaySun3.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun3.DescId = zc_ObjectFloat_Unit_DaySun3()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun4
                                       ON ObjectFloat_DaySun4.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun4.DescId = zc_ObjectFloat_Unit_DaySun4()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun5
                                       ON ObjectFloat_DaySun5.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun5.DescId = zc_ObjectFloat_Unit_DaySun5()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun6
                                       ON ObjectFloat_DaySun6.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun6.DescId = zc_ObjectFloat_Unit_DaySun6()
                 LEFT JOIN ObjectFloat AS ObjectFloat_DaySun7
                                       ON ObjectFloat_DaySun7.ObjectId = Object_Unit.Id
                                      AND ObjectFloat_DaySun7.DescId = zc_ObjectFloat_Unit_DaySun7()

                 LEFT JOIN ObjectLink AS ObjectLink_User
                                      ON ObjectLink_User.ObjectId = Object_RecalcMCSSheduler.Id
                                     AND ObjectLink_User.DescId = zc_ObjectLink_RecalcMCSSheduler_User()
                 LEFT JOIN Object AS Object_User
                                  ON Object_User.Id = ObjectLink_User.ChildObjectId
            WHERE
                Object_RecalcMCSSheduler.Id = inId;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_RecalcMCSSheduler(Integer, Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий. О.В.
 10.12.19                                                       *
 09.02.19                                                       *
 21.12.18                                                       *
*/

-- тест
-- select * from gpGet_Object_RecalcMCSSheduler(inId := 8567401 , inUnitId := 8301448 ,  inSession := '3');