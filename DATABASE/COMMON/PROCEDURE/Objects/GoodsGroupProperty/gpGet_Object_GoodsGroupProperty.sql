-- Function: gpGet_Object_GoodsGroupProperty()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroupProperty(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroupProperty(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ParentId Integer, ParentName TVarChar
            ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsGroupProperty()) AS Code
           , CAST ('' AS TVarChar)  AS Name 
           , CAST (0 as Integer)    AS ParentId
           , CAST ('' AS TVarChar)  AS ParentName
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object_Parent.Id        ::Integer  AS ParentId
           , Object_Parent.ValueData ::TVarChar AS ParentName
       FROM Object
        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                             ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object.Id
                            AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.23         *

*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsGroupProperty (0, '2')