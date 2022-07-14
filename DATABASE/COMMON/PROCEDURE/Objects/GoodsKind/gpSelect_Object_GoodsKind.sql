-- Function: gpSelect_Object_GoodsKind()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsKind (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsKind (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsKind(
    IN inShowAll        Boolean, 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsKind());
   vbUserId:= lpGetUserBySession (inSession);


   IF EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 AND BranchId NOT IN (301310, 8109544 )) -- филиал Запорожье + Ирна
   THEN
       -- результат такой
       RETURN QUERY 
       WITH tmpGoodsKind AS (SELECT DISTINCT ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId
                             FROM ObjectBoolean AS ObjectBoolean_Order
                                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectBoolean_Order.ObjectId
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0
                             WHERE ObjectBoolean_Order.ValueData = TRUE
                               AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                            )

       SELECT 
             Object.Id         AS Id 
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
       FROM tmpGoodsKind
            INNER JOIN Object ON Object.Id = tmpGoodsKind.GoodsKindId
                             AND (Object.isErased = FALSE OR inShowAll = TRUE)
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name
            , FALSE AS isErased
      ;
   ELSE
       -- результат другой
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id 
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
       FROM Object
       WHERE Object.DescId = zc_Object_GoodsKind()
           AND (Object.Id <> 268778 OR vbUserId = 5) -- "удален - шт" + Админ
           AND (Object.isErased = FALSE OR inShowAll = TRUE)
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name
            , FALSE AS isErased
      ;
   END IF;
     
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.19         *
 12.06.13         *
 00.06.13          
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsKind (inSession:= zfCalc_UserAdmin())
