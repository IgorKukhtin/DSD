-- Function: gpGet_Object_UnitGroup()

--DROP FUNCTION gpGet_Object_UnitGroup();

CREATE OR REPLACE FUNCTION gpGet_Object_UnitGroup(
    IN inId          Integer,       -- Касса 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer, ParentName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UnitGroup());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_UnitGroup();
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
           , UnitGroup.Id      AS ParentId
           , UnitGroup.ValueData AS ParentName
       FROM Object
       JOIN ObjectLink 
         ON ObjectLink.ObjectId = Object.Id
        AND ObjectLink.DescId = zc_ObjectLink_UnitGroup_Parent()
       JOIN Object AS UnitGroup
         ON UnitGroup.Id = ObjectLink.ChildObjectId
       WHERE Object.Id = inId;
   END IF; 
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_UnitGroup(integer, TVarChar)
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.13          *
 00.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_UnitGroup('2')