-- Function: gpSelect_Object_GoodsKindWeighing()

--DROP FUNCTION gpSelect_Object_GoodsKindWeighing();

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsKindWeighing(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GoodsKindId Integer, GoodsKindName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighing());

   RETURN QUERY
   SELECT
         Object.Id         AS Id
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , Object.isErased   AS isErased
       , Object_GoodsKind.Id        AS GoodsKindId
       , Object_GoodsKind.ValueData AS GoodsKindName

   FROM Object
   LEFT JOIN ObjectLink AS ObjectLink_GoodsKindWeighing_GoodsKind
                        ON ObjectLink_GoodsKindWeighing_GoodsKind.ObjectId = Object_Goods.Id
                       AND ObjectLink_GoodsKindWeighing_GoodsKind.DescId = zc_ObjectLink_Goods_Measure()
   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Goods_Measure.ChildObjectId
                                     AND Object_GoodsKind.DescId = zc_Object_GoodsKind()
   WHERE Object.DescId = zc_Object_GoodsKindWeighing();



END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsKindWeighing(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.03.14                                                         *
 21.03.14                                                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsKindWeighing('2')