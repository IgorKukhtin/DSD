-- Function: gpSelect_GoodsOnUnit_ForSite()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite (Text, Text, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite(
    IN inUnitId_list      Text     ,  -- Список Подразделений, через зпт
    IN inGoodsId_list     Text     ,  -- Список товаров, через зпт
    IN inFrontSite        Boolean  ,  -- Выводить фронт сайта
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                Integer

             , deleted           Integer

             , UnitId            Integer   -- Аптека (информативно)
             , Remains           TFloat    -- Остаток (с учетом резерва)

             , Price_unit        TFloat -- цена аптеки
             , Price_unit_sale   TFloat -- цена аптеки со скидкой
             , Price_min         TFloat -- цена миним поставщика с НДС с наценкой
             , Price_min_sale    TFloat -- цена миним поставщика с НДС с наценкой со скидкой
             , Price_minD        TFloat -- Delivery - цена миним с НДС с наценкой - доставка

             , JuridicalId       Integer    -- Поставщик (по которому найдена миним цена)
             , JuridicalName     TVarChar   -- Поставщик (по которому найдена миним цена)
             , ContractId        Integer    -- Договор (по которому найдена миним цена)
             , ContractName      TVarChar   -- Договор (по которому найдена миним цена)
             , ExpirationDate    TDateTime -- срок годности (по которому найдена миним цена)

              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   -- DECLARE inUnitId Integer;

   DECLARE vbIndex Integer;
   -- DECLARE vbMarginCategoryId Integer;
   DECLARE vbMarginCategoryId_site Integer;

   DECLARE vbOperDate_Begin1 TDateTime;
   DECLARE vbOperDate_Begin2 TDateTime;
   DECLARE vbOperDate_Begin3 TDateTime;
   DECLARE vbOperDate_Begin4 TDateTime;
   DECLARE vbSiteDiscount TFloat;
   DECLARE vbQueryText Text;
   
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);


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
    IF COALESCE(inGoodsId_list, '') <> ''
    THEN
      vbQueryText := 'INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail)
           WITH tmpRes AS (SELECT ObjectLink_Child.ChildObjectId      AS GoodsId
                                , ObjectLink_Child_ALL.ChildObjectId AS GoodsId_retail
                                , Object_Retail.DescId
                           FROM ObjectLink AS ObjectLink_Child
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
                           WHERE ObjectLink_Child.ChildObjectId IN ('||inGoodsId_list||')
                             AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                          )
              SELECT tmpRes.GoodsId, tmpRes.GoodsId_retail FROM tmpRes WHERE tmpRes.DescId = zc_Object_Retail()';
      
      EXECUTE vbQueryText;
    END IF;
    
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

                SELECT DISTINCT 
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail
                FROM _tmpGoodsMinPrice_List
                     CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                          ON ObjectLink_Unit_Juridical.ObjectId = _tmpUnitMinPrice_List.UnitId
                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                     INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                           ON ObjectLink_Goods_Object.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
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

    -- запомнили время перед lpSelectMinPrice_List
    vbOperDate_Begin2:= CLOCK_TIMESTAMP();

    --
    INSERT INTO _tmpMinPrice_List (GoodsId            ,
                                   GoodsCode          ,
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

          WITH
            GoodsList_all AS
             (SELECT Distinct _tmpGoodsMinPrice_List.GoodsId  AS GoodsId
              FROM _tmpGoodsMinPrice_List
             )

          SELECT
              MinPriceList.GoodsId,
              MinPriceList.GoodsCode,
              MinPriceList.GoodsName,
              MinPriceList.PartionGoodsDate,
              MinPriceList.Partner_GoodsId,
              MinPriceList.Partner_GoodsCode,
              MinPriceList.Partner_GoodsName,
              MinPriceList.MakerName,
              MinPriceList.ContractId,
              MinPriceList.AreaId,
              MinPriceList.JuridicalId,
              MinPriceList.JuridicalName,
              MinPriceList.Price,
              MinPriceList.SuperFinalPrice,
              MinPriceList.isTop,
              MinPriceList.isOneJuridical
          FROM GoodsList_all
               INNER JOIN MinPrice_ForSite AS MinPriceList
                                           ON GoodsList_all.GoodsId = MinPriceList.GoodsId;
                                           
    -- запомнили время после lpSelectMinPrice_List
    vbOperDate_Begin3:= CLOCK_TIMESTAMP();


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
               (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                     , MovementItem.ObjectId     AS GoodsId
                     , SUM (MovementItem.Amount) AS Amount
                FROM MovementBoolean AS MovementBoolean_Deferred
                     INNER JOIN Movement ON Movement.Id       = MovementBoolean_Deferred.MovementId
                                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                        AND Movement.DescId   = zc_Movement_Check()

                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.movementid = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.isErased   = FALSE

                WHERE MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                  AND MovementBoolean_Deferred.ValueData = TRUE
                GROUP BY MovementLinkObject_Unit.ObjectId
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
                     , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                             AND ObjectFloat_Goods_Price.ValueData > 0
                                 THEN ObjectFloat_Goods_Price.ValueData
                            ELSE ObjectFloat_Price_Value.ValueData
                       END AS Price
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
                     -- Фикс цена для всей Сети
                     LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                            ON ObjectFloat_Goods_Price.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                           AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()   
                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                             ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                            AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()  
               )
          , Price_Unit AS
               (SELECT Price_Unit_all.UnitId
                     , Price_Unit_all.GoodsId
                     , Price_Unit_all.Price
                FROM Price_Unit_all
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

        SELECT Object_Goods.Id                                                     AS Id

             , CASE WHEN Object_Goods.isErased = TRUE THEN 1 ELSE 0 END::Integer   AS deleted

             , tmpList.UnitId                                                      AS UnitId
             , (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0))::TFloat     AS Remains

             , Price_Unit.Price    AS Price_unit
             , ROUND (CASE WHEN vbSiteDiscount = 0 THEN Price_Unit.Price
                        ELSE CEIL(Price_Unit.Price * (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2) :: TFloat AS Price_unit_sale
             , ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory.MarginPercent, 0)      / 100), 2) :: TFloat  AS Price_min
             , ROUND (CASE WHEN vbSiteDiscount = 0 THEN ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory.MarginPercent, 0) / 100), 2)
                        ELSE CEIL(ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory.MarginPercent, 0) / 100), 2) * 
                        (100.0 - vbSiteDiscount) / 10.0) / 10.0 END, 2) :: TFloat AS Price_min_sale
             , ROUND (MinPrice_List_D.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100) * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2) :: TFloat  AS Price_minD

             , MinPrice_List.JuridicalId
             , MinPrice_List.JuridicalName
             , MinPrice_List.ContractId
             , Object_Contract.ValueData       AS ContractName
             , MinPrice_List.PartionGoodsDate  AS ExpirationDate

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

             LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmpList.GoodsId
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MinPrice_List.ContractId


             LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                  ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()


             LEFT JOIN MarginCategory      ON MinPrice_List.Price >= MarginCategory.MinPrice      AND MinPrice_List.Price < MarginCategory.MaxPrice
                                          AND MarginCategory.UnitId = tmpList.UnitId
             LEFT JOIN MarginCategory_site ON MinPrice_List.Price >= MarginCategory_site.MinPrice AND MinPrice_List.Price < MarginCategory_site.MaxPrice
             LEFT JOIN Object AS Object_MarginCategory      ON Object_MarginCategory.Id      = MarginCategory.MarginCategoryId
             LEFT JOIN Object AS Object_MarginCategory_site ON Object_MarginCategory_site.Id = vbMarginCategoryId_site
        ORDER BY Price_Unit.Price
       ;
       
     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
