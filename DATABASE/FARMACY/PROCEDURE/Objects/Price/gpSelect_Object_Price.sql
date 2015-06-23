-- Function: gpSelect_Object_Street (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Price(
    IN inUnitId      Integer,       -- подразделение
    IN inisShowAll   Boolean,	    --True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       --True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue Tfloat
             , GoodsId Integer, GoodsCode TVarChar, GoodsName TVarChar
             , DateChange TDateTime, MCSDateChange TDateTime
			 , isErased boolean
             ) AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
     vbUserId:= lpGetUserBySession (inSession);
     -- Ограничение на просмотр товарного справочника
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     IF inUnitId is null
     THEN
       inUnitId := 0;
     END IF;
     -- Результат
      RETURN QUERY
         SELECT DISTINCT
           Object_Price_View.Id
	      ,Object_Price_View.Price
          ,Object_Price_View.MCSValue

	      ,Object_Goods.id as  GoodsId
	      ,Object_Goods.goodscode as GoodsCode
	      ,object_goods.goodsname as GoodsName
	      ,Object_Price_View.DateChange
	      ,Object_Price_View.MCSDateChange
	      ,Object_Goods.isErased
         FROM Object_Goods_View AS Object_Goods
           LEFT OUTER JOIN Object_Price_View ON Object_Goods.id = object_price_view.goodsid
                                             AND Object_Price_View.unitid = inUnitId
         WHERE
           Object_Goods.ObjectId = vbObjectId
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
-- SELECT * FROM gpSelect_Object_Price (183292,True,False,'3');