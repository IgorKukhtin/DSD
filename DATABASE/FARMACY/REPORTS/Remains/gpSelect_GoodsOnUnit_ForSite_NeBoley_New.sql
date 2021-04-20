-- Function: gpSelect_GoodsOnUnit_ForSite_NeBoley

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite_NeBoley (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite_NeBoley (
    IN inUnitId  Integer  ,
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (GoodsId          Integer   -- идентификатор товара нашей сети
             , GoodsCode        Integer   -- код товара нашей сети
             , GoodsNameForSite TBlob     -- наименование товара для сайта
             , Price            TFloat    -- минимальная цена среди поставщиков и аптек
             , GoodsURL         TBlob     -- URL товара
              )
AS $BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       WITH tmpUnit AS (SELECT Object_Unit.Id AS UnitId
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
                             JOIN ObjectString AS ObjectString_Unit_Address
                                               ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                              AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                        WHERE Object_Unit.DescId = zc_Object_Unit()
                          AND (COALESCE (inUnitId, 0) = 0 OR Object_Unit.Id = inUnitId)  
                          AND Object_Unit.IsErased = False
                          AND COALESCE(ObjectString_Unit_Address.ValueData, '') <> ''
                          AND Object_Unit.ValueData NOT ILIKE '%ЗАКРЫТА%'
                          AND Object_Unit.ValueData NOT ILIKE '!%'
                       )
          , tmpUnitPrice AS (SELECT tmpUnit.UnitId
                                  , ObjectLink_Price_Goods.ChildObjectId AS GoodsId
                                  , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                          AND ObjectFloat_Goods_Price.ValueData > 0
                                              THEN ObjectFloat_Goods_Price.ValueData
                                         ELSE ObjectFloat_Price_Value.ValueData
                                    END AS Price
                             FROM tmpUnit
                                  JOIN ObjectLink AS ObjectLink_Price_Unit
                                                  ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                 AND ObjectLink_Price_Unit.ChildObjectId = tmpUnit.UnitId
                                  JOIN ObjectLink AS ObjectLink_Price_Goods
                                                  ON ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                 AND ObjectLink_Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  JOIN ObjectLink AS ObjectLink_Goods_Object
                                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                 AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
                                  JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                   ON ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                                  AND ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  -- Фикс цена для всей Сети
                                  LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                         ON ObjectFloat_Goods_Price.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                                        AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()   
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                          ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                                         AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()  
                            )
          , tmpRemains AS (SELECT Container.ObjectId               AS GoodsId
                                , MIN (tmpUnitPrice.Price)::TFloat AS Price
                           FROM Container
                                JOIN tmpUnitPrice ON tmpUnitPrice.UnitId = Container.WhereObjectId
                                                 AND tmpUnitPrice.GoodsId = Container.ObjectId 
                           WHERE Container.DescId = zc_Container_Count()
                             AND Container.Amount <> 0
                           GROUP BY Container.ObjectId
                          )
          , tmpMovementPriceListLast AS (SELECT Movement_PriceList.Id AS MovementId
                                              , ROW_NUMBER() OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId ORDER BY Movement_PriceList.OperDate DESC) AS RowNum
                                         FROM Movement AS Movement_PriceList
                                              JOIN MovementLinkObject AS MovementLinkObject_Juridical 
                                                                      ON MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                                     AND MovementLinkObject_Juridical.MovementId = Movement_PriceList.Id 
                                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                                           ON MovementLinkObject_Area.MovementId = Movement_PriceList.Id
                                                                          AND MovementLinkObject_Area.DescId     = zc_MovementLinkObject_Area()
                                              JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical
                                                              ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()
                                                             AND ObjectLink_JuridicalSettings_Juridical.ChildObjectId = MovementLinkObject_Juridical.ObjectId
                                              JOIN ObjectLink AS ObjectLink_JuridicalSettings_Retail
                                                              ON ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                                                             AND ObjectLink_JuridicalSettings_Retail.ObjectId = ObjectLink_JuridicalSettings_Juridical.ObjectId
                                                             AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = 4 
                                              JOIN ObjectBoolean AS ObjectBoolean_JuridicalSettings_Site
                                                                 ON ObjectBoolean_JuridicalSettings_Site.DescId = zc_ObjectBoolean_JuridicalSettings_Site()
                                                                AND ObjectBoolean_JuridicalSettings_Site.ObjectId = ObjectLink_JuridicalSettings_Juridical.ObjectId
                                                                AND ObjectBoolean_JuridicalSettings_Site.ValueData = TRUE
                                         WHERE Movement_PriceList.DescId = zc_Movement_PriceList()
                                           AND COALESCE(MovementLinkObject_Area.ObjectId, zc_Area_Basis()) = zc_Area_Basis()
                                           AND Movement_PriceList.StatusId <> zc_Enum_Status_Erased()
                                        )
          , tmpMovementPriceList AS (SELECT MovementId FROM tmpMovementPriceListLast WHERE RowNum = 1)
          , tmpPriceList AS (SELECT ObjectLink_Goods_Object.ObjectId  AS GoodsId
                                  , MIN (MI_PriceList.Amount)::TFloat AS Price
                             FROM tmpMovementPriceList
                                  JOIN MovementItem AS MI_PriceList
                                                    ON MI_PriceList.DescId = zc_MI_Master()
                                                   AND MI_PriceList.MovementId = tmpMovementPriceList.MovementId  
                                  JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                              ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                             AND MILinkObject_Goods.MovementItemId = MI_PriceList.Id
                                  JOIN ObjectLink AS ObjectLink_LinkGoods_Goods_Jur
                                                  ON ObjectLink_LinkGoods_Goods_Jur.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                 AND ObjectLink_LinkGoods_Goods_Jur.ChildObjectId = MILinkObject_Goods.ObjectId
                                  JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain_Jur
                                                  ON ObjectLink_LinkGoods_GoodsMain_Jur.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                                 AND ObjectLink_LinkGoods_GoodsMain_Jur.ObjectId = ObjectLink_LinkGoods_Goods_Jur.ObjectId
                                  JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                  ON ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                                 AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = ObjectLink_LinkGoods_GoodsMain_Jur.ChildObjectId
                                  JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                  ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                                 AND ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                  JOIN ObjectLink AS ObjectLink_Goods_Object
                                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                 AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
                             GROUP BY ObjectLink_Goods_Object.ObjectId
                            )
          , tmpGoodsAll AS (SELECT tmpAll.GoodsId
                                 , MIN (tmpAll.Price)::TFloat AS Price
                            FROM (SELECT tmpRemains.GoodsId
                                       , tmpRemains.Price
                                  FROM tmpRemains
                                  UNION
                                  SELECT tmpPriceList.GoodsId
                                       , tmpPriceList.Price
                                  FROM tmpPriceList
                                 ) AS tmpAll
                            GROUP BY tmpAll.GoodsId
                           )
          , MarginCategory_site_One AS (SELECT ObjectBoolean.ObjectId AS MarginCategoryId_site
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
                                          FROM tmpUnit AS tmpList
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
       SELECT tmpGoodsAll.GoodsId
            , Object_Goods.ObjectCode AS GoodsCode
            , ObjectBlob_Goods_Site.ValueData AS GoodsNameForSite
            , ROUND (tmpGoodsAll.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2)::TFloat AS Price
            , ('http://neboley.dp.ua/products/instruction/' || COALESCE (ObjectFloat_Goods_Site.ValueData::Integer, tmpGoodsAll.GoodsId))::TBlob AS GoodsURL
       FROM tmpGoodsAll
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsAll.GoodsId
            JOIN ObjectBlob AS ObjectBlob_Goods_Site
                            ON ObjectBlob_Goods_Site.ObjectId = tmpGoodsAll.GoodsId
                           AND ObjectBlob_Goods_Site.DescId = zc_ObjectBlob_Goods_Site()
            LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                  ON ObjectFloat_Goods_Site.ObjectId = tmpGoodsAll.GoodsId
                                 AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site() 
            LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                 ON ObjectLink_Goods_NDSKind.ObjectId = tmpGoodsAll.GoodsId
                                AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
            LEFT JOIN MarginCategory_site ON tmpGoodsAll.Price >= MarginCategory_site.MinPrice AND tmpGoodsAll.Price < MarginCategory_site.MaxPrice
           LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites 
                                    ON ObjectBoolean_isNotUploadSites.ObjectId = tmpGoodsAll.GoodsId 
                                   AND ObjectBoolean_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()
       WHERE COALESCE(ObjectBoolean_isNotUploadSites.ValueData, false) = False;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.   Шаблий О.В.
 29.03.18                                                                       *
 28.09.17                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite_NeBoley (inUnitId:= 0, inSession:= zfCalc_UserSite());
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite_NeBoley (inUnitId:= 183292, inSession:= zfCalc_UserSite());
-- SELECT DISTINCT * FROM gpSelect_GoodsOnUnit_ForSite_NeBoley (0, zfCalc_UserSite())
