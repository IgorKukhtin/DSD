-- Function: lpFillingMinPrice_ForSite()

DROP FUNCTION IF EXISTS lpFillingMinPrice_ForSite ();

CREATE OR REPLACE FUNCTION lpFillingMinPrice_ForSite()

RETURNS VOID
AS
$BODY$
  DECLARE inUnitId    Integer;
  DECLARE inObjectId  Integer;
  DECLARE inUserId    Integer;
  DECLARE vbCostCredit TFloat;
  DECLARE vbIsGoodsPromo Boolean;
BEGIN

  inUnitId := 0;
  inObjectId := 4 ;
  inUserId := zfCalc_UserSite()::Integer;

    -- !!!так "криво" определятся НАДО ЛИ учитывать маркет. контракт!!!
    vbIsGoodsPromo:= inObjectId >=0;
    -- !!!меняется параметр в нормальное значение!!!
    inObjectId:= ABS (inObjectId);


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

    -- !!!ОПТИМИЗАЦИЯ!!!
    ANALYZE ObjectLink;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remains'))
    THEN
      DROP TABLE _tmpMinPrice_Remains;
    END IF;

    -- Остатки - оптимизация
    CREATE TEMP TABLE _tmpMinPrice_Remains ON COMMIT DROP AS
        (WITH tmpRemains AS
              (SELECT Object_Goods_View.Id AS ObjectId_retail
               FROM Object_Goods_View
               WHERE Object_Goods_View.ObjectId = 4
                 AND Object_Goods_View.isErased = False)

        SELECT
            ObjectLink_Child_NB.ChildObjectId         AS ObjectID           -- !!!временно захардкодил, будет всегда товар НеБолей!!!
          , tmpRemains.ObjectId_retail                                      -- здесь товар "сети"
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

    -- Остатки + коды ...
    CREATE TEMP TABLE _tmpMinPrice_RemainsList ON COMMIT DROP AS
       (SELECT DISTINCT
            _tmpMinPrice_Remains.ObjectId,                  -- здесь товар "сети"
            _tmpMinPrice_Remains.ObjectId_retail,           -- здесь товар "сети"
            ObjectLink_LinkGoods_Main.ChildObjectId       AS GoodsMainId, -- здесь "общий" товар
            ObjectLink_LinkGoods_Child_jur.ChildObjectId  AS GoodsId        -- здесь товар "поставщика"
        FROM _tmpMinPrice_Remains

            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child
                                  ON ObjectLink_LinkGoods_Child.ChildObjectId = _tmpMinPrice_Remains.objectid
                                 AND ObjectLink_LinkGoods_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main
                                  ON ObjectLink_LinkGoods_Main.ObjectId = ObjectLink_LinkGoods_Child.ObjectId
                                 AND ObjectLink_LinkGoods_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()

            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Main_jur
                                  ON ObjectLink_LinkGoods_Main_jur.ChildObjectId = ObjectLink_LinkGoods_Main.ChildObjectId
                                 AND ObjectLink_LinkGoods_Main_jur.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Child_jur
                                  ON ObjectLink_LinkGoods_Child_jur.ObjectId = ObjectLink_LinkGoods_Main_jur.ObjectId
                                 AND ObjectLink_LinkGoods_Child_jur.DescId = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_Goods_Object_jur
                                  ON ObjectLink_Goods_Object_jur.ObjectId = ObjectLink_LinkGoods_Child_jur.ChildObjectId
                                 AND ObjectLink_Goods_Object_jur.DescId = zc_ObjectLink_Goods_Object()
            INNER JOIN Object ON Object.Id =ObjectLink_Goods_Object_jur.ChildObjectId
                              AND Object.DescId = zc_Object_Juridical()
       );

    ANALYZE _tmpMinPrice_RemainsList;

  CREATE TABLE MinPrice_ForSite_Temp
  (
    GoodsId            Integer,
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
  );


  -- Результат
  INSERT INTO MinPrice_ForSite_Temp
    WITH
    -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
    PriceSettings    AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval    (inUserId::TVarChar))
  , PriceSettingsTOP AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsTOPInterval (inUserId::TVarChar) WHERE vbIsGoodsPromo = TRUE)

    -- Установки для юр. лиц (для поставщика определяется договор и т.п)
  , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId) AS tmp
                          WHERE tmp.isSite = TRUE -- мне нужно: я отметил какие участвуют в аукционе цены для показа на сайте, чтобы цены только этих договоров и участвовали
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
                   WHERE vbIsGoodsPromo = TRUE -- !!!т.е. только в этом случае учитывается маркет. контракт!!!
                  )
    -- Список цены + ТОП
  , GoodsPrice AS
       (SELECT _tmpMinPrice_RemainsList.GoodsId
             , COALESCE (ObjectBoolean_Top.ValueData, FALSE) AS isTOP
        FROM _tmpMinPrice_RemainsList
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                   -- ON ObjectLink_Price_Goods.ChildObjectId = _tmpMinPrice_RemainsList.GoodsId
                                   ON ObjectLink_Price_Goods.ChildObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                   ON ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                  AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                     ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                     -- ON ObjectBoolean_Top.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                    AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
        WHERE ObjectBoolean_Top.ValueData = TRUE
       )

  , tmpMinPrice_RemainsPrice as (SELECT
            _tmpMinPrice_RemainsList.ObjectId                 AS GoodsId
          , _tmpMinPrice_RemainsList.ObjectId_retail          AS GoodsId_retail
          , Goods.GoodsCodeInt                 AS GoodsCode
          , Goods.GoodsName                    AS GoodsName
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
                     * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                  ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                    (PriceList.Amount * (100 - COALESCE (tmpJuridicalSettingsItem.Bonus, 0)) / 100)
                     -- И учитывается % бонуса из Маркетинговый контракт
                  * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
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

          , LastPriceList_View.AreaId            AS AreaId

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

             -- Срок партии товара (или Срок годности?) в Прайс-лист (поставщика)
            JOIN MovementItemDate AS MIDate_PartionGoods
                                  ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                 AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

             -- Установки для юр. лиц (для поставщика определяется договор и т.п)
            INNER JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = LastPriceList_View.JuridicalId
                                     --  AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId
                                       AND JuridicalSettings.ContractId      = LastPriceList_View.ContractId
            LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                              AND PriceList.Amount >= tmpJuridicalSettingsItem.PriceLimit_min
                                              AND PriceList.Amount <= tmpJuridicalSettingsItem.PriceLimit

            -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
            -- товар "сети"
            LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = _tmpMinPrice_RemainsList.ObjectId

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

            -- % бонуса из Маркетинговый контракт
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = _tmpMinPrice_RemainsList.ObjectId
                                AND GoodsPromo.JuridicalId = LastPriceList_View.JuridicalId
        WHERE (COALESCE (Object_JuridicalGoods.MinimumLot, 0) = 0
            OR Object_JuridicalGoods.IsPromo                  = FALSE
              )
       )

   -- данные по % кредитных средств из справочника
  , tmpCostCredit AS (SELECT * FROM gpSelect_Object_RetailCostCredit(inRetailId := inObjectId, inShowAll := FALSE, inisErased := FALSE, inSession := inUserId :: TVarChar) AS tmp)

    -- почти финальный список
  , FinalList AS
       (SELECT
        ddd.GoodsId
      , ddd.GoodsId_retail
      , ddd.GoodsCode
      , ddd.GoodsName
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
      , ddd.Deferment
      , ddd.PriceListMovementItemId
      , (FinalPrice - FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit)) / 100) :: TFloat AS SuperFinalPrice
      , ddd.isTOP

    FROM (SELECT DISTINCT
          tmpMinPrice_RemainsPrice.GoodsId
          , tmpMinPrice_RemainsPrice.GoodsId_retail
          , tmpMinPrice_RemainsPrice.GoodsCode
          , tmpMinPrice_RemainsPrice.GoodsName
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

          , tmpMinPrice_RemainsPrice.AreaId
        FROM tmpMinPrice_RemainsPrice
        WHERE  COALESCE (tmpMinPrice_RemainsPrice.JuridicalIsPriceClose, FALSE) <> TRUE

       ) AS ddd
       -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту)
       LEFT JOIN PriceSettings    ON ddd.MinPrice BETWEEN PriceSettings.MinPrice    AND PriceSettings.MaxPrice
       LEFT JOIN PriceSettingsTOP ON ddd.MinPrice BETWEEN PriceSettingsTOP.MinPrice AND PriceSettingsTOP.MaxPrice
       LEFT JOIN tmpCostCredit    ON ddd.MinPrice BETWEEN tmpCostCredit.MinPrice    AND tmpCostCredit.PriceLimit
   )

    -- отсортировали по цене + Дней отсрочки и получили первого
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*,
                                  ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId, FinalList.AreaId
                                                     ORDER BY FinalList.SuperFinalPrice ASC, FinalList.Deferment DESC, FinalList.PriceListMovementItemId ASC) AS Ord
                           FROM FinalList
                          ) AS T0
                     WHERE T0.Ord = 1
                    )

    -- сколько поставщиков у товара
  , tmpCountJuridical AS (SELECT FinalList.GoodsId, FinalList.AreaId, COUNT (DISTINCT FinalList.JuridicalId) AS CountJuridical
                          FROM FinalList
                          GROUP BY FinalList.GoodsId, FinalList.AreaId
                         )
    -- Результат
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
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END ::Boolean AS isOneJuridical
    FROM MinPriceList
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId
                                    AND tmpCountJuridical.AreaId  = MinPriceList.AreaId;

  DROP TABLE IF EXISTS MinPrice_ForSite;
  ALTER TABLE MinPrice_ForSite_Temp RENAME TO MinPrice_ForSite;
  ALTER TABLE MinPrice_ForSite OWNER TO postgres;
  CREATE INDEX idx_MinPrice_ForSite_GoodsId ON MinPrice_ForSite(GoodsId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpFillingMinPrice_ForSite () OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.    Фелонюк И.В.
 12.04.19         * переделка на новые рельсы
 07.02.19         * если isBonusClose = true бонусы не учитываем
 14.01.19                        *
 15.04.16         *
*/

-- тест
--SELECT * FROM lpFillingMinPrice_ForSite ()
-- SELECT Count(*) FROM MinPrice_ForSite

