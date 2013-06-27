-- Function: gpSelect_Object_Unit()

-- DROP FUNCTION gpSelect_Object_Unit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
   SELECT Object_Unit.Id             AS Id 
        , Object_Unit.ObjectCode     AS Code
        , Object_Unit.ValueData      AS Name
        , Object_Unit.isErased       AS isErased
        , ObjectLink_Unit_Parent.ChildObjectId AS ParentId
   FROM Object AS Object_Unit
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
               ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
              AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

   WHERE Object_Unit.DescId = zc_Object_Unit();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit ('2')