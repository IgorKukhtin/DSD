-- Function: gpSelect_Object_DocumentKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DocumentKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DocumentKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, EnumName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , isAuto Boolean
             , isErased Boolean
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_DocumentKind());
    vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY 
   SELECT
        Object_DocumentKind.Id           AS Id 
      , Object_DocumentKind.ObjectCode   AS Code
      , Object_DocumentKind.ValueData    AS Name
      , ObjectString_Enum.ValueData      AS EnumName
   -- , ObjectString_Enum.DescId :: TVarChar

      , Object_Goods.Id                  AS GoodsId
      , Object_Goods.ObjectCode          AS GoodsCode
      , Object_Goods.ValueData           AS GoodsName

      , Object_GoodsKind.Id              AS GoodsKindId
      , Object_GoodsKind.ObjectCode      AS GoodsKindCode
      , Object_GoodsKind.ValueData       AS GoodsKindName
      
      , COALESCE (ObjectBoolean_isAuto.ValueData, False) :: Boolean AS isAuto
      , Object_DocumentKind.isErased     AS isErased
      
   FROM Object AS Object_DocumentKind
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_DocumentKind.Id
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()

        LEFT JOIN ObjectLink AS ObjectLink_DocumentKind_Goods
                             ON ObjectLink_DocumentKind_Goods.ObjectId = Object_DocumentKind.Id
                            AND ObjectLink_DocumentKind_Goods.DescId = zc_ObjectLink_DocumentKind_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_DocumentKind_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_DocumentKind_GoodsKind
                             ON ObjectLink_DocumentKind_GoodsKind.ObjectId = Object_DocumentKind.Id
                            AND ObjectLink_DocumentKind_GoodsKind.DescId = zc_ObjectLink_DocumentKind_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_DocumentKind_GoodsKind.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isAuto
                                ON ObjectBoolean_isAuto.ObjectId = Object_DocumentKind.Id
                               AND ObjectBoolean_isAuto.DescId = zc_ObjectBoolean_DocumentKind_isAuto()

   WHERE Object_DocumentKind.DescId = zc_Object_DocumentKind()
     AND (ObjectString_Enum.ObjectId IS NULL
       OR Object_DocumentKind.Id IN (zc_Enum_DocumentKind_PackDiff())
       OR vbUserId IN (5, zfCalc_UserMain())
         )
  ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.17         *
 13.06.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_DocumentKind('2')
