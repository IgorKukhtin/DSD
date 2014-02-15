-- Function: gpSelect_Object_PersonalGroup(TVarChar)

--DROP FUNCTION gpSelect_Object_PersonalGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , WorkHours TFloat
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PersonalGroup());

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

     WHERE Object_PersonalGroup.DescId = zc_Object_PersonalGroup();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PersonalGroup(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13         * 

*/

-- тест
-- SELECT * FROM gpSelect_Object_PersonalGroup('2')