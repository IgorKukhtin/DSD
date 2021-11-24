-- Function: lpSelectMinPrice_AllGoodsSite()

DROP FUNCTION IF EXISTS lpSelectMinPrice_AllGoodsSite (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_AllGoodsSite (
    IN inObjectId    Integer      , -- Торговая сеть
    IN inUserId      Integer        -- сессия пользователя
)

RETURNS TABLE (
    GoodsId            Integer,
    GoodsId_retail     Integer,
    GoodsId_Main       Integer,
    GoodsCode          Integer,
    GoodsName          TVarChar,
    Remains            TFloat,
    MidPriceIncome     TFloat,
    MinPriceIncome     TFloat,
    MaxPriceIncome     TFloat,
    MidPriceSale       TFloat,
    MidPriceUnit       TFloat,
    PriceUnitBase      TFloat,
    MidPriceUnitDiff   TFloat,
    PriceLlist         TVarChar,
    MinExpirationDate  TDateTime,
    PartionGoodsDate   TDateTime,
    Partner_GoodsId    Integer,
    Partner_GoodsCode  TVarChar,
    Partner_GoodsName  TVarChar,
    MakerName          TVarChar,
    ContractId         Integer,
    JuridicalId        Integer,
    JuridicalName      TVarChar,
    AreaId             Integer,
    AreaName           TVarChar,
    Price              TFloat,
    SuperFinalPrice    TFloat,
    isTop              Boolean,
    isTOP_Price        Boolean,
    isOneJuridical     Boolean,
    PercentMarkup      TFloat,

    isJuridicalPromo   Boolean,
    
    JuridicalPromoOneId   Integer,
    ContractPromoOneId    Integer,
    PercentMarkupPromoOne TFloat,
    PricePromoOne         TFloat,
    PartionGoodsDateOne   TDateTime, 

    JuridicalPromoTwoId   Integer,
    ContractPromoTwoId    Integer,
    PercentMarkupPromoTwo TFloat,
    PricePromoTwo         TFloat,
    PartionGoodsDateTwo   TDateTime,
    
    PricePromo         TFloat
)

AS
$BODY$
  DECLARE vbIsGoodsPromo Boolean;
  DECLARE vbCostCredit TFloat;
  DECLARE vbMainJuridicalId Integer;
BEGIN
    -- !!!так "криво" определятся НАДО ЛИ учитывать маркет. контракт!!!
    vbIsGoodsPromo:= inObjectId >=0;
    -- !!!меняется параметр в нормальное значение!!!
    inObjectId:= ABS (inObjectId);
    
    vbMainJuridicalId := 1311462;
 
    -- Перечень активных аптек 
    CREATE TEMP TABLE _tmpUnit ON COMMIT DROP AS
       (WITH 
             tmpMovement AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                             FROM Movement 
                             
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                               
                             WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '10 DAY'
                               AND Movement.DescId = zc_Movement_Check()
                               AND Movement.StatusId = zc_Enum_Status_Complete()),
             tmpUnitAll AS (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement) 
             
        SELECT tmpUnitAll.UnitId
             , ObjectLink_Unit_Juridical.ChildObjectId AS JuridicalID
             , ObjectLink_Unit_Area.ChildObjectId      AS AreaID
        FROM tmpUnitAll
             INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON ObjectLink_Unit_Juridical.ObjectId = tmpUnitAll.UnitId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                   ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                  AND ObjectLink_Juridical_Retail.ChildObjectId = inObjectId   
                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             INNER JOIN ObjectLink AS ObjectLink_Unit_Area
                                   ON ObjectLink_Unit_Area.ObjectId = tmpUnitAll.UnitId
                                  AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
        );

    --RAISE EXCEPTION '<%>', (select count(*) from _tmpUnit);


     -- получаем значение константы % кредитных средств
     vbCostCredit := COALESCE ((SELECT COALESCE (ObjectFloat_SiteDiscount.ValueData, 0)          :: TFloat    AS SiteDiscount
                                FROM Object AS Object_GlobalConst
                                     INNER JOIN ObjectBoolean AS ObjectBoolean_SiteDiscount
                                                              ON ObjectBoolean_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                                             AND ObjectBoolean_SiteDiscount.DescId = zc_ObjectBoolean_GlobalConst_SiteDiscount()
                                                             AND ObjectBoolean_SiteDiscount.ValueData = TRUE
                                     INNER JOIN ObjectFloat AS ObjectFloat_SiteDiscount
                                                           ON ObjectFloat_SiteDiscount.ObjectId = Object_GlobalConst.Id
                                                          AND ObjectFloat_SiteDiscount.DescId = zc_ObjectFloat_GlobalConst_SiteDiscount()
                                                          AND COALESCE (ObjectFloat_SiteDiscount.ValueData, 0) <> 0
                                WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
                                  AND Object_GlobalConst.Id =zc_Enum_GlobalConst_CostCredit()
                                )
                                , 0)  :: TFloat;

    --RAISE EXCEPTION '<%>', vbCostCredit;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remains'))
    THEN
      DROP TABLE _tmpMinPrice_Remains;
    END IF;

    -- Остатки - оптимизация
    CREATE TEMP TABLE _tmpMinPrice_Remains ON COMMIT DROP AS
       (WITH 
         MarginCategory_Unit AS
               (SELECT tmp.UnitId
                     , tmp.MarginCategoryId
                FROM (SELECT ObjectLink_MarginCategoryLink_Unit.ChildObjectId AS UnitId
                           , ObjectLink_MarginCategory.ChildObjectId AS MarginCategoryId
                           , ROW_NUMBER() OVER (PARTITION BY ObjectLink_MarginCategoryLink_Unit.ChildObjectId ORDER BY ObjectLink_MarginCategoryLink_Unit.ChildObjectId, ObjectLink_MarginCategory.ChildObjectId) AS Ord
                      FROM ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                           LEFT JOIN ObjectLink AS ObjectLink_MarginCategory
                                                ON ObjectLink_MarginCategory.ObjectId = ObjectLink_MarginCategoryLink_Unit.ObjectId
                                               AND ObjectLink_MarginCategory.DescId   = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                                 ON ObjectFloat_Percent.ObjectId = ObjectLink_MarginCategory.ChildObjectId
                                                AND ObjectFloat_Percent.DescId   = zc_ObjectFloat_MarginCategory_Percent()
                      WHERE COALESCE (ObjectFloat_Percent.ValueData, 0) = 0 -- !!!вот так криво!!!
                        AND ObjectLink_MarginCategoryLink_Unit.DescId        = zc_ObjectLink_MarginCategoryLink_Unit()
                     ) AS tmp
                WHERE tmp.Ord = 1 -- !!!только одна категория!!!
               )
      , MarginCategory_all AS
           (SELECT DISTINCT
                   tmp.UnitId
                 , tmp.MarginCategoryId
                 , ObjectFloat_MarginPercent.ValueData AS MarginPercent
                 , ObjectFloat_MinPrice.ValueData      AS MinPrice
                 , ROW_NUMBER() OVER (PARTITION BY tmp.UnitId, tmp.MarginCategoryId ORDER BY tmp.UnitId, tmp.MarginCategoryId, ObjectFloat_MinPrice.ValueData) AS ORD
            FROM (SELECT MarginCategory_Unit.UnitId, MarginCategory_Unit.MarginCategoryId FROM MarginCategory_Unit
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
                 , MarginCategory_all.MinPrice * (100 + MarginCategory_all.MarginPercent) / 100 AS MinPrice
                 , COALESCE (MarginCategory_all_next.MinPrice, 1000000) * (100 + MarginCategory_all.MarginPercent) / 100 AS MaxPrice
            FROM MarginCategory_all
                 LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.UnitId           = MarginCategory_all.UnitId
                                                                        AND MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                        AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
           )
       , tmp AS
             (SELECT Container.ObjectId
                   , Container.WhereObjectId     
                   , Container.Id
                   , Container.Amount
              FROM
                  Container
              WHERE Container.DescId = zc_Container_Count()
                AND Container.WhereObjectId IN (select _tmpUnit.UnitId from _tmpUnit)
                AND Container.Amount <> 0
                  )
       , tmpContainer AS 
                     (SELECT Container.ObjectId AS ObjectId_retail -- здесь товар "сети"
                           , Container.WhereObjectId AS UnitId
                           , Container.Amount
                           , Object_PartionMovementItem.ObjectCode ::Integer AS MI_Partion
                      FROM tmp AS Container
                          LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                              ON CLO_PartionMovementItem.ContainerId = Container.Id
                                                             AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                          LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem
                                                 ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                      )
       , tmpMI_Float AS (SELECT *
                         FROM MovementItemFloat
                         WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpContainer.MI_Partion FROM tmpContainer)
                           AND MovementItemFloat.DescId IN (zc_MIFloat_PriceSale(), zc_MIFloat_PriceWithOutVAT())
                         )
       , tmpContainerUnit AS 
                     (SELECT Container.ObjectId_retail  AS GoodsId
                           , Container.UnitId           AS UnitId
                      FROM tmpContainer AS Container
                      GROUP BY Container.ObjectId_retail
                             , Container.UnitId 
                      )
       , tmpPreceUnit AS 
                     (SELECT Container.GoodsId      AS GoodsId
                           , Container.UnitId 
                           , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                              AND ObjectFloat_Goods_Price.ValueData > 0
                                             THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                             ELSE ROUND (Price_Value.ValueData, 2)
                             END                                          AS Price
                           , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                              AND ObjectFloat_Goods_Price.ValueData > 0
                                             THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                             ELSE Price_Value.ValueData * (100 - CASE WHEN ObjectFloat_Goods_PercentMarkup.ValueData = 100 THEN 0
                                                                                      ELSE COALESCE(NULLIF(ObjectFloat_Goods_PercentMarkup.ValueData, 0), MarginCategory.MarginPercent, 0) END) / 100
                             END                                          AS PriceBase
                           , ROW_NUMBER() OVER (Partition BY Container.GoodsId ORDER BY CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                                                                              AND ObjectFloat_Goods_Price.ValueData > 0
                                                                                             THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                                                                             ELSE ROUND (Price_Value.ValueData, 2)
                                                                                        END ) AS ord
                            , COUNT (*) OVER (Partition BY Container.GoodsId) AS CountPrice

                      FROM tmpContainerUnit AS Container
                                                  
                           INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                 ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                AND ObjectLink_Price_Unit.ChildObjectId =  Container.UnitId
                           
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                AND Price_Goods.ChildObjectId =  Container.GoodsId

                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                                                  ON ObjectFloat_Goods_PercentMarkup.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_PercentMarkup.DescId   = zc_ObjectFloat_Goods_PercentMarkup()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
 
                           LEFT JOIN MarginCategory  ON ROUND (Price_Value.ValueData, 2) >= MarginCategory.MinPrice     
                                                    AND ROUND (Price_Value.ValueData, 2) < MarginCategory.MaxPrice
                                                    AND MarginCategory.UnitId = Container.UnitId 
                      )
       , tmpMidPreceUnit AS 
                     (SELECT Container.GoodsId      AS GoodsId
                           , CASE WHEN COUNT(*) >= 3
                                  THEN
                                    ROUND(SUM(CASE WHEN Container.ord = 1
                                                     OR Container.ord = Container.CountPrice
                                                   THEN 0
                                                   ELSE Container.Price     
                                                   END) / (COUNT(*) - 2), 1)
                                  
                                  ELSE
                                    ROUND(SUM(Container.Price) / COUNT(*), 1)  
                                  END :: TFloat                                                      AS Price
                           , CASE WHEN COUNT(*) >= 3
                                  THEN
                                    ROUND(SUM(CASE WHEN Container.ord = 1
                                                     OR Container.ord = Container.CountPrice
                                                   THEN 0
                                                   ELSE Container.PriceBase     
                                                   END) / (COUNT(*) - 2), 1)
                                  
                                  ELSE
                                    ROUND(SUM(Container.PriceBase) / COUNT(*), 1)  
                                  END :: TFloat                                                      AS PriceBase
                           , (CASE WHEN COUNT(*) >= 3
                                   THEN
                                     (MAX(tmpPreceUnitMax.Price) - MAX(tmpPreceUnitMin.Price)) / MAX(tmpPreceUnitMax.Price) 
                                   ELSE
                                     (MAX(Container.Price) - MIN(Container.Price)) / MAX(Container.Price) 
                              END * 100)  :: TFloat                                               AS MidPriceUnitDiff
                           , string_agg(Container.Price::TVarChar||' '||Container.CountPrice::TVarChar, ',')::TVarChar                                    AS PriceLlist
                      FROM tmpPreceUnit AS Container
                      
                           LEFT JOIN tmpPreceUnit AS tmpPreceUnitMin 
                                                  ON tmpPreceUnitMin.GoodsId = Container.GoodsId 
                                                 AND tmpPreceUnitMin.Ord = 2

                           LEFT JOIN tmpPreceUnit AS tmpPreceUnitMax
                                                  ON tmpPreceUnitMax.GoodsId = Container.GoodsId 
                                                 AND tmpPreceUnitMax.Ord = tmpPreceUnitMax.CountPrice - 1
                      GROUP BY Container.GoodsId
                      )
       , tmpRemains AS
                   (SELECT
                        Container.ObjectId_retail -- здесь товар "сети"
                      , SUM (Container.Amount)       AS Amount
                      , MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()))  AS MinExpirationDate -- Срок годности
                      , SUM (Container.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0)) / SUM (Container.Amount) AS MidPriceSale -- !!! средняя Цена реал. с НДС!!!
                      , MIN (CASE WHEN COALESCE (MIFloat_Income_Price.ValueData, 0) < 0.33 THEN 10000000 ELSE COALESCE (MIFloat_Income_Price.ValueData, 0) END) AS MinPriceIncome
                      , CASE WHEN SUM (CASE WHEN COALESCE (MIFloat_Income_Price.ValueData, 0.0) < 0.33 THEN 0.0 ELSE Container.Amount END) > 0 THEN
                        SUM (CASE WHEN COALESCE (MIFloat_Income_Price.ValueData, 0) < 0.33 THEN 0.0 ELSE Container.Amount END * COALESCE (MIFloat_Income_Price.ValueData, 0)) / 
                             SUM (CASE WHEN COALESCE (MIFloat_Income_Price.ValueData, 0) < 0.33 THEN 0.0 ELSE Container.Amount END) ELSE 0 END AS MidPriceIncome -- !!! средняя Цена реал. с НДС!!!
                      , MAX (COALESCE (MIFloat_Income_Price.ValueData, 0)) AS MaxPriceIncome
                    FROM tmpContainer AS Container
                         LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                          ON MIDate_ExpirationDate.MovementItemId = Container.MI_Partion
                                                         AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                         -- Цена реал. с НДС
                         LEFT JOIN tmpMI_Float AS MIFloat_PriceSale
                                                     ON MIFloat_PriceSale.MovementItemId = Container.MI_Partion
                                                    AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                         -- Цена поставщика без учета НДС
                         LEFT OUTER JOIN tmpMI_Float AS MIFloat_Income_Price
                                                           ON MIFloat_Income_Price.MovementItemId = Container.MI_Partion
                                                          AND MIFloat_Income_Price.DescId = zc_MIFloat_PriceWithOutVAT()
                                                                                                                    
                    GROUP BY Container.ObjectId_retail
                    HAVING SUM (Container.Amount) > 0
       )

        --
        SELECT
            ObjectLink_Child_NB.ChildObjectId         AS ObjectID           -- !!!временно захардкодил, будет всегда товар НеБолей!!!
          , tmpRemains.ObjectId_retail                                      -- здесь товар "сети"
          , ObjectLink_Main.ChildObjectId             AS ObjectId_Main
          , tmpRemains.Amount ::TFloat                AS Amount
          , tmpRemains.MinExpirationDate :: TDateTime AS MinExpirationDate  -- Срок годности
          , tmpRemains.MidPriceSale       -- !!! средняя Цена реал. с НДС!!!
          , CASE WHEN tmpRemains.MinPriceIncome > tmpRemains.MaxPriceIncome THEN tmpRemains.MaxPriceIncome ELSE tmpRemains.MinPriceIncome END AS MinPriceIncome   -- !!! минимальная цена прихода         
          , CASE WHEN COALESCE(tmpRemains.MidPriceIncome, 0) = 0 THEN tmpRemains.MaxPriceIncome ELSE tmpRemains.MidPriceIncome END AS MidPriceIncome              -- !!! средняя цена прихода       
          , tmpRemains.MaxPriceIncome     -- !!! максимальная цена прихода   
          , tmpMidPreceUnit.Price                     AS MidPriceUnit       -- !!! средняя цена в аптеках      
          , tmpMidPreceUnit.PriceBase                 AS PriceUnitBase      -- !!! средняя цена в аптеках без наценки
          , tmpMidPreceUnit.MidPriceUnitDiff          AS MidPriceUnitDiff 
          , tmpMidPreceUnit.PriceLlist
        FROM tmpRemains
                                    -- !!!временно захардкодил, будет всегда товар НеБолей!!!!
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmpRemains.ObjectId_retail
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
                                    LEFT JOIN tmpMidPreceUnit ON tmpMidPreceUnit.GoodsId = tmpRemains.ObjectId_retail
       );

    ANALYZE _tmpMinPrice_Remains;

