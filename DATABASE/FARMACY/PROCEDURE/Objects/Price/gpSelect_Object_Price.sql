-- Function: gpSelect_Object_Street (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Price(
    IN inUnitId      Integer,       -- подразделение
    IN inisShowAll   Boolean,	    --True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       --True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue Tfloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
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
    IF COALESCE(inUnitId,0) = 0
    THEN
        RETURN QUERY
            SELECT 
               NULL::Integer                    AS Id
              ,NULL::TFloat                     AS Price
              ,NULL::TFloat                     AS MCSValue
              ,NULL::Integer                    AS GoodsId
              ,NULL::Integer                    AS GoodsCode
              ,NULL::TVarChar                   AS GoodsName
              ,NULL::TDateTime                  AS DateChange
              ,NULL::TDateTime                  AS MCSDateChange
              ,NULL::Boolean                    AS isErased
            WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
            SELECT
               Object_Price_View.Id             AS Id
              ,Object_Price_View.Price          AS Price 
              ,Object_Price_View.MCSValue       AS MCSValue
              ,Object_Goods.id                  AS GoodsId
              ,Object_Goods.ObjectCode          AS GoodsCode
              ,object_goods.ValueData           AS GoodsName
              ,Object_Price_View.DateChange     AS DateChange
              ,Object_Price_View.MCSDateChange  AS MCSDateChange
              ,Object_Goods.isErased            AS isErased 
             FROM Object AS Object_Goods
               INNER JOIN ObjectLink ON Object_Goods.Id = ObjectLink.ObjectId
                                    AND ObjectLink.ChildObjectId = vbObjectId
               LEFT OUTER JOIN Object_Price_View ON Object_Goods.id = object_price_view.goodsid
                                                 AND Object_Price_View.unitid = inUnitId
             WHERE
               Object_Goods.DescId = zc_Object_Goods()
               AND
               (
                 inisShowDel = True
                 or
                 Object_Goods.isErased = False
               )
             ORDER BY
               GoodsName;
    ELSE
        RETURN QUERY
            SELECT
               Object_Price_View.Id             AS Id
              ,Object_Price_View.Price          AS Price 
              ,Object_Price_View.MCSValue       AS MCSValue
              ,Object_Goods.id                  AS GoodsId
              ,Object_Goods.ObjectCode          AS GoodsCode
              ,object_goods.ValueData           AS GoodsName
              ,Object_Price_View.DateChange     AS DateChange
              ,Object_Price_View.MCSDateChange  AS MCSDateChange
              ,Object_Goods.isErased            AS isErased 
             FROM Object_Price_View
               LEFT OUTER JOIN Object AS Object_Goods ON Object_Goods.id = object_price_view.goodsid
             WHERE
               Object_Price_View.unitid = inUnitId
               AND
               (
                 inisShowDel = True
                 or
                 Object_Goods.isErased = False
               )
             ORDER BY
               GoodsName;
    END IF;
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