-- Function: gpSelect_Object_GoodsPrint (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPrint (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPrint(
    IN inUnitId      Integer,       --  подразделение сессии GoodsPrint
    IN inUserId      Integer,       --  Пользователь сессии GoodsPrint
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (UnitId               Integer
             , UnitName             TVarChar
             , UserId               Integer
             , UserName             TVarChar
             , InsertDate           TDateTime
             , GoodsCode            Integer
             , GoodsName            TVarChar
             , GoodsGroupName        TVarChar
 )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsPrint());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       SELECT Object_Unit.Id                      AS UnitId
            , Object_Unit.ValueData               AS UnitName
            , Object_User.Id                      AS UserId
            , Object_User.ValueData               AS UserName
            , Object_GoodsPrint.Amount            AS Amount
            , Object_GoodsPrint.InsertDate        AS InsertDate
            , Object_Goods.ObjectCode             AS GoodsCode
            , Object_Goods.ValueData              AS GoodsName
            , Object_GoodsGroup.ValueData         AS GoodsGroupName
       FROM Object_GoodsPrint
            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = Object_GoodsPrint.UnitId
            LEFT JOIN Object AS Object_User  ON Object_User.Id  = Object_GoodsPrint.UserId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Object_GoodsPrint.GoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

       WHERE (Object_GoodsPrint.UserId = inUserId OR inUserId = 0)
         AND (Object_GoodsPrint.UnitId = inUnitId OR inUnitId = 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
17.08.17          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPrint (inUnitId:=0, inUserId:= 0, inSession:= zfCalc_UserAdmin())
