-- Function: gpGet_Object_PersonalGroup (Integer,TVarChar)

-- DROP FUNCTION gpGet_Object_PersonalGroup (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PersonalGroup(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , WorkHours TFloat
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PersonalGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_PersonalGroup.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as TFloat)  AS WorkHours

           , CAST (0 as Integer)    AS UnitId
           , CAST (0 as Integer)    AS UnitCode
           , CAST ('' as TVarChar)  AS UnitName

           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_PersonalGroup
       WHERE Object_PersonalGroup.DescId = zc_Object_PersonalGroup();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PersonalGroup.Id          AS Id
           , Object_PersonalGroup.ObjectCode  AS Code
           , Object_PersonalGroup.ValueData   AS Name
           
           , ObjectFloat_WorkHours.ValueData  AS WorkHours
           
           , Object_Unit.Id          AS UnitId
           , Object_Unit.ObjectCode  AS UnitCode
           , Object_Unit.ValueData   AS UnitName

           , Object_PersonalGroup.isErased AS isErased
           
       FROM Object AS Object_PersonalGroup
       
            LEFT JOIN ObjectFloat AS ObjectFloat_WorkHours
                                ON ObjectFloat_WorkHours.ObjectId = Object_PersonalGroup.Id 
                               AND ObjectFloat_WorkHours.DescId = zc_ObjectFloat_PersonalGroup_WorkHours()
     
            LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                                       AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId
            
       WHERE Object_PersonalGroup.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PersonalGroup(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13          *

*/

-- тест
-- SELECT * FROM gpGet_Object_PersonalGroup (2, '')