-- RAISE notice  '<В наличии %>', (select count(*) from _tmpMinPrice_Remains);


    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remainslist'))
    THEN
      DROP TABLE _tmpMinPrice_RemainsList;
    END IF;


    -- Остатки + коды ...
    CREATE TEMP TABLE _tmpMinPrice_RemainsList ON COMMIT DROP AS
       (SELECT
            _tmpMinPrice_Remains.ObjectId,                  -- здесь товар "сети"
            _tmpMinPrice_Remains.ObjectId_retail,           -- здесь товар "сети"
            Object_Goods_Retail.GoodsMainId,                -- здесь "общий" товар
            Object_Goods_Juridical.Id     AS GoodsId,       -- здесь товар "поставщика"
            _tmpMinPrice_Remains.Amount,
            _tmpMinPrice_Remains.MinExpirationDate
        FROM _tmpMinPrice_Remains
            INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = _tmpMinPrice_Remains.objectid                  -- Связь товара сети с общим
            INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Retail.GoodsMainId -- Связь товара сети с общим
       );

    ANALYZE _tmpMinPrice_RemainsList;
-- RAISE notice '_tmpMinPrice_RemainsList <%>', (select count(*) from _tmpMinPrice_RemainsList);

    -- Результат
    RETURN QUERY
    WITH
    -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
    PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (inUserId::TVarChar))
  , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (inUserId::TVarChar) WHERE vbIsGoodsPromo = TRUE)

    -- Установки для юр. лиц (для поставщика определяется договор и т.п)
  , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId)
                         )
    -- элементы установок юр.лиц (границы цен для бонуса)
  , tmpJuridicalSettingsItem AS (SELECT tmp.JuridicalSettingsId
                                      , tmp.Bonus
                                      , tmp.PriceLimit_min
                                      , tmp.PriceLimit
                                 FROM JuridicalSettings
                                      INNER JOIN gpSelect_Object_JuridicalSettingsItem (JuridicalSettings.JuridicalSettingsId, inUserId::TVarChar) AS tmp ON tmp.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                 WHERE COALESCE (JuridicalSettings.isBonusClose, FALSE) = FALSE
                                 )

    -- Маркетинговый контракт
  , GoodsPromo AS (SELECT tmp.JuridicalId
                        , tmp.GoodsId        -- здесь товар "сети"
                        , tmp.ChangePercent
                   FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp
                  -- WHERE vbIsGoodsPromo = TRUE -- !!!т.е. только в этом случае учитывается маркет. контракт!!!
                  )
    -- Список цены + ТОП + % наценки
  , GoodsPrice AS
       (SELECT _tmpMinPrice_RemainsList.GoodsId
             , COALESCE (ObjectBoolean_Top.ValueData, FALSE) AS isTOP
             , COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup
        FROM _tmpMinPrice_RemainsList
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                   -- ON ObjectLink_Price_Goods.ChildObjectId = _tmpMinPrice_RemainsList.GoodsId
                                   ON ObjectLink_Price_Goods.ChildObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                   ON ObjectLink_Price_Unit.ChildObjectId = 0
                                  AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                     ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                     -- ON ObjectBoolean_Top.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                    AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
             LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                   ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Goods.ObjectId
                                   -- ON ObjectFloat_PercentMarkup.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                  AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
        WHERE ObjectBoolean_Top.ValueData = TRUE OR ObjectFloat_PercentMarkup.ValueData <> 0
       )

  , tmpJuridicalArea AS (SELECT DISTINCT
                                tmp.JuridicalId              AS JuridicalId
                              , tmp.AreaId_Juridical         AS AreaId
                              , tmp.AreaName_Juridical       AS AreaName
                         FROM lpSelect_Object_JuridicalArea_byUnit (0, 0) AS tmp
                         WHERE tmp.UnitId IN (select _tmpUnit.UnitId from _tmpUnit WHERE _tmpUnit.JuridicalId = vbMainJuridicalId)
                         )
  , tmpMinPrice_RemainsPrice as (SELECT
            _tmpMinPrice_RemainsList.ObjectId                 AS GoodsId
          , _tmpMinPrice_RemainsList.ObjectId_retail          AS GoodsId_retail
          , _tmpMinPrice_RemainsList.Amount                   AS Remains
          , _tmpMinPrice_RemainsList.MinExpirationDate        AS MinExpirationDate
            -- просто цена поставщика
          , PriceList.Amount                   AS Price
            -- минимальная цена поставщика - для товара "сети"
          , MIN (PriceList.Amount) OVER (PARTITION BY _tmpMinPrice_RemainsList.ObjectId) AS MinPrice
          , PriceList.Id                       AS PriceListMovementItemId
          , PriceList.MovementId               AS PriceListMovementId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

          , CASE -- если Цена поставщика не попадает в ценовые промежутки
                 WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                  THEN PriceList.Amount
                       -- учитывается % бонуса из Маркетинговый контракт
                     * (1 - COALESCE (CASE WHEN vbIsGoodsPromo = TRUE THEN GoodsPromo.ChangePercent ELSE 0 END, 0) / 100)

                 ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                    (PriceList.Amount * (100 - COALESCE (tmpJuridicalSettingsItem.Bonus, 0)) / 100)
                     -- И учитывается % бонуса из Маркетинговый контракт
                  * (1 - COALESCE (CASE WHEN vbIsGoodsPromo = TRUE THEN GoodsPromo.ChangePercent ELSE 0 END, 0) / 100)
            END :: TFloat AS FinalPrice

          , MILinkObject_Goods.ObjectId        AS Partner_GoodsId
          , Object_JuridicalGoods.GoodsCode    AS Partner_GoodsCode
          , Object_JuridicalGoods.GoodsName    AS Partner_GoodsName
          , Object_JuridicalGoods.MakerName    AS MakerName
          , LastPriceList_find_View.ContractId      AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , JuridicalSettings.isPriceClose     AS JuridicalIsPriceClose
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE) /*Goods.isTOP*/) AS isTOP
          , COALESCE (GoodsPrice.isTOP, FALSE) AS isTOP_Price
          , COALESCE (GoodsPrice.PercentMarkup, 0) AS PercentMarkup

          , tmpJuridicalArea.AreaId            AS AreaId
          , tmpJuridicalArea.AreaName          AS AreaName
          , COALESCE (GoodsPromo.GoodsId, 0) = _tmpMinPrice_RemainsList.ObjectId_retail  AS isJuridicalPromo

          , COALESCE (ObjectBoolean_PriorityReprice.ValueData, FALSE) AS isPriorityReprice

        FROM -- Остатки + коды ...
             _tmpMinPrice_RemainsList
             -- товары в прайс-листе (поставщика)
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                              ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                             AND MILinkObject_Goods.ObjectId = _tmpMinPrice_RemainsList.GoodsId  -- товар "поставщика"
             -- Прайс-лист (поставщика) - MovementItem
            JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
                                          AND PriceList.isErased = False 
             -- Прайс-лист (поставщика) - Movement
            JOIN LastPriceList_find_View ON LastPriceList_find_View.MovementId = PriceList.MovementId

            JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = LastPriceList_find_View.JuridicalId
                                 AND tmpJuridicalArea.AreaId      = LastPriceList_find_View.AreaId

             -- Срок партии товара (или Срок годности?) в Прайс-лист (поставщика)
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

             -- Установки для юр. лиц (для поставщика определяется договор и т.п)
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = LastPriceList_find_View.JuridicalId
                                       AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId
                                       AND JuridicalSettings.ContractId      = LastPriceList_find_View.ContractId
            LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                              AND PriceList.Amount >= tmpJuridicalSettingsItem.PriceLimit_min
                                              AND PriceList.Amount <= tmpJuridicalSettingsItem.PriceLimit

            -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                   AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = _tmpMinPrice_RemainsList.ObjectId

            -- Поставщик
            INNER JOIN Object AS Juridical ON Juridical.Id = LastPriceList_find_View.JuridicalId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriorityReprice
                                    ON ObjectBoolean_PriorityReprice.ObjectId = Juridical.Id
                                   AND ObjectBoolean_PriorityReprice.DescId = zc_ObjectBoolean_Juridical_PriorityReprice()

            -- Дней отсрочки по договору
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                  ON ObjectFloat_Deferment.ObjectId = LastPriceList_find_View.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

            -- % бонуса из Маркетинговый контракт
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = _tmpMinPrice_RemainsList.ObjectId
                                AND GoodsPromo.JuridicalId = LastPriceList_find_View.JuridicalId
                                
        WHERE (COALESCE (Object_JuridicalGoods.MinimumLot, 0) = 0
            OR Object_JuridicalGoods.IsPromo                  = FALSE
              )
       )
  , tmpMinPrice_PriorityReprice as (SELECT DISTINCT tmpMinPrice_RemainsPrice.GoodsId
                                    FROM tmpMinPrice_RemainsPrice
                                    WHERE isPriorityReprice = True
                                    )
       

   -- данные по % кредитных средств из справочника
  , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := inObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inUserId :: TVarChar) AS tmp)

    -- почти финальный список
  , FinalList AS
       (SELECT
        ddd.GoodsId
      , ddd.GoodsId_retail
      , ddd.Remains
      , ddd.MinExpirationDate
      , ddd.Price
      , ddd.PartionGoodsDate
      , ddd.Partner_GoodsId
      , ddd.Partner_GoodsCode
      , ddd.Partner_GoodsName
      , ddd.MakerName
      , ddd.ContractId
      , ddd.JuridicalId
      , ddd.JuridicalName
      , ddd.AreaId
      , ddd.AreaName
      , ddd.Deferment
      , ddd.PriceListMovementItemId
      , (FinalPrice - FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit)) / 100) :: TFloat AS SuperFinalPrice
      , ddd.isTOP
      , ddd.isTOP_Price
      , ddd.PercentMarkup
      , ddd.isJuridicalPromo

    FROM (SELECT DISTINCT
          tmpMinPrice_RemainsPrice.GoodsId
          , tmpMinPrice_RemainsPrice.GoodsId_retail
          , tmpMinPrice_RemainsPrice.Remains
          , tmpMinPrice_RemainsPrice.MinExpirationDate
            -- просто цена поставщика
          , tmpMinPrice_RemainsPrice.Price
            -- минимальная цена поставщика - для товара "сети"
          , tmpMinPrice_RemainsPrice.MinPrice
          , tmpMinPrice_RemainsPrice.PriceListMovementItemId
          , tmpMinPrice_RemainsPrice.PartionGoodsDate

          , tmpMinPrice_RemainsPrice.FinalPrice

          , tmpMinPrice_RemainsPrice.Partner_GoodsId
          , tmpMinPrice_RemainsPrice.Partner_GoodsCode
          , tmpMinPrice_RemainsPrice.Partner_GoodsName
          , tmpMinPrice_RemainsPrice.MakerName
          , tmpMinPrice_RemainsPrice.ContractId
          , tmpMinPrice_RemainsPrice.JuridicalId
          , tmpMinPrice_RemainsPrice.JuridicalName
          , tmpMinPrice_RemainsPrice.Deferment
          , tmpMinPrice_RemainsPrice.isTOP
          , tmpMinPrice_RemainsPrice.isTOP_Price
          , tmpMinPrice_RemainsPrice.PercentMarkup

          , tmpMinPrice_RemainsPrice.AreaId
          , tmpMinPrice_RemainsPrice.AreaName
          , tmpMinPrice_RemainsPrice.isJuridicalPromo
          , ROW_NUMBER() OVER (PARTITION BY tmpMinPrice_RemainsPrice.PriceListMovementId
                                          , tmpMinPrice_RemainsPrice.GoodsId
                                            ORDER BY tmpMinPrice_RemainsPrice.Price DESC) AS Ord

        FROM tmpMinPrice_RemainsPrice
        
             LEFT JOIN tmpMinPrice_PriorityReprice ON tmpMinPrice_PriorityReprice.GoodsId  = tmpMinPrice_RemainsPrice.GoodsId
                                                  
        WHERE  COALESCE (tmpMinPrice_RemainsPrice.JuridicalIsPriceClose, FALSE) <> TRUE
          AND (tmpMinPrice_RemainsPrice.isPriorityReprice = True OR COALESCE (tmpMinPrice_PriorityReprice.GoodsId , 0) = 0)
        

       ) AS ddd
       -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту)
       LEFT JOIN PriceSettings    ON ddd.MinPrice   BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice   BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
       LEFT JOIN tmpCostCredit    ON ddd.MinPrice   BETWEEN tmpCostCredit.MinPrice    AND tmpCostCredit.PriceLimit
       WHERE ddd.Ord = 1
   )
    -- отсортировали по цене + Дней отсрочки и получили первого
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId 
                                                     ORDER BY CASE WHEN FinalList.PartionGoodsDate IS NULL 
                                                                     OR FinalList.PartionGoodsDate >= CURRENT_DATE + INTERVAL '6 month'
                                                              THEN 0 ELSE 1 END 
                                                            , FinalList.SuperFinalPrice ASC
                                                            , FinalList.Deferment DESC
                                                            , FinalList.PriceListMovementItemId ASC) AS Ord
                           FROM FinalList
                          ) AS T0
                     WHERE T0.Ord = 1
                    )
    -- сколько поставщиков у товара
  , tmpCountJuridical AS (SELECT FinalList.GoodsId, COUNT (DISTINCT FinalList.JuridicalId) AS CountJuridical
                          FROM FinalList
                          GROUP BY FinalList.GoodsId
                         )
  , FinalListPromo AS (SELECT FinalList.*
                          , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId 
                                               ORDER BY CASE WHEN FinalList.PartionGoodsDate IS NULL 
                                                               OR FinalList.PartionGoodsDate >= CURRENT_DATE + INTERVAL '6 month'
                                                        THEN 0 ELSE 1 END 
                                                      , FinalList.SuperFinalPrice ASC
                                                      , FinalList.Deferment DESC
                                                      , FinalList.PriceListMovementItemId ASC) AS Ord
                     FROM FinalList
                     WHERE FinalList.isJuridicalPromo = True
                    )
    -- Результат
    SELECT
        _tmpMinPrice_Remains.ObjectId         AS GoodsId,
        _tmpMinPrice_Remains.ObjectId_retail  AS GoodsId_retail,
        _tmpMinPrice_Remains.ObjectId_Main    AS GoodsId_Main,
        Goods.GoodsCodeInt                    AS GoodsCode,
        Goods.GoodsName                       AS GoodsName,
        COALESCE(_tmpMinPrice_Remains.Amount, MinPriceList.Remains)                           AS Remains,
        _tmpMinPrice_Remains.MinPriceIncome:: TFloat   AS MinPriceIncome,
        _tmpMinPrice_Remains.MidPriceIncome:: TFloat   AS MidPriceIncome,
        _tmpMinPrice_Remains.MaxPriceIncome:: TFloat   AS MaxPriceIncome,
        _tmpMinPrice_Remains.MidPriceSale:: TFloat     AS MidPriceSale,
        _tmpMinPrice_Remains.MidPriceUnit:: TFloat     AS MidPriceUnit,
        _tmpMinPrice_Remains.PriceUnitBase:: TFloat    AS PriceUnitBase,
        _tmpMinPrice_Remains.MidPriceUnitDiff:: TFloat AS MidPriceUnitDiff,
        _tmpMinPrice_Remains.PriceLlist,
        COALESCE(_tmpMinPrice_Remains.MinExpirationDate , MinPriceList.MinExpirationDate)     AS MinExpirationDate,
        MinPriceList.PartionGoodsDate,
        MinPriceList.Partner_GoodsId,
        MinPriceList.Partner_GoodsCode,
        MinPriceList.Partner_GoodsName,
        MinPriceList.MakerName,
        MinPriceList.ContractId,
        MinPriceList.JuridicalId,
        MinPriceList.JuridicalName,
        MinPriceList.AreaId,
        MinPriceList.AreaName,
        MinPriceList.Price,
        MinPriceList.SuperFinalPrice,
        MinPriceList.isTop :: Boolean AS isTop,
        MinPriceList.isTOP_Price :: Boolean AS isTOP_Price,
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END :: Boolean AS isOneJuridical,
        MinPriceList.PercentMarkup :: TFloat AS PercentMarkup,
        
        MinPriceList.isJuridicalPromo,
        FinalListOne.JuridicalId, 
        FinalListOne.ContractId, 
        FinalListOne.PercentMarkup :: TFloat AS PercentMarkupPromo,
        FinalListOne.Price,
        FinalListOne.PartionGoodsDate,
        
        FinalListTwo.JuridicalId, 
        FinalListTwo.ContractId, 
        FinalListTwo.PercentMarkup :: TFloat AS PercentMarkupPromo,
        FinalListTwo.Price,
        FinalListTwo.PartionGoodsDate,
        
        CASE WHEN COALESCE (FinalListTwo.Price, 0) = 0
             THEN FinalListOne.Price 
             ELSE ROUND((FinalListOne.Price + FinalListTwo.Price) / 2, 2) END :: TFloat
    FROM _tmpMinPrice_Remains
    
         LEFT JOIN MinPriceList ON MinPriceList.GoodsId_retail = _tmpMinPrice_Remains.ObjectId_retail
    
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId

         LEFT JOIN FinalListPromo AS FinalListOne ON FinalListOne.GoodsId = MinPriceList.GoodsId
                                 AND FinalListOne.Ord = 1
         LEFT JOIN FinalListPromo AS FinalListTwo ON FinalListTwo.GoodsId = MinPriceList.GoodsId
                                 AND FinalListTwo.Ord = 2
         -- товар "сети"
         LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = _tmpMinPrice_Remains.ObjectId_retail
    WHERE COALESCE(MinPriceList.Ord, 1) = 1
    ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_AllGoodsSite (Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.06.21                                                       * 
*/

-- тест

 SELECT * FROM lpSelectMinPrice_AllGoodsSite (4, 3); 