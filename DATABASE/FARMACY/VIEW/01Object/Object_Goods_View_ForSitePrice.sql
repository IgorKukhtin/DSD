-- View: Object_Goods_View_ForSitePrice

DROP VIEW IF EXISTS Object_Goods_View_ForSitePrice;

CREATE OR REPLACE VIEW Object_Goods_View_ForSitePrice AS
    SELECT
         ObjectLink_Goods_Object.ObjectId                        as id
       , Object_Goods.ObjectCode                                 as article
       , ObjectFloat_Goods_Site.ValueData :: Integer             as Id_Site
       , ObjectBlob_Site.ValueData                               as Name_Site
       , Object_Goods.ValueData                                  as name
       , ROUND (LoadPriceListItem.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2) :: TFloat  AS PriceBADM
       , CASE WHEN Object_Goods.isErased=TRUE THEN 1::Integer ELSE 0::Integer END                                   AS deleted
       , ObjectLink_Goods_Object.ChildObjectId                   AS ObjectId
       , ObjectFloat_NDSKind_NDS.ValueData                       AS NDS
       , MarginCategory_site.MarginPercent                       AS MarginPercent

    -- FROM Object_Goods_View AS Object_Goods
    FROM ObjectLink AS ObjectLink_Goods_Object
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId

        LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                    ON ObjectFloat_Goods_Site.ObjectId = ObjectLink_Goods_Object.ObjectId
                                   AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()

        LEFT OUTER JOIN ObjectBlob AS ObjectBlob_Site
                                   ON ObjectBlob_Site.ObjectId = ObjectLink_Goods_Object.ObjectId
                                  AND ObjectBlob_Site.DescId = zc_objectBlob_Goods_Site()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = ObjectLink_Goods_Object.ObjectId
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                             
        LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = ObjectLink_Goods_Object.ObjectId
                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
        LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
        -- [15:32] Александр: конкретно для данного случая делать расчет минимальной цены не нужно , нужно отдавать цену для доставки по Украине от поставщика БАДМ отсрочка
        LEFT JOIN LoadPriceListItem ON LoadPriceListItem.GoodsId         = ObjectLink_Main.ChildObjectId
                                   AND LoadPriceListItem.LoadPriceListId = -- БаДМ + Бадм отсрочка + Днепр
                                                                           (SELECT LoadPriceList.Id FROM LoadPriceList WHERE LoadPriceList.JuridicalId = 59610 AND LoadPriceList.ContractId = 183257 AND COALESCE (LoadPriceList.AreaId, 0) IN (0, zc_Area_Basis()))
        LEFT JOIN (WITH MarginCategory_all AS (SELECT DISTINCT
                                                      ObjectFloat_MarginPercent.ValueData AS MarginPercent
                                                    , ObjectFloat_MinPrice.ValueData      AS MinPrice
                                                    , ROW_NUMBER() OVER (PARTITION BY ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId ORDER BY ObjectFloat_MinPrice.ValueData) AS ORD
                                               FROM ObjectLink AS ObjectLink_MarginCategoryItem_MarginCategory
                                                    LEFT JOIN ObjectFloat AS ObjectFloat_MinPrice
                                                                          ON ObjectFloat_MinPrice.ObjectId =ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                                                         AND ObjectFloat_MinPrice.DescId = zc_ObjectFloat_MarginCategoryItem_MinPrice()
                                                    LEFT JOIN ObjectFloat AS ObjectFloat_MarginPercent
                                                                          ON ObjectFloat_MarginPercent.ObjectId = ObjectLink_MarginCategoryItem_MarginCategory.ObjectId
                                                                         AND ObjectFloat_MarginPercent.DescId = zc_ObjectFloat_MarginCategoryItem_MarginPercent()
                                               WHERE  ObjectLink_MarginCategoryItem_MarginCategory.ChildObjectId = (SELECT ObjectBoolean.ObjectId
                                                                                                                             FROM ObjectBoolean
                                                                                                                             WHERE ObjectBoolean.ValueData = TRUE
                                                                                                                               AND ObjectBoolean.DescId = zc_ObjectBoolean_MarginCategory_Site()
                                                                                                                             LIMIT 1
                                                                                                                            )
                                                                         AND ObjectLink_MarginCategoryItem_MarginCategory.DescId = zc_ObjectLink_MarginCategoryItem_MarginCategory()
                                              )
                   --
                   SELECT DISTINCT
                          MarginCategory_all.MarginPercent
                        , MarginCategory_all.MinPrice
                        , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice
                   FROM MarginCategory_all
                        LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                  ) AS MarginCategory_site ON LoadPriceListItem.Price >= MarginCategory_site.MinPrice
                                          AND LoadPriceListItem.Price < MarginCategory_site.MaxPrice


    WHERE ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!ВРЕМЕННО!!!
      -- AND (ObjectBoolean_Goods_Published.ValueData = TRUE OR ObjectBoolean_Goods_Published.ValueData IS NULL)
    --ORDER BY ObjectBlob_Site.ValueData
   ;

ALTER TABLE Object_Goods_View_ForSitePrice  OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 24.05.17                                        *
*/

-- Select * from Object_Goods_View_ForSitePrice as Object_Goods Where Object_Goods.ObjectId = lpGet_DefaultValue('zc_Object_Retail', 3)::Integer LIMIT 100
