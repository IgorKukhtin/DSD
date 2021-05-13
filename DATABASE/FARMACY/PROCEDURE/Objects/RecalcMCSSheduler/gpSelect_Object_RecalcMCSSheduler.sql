-- Function: gpSelect_Object_RecalcMCSSheduler()

DROP FUNCTION IF EXISTS gpSelect_Object_RecalcMCSSheduler(Boolean ,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RecalcMCSSheduler(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord Integer, ID Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , AreaName TVarChar, JuridicalId Integer, JuridicalName TVarChar
             , RetailId Integer, RetailName TVarChar
             , ProvinceCityName TVarChar
             , PharmacyItem boolean
             , Comment TVarChar

             , UserId Integer
             , UserName TVarChar
             , DateRun TDateTime
             , DateRunSun TDateTime

             , Period TVarChar
             , Period1 TVarChar
             , Period2 TVarChar
             , Period3 TVarChar
             , Period4 TVarChar
             , Period5 TVarChar
             , Period6 TVarChar
             , Period7 TVarChar

             , PeriodSun1 TVarChar
             , PeriodSun2 TVarChar
             , PeriodSun3 TVarChar
             , PeriodSun4 TVarChar
             , PeriodSun5 TVarChar
             , PeriodSun6 TVarChar
             , PeriodSun7 TVarChar

             , Color_cal Integer
             , AllRetail boolean
             , UserRun TVarChar
             , SelectRun boolean
             , isErased boolean) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

   RETURN QUERY
                         
       SELECT
             ROW_NUMBER() OVER (ORDER BY Object_RecalcMCSSheduler.Id)::Integer as Ord
           , Object_RecalcMCSSheduler.Id                      AS Id
           , Object_RecalcMCSSheduler.ObjectCode              AS Code
           , Object_RecalcMCSSheduler.ValueData               AS Name
           , Object_Unit.Id                                   AS UnitId
           , Object_Unit.ObjectCode                           AS UnitCode
           , Object_Unit.ValueData                            AS UnitName
           , Object_Area.ValueData                            AS AreaName
           , Object_Juridical.Id                              AS JuridicalID
           , Object_Juridical.ValueData                       AS JuridicalName
           , Object_Retail.Id                                 AS RetailID
           , Object_Retail.ValueData                          AS RetailName
           , Object_ProvinceCity.ValueData                    AS ProvinceCityName
           , COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) AS PharmacyItem
           , ObjectString_Comment.ValueData                   AS Comment

           , Object_User.Id                                   AS UnitId
           , Object_User.ValueData                            AS UnitName
           , ObjectDate_DateRun.ValueData                     AS DateRun
           , ObjectDate_DateRunSun.ValueData                  AS DateRunSun
           
           , (ObjectFloat_Period.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_Day.ValueData:: Integer::TVarChar)::TVarChar     AS Period

           , (ObjectFloat_Period1.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_Day1.ValueData:: Integer::TVarChar)::TVarChar     AS Period1

           , (ObjectFloat_Period2.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_Day2.ValueData:: Integer::TVarChar)::TVarChar     AS Period2

           , (ObjectFloat_Period3.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_Day3.ValueData:: Integer::TVarChar)::TVarChar     AS Period3

           , (ObjectFloat_Period4.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_Day4.ValueData:: Integer::TVarChar)::TVarChar     AS Period4

           , (ObjectFloat_Period5.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_Day5.ValueData:: Integer::TVarChar)::TVarChar     AS Period5

           , (ObjectFloat_Period6.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_Day6.ValueData:: Integer::TVarChar)::TVarChar     AS Period6

           , (ObjectFloat_Period7.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_Day7.ValueData:: Integer::TVarChar)::TVarChar     AS Period7

           , (ObjectFloat_PeriodSun1.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_DaySun1.ValueData:: Integer::TVarChar)::TVarChar  AS PeriodSun1

           , (ObjectFloat_PeriodSun2.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_DaySun2.ValueData:: Integer::TVarChar)::TVarChar  AS PeriodSun2

           , (ObjectFloat_PeriodSun3.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_DaySun3.ValueData:: Integer::TVarChar)::TVarChar  AS PeriodSun3

           , (ObjectFloat_PeriodSun4.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_DaySun4.ValueData:: Integer::TVarChar)::TVarChar  AS PeriodSun4

           , (ObjectFloat_PeriodSun5.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_DaySun5.ValueData:: Integer::TVarChar)::TVarChar  AS PeriodSun5

           , (ObjectFloat_PeriodSun6.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_DaySun6.ValueData:: Integer::TVarChar)::TVarChar  AS PeriodSun6

           , (ObjectFloat_PeriodSun7.ValueData::Integer::TVarChar||'/'||
             ObjectFloat_DaySun7.ValueData:: Integer::TVarChar)::TVarChar  AS PeriodSun7

           
           
           , CASE WHEN COALESCE (ObjectBoolean_AllRetail.ValueData, FALSE) = TRUE
             THEN
               42495
             ELSE  zc_Color_White() END                                                         AS Color_cal
           , COALESCE (ObjectBoolean_AllRetail.ValueData, FALSE)                                AS AllRetail
           , Object_UserRun.ValueData                                                           AS UserRun
           , COALESCE (ObjectBoolean_SelectRun.ValueData, FALSE)                                AS SelectRun
           , Object_RecalcMCSSheduler.isErased                                                  AS isErased

       FROM Object AS Object_RecalcMCSSheduler
           LEFT JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
           LEFT JOIN Object AS Object_Unit
                             ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_AllRetail
                                   ON ObjectBoolean_AllRetail.ObjectId = Object_RecalcMCSSheduler.Id
                                  AND ObjectBoolean_AllRetail.DescId = zc_ObjectBoolean_RecalcMCSSheduler_AllRetail()

           LEFT JOIN ObjectDate AS ObjectDate_DateRun
                                ON ObjectDate_DateRun.ObjectId = Object_RecalcMCSSheduler.Id
                               AND ObjectDate_DateRun.DescId = zc_ObjectFloat_RecalcMCSSheduler_DateRun()
           LEFT JOIN ObjectDate AS ObjectDate_DateRunSun
                                ON ObjectDate_DateRunSun.ObjectId = Object_RecalcMCSSheduler.Id
                               AND ObjectDate_DateRunSun.DescId = zc_ObjectFloat_RecalcMCSSheduler_DateRunSun()

           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_RecalcMCSSheduler.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_RecalcMCSSheduler_Comment()

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                ON ObjectLink_Unit_Area.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                               AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                ON ObjectLink_Unit_ProvinceCity.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
           LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_PharmacyItem
                                   ON ObjectBoolean_PharmacyItem.ObjectId = ObjectLink_Unit.ChildObjectId
                                  AND ObjectBoolean_PharmacyItem.DescId = zc_ObjectBoolean_Unit_PharmacyItem()

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

           LEFT JOIN ObjectLink AS ObjectLink_UserRun
                                 ON ObjectLink_UserRun.ObjectId = Object_RecalcMCSSheduler.Id
                                AND ObjectLink_UserRun.DescId = zc_ObjectLink_RecalcMCSSheduler_UserRun()
           LEFT JOIN Object AS Object_UserRun
                            ON Object_UserRun.Id = ObjectLink_UserRun.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_SelectRun
                                   ON ObjectBoolean_SelectRun.ObjectId = Object_RecalcMCSSheduler.Id
                                  AND ObjectBoolean_SelectRun.DescId = zc_ObjectBoolean_RecalcMCSSheduler_SelectRun()

       WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()
         AND (Object_RecalcMCSSheduler.isErased = False OR COALESCE(inIsErased, False) = True);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_RecalcMCSSheduler (Boolean ,TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.12.19                                                       *
 09.02.19                                                       *
 21.12.18                                                       *
*/

-- тест
--
 select * from gpSelect_Object_RecalcMCSSheduler(inIsErased := False, inSession := '3');