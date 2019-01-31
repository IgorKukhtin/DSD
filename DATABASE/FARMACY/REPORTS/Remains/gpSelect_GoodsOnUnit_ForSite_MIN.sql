-- Function: gpSelect_GoodsOnUnit_ForSite_MIN()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite_MIN (Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite_MIN(
    IN inGoodsId_list     Text     ,  -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                Integer
             , Article           Integer
             , Id_Site           Integer
             , Name_Site         TBlob
             , Name              TVarChar

             , Price_unit        TFloat -- цена аптеки
             , Remains           TFloat -- Остаток

             , UnitId            Integer   -- Аптека (информативно)
             , UnitName          TVarChar  -- Аптека (информативно)
             , AreaId            Integer    -- 
             , AreaName          TVarChar   -- 

             -- , NDS         TFloat
             -- , NDSKindName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbIndex Integer;
   DECLARE vbSiteDiscount TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);


    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpGoodsMinPrice_List;
    END IF;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpunitminprice_list')
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer, AreaId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpUnitMinPrice_List;
    END IF;

    -- подразделения - сеть Не болей
    INSERT INTO _tmpUnitMinPrice_List (UnitId, AreaId) 
      SELECT tmp.UnitId
           , COALESCE (OL_Unit_Area.ChildObjectId, zc_Area_Basis()) AS AreaId
      FROM (SELECT Object_Unit.Id AS UnitId
            FROM Object AS Object_Unit
                 INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                       ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                      AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                 INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                      ON ObjectLink_Juridical_Retail.ObjectId      = ObjectLink_Unit_Juridical.ChildObjectId
                                     AND ObjectLink_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                                     AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId -- !!!сеть Не болей!!!
            WHERE Object_Unit.DescId   = zc_Object_Unit()
              AND Object_Unit.isErased = FALSE
           ) AS tmp
           LEFT JOIN ObjectLink AS OL_Unit_Area
                                ON OL_Unit_Area.ObjectId = tmp.UnitId
                               AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
          ;

    -- парсим товары
    vbIndex := 1;
    WHILE SPLIT_PART (inGoodsId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpGoodsMinPrice_List (GoodsId)
           SELECT tmp.GoodsId
           FROM (SELECT SPLIT_PART (inGoodsId_list, ',', vbIndex) :: Integer AS GoodsId
                ) AS tmp
          ;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;
    

    -- !!!Оптимизация!!!
    ANALYZE _tmpUnitMinPrice_List;

    -- если нет товаров
    IF NOT EXISTS (SELECT 1 FROM _tmpGoodsMinPrice_List WHERE GoodsId <> 0)
    THEN
         -- все остатки
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId)
           -- SELECT DISTINCT Container.ObjectId -- здесь товар "сети"
           -- !!!временно захардкодил, будет всегда товар НеБолей!!!!
           SELECT DISTINCT
                  Container.ObjectId
           FROM _tmpUnitMinPrice_List
                INNER JOIN Container ON Container.WhereObjectId = _tmpUnitMinPrice_List.UnitId
                                    AND Container.DescId = zc_Container_Count()
                                    AND Container.Amount <> 0
          ;
    END IF;


    -- !!!Оптимизация!!!
    ANALYZE _tmpGoodsMinPrice_List;

    -- еще - _tmpContainerCount
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCount'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpContainerCount (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCount;
    END IF;
    --
    INSERT INTO _tmpContainerCount (UnitId, GoodsId, Amount)
                WITH tmpContainer AS 
               (SELECT Container.WhereObjectId                AS UnitId
                     , _tmpGoodsMinPrice_List.GoodsId         AS GoodsId
                     , SUM (Container.Amount)                 AS Amount
                FROM _tmpGoodsMinPrice_List
                     INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId
                                         AND Container.DescId   = zc_Container_Count()
                                         AND Container.Amount   <> 0
                                         AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)

                GROUP BY Container.WhereObjectId
                       , _tmpGoodsMinPrice_List.GoodsId
                HAVING SUM (Container.Amount) > 0
               )
                -- результат
                SELECT tmpContainer.UnitId
                     , tmpContainer.GoodsId
                     , tmpContainer.Amount
                FROM tmpContainer
                     -- INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = tmpContainer.UnitId
               ;


    -- !!!Оптимизация!!!
    ANALYZE _tmpContainerCount;



    -- Результат
    RETURN QUERY
       WITH Price_Unit_all AS
               (SELECT _tmpList.UnitId
                     , _tmpList.GoodsId
                     , _tmpList.Amount
                     , ObjectFloat_Price_Value.ValueData AS Price
                       --  № п/п
                     , ROW_NUMBER() OVER (PARTITION BY _tmpList.GoodsId ORDER BY ObjectFloat_Price_Value.ValueData ASC) AS Ord
                -- FROM _tmpGoodsMinPrice_List
                FROM _tmpContainerCount AS _tmpList
                     INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                           ON ObjectLink_Price_Goods.ChildObjectId = _tmpList.GoodsId
                                          AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                           ON ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                          AND ObjectLink_Price_Unit.ChildObjectId = _tmpList.UnitId
                     LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                           ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectFloat_Price_Value.DescId   = zc_ObjectFloat_Price_Value()
               )
          , Price_Unit AS
               (SELECT Price_Unit_all.UnitId
                     , Price_Unit_all.GoodsId
                     , Price_Unit_all.Amount
                     , ROUND (CASE WHEN vbSiteDiscount = 0 THEN Price_Unit_all.Price 
                       ELSE CEIL(Price_Unit_all.Price * (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2) :: TFloat AS Price
                FROM Price_Unit_all
                     -- INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = Price_Unit_all.UnitId
                WHERE Price_Unit_all.Ord = 1 -- !!!выбрали МИНИМАЛЬНУЮ цену!!!
               )

        SELECT Object_Goods.Id                             AS Id
             , Object_Goods.ObjectCode                     AS Article
             , ObjectFloat_Goods_Site.ValueData :: Integer AS Id_Site
             , ObjectBlob_Site.ValueData                   AS Name_Site
             , Object_Goods.ValueData                      AS Name

             , Price_Unit.Price                     AS Price_unit
             , Price_Unit.Amount          :: TFloat AS Remains

             , Object_Unit.Id                       AS UnitId
             , Object_Unit.ValueData                AS UnitName
             , _tmpUnitMinPrice_List.AreaId         AS AreaId
             , Object_Area.ValueData                AS AreaName
                                                    

             -- , ObjectFloat_NDSKind_NDS.ValueData    AS NDS
             -- , Object_NDSKind.ValueData             AS NDSKindName
             
        FROM _tmpGoodsMinPrice_List AS tmpList
             LEFT JOIN Price_Unit     ON Price_Unit.GoodsId     = tmpList.GoodsId

             LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmpList.GoodsId
             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = Price_Unit.UnitId
                            
             LEFT JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = Price_Unit.UnitId
             LEFT JOIN Object AS Object_Area ON Object_Area.Id               = _tmpUnitMinPrice_List.AreaId

             /*LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                  ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()*/

             LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                   ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()
             LEFT JOIN ObjectBlob AS ObjectBlob_Site
                                  ON ObjectBlob_Site.ObjectId = Object_Goods.Id
                                 AND ObjectBlob_Site.DescId   = zc_objectBlob_Goods_Site()
             /*LEFT JOIN ObjectBlob AS ObjectBlob_Description
                                  ON ObjectBlob_Description.ObjectId = Object_Goods.Id
                                 AND ObjectBlob_Description.DescId   = zc_objectBlob_Goods_Description()*/
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 30.01.19                                                                    *
 04.01.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite_MIN (inGoodsId_list:= '47761', inSession:= zfCalc_UserSite()) ORDER BY 1;
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite_MIN (inGoodsId_list:= '331,951,16876,40618', inSession:= zfCalc_UserSite()) ORDER BY 1;
-- SELECT p.* FROM gpSelect_GoodsOnUnit_ForSite_MIN('508,517,520,526,523,511,544,538,553,559,562,565,571,547,1642,1654,1714,1867,1933,2059,2095,2230,2257,2275,2323,2341,2344,2320,2509,2515', zfCalc_UserSite()) AS p ORDER BY p.price_unit
