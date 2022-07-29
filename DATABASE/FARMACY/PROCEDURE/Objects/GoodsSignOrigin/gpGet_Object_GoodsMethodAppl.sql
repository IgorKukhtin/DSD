-- Function: gpGet_Object_GoodsSignOrigin (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsSignOrigin (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsSignOrigin(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameUkr TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsSignOrigin());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsSignOrigin()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS NameUkr
           , False                  AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_GoodsSignOrigin.Id                       AS Id
            , Object_GoodsSignOrigin.ObjectCode               AS Code
            , Object_GoodsSignOrigin.ValueData                AS Name
            , ObjectString_GoodsSignOrigin_NameUkr.ValueData  AS NameUkr
            , Object_GoodsSignOrigin.isErased                 AS isErased
       FROM Object AS Object_GoodsSignOrigin

           LEFT JOIN ObjectString AS ObjectString_GoodsSignOrigin_NameUkr
                                  ON ObjectString_GoodsSignOrigin_NameUkr.ObjectId = Object_GoodsSignOrigin.Id
                                 AND ObjectString_GoodsSignOrigin_NameUkr.DescId = zc_ObjectString_GoodsSignOrigin_NameUkr()   

       WHERE Object_GoodsSignOrigin.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.07.22                                                       *              

*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsSignOrigin(0,'2')