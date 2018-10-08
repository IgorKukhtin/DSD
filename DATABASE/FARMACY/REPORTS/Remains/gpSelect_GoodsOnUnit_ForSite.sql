-- Function: gpSelect_GoodsOnUnit_ForSite()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite (TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite (Text, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite(
    IN inUnitId_list      Text     ,  -- Список Подразделений, через зпт
    IN inGoodsId_list     Text     ,  -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                Integer
             , Article           Integer
             , Id_Site           Integer
             , Name_Site         TBlob
             , Name              TVarChar
             , foto              TVarChar
             , thumb             TVarChar
             , description       TBlob
             , appointment_id    Integer
             , category_id       Integer
             , Name_category     TVarChar
             , published         Integer
             , deleted           Integer
             , ObjectId          Integer   -- Торговая сеть (информативно)
             , ObjectName        TVarChar  -- Торговая сеть (информативно)
             , UnitId            Integer   -- Аптека (информативно)
             , UnitName          TVarChar  -- Аптека (информативно)
             , Remains           TFloat    -- Остаток (с учетом резерва)
             , RemainsAll        TFloat    -- Остаток (без учета резерва)
             , AmountDeferred    TFloat    -- резерв

             , AreaId            Integer    -- 
             , AreaName          TVarChar   -- 
             , JuridicalId       Integer    -- Поставщик (по которому найдена миним цена)
             , JuridicalName     TVarChar   -- Поставщик (по которому найдена миним цена)
             , ContractId        Integer    -- Договор (по которому найдена миним цена)
             , ContractName      TVarChar   -- Договор (по которому найдена миним цена)
             , Manufacturer      TVarChar
             , ExpirationDate    TDateTime -- срок годности (по которому найдена миним цена)
             , Price_unit        TFloat -- цена аптеки
             , Price_minNoNds    TFloat -- Original - цена миним без НДС (без наценок, информативная)
             , Price_minO        TFloat -- Original - цена миним с НДС (без наценок, информативная)
             , Price_min         TFloat -- цена миним поставщика с НДС с наценкой
             , Price_minD        TFloat -- Delivery - цена миним с НДС с наценкой - доставка

             , MarginPercent           TFloat  -- % наценка (информативная)
             , MarginPercent_site      TFloat  -- % наценка - доставка (информативная)
             , MarginCategoryName      TVarChar -- наценка название (информативная)
             , MarginCategoryName_site TVarChar -- наценка название - доставка (информативная)
             
             , NDS         TFloat
             , NDSKindName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   -- DECLARE inUnitId Integer;

   DECLARE vbIndex Integer;
   -- DECLARE vbMarginCategoryId Integer;
   DECLARE vbMarginCategoryId_site Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
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

    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpUnitMinPrice_List (UnitId, AreaId) 
           SELECT tmp.UnitId
                , COALESCE (OL_Unit_Area.ChildObjectId, zc_Area_Basis()) AS AreaId
           FROM (SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer AS UnitId
                ) AS tmp
                LEFT JOIN ObjectLink AS OL_Unit_Area
                                     ON OL_Unit_Area.ObjectId = tmp.UnitId
                                    AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
          ;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;

    -- !!!Временно!!!
    -- inUnitId:= (SELECT tmpList.UnitId FROM _tmpUnitMinPrice_List LIMIT 1);

    -- !!!Временно!!!
    -- INSERT INTO _tmpUnitMinPrice_List (UnitId) SELECT 0 WHERE NOT EXISTS (SELECT 1 FROM _tmpUnitMinPrice_List);

    -- парсим товары
    vbIndex := 1;
    WHILE SPLIT_PART (inGoodsId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
           WITH tmp AS (SELECT SPLIT_PART (inGoodsId_list, ',', vbIndex) :: Integer AS GoodsId)
              , tmpRes AS (SELECT tmp.GoodsId
                                , ObjectLink_Child_ALL.ChildObjectId AS GoodsId_retail
                                , Object_Retail.DescId
                           FROM tmp
                                INNER JOIN ObjectLink AS ObjectLink_Child
                                                      ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                     AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                         AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Main_ALL ON ObjectLink_Main_ALL.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                            AND ObjectLink_Main_ALL.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Child_ALL ON ObjectLink_Child_ALL.ObjectId = ObjectLink_Main_ALL.ObjectId
                                                                             AND ObjectLink_Child_ALL.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                      ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Goods_Object.ChildObjectId
                                                                -- AND Object_Retail.DescId = zc_Object_Retail()
                          )
              SELECT tmpRes.GoodsId, tmpRes.GoodsId_retail FROM tmpRes WHERE tmpRes.DescId = zc_Object_Retail()
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
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
           -- SELECT DISTINCT Container.ObjectId -- здесь товар "сети"
           -- !!!временно захардкодил, будет всегда товар НеБолей!!!!
           SELECT DISTINCT
                  ObjectLink_Child_NB.ChildObjectId AS ObjectID -- здесь товар "сети"
                , Container.ObjectId
           FROM _tmpUnitMinPrice_List
                INNER JOIN Container ON Container.WhereObjectId = _tmpUnitMinPrice_List.UnitId
                                    AND Container.DescId = zc_Container_Count()
                                    AND Container.Amount <> 0
                                    -- !!!временно захардкодил, будет всегда товар НеБолей!!!!
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = Container.ObjectId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                               AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                                                                AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
          ;
    END IF;


    -- !!!Оптимизация!!!
    ANALYZE _tmpGoodsMinPrice_List;

    -- еще оптимизируем - _tmpContainerCount
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCount'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpContainerCount (UnitId Integer, GoodsId Integer, GoodsId_retail Integer, Amount TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCount;
    END IF;
    --
    INSERT INTO _tmpContainerCount (UnitId, GoodsId, GoodsId_retail, Amount)
                WITH tmpContainer AS 
               (SELECT Container.WhereObjectId                AS UnitId
                     , _tmpGoodsMinPrice_List.GoodsId         AS GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail  AS GoodsId_retail
                     , SUM (Container.Amount)                 AS Amount
                FROM _tmpGoodsMinPrice_List
                     INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                         AND Container.DescId   = zc_Container_Count()
                                         AND Container.Amount   <> 0
                                         AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)


                GROUP BY Container.WhereObjectId
                       , _tmpGoodsMinPrice_List.GoodsId
                       , _tmpGoodsMinPrice_List.GoodsId_retail
                HAVING SUM (Container.Amount) > 0
               )
                -- результат
                SELECT tmpContainer.UnitId
                     , tmpContainer.GoodsId
                     , tmpContainer.GoodsId_retail
                     , tmpContainer.Amount
                FROM tmpContainer
                     -- INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = tmpContainer.UnitId
               ;

    -- !!!добавили, если нет остатка!!!
    -- INSERT INTO _tmpContainerCount (UnitId, GoodsId, GoodsId_retail, Amount)
    --    SELECT 0, tmp.GoodsId, tmp.GoodsId, 0 
    --    FROM _tmpGoodsMinPrice_List AS tmp 
    --         LEFT JOIN _tmpContainerCount ON _tmpContainerCount.GoodsId = tmp.GoodsId WHERE _tmpContainerCount.GoodsId IS NULL;

    -- !!!Оптимизация!!!
    ANALYZE _tmpContainerCount;

    -- еще оптимизируем - _tmpList
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpList'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpList (UnitId Integer, AreaId Integer, GoodsId Integer, GoodsId_retail Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpList;
    END IF;
    --
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail)
                -- SELECT DISTINCT _tmpContainerCount.UnitId, _tmpContainerCount.GoodsId, _tmpContainerCount.GoodsId_retail FROM _tmpContainerCount;
                /*WITH tmp AS (SELECT DISTINCT 
                                    _tmpUnitMinPrice_List.UnitId
                                  , _tmpUnitMinPrice_List.AreaId
                                  , _tmpGoodsMinPrice_List.GoodsId
                             FROM _tmpGoodsMinPrice_List
                                  CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                            )*/
                SELECT DISTINCT 
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , ObjectLink_Child_R.ChildObjectId AS GoodsId_retail
                FROM _tmpGoodsMinPrice_List
                     CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                          ON ObjectLink_Unit_Juridical.ObjectId = _tmpUnitMinPrice_List.UnitId
                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                     INNER JOIN ObjectLink AS ObjectLink_Child
                                           ON ObjectLink_Child.ChildObjectId = _tmpGoodsMinPrice_List.GoodsId
                                          AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                     INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                              AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                     INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                               AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                     INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                           ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_R.ChildObjectId
                                          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                          AND ObjectLink_Goods_Object.ChildObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                ;
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail)
                SELECT DISTINCT 
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId AS GoodsId_retail
                FROM _tmpGoodsMinPrice_List
                     CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                     LEFT JOIN _tmpList ON _tmpList.UnitId = _tmpUnitMinPrice_List.UnitId
                                       AND _tmpList.GoodsId = _tmpGoodsMinPrice_List.GoodsId
                WHERE _tmpList.GoodsId IS NULL;

    -- еще оптимизируем - _tmpMinPrice_List
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMinPrice_List'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpMinPrice_List (GoodsId            Integer,
                                            GoodsCode          Integer,
                                            GoodsName          TVarChar,
                                            PartionGoodsDate   TDateTime,
                                            Partner_GoodsId    Integer,
                                            Partner_GoodsCode  TVarChar,
                                            Partner_GoodsName  TVarChar,
                                            MakerName          TVarChar,
                                            ContractId         Integer,
                                            AreaId             Integer,
                                            JuridicalId        Integer,
                                            JuridicalName      TVarChar,
                                            Price              TFloat, 
                                            SuperFinalPrice    TFloat,
                                            isTop              Boolean,
                                            isOneJuridical     Boolean
                                           ) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpMinPrice_List;
    END IF;
    --
             INSERT INTO _tmpMinPrice_List (GoodsId            ,
                                            GoodsCode ,
                                            GoodsName          ,
                                            PartionGoodsDate   ,
                                            Partner_GoodsId    ,
                                            Partner_GoodsCode  ,
                                            Partner_GoodsName  ,
                                            MakerName          ,
                                            ContractId         ,
                                            AreaId             ,
                                            JuridicalId        ,
                                            JuridicalName      ,
                                            Price              ,
                                            SuperFinalPrice    ,
                                            isTop              ,
                                            isOneJuridical)
                                     SELECT tmp.GoodsId            ,
                                            tmp.GoodsCode ,
                                            tmp.GoodsName          ,
                                            tmp.PartionGoodsDate   ,
                                            tmp.Partner_GoodsId    ,
                                            tmp.Partner_GoodsCode  ,
                                            tmp.Partner_GoodsName  ,
                                            tmp.MakerName          ,
                                            tmp.ContractId         ,
                                            tmp.AreaId             ,
                                            tmp.JuridicalId        ,
                                            tmp.JuridicalName      ,
                                            tmp.Price              ,
                                            tmp.SuperFinalPrice    ,
                                            tmp.isTop              ,
                                            tmp.isOneJuridical
                FROM lpSelectMinPrice_List (inUnitId  := 0          -- !!!т.к. не зависит от UnitId, хотя ...!!!
                                          , inObjectId:= vbObjectId
                                          , inUserId  := vbUserId
                                           ) AS tmp
               ;


    -- поиск категории для сайта
    vbMarginCategoryId_site:= (SELECT ObjectBoolean.ObjectId
                               FROM ObjectBoolean
                               WHERE ObjectBoolean.ValueData = TRUE
                                 AND ObjectBoolean.DescId = zc_ObjectBoolean_MarginCategory_Site()
                               LIMIT 1
                              );


    -- !!!Оптимизация!!!
    ANALYZE _tmpList;
    -- !!!Оптимизация!!!
    ANALYZE _tmpMinPrice_List;


    -- Результат
    RETURN QUERY
       WITH tmpMI_Deferred AS
               (SELECT tmpList.UnitId
                     , MovementItem.ObjectId     AS GoodsId
                     , SUM (MovementItem.Amount) AS Amount
                FROM _tmpUnitMinPrice_List AS tmpList
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.ObjectId = tmpList.UnitId
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                     INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                ON MovementBoolean_Deferred.MovementId = MovementLinkObject_Unit.MovementId
                                               AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                               AND MovementBoolean_Deferred.ValueData = TRUE
                     INNER JOIN Movement ON Movement.Id       = MovementLinkObject_Unit.MovementId
                                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                        AND Movement.DescId   = zc_Movement_Check()
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased   = FALSE
                     -- INNER JOIN _tmpGoodsMinPrice_List ON _tmpGoodsMinPrice_List.GoodsId = MovementItem.ObjectId
                GROUP BY tmpList.UnitId
                       , MovementItem.ObjectId
               )
          , MarginCategory_Unit AS
               (SELECT tmp.UnitId
                     , tmp.MarginCategoryId
                FROM (SELECT tmpList.UnitId
                           , ObjectLink_MarginCategory.ChildObjectId AS MarginCategoryId
                           , ROW_NUMBER() OVER (PARTITION BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId ORDER BY tmpList.UnitId, ObjectLink_MarginCategory.ChildObjectId) AS Ord
                      FROM _tmpUnitMinPrice_List AS tmpList
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
          , Price_Unit_all AS
               (SELECT _tmpList.UnitId
                     , _tmpList.GoodsId
                     , ObjectFloat_Price_Value.ValueData AS Price
                -- FROM _tmpGoodsMinPrice_List
                FROM _tmpList
                     INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                           ON ObjectLink_Price_Goods.ChildObjectId = _tmpList.GoodsId_retail -- _tmpGoodsMinPrice_List.GoodsId
                                          AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                           ON ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                          AND ObjectLink_Price_Unit.ChildObjectId = _tmpList.UnitId
                     -- INNER JOIN _tmpUnitMinPrice_List AS tmpList ON tmpList.UnitId = ObjectLink_Price_Unit.ChildObjectId
                     LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                           ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
               )
          , Price_Unit AS
               (SELECT Price_Unit_all.UnitId
                     , Price_Unit_all.GoodsId
                     , ROUND (Price_Unit_all.Price, 2) :: TFloat AS Price
                FROM Price_Unit_all
                     -- INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = Price_Unit_all.UnitId
               )
          , MarginCategory_all AS
               (SELECT DISTINCT 
                       tmp.UnitId
                     , tmp.MarginCategoryId
                     , ObjectFloat_MarginPercent.ValueData AS MarginPercent
                     , ObjectFloat_MinPrice.ValueData      AS MinPrice
                     , ROW_NUMBER() OVER (PARTITION BY tmp.UnitId, tmp.MarginCategoryId ORDER BY tmp.UnitId, tmp.MarginCategoryId, ObjectFloat_MinPrice.ValueData) AS ORD
                FROM (SELECT MarginCategory_Unit.UnitId, MarginCategory_Unit.MarginCategoryId FROM MarginCategory_Unit
                     UNION ALL
                      SELECT 0 AS UnitId, vbMarginCategoryId_site AS MarginCategoryId
                     ) AS tmp
                     -- INNER JOIN Object_MarginCategoryItem_View ON Object_MarginCategoryItem_View.MarginCategoryId = tmp.MarginCategoryId
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
          , MarginCategory AS
               (SELECT DISTINCT 
                       MarginCategory_all.UnitId
                     , MarginCategory_all.MarginCategoryId
                     , MarginCategory_all.MarginPercent
                     , MarginCategory_all.MinPrice
                     , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice 
                FROM MarginCategory_all
                     LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.UnitId           = MarginCategory_all.UnitId
                                                                            AND MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                            AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                WHERE MarginCategory_all.MarginCategoryId <> vbMarginCategoryId_site
               )
          , MarginCategory_site AS
               (SELECT DISTINCT 
                       MarginCategory_all.MarginPercent
                     , MarginCategory_all.MinPrice
                     , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice 
                FROM MarginCategory_all
                     LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                            AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                WHERE MarginCategory_all.MarginCategoryId = vbMarginCategoryId_site
               )

        SELECT Object_Goods.Id                             AS Id
             , Object_Goods.ObjectCode                     AS Article
             , ObjectFloat_Goods_Site.ValueData :: Integer AS Id_Site
             , ObjectBlob_Site.ValueData                   AS Name_Site
             , Object_Goods.ValueData                      AS Name
             , ObjectString_Foto.ValueData                             AS foto
             , ObjectString_Thumb.ValueData                            AS thumb
             , ObjectBlob_Description.ValueData                        AS description
             , ObjectLink_Goods_Appointment.ChildObjectId              AS appointment_id
             , ObjectLink_Goods_GoodsGroup.ChildObjectId               AS category_id
             , Object_GoodsGroup.ValueData                             AS Name_category

             , CASE WHEN ObjectBoolean_Goods_Published.ValueData = TRUE THEN 1 ELSE 0 END :: Integer AS published
             , CASE WHEN Object_Goods.isErased = TRUE THEN 1 ELSE 0 END                   :: Integer AS deleted

             , ObjectLink_Goods_Object.ChildObjectId                   AS ObjectId
             , Object.ValueData                                        AS ObjectName
             , Object_Unit.Id                                          AS UnitId
             , Object_Unit.ValueData                                   AS UnitName

             , (tmpList2.Amount /*ContainerCount.Amount*/ - COALESCE (tmpMI_Deferred.Amount, 0)) :: TFloat AS Remains
             , tmpList2.Amount /*ContainerCount.Amount*/                                         :: TFloat AS RemainsAll
             , tmpMI_Deferred.Amount                                                            :: TFloat AS AmountDeferred

             , MinPrice_List.AreaId
             , Object_Area.ValueData AS AreaName
             , MinPrice_List.JuridicalId
             , MinPrice_List.JuridicalName
             , MinPrice_List.ContractId
             , Object_Contract.ValueData       AS ContractName
             , MinPrice_List.MakerName         AS Manufacturer
             , MinPrice_List.PartionGoodsDate  AS ExpirationDate

             , Price_Unit.Price    AS Price_unit
             , MinPrice_List.Price AS Price_minNoNds
             , ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2) :: TFloat  AS Price_minO
             , ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory.MarginPercent, 0)      / 100), 2) :: TFloat  AS Price_min
             , ROUND (MinPrice_List_D.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2) :: TFloat  AS Price_minD

             , MarginCategory.MarginPercent         AS MarginPercent
             , MarginCategory_site.MarginPercent    AS MarginPercent_site
             , Object_MarginCategory.ValueData      AS MarginCategoryName
             , Object_MarginCategory_site.ValueData AS MarginCategoryName_site

             , ObjectFloat_NDSKind_NDS.ValueData    AS NDS
             , Object_NDSKind.ValueData             AS NDSKindName
             
        FROM _tmpList AS tmpList -- _tmpContainerCount AS tmpList -- _tmpList AS tmpList -- _tmpGoodsMinPrice_List
             -- LEFT JOIN _tmpUnitMinPrice_List ON 1=1

             LEFT JOIN tmpMI_Deferred ON tmpMI_Deferred.GoodsId = tmpList.GoodsId_retail
                                     AND tmpMI_Deferred.UnitId  = tmpList.UnitId

             LEFT JOIN Price_Unit     ON Price_Unit.GoodsId     = tmpList.GoodsId
                                     AND Price_Unit.UnitId      = tmpList.UnitId
             LEFT JOIN _tmpContainerCount AS tmpList2
                                          ON tmpList2.GoodsId = tmpList.GoodsId
                                         AND tmpList2.UnitId  = tmpList.UnitId
             LEFT JOIN _tmpMinPrice_List AS MinPrice_List  ON MinPrice_List.GoodsId  = tmpList.GoodsId
                                                          AND MinPrice_List.AreaId   = tmpList.AreaId
             LEFT JOIN _tmpMinPrice_List AS MinPrice_List_D  ON MinPrice_List_D.GoodsId  = tmpList.GoodsId
                                                            AND MinPrice_List_D.AreaId   = zc_Area_Basis()

             LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpList.UnitId AND Object_Unit.DescId = zc_Object_Unit()
             LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmpList.GoodsId
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MinPrice_List.ContractId
             LEFT JOIN Object AS Object_Area     ON Object_Area.Id     = MinPrice_List.AreaId

                            
             LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                  ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   

             /*LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                    ON ObjectString_Goods_Maker.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()*/
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                  ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
             LEFT JOIN Object ON Object.Id = ObjectLink_Goods_Object.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                   ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                     ON ObjectBoolean_Goods_Published.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()
             LEFT JOIN ObjectString AS ObjectString_Foto
                                     ON ObjectString_Foto.ObjectId = Object_Goods.Id 
                                    AND ObjectString_Foto.DescId = zc_ObjectString_Goods_Foto()
             LEFT JOIN ObjectString AS ObjectString_Thumb
                                     ON ObjectString_Thumb.ObjectId = Object_Goods.Id
                                    AND ObjectString_Thumb.DescId = zc_ObjectString_Goods_Thumb()
             LEFT JOIN ObjectBlob AS ObjectBlob_Site
                                   ON ObjectBlob_Site.ObjectId = Object_Goods.Id
                                  AND ObjectBlob_Site.DescId = zc_objectBlob_Goods_Site()
             LEFT JOIN ObjectBlob AS ObjectBlob_Description
                                   ON ObjectBlob_Description.ObjectId = Object_Goods.Id
                                  AND ObjectBlob_Description.DescId = zc_objectBlob_Goods_Description()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Appointment
                                  ON ObjectLink_Goods_Appointment.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment()

             LEFT JOIN MarginCategory      ON MinPrice_List.Price >= MarginCategory.MinPrice      AND MinPrice_List.Price < MarginCategory.MaxPrice
                                          AND MarginCategory.UnitId = tmpList.UnitId
             LEFT JOIN MarginCategory_site ON MinPrice_List.Price >= MarginCategory_site.MinPrice AND MinPrice_List.Price < MarginCategory_site.MaxPrice
             LEFT JOIN Object AS Object_MarginCategory      ON Object_MarginCategory.Id      = MarginCategory.MarginCategoryId
             LEFT JOIN Object AS Object_MarginCategory_site ON Object_MarginCategory_site.Id = vbMarginCategoryId_site
        ORDER BY Price_Unit.Price
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.04.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId_list:= '1781716', inGoodsId_list:= '47761', inSession:= zfCalc_UserSite()) ORDER BY 1;
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId_list:= '377613,183292', inGoodsId_list:= '331,951,16876,40618', inSession:= zfCalc_UserSite()) ORDER BY 1;
-- SELECT p.id, p.id_site, p.name, p.name_site, p.article, p.article, p.unitid, p.juridicalid, p.juridicalname, p.contractid, p.contractname, p.expirationdate, p.manufacturer, p.remains, p.price_unit, p.price_mino, p.price_mino, p.price_min, p.price_mind FROM gpSelect_GoodsOnUnit_ForSite('183292,183288,377605,375627,394426,472116,494882,1529734,1781716,377606,377595,183290,183289,183294,377613,377574,377594,377610,183293,375626,183291', '508,517,520,526,523,511,544,538,553,559,562,565,571,547,1642,1654,1714,1867,1933,2059,2095,2230,2257,2275,2323,2341,2344,2320,2509,2515', zfCalc_UserSite()) AS p ORDER BY p.price_unit
