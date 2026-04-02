-- Function: gpGet_Object_OrderGoods()

DROP FUNCTION IF EXISTS gpGet_Object_OrderGoods(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_OrderGoods(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_OrderGoods());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_OrderGoods()) AS Code
           , CAST ('' as TVarChar)  AS Name  
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_OrderGoods.Id            AS Id 
         , Object_OrderGoods.ObjectCode    AS Code
         , Object_OrderGoods.ValueData     AS Name 
         , ObjectString_Comment.ValueData  AS Comment
         , Object_OrderGoods.isErased      AS isErased
     FROM OBJECT AS Object_OrderGoods
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_OrderGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_OrderGoods_Comment()   
       WHERE Object_OrderGoods.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.26         *
*/

-- тест
-- SELECT * FROM gpGet_Object_OrderGoods(0, '2')