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
  , tmpObject_Goods AS (SELECT Object_Goods_Retail.id
                             , Object_Goods_Retail.GoodsMainId
                             , Object_Goods_Retail.isTop
                             , Object_Goods_Main.ObjectCode
                             , Object_Goods_Main.Name
                        FROM Object_Goods_Retail
                             LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                        WHERE Object_Goods_Retail.RetailId = inObjectId)
    -- Список цены + ТОП
  , GoodsPrice AS
       (SELECT tmpObject_Goods.Id                            AS GoodsId
             , COALESCE (ObjectBoolean_Top.ValueData, FALSE) AS isTOP
        FROM tmpObject_Goods
             INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                   ON ObjectLink_Price_Goods.ChildObjectId = tmpObject_Goods.Id
                                  AND ObjectLink_Price_Goods.DescId = zc_ObjectLink_Price_Goods()
             INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                   ON ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                  AND ObjectLink_Price_Unit.ObjectId = ObjectLink_Price_Goods.ObjectId
                                  AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                     ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                    AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
        WHERE ObjectBoolean_Top.ValueData = TRUE
       )
  , tmpLoadPriceListItem as (SELECT
                                     LoadPriceList.JuridicalId
                                   , LoadPriceList.ContractId
                                   , LoadPriceList.AreaId

                                   , LoadPriceListItem.ID
                                   , LoadPriceListItem.GoodsId
                                   , LoadPriceListItem.Price
                                   , LoadPriceListItem.ExpirationDate
                                   , ROW_NUMBER() OVER (PARTITION BY LoadPriceList.Id , LoadPriceListItem.GoodsId ORDER BY LoadPriceListItem.Price Desc)  AS Ord
                                   , Object_JuridicalGoods.Id           AS Partner_GoodsId
                                   , Object_JuridicalGoods.Code         AS Partner_GoodsCode
                                   , Object_JuridicalGoods.Name         AS Partner_GoodsName
                                   , Object_JuridicalGoods.MakerName    AS MakerName
                                   , Object_JuridicalGoods.MinimumLot   AS MinimumLot
                                   , Object_JuridicalGoods.IsPromo      AS IsPromo


                              FROM LoadPriceList
                                   INNER JOIN LoadPriceListItem ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                                                               AND COALESCE (LoadPriceListItem.GoodsId, 0) <> 0
                                                               AND COALESCE (LoadPriceListItem.ExpirationDate, zc_DateEnd()) > CURRENT_DATE + INTERVAL '200 DAY'
                                   -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
                                   INNER JOIN Object_Goods_Juridical AS Object_JuridicalGoods
                                                                     ON Object_JuridicalGoods.GoodsMainId = LoadPriceListItem.GoodsId
                                                                    AND Object_JuridicalGoods.JuridicalId = LoadPriceList.JuridicalId)

              -- товары в прайс-листе (поставщика)
  , tmpMinPrice_RemainsPrice as (SELECT
            tmpObject_Goods.Id                 AS GoodsId
          , tmpObject_Goods.Id                 AS GoodsId_retail
          , tmpObject_Goods.ObjectCode         AS GoodsCode
          , tmpObject_Goods.Name               AS GoodsName
            -- просто цена поставщика
          , LoadPriceListItem.Price            AS Price
            -- минимальная цена поставщика - для товара "сети"
          , MIN (LoadPriceListItem.Price) OVER (PARTITION BY  tmpObject_Goods.Id) AS MinPrice
          , LoadPriceListItem.ID               AS PriceListMovementItemId
          , LoadPriceListItem.ExpirationDate   AS PartionGoodsDate
          , CASE -- если Цена поставщика не попадает в ценовые промежутки
                 WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                  THEN LoadPriceListItem.Price
                       -- учитывается % бонуса из Маркетинговый контракт
                     * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
                  ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                    (LoadPriceListItem.Price  * (100 - COALESCE (tmpJuridicalSettingsItem.Bonus, 0)) / 100)
                     -- И учитывается % бонуса из Маркетинговый контракт
                  * (1 - COALESCE (GoodsPromo.ChangePercent, 0) / 100)
            END :: TFloat AS FinalPrice

          , LoadPriceListItem.Partner_GoodsId           AS Partner_GoodsId
          , LoadPriceListItem.Partner_GoodsCode         AS Partner_GoodsCode
          , LoadPriceListItem.Partner_GoodsName         AS Partner_GoodsName
          , LoadPriceListItem.MakerName                 AS MakerName
          , LoadPriceListItem.ContractId       AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , JuridicalSettings.isPriceClose     AS JuridicalIsPriceClose
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), COALESCE (tmpObject_Goods.isTOP, FALSE)) AS isTOP

          , LoadPriceListItem.AreaId           AS AreaId

        FROM -- Остатки + коды ...
             tmpObject_Goods

              -- товары в прайс-листе (поставщика)
             INNER JOIN tmpLoadPriceListItem AS LoadPriceListItem ON LoadPriceListItem.GoodsId = tmpObject_Goods.GoodsMainId
                                                                 AND LoadPriceListItem.Ord = 1

             -- Установки для юр. лиц (для поставщика определяется договор и т.п)
             INNER JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = LoadPriceListItem.JuridicalId
                                         AND JuridicalSettings.ContractId      = LoadPriceListItem.ContractId
             LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                               AND LoadPriceListItem.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                               AND LoadPriceListItem.Price <= tmpJuridicalSettingsItem.PriceLimit

             LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpObject_Goods.Id

             -- Поставщик
             INNER JOIN Object AS Juridical ON Juridical.Id = LoadPriceListItem.JuridicalId

             -- Дней отсрочки по договору
             LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                   ON ObjectFloat_Deferment.ObjectId = LoadPriceListItem.ContractId
                                  AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

             -- % бонуса из Маркетинговый контракт
             LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     =  tmpObject_Goods.Id
                                 AND GoodsPromo.JuridicalId = LoadPriceListItem.JuridicalId
        WHERE (COALESCE (LoadPriceListItem.MinimumLot, 0) = 0
            OR LoadPriceListItem.IsPromo                  = FALSE
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
--
-- SELECT * FROM lpFillingMinPrice_ForSite ()
-- SELECT Count(*) FROM MinPrice_ForSite    - 22572