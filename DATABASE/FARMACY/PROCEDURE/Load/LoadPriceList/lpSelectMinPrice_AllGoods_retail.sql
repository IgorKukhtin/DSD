-- Function: lpSelectMinPrice_AllGoods()

DROP FUNCTION IF EXISTS lpSelectMinPrice_AllGoods_retail (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_AllGoods_retail(
    IN inObjectId    Integer      , -- Торговая сеть
    IN inUserId      Integer        -- сессия пользователя
)

RETURNS TABLE (
    GoodsId            Integer,
    GoodsId_retail     Integer,
    GoodsCode          Integer,
    GoodsName          TVarChar,
    Remains            TFloat,
    MidPriceSale       TFloat,
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
    isOneJuridical     Boolean,
    PercentMarkup      TFloat   -- !!! % наценки для цены со скидкой !!!
)

AS
$BODY$
  DECLARE vbCostCredit TFloat;
BEGIN
    -- !!!ОПТИМИЗАЦИЯ!!!
    ANALYZE ObjectLink;

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

    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPriceChange'))
    THEN
        -- Список - товары по которым ЕСТЬ цены СО СКИДКОЙ - оптимизация
        CREATE TEMP TABLE _tmpPriceChange ON COMMIT DROP AS
           (SELECT
                OL_PriceChange_Goods.ChildObjectId                     AS GoodsId       -- здесь товар "сети"
              , COALESCE (OF_PriceChange_Value.ValueData, 0) :: TFloat AS Price         -- текущая цена со скидкой
              , COALESCE (OF_PercentMarkup.ValueData, 0)     :: TFloat AS PercentMarkup -- % наценки
            FROM Object AS Object_PriceChange
                 INNER JOIN ObjectLink AS OL_PriceChange_Retail
                                       ON OL_PriceChange_Retail.ObjectId      = Object_PriceChange.Id
                                      AND OL_PriceChange_Retail.DescId        = zc_ObjectLink_PriceChange_Retail()
                                      AND OL_PriceChange_Retail.ChildObjectId = inObjectId
                 INNER JOIN ObjectLink AS OL_PriceChange_Goods
                                       ON OL_PriceChange_Goods.ObjectId = Object_PriceChange.Id
                                      AND OL_PriceChange_Goods.DescId   = zc_ObjectLink_PriceChange_Goods()
                 LEFT JOIN ObjectFloat AS OF_PriceChange_Value
                                       ON OF_PriceChange_Value.ObjectId = Object_PriceChange.Id
                                      AND OF_PriceChange_Value.DescId   = zc_ObjectFloat_PriceChange_Value()
                 LEFT JOIN ObjectFloat AS OF_FixValue
                                       ON OF_FixValue.ObjectId = Object_PriceChange.Id
                                      AND OF_FixValue.DescId   = zc_ObjectFloat_PriceChange_FixValue()
                 LEFT JOIN ObjectFloat AS OF_PercentMarkup
                                       ON OF_PercentMarkup.ObjectId = Object_PriceChange.Id
                                      AND OF_PercentMarkup.DescId   = zc_ObjectFloat_PriceChange_PercentMarkup()
                 LEFT JOIN ObjectFloat AS OF_FixPercent
                                       ON OF_FixPercent.ObjectId = Object_PriceChange.Id
                                      AND OF_FixPercent.DescId   = zc_ObjectFloat_PriceChange_FixPercent()
            WHERE Object_PriceChange.DescId   = zc_Object_PriceChange()
              AND Object_PriceChange.isErased = FALSE
              AND OF_PercentMarkup.ValueData <> 0
              AND COALESCE (OF_FixValue.ValueData, 0) = 0    -- !!! только если НЕ установлена фиксированная цена со скидкой !!!
              AND COALESCE (OF_FixPercent.ValueData, 0) = 0  -- !!! только если НЕ установлен фиксированный % со скидкой !!!
           );

        ANALYZE _tmpPriceChange;

    END IF;


    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remains'))
    THEN
      DROP TABLE _tmpMinPrice_Remains;
    END IF;

    -- Остатки - оптимизация
    CREATE TEMP TABLE _tmpMinPrice_Remains ON COMMIT DROP AS
       (WITH tmpRemains AS
       (SELECT
            _tmpPriceChange.GoodsId      AS ObjectId_retail -- здесь товар "сети"
          , SUM (Container.Amount)       AS Amount
          , MIN (COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()))  AS MinExpirationDate -- Срок годности
          , SUM (Container.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0)) / SUM (Container.Amount) AS MidPriceSale -- !!! средняя Цена реал. с НДС!!!
        FROM _tmpPriceChange
             INNER JOIN Container ON Container.ObjectId = _tmpPriceChange.GoodsId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount <> 0
             INNER JOIN ObjectLink AS OL_Unit_Juridical
                                   ON OL_Unit_Juridical.ObjectId = Container.WhereObjectId
                                  AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
             INNER JOIN ObjectLink AS OL_Juridical_Retail
                                   ON OL_Juridical_Retail.ObjectId      = OL_Unit_Juridical.ChildObjectId
                                  AND OL_Juridical_Retail.ChildObjectId = inObjectId
                                  AND OL_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
            LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                ON CLO_PartionMovementItem.ContainerId = Container.Id
                                               AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem
                                   ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
            LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                              ON MIDate_ExpirationDate.MovementItemId = Object_PartionMovementItem.ObjectCode
                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
            -- Цена реал. с НДС
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = Object_PartionMovementItem.ObjectCode
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
        GROUP BY _tmpPriceChange.GoodsId
        HAVING SUM (Container.Amount) > 0
       )
        --
        SELECT
            ObjectLink_Child_NB.ChildObjectId         AS ObjectID           -- !!!временно захардкодил, будет всегда товар НеБолей!!!
          , tmpRemains.ObjectId_retail                                      -- здесь товар "сети"
          , tmpRemains.Amount ::TFloat                AS Amount
          , tmpRemains.MinExpirationDate :: TDateTime AS MinExpirationDate  -- Срок годности
          , tmpRemains.MidPriceSale       -- !!! средняя Цена реал. с НДС!!!
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
       );

    ANALYZE _tmpMinPrice_Remains;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remainslist'))
    THEN
      DROP TABLE _tmpMinPrice_RemainsList;
    END IF;

