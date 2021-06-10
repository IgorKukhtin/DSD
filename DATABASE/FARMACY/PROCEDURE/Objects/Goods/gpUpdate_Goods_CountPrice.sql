-- Function: gpUpdate_Goods_CountPrice()

DROP FUNCTION IF EXISTS gpUpdate_Goods_CountPrice(TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_CountPrice(
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpDataCount'))
     THEN
         DROP TABLE _tmpDataCount;
     END IF;

     CREATE TEMP TABLE _tmpDataCount (GoodsId Integer, CountPrice  TFloat) ON COMMIT DROP;
     INSERT INTO _tmpDataCount (GoodsId, CountPrice)
     
            WITH
            tmpGoods AS (SELECT DISTINCT ObjectLink_Goods_Object1.ObjectId AS GoodsId -- товар сети
                              , ObjectLink_Main_R.ChildObjectId            AS GoodsMainId
                              , Object_Retail.Id                           AS RetailId
                         FROM  ObjectLink AS ObjectLink_Main_R  
                               -- связь с товар сети ...
                              INNER JOIN ObjectLink AS ObjectLink_Child_R 
                                                    ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                   AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                              --торговая сеть
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object1
                                                    ON ObjectLink_Goods_Object1.ObjectId = ObjectLink_Child_R.ChildObjectId
                                                   AND ObjectLink_Goods_Object1.DescId = zc_ObjectLink_Goods_Object()
                              INNER JOIN Object AS Object_Retail
                                                ON Object_Retail.Id = ObjectLink_Goods_Object1.ChildObjectId
                                               AND Object_Retail.DescId = zc_Object_Retail()
                         WHERE ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                         )

          -- считаем кол-во прайсов
          , tmpCount AS (
                         SELECT COALESCE (LoadPriceList.AreaId,0)          AS AreaId
                              , LoadPriceListItem.GoodsId                  AS GoodsMainId
                              , Count (DISTINCT LoadPriceList.JuridicalId) AS CountPrice
                         FROM LoadPriceListItem 
                              INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                         WHERE LoadPriceListItem.GoodsId > 0
                         GROUP BY COALESCE (LoadPriceList.AreaId,0)
                                , LoadPriceListItem.GoodsId
                        )

          , tmpRetail AS (SELECT DISTINCT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                               , ObjectLink_Unit_Area.ChildObjectId                 AS AreaId
                          FROM Object AS Object_Unit
                               INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                     ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                               INNER JOIN ObjectLink AS ObjectLink_Unit_Area
                                                     ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                                                    AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                                                    AND COALESCE ( ObjectLink_Unit_Area.ChildObjectId, 0) <> 0
                               INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                     ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                    AND COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, 0) <> 0
                          WHERE Object_Unit.DescId = zc_Object_Unit()
                            AND Object_Unit.isErased = False
                          )


         SELECT tmp.GoodsId, SUM (tmp.CountPrice) AS CountPrice
                --lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountPrice(), tmp.GoodsId, SUM (COALESCE(tmp.CountPrice,0))  )
         FROM (SELECT tmpGoods.GoodsId, tmpCount.CountPrice, tmpGoods.GoodsMainId
               FROM tmpGoods
                    INNER JOIN tmpRetail ON tmpRetail.RetailId = tmpGoods.RetailId
 
                    LEFT JOIN tmpCount ON tmpCount.AreaId      = tmpRetail.AreaId
                                      AND tmpCount.GoodsMainId = tmpGoods.GoodsMainId
               WHERE COALESCE (tmpCount.AreaId, 0) <> 0
             UNION ALL
               SELECT tmpGoods.GoodsId, tmpCount.CountPrice, tmpGoods.GoodsMainId
               FROM tmpGoods
                    LEFT JOIN tmpCount ON COALESCE (tmpCount.AreaId, 0) = 0
                                      AND tmpCount.GoodsMainId          = tmpGoods.GoodsMainId
               WHERE COALESCE (tmpCount.AreaId, 0) = 0
               ) AS tmp
         GROUP BY tmp.GoodsId; 
         
     -- записываем свойство кол-во прайсов товару сети
     PERFORM lpUpdate_Goods_CountPrice (_tmpDataCount.GoodsId, COALESCE (_tmpDataCount.CountPrice, 0), vbUserId)
     FROM _tmpDataCount
     ; 

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 10.06.11                                                      * 
 16.03.18         *
*/

-- тест
-- SELECT * FROM gpUpdate_Goods_CountPrice('3'::TVarChar)