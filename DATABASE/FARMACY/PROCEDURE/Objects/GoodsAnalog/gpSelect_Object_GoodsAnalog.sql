-- Function: gpSelect_Object_GoodsAnalog()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsAnalog(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsAnalog(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsAnalog()());

   RETURN QUERY
   SELECT
          Object_GoodsAnalog.Id         AS Id
        , Object_GoodsAnalog.ObjectCode AS Code
        , Object_GoodsAnalog.ValueData  AS Name

        , Object_GoodsAnalog.isErased   AS isErased
   FROM Object AS Object_GoodsAnalog
   WHERE Object_GoodsAnalog.DescId = zc_Object_GoodsAnalog();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 01.04.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsAnalog('3')