-- RAISE EXCEPTION '<%>', (select count(*) from Remains);

    -- Остатки + коды ...
    CREATE TEMP TABLE _tmpMinPrice_RemainsList ON COMMIT DROP AS
       (SELECT
            _tmpMinPrice_Remains.ObjectId,                  -- здесь товар "сети"
            _tmpMinPrice_Remains.ObjectId_retail,           -- здесь товар "сети"
            Object_LinkGoods_View.GoodsMainId, -- здесь "общий" товар
            PriceList_GoodsLink.GoodsId,       -- здесь товар "поставщика"
            _tmpMinPrice_Remains.Amount,
            _tmpMinPrice_Remains.MinExpirationDate,
            _tmpMinPrice_Remains.MidPriceSale
        FROM _tmpMinPrice_Remains
            INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = _tmpMinPrice_Remains.objectid -- Связь товара сети с общим
            LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                            ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
       );

    ANALYZE _tmpMinPrice_RemainsList;
--RAISE notice '<%>', (select count(*) from _tmpMinPrice_RemainsList);


    -- Результат
    RETURN QUERY
    WITH
    -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
    PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (inUserId::TVarChar))

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
    -- Список цены + ТОП + % наценки
  , GoodsPrice AS
       (SELECT tmp.GoodsId
             , CASE WHEN tmp.isTOP = 1 THEN TRUE ELSE FALSE END AS isTOP
             , tmp.PercentMarkup
        FROM
       (SELECT _tmpMinPrice_RemainsList.GoodsId
             , MAX (CASE WHEN COALESCE (ObjectBoolean_Top.ValueData, FALSE) = TRUE THEN 1 ELSE 0 END) AS isTOP
             , _tmpPriceChange.PercentMarkup
        FROM _tmpMinPrice_RemainsList
             INNER JOIN _tmpPriceChange ON _tmpPriceChange.GoodsId = _tmpMinPrice_RemainsList.ObjectId_retail
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                -- ON ObjectLink_Price_Goods.ChildObjectId = _tmpMinPrice_RemainsList.GoodsId
                                   ON ObjectLink_Price_Goods.ChildObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                     ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                     -- ON ObjectBoolean_Top.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                    AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
             LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                   ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Goods.ObjectId
                                   -- ON ObjectFloat_PercentMarkup.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                  AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
        GROUP BY  _tmpMinPrice_RemainsList.GoodsId
                , _tmpPriceChange.PercentMarkup
       ) AS tmp
       )

  , tmpJuridicalArea AS (SELECT DISTINCT
                                tmp.UnitId                   AS UnitId
                              , tmp.JuridicalId              AS JuridicalId
                              , tmp.AreaId_Juridical         AS AreaId
                              , tmp.AreaName_Juridical       AS AreaName
                         FROM lpSelect_Object_JuridicalArea_byUnit (0, 0) AS tmp
                         WHERE tmp.RetailId_Juridical = inObjectId
                         )
  , tmpMinPrice_RemainsPrice as (SELECT
            _tmpMinPrice_RemainsList.ObjectId                 AS GoodsId
          , _tmpMinPrice_RemainsList.ObjectId_retail          AS GoodsId_retail
          , Goods.GoodsCodeInt                 AS GoodsCode
          , Goods.GoodsName                    AS GoodsName
          , _tmpMinPrice_RemainsList.Amount                   AS Remains
          , _tmpMinPrice_RemainsList.MinExpirationDate        AS MinExpirationDate
          , _tmpMinPrice_RemainsList.MidPriceSale             AS MidPriceSale
            -- просто цена поставщика
          , PriceList.Amount                   AS Price
            -- минимальная цена поставщика - для товара "сети"
          , MIN (PriceList.Amount) OVER (PARTITION BY _tmpMinPrice_RemainsList.ObjectId) AS MinPrice
          , PriceList.Id                       AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

            , CASE -- если Цена поставщика не попадает в ценовые промежутки
                   WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                    THEN PriceList.Amount
                         -- учитывается % бонуса из Маркетинговый контракт
--                       * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)

                   ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                      (PriceList.Amount * (100 - COALESCE (tmpJuridicalSettingsItem.Bonus, 0)) / 100)
                       -- И учитывается % бонуса из Маркетинговый контракт