/*     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                   AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr =  '172.17.2.4') AS Value2
             , (SELECT COUNT (*) FROM tmp_pg WHERE client_addr <> '172.17.2.4') AS Value3
             , 0 AS Value4
             , 0 AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , (vbOperDate_Begin2 - vbOperDate_Begin1) :: INTERVAL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , (vbOperDate_Begin3 - vbOperDate_Begin2) :: INTERVAL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin3) :: INTERVAL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_GoodsOnUnit_ForSite'
               -- ProtocolData
             , CHR (39) || inUnitId_list || CHR (39) || ' , ' || CHR (39) || inGoodsId_list || CHR (39)
        WHERE vbUserId > 0
        ;*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 30.01.19                                                                    *
 19.04.16                                        *
*/

-- тест
-- SELECT * FROM ResourseProtocol ORDER BY Id DESC LIMIT 4000
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId_list:= '1781716', inGoodsId_list:= '47761', inSession:= zfCalc_UserSite()) ORDER BY 1;
--
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId_list:= '377613,183292', inGoodsId_list:= '331,951,16876,40618', inFrontSite := False, inSession:= zfCalc_UserSite()) ORDER BY 1;
--SELECT * FROM gpSelect_GoodsOnUnit_ForSite('183292,183288,377605,375627,394426,472116,494882,1529734,1781716,377606,377595,183290,183289,183294,377613,377574,377594,377610,183293,375626,183291', '508,517,520,526,523,511,544,538,553,559,562,565,571,547,1642,1654,1714,1867,1933,2059,2095,2230,2257,2275,2323,2341,2344,2320,2509,2515', False, zfCalc_UserSite()) AS p ORDER BY p.price_unit
