-- Function: gpSelect_Object_Cash_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_Cash_Tree(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash_Tree(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Cash());

   RETURN QUERY 
       SELECT
             Object_Cash.Id                  AS Id
           , Object_Cash.ObjectCode          AS Code
           , Object_Cash.ValueData           AS Name
           , COALESCE (ObjectLink_Cash_Parent.ChildObjectId, 0)   AS ParentId
           , Object_Cash.isErased            AS isErased
       FROM Object AS Object_Cash
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Parent
                                 ON ObjectLink_Cash_Parent.ObjectId = Object_Cash.Id
                                AND ObjectLink_Cash_Parent.DescId = zc_ObjectLink_Cash_Parent()
       WHERE Object_Cash.DescId = zc_Object_Cash()
         AND Object_Cash.Id IN (SELECT DISTINCT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Cash_Parent())

      UNION
       SELECT 0 AS Id,
              0 AS Code,
              CAST('ВСЕ' AS TVarChar) AS Name,
              0 AS ParentId,
              FALSE AS isErased
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
-- SELECT * FROM gpSelect_Object_Cash_Tree ('2')
