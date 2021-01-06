-- Function: gpGet_Object_Maker()

DROP FUNCTION IF EXISTS gpGet_Object_Maker(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Maker(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , CountryId Integer, CountryCode Integer, CountryName TVarChar
             , ContactPersonId Integer, ContactPersonCode Integer, ContactPersonName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , SendPlan TDateTime
             , SendReal TDateTime
             , AmountDay TFloat
             , AmountMonth TFloat
             , isReport1  Boolean
             , isReport2  Boolean
             , isReport3  Boolean
             , isReport4  Boolean
             , isReport5  Boolean
             , isReport6  Boolean
             , isReport7  Boolean
             , isQuarter  Boolean
             , is4Month   Boolean
             , isErased   Boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Maker());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Maker()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)   AS CountryId
           , CAST (0 as Integer)   AS CountryCode
           , CAST ('' as TVarChar) AS CountryName

           , CAST (0 as Integer)   AS ContactPersonId
           , CAST (0 as Integer)   AS ContactPersonCode
           , CAST ('' as TVarChar) AS ContactPersonName

           , CAST (0 as Integer)   AS JuridicalId
           , CAST (0 as Integer)   AS JuridicalCode
           , CAST ('' as TVarChar) AS JuridicalName

           , NULL  :: TDateTime AS SendPlan
           , NULL  :: TDateTime AS SendReal

           , NULL  :: TFloat    AS AmountDay
           , NULL  :: TFloat    AS AmountMonth

           , FALSE :: Boolean   AS isReport1
           , FALSE :: Boolean   AS isReport2
           , FALSE :: Boolean   AS isReport3
           , FALSE :: Boolean   AS isReport4
           , FALSE :: Boolean   AS isReport5
           , FALSE :: Boolean   AS isReport6
           , FALSE :: Boolean   AS isReport7
           , FALSE :: Boolean   AS isQuarter
           , FALSE :: Boolean   AS is4Month

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Maker.Id          AS Id
           , Object_Maker.ObjectCode  AS Code
           , Object_Maker.ValueData   AS Name
           
           , Object_Country.Id    AS CountryId
           , Object_Country.ObjectCode  AS CountryCode
           , Object_Country.ValueData   AS CountryName

           , Object_ContactPerson.Id          AS ContactPersonId
           , Object_ContactPerson.ObjectCode  AS ContactPersonCode
           , Object_ContactPerson.ValueData   AS ContactPersonName

           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName

           , COALESCE (ObjectDate_SendPlan.ValueData, NULL) :: TDateTime AS SendPlan
           , COALESCE (ObjectDate_SendReal.ValueData, NULL) :: TDateTime AS SendReal

           , COALESCE (ObjectFloat_Day.ValueData, NULL)   :: TFloat AS AmountDay
           , COALESCE (ObjectFloat_Month.ValueData, NULL) :: TFloat AS AmountMonth

           , COALESCE (ObjectBoolean_Maker_Report1.ValueData, FALSE) :: Boolean AS isReport1
           , COALESCE (ObjectBoolean_Maker_Report2.ValueData, FALSE) :: Boolean AS isReport2
           , COALESCE (ObjectBoolean_Maker_Report3.ValueData, FALSE) :: Boolean AS isReport3
           , COALESCE (ObjectBoolean_Maker_Report4.ValueData, FALSE) :: Boolean AS isReport4
           , COALESCE (ObjectBoolean_Maker_Report5.ValueData, FALSE) :: Boolean AS isReport5
           , COALESCE (ObjectBoolean_Maker_Report6.ValueData, FALSE) :: Boolean AS isReport6
           , COALESCE (ObjectBoolean_Maker_Report7.ValueData, FALSE) :: Boolean AS isReport7
           , COALESCE (ObjectBoolean_Maker_Quarter.ValueData, FALSE) :: Boolean AS isQuarter
           , COALESCE (ObjectBoolean_Maker_4Month.ValueData, FALSE) :: Boolean  AS is4Month

           , Object_Maker.isErased AS isErased
           
       FROM Object AS Object_Maker
       
           LEFT JOIN ObjectLink AS ObjectLink_Maker_Country 
                                ON ObjectLink_Maker_Country.ObjectId = Object_Maker.Id 
                               AND ObjectLink_Maker_Country.DescId = zc_ObjectLink_Maker_Country()
           LEFT JOIN Object AS Object_Country ON Object_Country.Id = ObjectLink_Maker_Country.ChildObjectId              

           LEFT JOIN ObjectLink AS ObjectLink_Maker_ContactPerson 
                                ON ObjectLink_Maker_ContactPerson.ObjectId = Object_Maker.Id 
                               AND ObjectLink_Maker_ContactPerson.DescId = zc_ObjectLink_Maker_ContactPerson()
           LEFT JOIN Object AS Object_ContactPerson ON Object_ContactPerson.Id = ObjectLink_Maker_ContactPerson.ChildObjectId 

           LEFT JOIN ObjectLink AS ObjectLink_Maker_Juridical
                                ON ObjectLink_Maker_Juridical.ObjectId = Object_Maker.Id 
                               AND ObjectLink_Maker_Juridical.DescId = zc_ObjectLink_Maker_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Maker_Juridical.ChildObjectId 

           LEFT JOIN ObjectDate AS ObjectDate_SendPlan
                                ON ObjectDate_SendPlan.ObjectId = Object_Maker.Id
                               AND ObjectDate_SendPlan.DescId = zc_ObjectDate_Maker_SendPlan()
           LEFT JOIN ObjectDate AS ObjectDate_SendReal
                                ON ObjectDate_SendReal.ObjectId = Object_Maker.Id
                               AND ObjectDate_SendReal.DescId = zc_ObjectDate_Maker_SendReal()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report1
                                   ON ObjectBoolean_Maker_Report1.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report1.DescId = zc_ObjectBoolean_Maker_Report1()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report2
                                   ON ObjectBoolean_Maker_Report2.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report2.DescId = zc_ObjectBoolean_Maker_Report2()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report3
                                   ON ObjectBoolean_Maker_Report3.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report3.DescId = zc_ObjectBoolean_Maker_Report3()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report4
                                   ON ObjectBoolean_Maker_Report4.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report4.DescId = zc_ObjectBoolean_Maker_Report4()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report5
                                   ON ObjectBoolean_Maker_Report5.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report5.DescId = zc_ObjectBoolean_Maker_Report5()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report6
                                   ON ObjectBoolean_Maker_Report6.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report6.DescId = zc_ObjectBoolean_Maker_Report6()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Report7
                                   ON ObjectBoolean_Maker_Report7.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Report7.DescId = zc_ObjectBoolean_Maker_Report7()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_Quarter
                                   ON ObjectBoolean_Maker_Quarter.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_Quarter.DescId = zc_ObjectBoolean_Maker_Quarter()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Maker_4Month
                                   ON ObjectBoolean_Maker_4Month.ObjectId = Object_Maker.Id
                                  AND ObjectBoolean_Maker_4Month.DescId = zc_ObjectBoolean_Maker_4Month()

           LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                 ON ObjectFloat_Day.ObjectId = Object_Maker.Id
                                AND ObjectFloat_Day.DescId = zc_ObjectFloat_Maker_Day()
           LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                 ON ObjectFloat_Month.ObjectId = Object_Maker.Id
                                AND ObjectFloat_Month.DescId = zc_ObjectFloat_Maker_Month()

       WHERE Object_Maker.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Maker(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.01.21                                                       *
 14.01.20                                                       *
 07.08.19                                                       *
 05.04.19                                                       *
 03.04.19                                                       *
 18.01.19         *
 11.01.19         *
 11.02.14         *  

*/

-- тест
-- SELECT * FROM gpGet_Object_Maker (2, '')