-- Function: gpSelect_Object_CorrectWagesPercentage()

DROP FUNCTION IF EXISTS gpSelect_Object_CorrectWagesPercentage(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CorrectWagesPercentage(
    IN inShowAll       Boolean ,	  -- Показать все
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               UserId Integer, UserName TVarChar,
               UnitId Integer, UnitName TVarChar,
               DateStart TDateTime, DateEnd TDateTime, 
               Percent TFloat,
               isCheck Boolean, isStore Boolean,
               isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CorrectWagesPercentage());

   RETURN QUERY 
       SELECT 
             Object_CorrectWagesPercentage.Id
           , Object_CorrectWagesPercentage.ObjectCode
           , Object_CorrectWagesPercentage.ValueData
         
           , Object_User.ID                  AS UserId
           , Object_User.ValueData           AS UserName 
           
           , Object_Unit.ID                  AS UnitId
           , Object_Unit.ValueData           AS UnitName 

           , ObjectDate_DateStart.ValueData  AS  DateStart
           , ObjectDate_DateEnd.ValueData    AS  DateEnd

           , ObjectFloat_Percent.ValueData           AS Percent         
           
           , COALESCE (ObjectBoolean_Check.ValueData, FALSE)   AS isCheck
           , COALESCE (ObjectBoolean_Store.ValueData, FALSE)   AS isStore

           , Object_CorrectWagesPercentage.isErased
           
       FROM Object AS Object_CorrectWagesPercentage
       
       
           LEFT JOIN ObjectLink AS ObjectLink_CorrectWagesPercentage_User
                                ON ObjectLink_CorrectWagesPercentage_User.ObjectId = Object_CorrectWagesPercentage.Id
                               AND ObjectLink_CorrectWagesPercentage_User.DescId = zc_ObjectLink_CorrectWagesPercentage_User()
           LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_CorrectWagesPercentage_User.ChildObjectId   
           
           LEFT JOIN ObjectLink AS ObjectLink_CorrectWagesPercentage_Unit
                                ON ObjectLink_CorrectWagesPercentage_Unit.ObjectId = Object_CorrectWagesPercentage.Id
                               AND ObjectLink_CorrectWagesPercentage_Unit.DescId = zc_ObjectLink_CorrectWagesPercentage_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_CorrectWagesPercentage_Unit.ChildObjectId   

           LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                ON ObjectDate_DateStart.ObjectId = Object_CorrectWagesPercentage.Id 
                               AND ObjectDate_DateStart.DescId = zc_ObjectDate_CorrectWagesPercentage_DateStart()
           LEFT JOIN ObjectDate AS ObjectDate_DateEnd
                                ON ObjectDate_DateEnd.ObjectId = Object_CorrectWagesPercentage.Id 
                               AND ObjectDate_DateEnd.DescId = zc_ObjectDate_CorrectWagesPercentage_DateEnd()

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                 ON ObjectFloat_Percent.ObjectId = Object_CorrectWagesPercentage.Id 
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_CorrectWagesPercentage_Percent()
                                
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Check
                                   ON ObjectBoolean_Check.ObjectId = Object_CorrectWagesPercentage.Id 
                                  AND ObjectBoolean_Check.DescId = zc_ObjectBoolean_CorrectWagesPercentage_Check()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Store
                                   ON ObjectBoolean_Store.ObjectId = Object_CorrectWagesPercentage.Id 
                                  AND ObjectBoolean_Store.DescId = zc_ObjectBoolean_CorrectWagesPercentage_Store()

       WHERE Object_CorrectWagesPercentage.DescId = zc_Object_CorrectWagesPercentage()
         AND (inShowAll = True OR Object_CorrectWagesPercentage.isErased = False)
       ORDER BY Object_CorrectWagesPercentage.Id
       ;
            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CorrectWagesPercentage (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.09.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_CorrectWagesPercentage (True, '3')