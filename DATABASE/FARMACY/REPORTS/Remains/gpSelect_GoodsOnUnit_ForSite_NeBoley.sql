-- Function: gpSelect_GoodsOnUnit_ForSite_NeBoley

-- ???СТАРАЯ ВЕРСИЯ???

-- DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite_NeBoley (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite_NeBoley (
    IN inSession TVarChar -- сессия пользователя
)
RETURNS TABLE (GoodsId          Integer   -- идентификатор товара нашей сети
             , GoodsCode        Integer   -- код товара нашей сети
             , GoodsNameForSite TBlob     -- наименование товара для сайта
             , Price            TFloat    -- минимальная цена среди поставщиков и аптек
             , GoodsURL         TBlob     -- URL товара
              )
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitRec RECORD;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     FOR vbUnitRec IN 
       SELECT Object_Unit.Id AS UnitId
       FROM Object AS Object_Unit
            JOIN ObjectLink AS ObjectLink_Unit_Juridical
                            ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                           AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            JOIN ObjectLink AS ObjectLink_Juridical_Retail
                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                           AND ObjectLink_Juridical_Retail.ChildObjectId = 4 -- торговая сеть "Не болей" 
            JOIN ObjectBoolean AS ObjectBoolean_isLeaf
                               ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                              AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf() 
                              AND ObjectBoolean_isLeaf.ValueData = TRUE
       WHERE Object_Unit.DescId = zc_Object_Unit()
     LOOP
          RETURN QUERY
            WITH MarginCategory_site_One AS (SELECT ObjectBoolean.ObjectId AS MarginCategoryId_site
                                             FROM ObjectBoolean
                                             WHERE ObjectBoolean.ValueData = TRUE
                                               AND ObjectBoolean.DescId = zc_ObjectBoolean_MarginCategory_Site()
                                             LIMIT 1
                                            )
               , MarginCategory_Unit AS (SELECT tmp.UnitId
                                              , tmp.MarginCategoryId
                                         FROM (SELECT tmpList.UnitId
                                                    , ObjectLink_MarginCategory.ChildObjectId AS MarginCategoryId
                                                 -- , ROW_NUMBER() OVER (PARTITION BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId ORDER BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId) AS Ord
                                                    , ROW_NUMBER() OVER (PARTITION BY tmpList.UnitId ORDER BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId) AS Ord
                                               FROM (SELECT vbUnitRec.UnitId AS UnitId) AS tmpList
                                                    INNER JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                                                                          ON ObjectLink_MarginCategoryLink_Unit.ChildObjectId = tmpList.UnitId
                                                                         AND ObjectLink_MarginCategoryLink_Unit.DescId        = zc_ObjectLink_MarginCategoryLink_Unit()
                                                    LEFT JOIN ObjectLink AS ObjectLink_MarginCategory
                                                                         ON ObjectLink_MarginCategory.ObjectId = ObjectLink_MarginCategoryLink_Unit.ObjectId
                                                                        AND ObjectLink_MarginCategory.DescId   = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                                                    LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                                                          ON ObjectFloat_Percent.ObjectId = ObjectLink_MarginCategory.ChildObjectId
                                                                         AND ObjectFloat_Percent.DescId   = zc_ObjectFloat_MarginCategory_Percent()
                                               WHERE COALESCE (ObjectFloat_Percent.ValueData, 0) = 0 -- !!!вот так криво!!!
                                              ) AS tmp
                                         WHERE tmp.Ord = 1 -- !!!только одна категория!!!
                                        )
               , MarginCategory_all AS (SELECT DISTINCT 
                                               tmp.UnitId
                                             , tmp.MarginCategoryId
                                             , ObjectFloat_MarginPercent.ValueData AS MarginPercent
                                             , ObjectFloat_MinPrice.ValueData      AS MinPrice
                                             , ROW_NUMBER() OVER (PARTITION BY tmp.UnitId, tmp.MarginCategoryId ORDER BY tmp.UnitId, tmp.MarginCategoryId, ObjectFloat_MinPrice.ValueData) AS ORD
                                        FROM (SELECT MarginCategory_Unit.UnitId, MarginCategory_Unit.MarginCategoryId FROM MarginCategory_Unit
                                              UNION ALL
                                              SELECT 0 AS UnitId, MarginCategory_site_One.MarginCategoryId_site AS MarginCategoryId FROM MarginCategory_site_One
                                             ) AS tmp
                                             INNER JOIN ObjectLink AS ObjectLink_MarginCategoryItem_MarginCategory
                                                                   ON ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId = tmp.MarginCategoryId
                                                                  AND ObjectLink_MarginCategoryItem_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory()
                                             INNER JOIN Object ON Object.Id = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                                              AND Object.isErased = FALSE
                                             LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                                   ON ObjectFloat_MinPrice.ObjectId =ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                                                  AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()  
                                             LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                                                   ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                                                  AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()
                                       )
               , MarginCategory_site AS (SELECT DISTINCT 
                                                MarginCategory_all.MarginPercent
                                              , MarginCategory_all.MinPrice
                                              , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice 
                                         FROM MarginCategory_all
                                              JOIN MarginCategory_site_One ON MarginCategory_site_One.MarginCategoryId_site = MarginCategory_all.MarginCategoryId
                                              LEFT JOIN MarginCategory_all AS MarginCategory_all_next 
                                                                           ON MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                          AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                                        )
            SELECT MinPriceList.GoodsId
                 , MinPriceList.GoodsCode
                 , ObjectBlob_Goods_Site.ValueData AS GoodsNameForSite
                 , ROUND (MinPriceList.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2) :: TFloat AS Price
                 , ('http://neboley.dp.ua/products/instruction/' || COALESCE (ObjectFloat_Goods_Site.ValueData::Integer, MinPriceList.GoodsId))::TBlob AS GoodsURL
            FROM lpSelectMinPrice_List (vbUnitRec.UnitId, 4, vbUserId) AS MinPriceList
                 JOIN ObjectBlob AS ObjectBlob_Goods_Site
                                 ON ObjectBlob_Goods_Site.ObjectId = MinPriceList.GoodsId
                                AND ObjectBlob_Goods_Site.DescId = zc_ObjectBlob_Goods_Site()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                       ON ObjectFloat_Goods_Site.ObjectId = MinPriceList.GoodsId
                                      AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site() 
                 LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                      ON ObjectLink_Goods_NDSKind.ObjectId = MinPriceList.GoodsId
                                     AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                 LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                       ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                      AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
                 LEFT JOIN MarginCategory_site ON MinPriceList.Price >= MarginCategory_site.MinPrice AND MinPriceList.Price < MarginCategory_site.MaxPrice
            ;

     END LOOP;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 30.08.17                                                        *
*/

-- тест
-- SELECT DISTINCT * FROM gpSelect_GoodsOnUnit_ForSite_NeBoley (inSession:= zfCalc_UserSite());
