-- Function: gpSelect_Object_Street (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Price(
    IN inUnitId      Integer,       -- подразделение
    IN inisShowAll   Boolean,	    --True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       --True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , DateChange TDateTime,
			 isErased boolean
             ) AS
$BODY$
DECLARE
  vbUserId Integer;
  --vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);
     IF inUnitId is null
     THEN
       inUnitId := 0;
     END IF;
     -- Результат
      RETURN QUERY
         SELECT DISTINCT
           Object_Price_View.Id
	      ,Object_Price_View.Price
	      ,Object_Goods.id as  GoodsId
	      ,Object_Goods.objectcode as GoodsCode
	      ,object_goods.valuedata as GoodsName
	      ,Object_Price_View.DateChange
	      ,Object_Goods.isErased
         FROM Object AS Object_Goods
           LEFT OUTER JOIN Object_Price_View ON Object_Goods.id = object_price_view.goodsid
                                             AND Object_Price_View.unitid = inUnitId

         WHERE
           Object_Goods.descid = zc_object_goods()
           AND
           (
             (
               inIsSHowAll = True
               AND
               inUnitId <> 0
             )
             or
             object_price_view.id is not null
           )
           AND
           (
             inisShowDel = True
             or
             Object_Goods.isErased = False
           )
         ORDER BY
           GoodsName;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.06.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Price (183292,False,False,'3');