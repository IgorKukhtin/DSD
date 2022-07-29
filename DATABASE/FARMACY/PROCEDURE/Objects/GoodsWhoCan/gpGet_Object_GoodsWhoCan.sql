-- Function: gpGet_Object_GoodsWhoCan (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsWhoCan (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsWhoCan(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameUkr TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsWhoCan());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsWhoCan()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS NameUkr
           , False                  AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_GoodsWhoCan.Id                       AS Id
            , Object_GoodsWhoCan.ObjectCode               AS Code
            , Object_GoodsWhoCan.ValueData                AS Name
            , ObjectString_GoodsWhoCan_NameUkr.ValueData  AS NameUkr
            , Object_GoodsWhoCan.isErased                 AS isErased
       FROM Object AS Object_GoodsWhoCan

           LEFT JOIN ObjectString AS ObjectString_GoodsWhoCan_NameUkr
                                  ON ObjectString_GoodsWhoCan_NameUkr.ObjectId = Object_GoodsWhoCan.Id
                                 AND ObjectString_GoodsWhoCan_NameUkr.DescId = zc_ObjectString_GoodsWhoCan_NameUkr()   

       WHERE Object_GoodsWhoCan.Id = inId;
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
-- SELECT * FROM gpGet_Object_GoodsWhoCan(0,'2')