--                    * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
              END :: TFloat AS FinalPrice

          , MILinkObject_Goods.ObjectId        AS Partner_GoodsId
          , Object_JuridicalGoods.GoodsCode    AS Partner_GoodsCode
          , Object_JuridicalGoods.GoodsName    AS Partner_GoodsName
          , Object_JuridicalGoods.MakerName    AS MakerName
          , LastPriceList_View.ContractId      AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , JuridicalSettings.isPriceClose     AS JuridicalIsPriceClose
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE) /*Goods.isTOP*/) AS isTOP
          , COALESCE (GoodsPrice.PercentMarkup, 0) AS PercentMarkup

          , tmpJuridicalArea.AreaId            AS AreaId
          , tmpJuridicalArea.AreaName          AS AreaName

        FROM -- Остатки + коды ...
             _tmpMinPrice_RemainsList
             -- товары в прайс-листе (поставщика)
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                              ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                             AND MILinkObject_Goods.ObjectId = _tmpMinPrice_RemainsList.GoodsId  -- товар "поставщика"
             -- Прайс-лист (поставщика) - MovementItem
            JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
             -- Прайс-лист (поставщика) - Movement
            JOIN LastPriceList_View ON LastPriceList_View.MovementId = PriceList.MovementId

            JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = LastPriceList_View.JuridicalId
                                 AND tmpJuridicalArea.AreaId      = LastPriceList_View.AreaId

             -- Срок партии товара (или Срок годности?) в Прайс-лист (поставщика)
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

             -- Установки для юр. лиц (для поставщика определяется договор и т.п)
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = LastPriceList_View.JuridicalId
                                       -- AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId
                                       AND JuridicalSettings.ContractId      = LastPriceList_View.ContractId
            LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                              AND PriceList.Amount >= tmpJuridicalSettingsItem.PriceLimit_min
                                              AND PriceList.Amount <= tmpJuridicalSettingsItem.PriceLimit
            -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
            -- товар "сети"
            LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = _tmpMinPrice_RemainsList.ObjectId
            -- LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = _tmpMinPrice_RemainsList.ObjectId_retail
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                   AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = _tmpMinPrice_RemainsList.ObjectId

            -- Поставщик
            INNER JOIN Object AS Juridical ON Juridical.Id = LastPriceList_View.JuridicalId

            -- Дней отсрочки по договору
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                  ON ObjectFloat_Deferment.ObjectId = LastPriceList_View.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
           )

    -- почти финальный список
  , FinalList AS
       (SELECT
        ddd.GoodsId
      , ddd.GoodsId_retail
      , ddd.GoodsCode
      , ddd.GoodsName
      , ddd.Remains
      , ddd.MinExpirationDate
      , ddd.MidPriceSale
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

/*     -- до 07,04,2019
      , CASE -- если Дней отсрочки по договору = 0 + ТОП-позиция учитывает % из ... (что б уравновесить ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = TRUE
                  THEN FinalPrice -- * (100 + COALESCE (PriceSettingsTOP.Percent, 0)) / 100
             -- если Дней отсрочки по договору = 0 + НЕ ТОП-позиция = учитывает % из Установки для ценовых групп (что б уравновесить ... )
             WHEN ddd.Deferment = 0 AND ddd.isTOP = FALSE
                  THEN FinalPrice * (100 + COALESCE (PriceSettings.Percent, 0)) / 100
             -- иначе НЕ учитывает
             ELSE FinalPrice

        END :: TFloat AS SuperFinalPrice
*/
        -- с 07,04,2019
      , (FinalPrice - FinalPrice * ((ddd.Deferment) * vbCostCredit) / 100) :: TFloat AS SuperFinalPrice
     
      , ddd.isTOP
      , ddd.PercentMarkup

    FROM (SELECT DISTINCT
          tmpMinPrice_RemainsPrice.GoodsId
          , tmpMinPrice_RemainsPrice.GoodsId_retail
          , tmpMinPrice_RemainsPrice.GoodsCode
          , tmpMinPrice_RemainsPrice.GoodsName
          , tmpMinPrice_RemainsPrice.Remains
          , tmpMinPrice_RemainsPrice.MinExpirationDate
          , tmpMinPrice_RemainsPrice.MidPriceSale
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
          , tmpMinPrice_RemainsPrice.PercentMarkup

          , tmpMinPrice_RemainsPrice.AreaId
          , tmpMinPrice_RemainsPrice.AreaName
        FROM tmpMinPrice_RemainsPrice
        WHERE  COALESCE (tmpMinPrice_RemainsPrice.JuridicalIsPriceClose, FALSE) <> TRUE

       ) AS ddd
       -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту)
       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
   )
    -- отсортировали по цене + Дней отсрочки и получили первого
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId ORDER BY FinalList.SuperFinalPrice ASC, FinalList.Deferment DESC, FinalList.PriceListMovementItemId ASC) AS Ord
                           FROM FinalList
                          ) AS T0
                     WHERE T0.Ord = 1
                    )
    -- сколько поставщиков у товара
  , tmpCountJuridical AS (SELECT FinalList.GoodsId, COUNT (DISTINCT FinalList.JuridicalId) AS CountJuridical
                          FROM FinalList
                          GROUP BY FinalList.GoodsId
                         )
    -- Результат
    SELECT
        MinPriceList.GoodsId,
        MinPriceList.GoodsId_retail,
        MinPriceList.GoodsCode,
        MinPriceList.GoodsName,
        MinPriceList.Remains,
        MinPriceList.MidPriceSale ::TFloat,
        MinPriceList.MinExpirationDate,
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
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END :: Boolean AS isOneJuridical,
        MinPriceList.PercentMarkup :: TFloat AS PercentMarkup
    FROM MinPriceList
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_AllGoods_retail (Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 07.02.19         * если isBonusClose = true бонусы не учитываем 
 14.01.19         * tmpJuridicalSettingsItem - теперь значения Бонус берем из Итемов
 21.08.18                                        *
*/

-- тест
-- SELECT * FROM lpSelectMinPrice_AllGoods_retail (3031066, 3) WHERE GoodsCode = 1069 -- !!!Никополь!!!
-- SELECT * FROM lpSelectMinPrice_AllGoods_retail (4, 3) WHERE GoodsCode = 8969 -- "Аптека_1 пр_Правды_6"
