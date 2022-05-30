-- Function: gpSelect_Object_Unit_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Tree(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_Tree(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, isLeaf Boolean, isErased Boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY 
       SELECT
             Object_Unit.Id                  AS Id
           , Object_Unit.ObjectCode          AS Code
           , Object_Unit.ValueData           AS Name
           , Object_Parent.Id                AS ParentId
           , COALESCE (ObjectBoolean_isLeaf.ValueData, TRUE) :: Boolean  AS isLeaf
           , Object_Unit.isErased            AS isErased
       FROM Object AS Object_Unit
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                    ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()
       WHERE Object_Unit.DescId = zc_Object_Unit()
         AND Object_Unit.Id IN (SELECT DISTINCT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Parent())

      UNION
       SELECT
             0 AS Id
           , 0 AS Code
           , CAST('ВСЕ' AS TVarChar) AS Name
           , 0 AS ParentId
           , FALSE :: Boolean AS isLeaf
           , FALSE :: Boolean AS isErased
            ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_Tree ('5')
