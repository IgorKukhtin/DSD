-- Function: gpGet_Object_GoodsKindWeighing()

--DROP FUNCTION gpGet_Object_GoodsKindWeighing();

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsKindWeighing(
    IN inId          Integer,       -- Единица измерения
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GoodsKindId Integer, GoodsKindName TVarChar) AS
$BODY$BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighing());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)    AS GoodsKindId
           , CAST ('' as TVarChar)  AS GoodsKindName
       FROM Object
       WHERE Object.DescId = zc_Object_GoodsKindWeighing();
   ELSE
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
                            ON ObjectLink_GoodsKindWeighing_GoodsKind.ObjectId = Object.Id
                           AND ObjectLink_GoodsKindWeighing_GoodsKind.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKind()
       LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Goods_Measure.ChildObjectId
                                           AND Object_GoodsKind.DescId = zc_Object_GoodsKind()

       WHERE Object.Id = inId;
   END IF;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsKindWeighing(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.03.14                                                         *


*/

-- тест
-- SELECT * FROM gpSelect_GoodsKindWeighing('2')