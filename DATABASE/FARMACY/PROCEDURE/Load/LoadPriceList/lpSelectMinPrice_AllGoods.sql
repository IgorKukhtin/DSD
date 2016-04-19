-- Function: lpSelectMinPrice_AllGoods()

DROP FUNCTION IF EXISTS lpSelectMinPrice_AllGoods (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_AllGoods(
    IN inUnitId      Integer      , -- Аптека
    IN inObjectId    Integer      , -- Торговая сеть
    IN inUserId      Integer        -- сессия пользователя
)

RETURNS TABLE (
    GoodsId            Integer,
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
    Price              TFloat, 
    SuperFinalPrice    TFloat,
    isTop              Boolean,
    isOneJuridical     Boolean
)

AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
BEGIN

    -- Нашли у Аптеки "Главное юр лицо"
    SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;


    -- Результат
    RETURN QUERY
    WITH
    -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту) !!!внутри проц определяется ObjectId!!!
    PriceSettings AS (SELECT * FROM gpSelect_Object_PriceGroupSettingsInterval (inUserId::TVarChar)
                     )
    -- Установки для юр. лиц (для поставщика определяется договор и т.п)
  , JuridicalSettings AS (SELECT * FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId)
                         )
    -- Остатки
  , Remains AS
       (SELECT
            Container.ObjectId, -- здесь товар "сети"
            SUM(Container.Amount)::TFloat                      AS Amount,
            MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate, -- Срок годности
            SUM( Container.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0)) / SUM(Container.Amount)      AS MidPriceSale -- !!! средняя Цена реал. с НДС!!!
        FROM 
            Container
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
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId = inUnitId
          AND Container.Amount <> 0
        GROUP BY Container.ObjectId
        HAVING SUM (Container.Amount) > 0
       )
    -- Остатки + коды ...
  , GoodsList AS
       (SELECT 
            Remains.ObjectId,                  -- здесь товар "сети"
            Object_LinkGoods_View.GoodsMainId, -- здесь "общий" товар
            PriceList_GoodsLink.GoodsId,       -- здесь товар "поставщика"
            Remains.Amount,
            Remains.MinExpirationDate,
            Remains.MidPriceSale
        FROM 
            Remains
            INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = Remains.objectid -- Связь товара сети с общим
            LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                            ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
       )
    -- почти финальный список
  , FinalList AS
       (SELECT 
        ddd.GoodsId
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
      , ddd.Deferment
      , ddd.PriceListMovementItemId

      , CASE -- если Дней отсрочки по договору = 0 или ТОП-позиция
             WHEN ddd.Deferment = 0 OR ddd.isTOP = TRUE
                  THEN FinalPrice
             -- иначе учитывает % из Установки для ценовых групп (что б уравновесить ... )
             ELSE FinalPrice * (100 - PriceSettings.Percent) / 100

        END :: TFloat AS SuperFinalPrice

      , ddd.isTOP

    FROM (SELECT DISTINCT 
            GoodsList.ObjectId                 AS GoodsId
          , Goods.GoodsCodeInt                 AS GoodsCode
          , Goods.GoodsName                    AS GoodsName  
          , GoodsList.Amount                   AS Remains
          , GoodsList.MinExpirationDate        AS MinExpirationDate
          , GoodsList.MidPriceSale             AS MidPriceSale
            -- просто цена поставщика
          , PriceList.Amount                   AS Price
            -- минимальная цена поставщика - для товара "сети"
          , MIN (PriceList.Amount) OVER (PARTITION BY GoodsList.ObjectId) AS MinPrice
          , PriceList.Id                       AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

          , CASE -- если ТОП-позиция или Цена поставщика >= PriceLimit (до какой цены учитывать бонус при расчете миним. цены)
                 WHEN Goods.isTOP = TRUE OR COALESCE (JuridicalSettings.PriceLimit, 0) <= PriceList.Amount
                    THEN PriceList.Amount
                 -- иначе учитывается бонус
                 ELSE (PriceList.Amount * (100 - COALESCE (JuridicalSettings.Bonus, 0)) / 100) :: TFloat 
            END AS FinalPrice

          , MILinkObject_Goods.ObjectId        AS Partner_GoodsId
          , Object_JuridicalGoods.GoodsCode    AS Partner_GoodsCode
          , Object_JuridicalGoods.GoodsName    AS Partner_GoodsName
          , Object_JuridicalGoods.MakerName    AS MakerName
          , LastPriceList_View.ContractId      AS ContractId
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , COALESCE (ObjectFloat_Deferment.ValueData, 0) :: Integer AS Deferment
          , Goods.isTOP
        
        FROM -- Остатки + коды ...
             GoodsList 
             -- товары в прайс-листе (поставщика)
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                              ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                             AND MILinkObject_Goods.ObjectId = GoodsList.GoodsId  -- товар "поставщика"
             -- Прайс-лист (поставщика) - MovementItem
            JOIN MovementItem AS PriceList ON PriceList.Id = MILinkObject_Goods.MovementItemId
             -- Прайс-лист (поставщика) - Movement
            JOIN LastPriceList_View ON LastPriceList_View.MovementId = PriceList.MovementId

             -- Срок партии товара (или Срок годности?) в Прайс-лист (поставщика)
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

             -- Установки для юр. лиц (для поставщика определяется договор и т.п)
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = LastPriceList_View.JuridicalId 
                                       AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId
                                       AND JuridicalSettings.ContractId      = LastPriceList_View.ContractId 
            -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
            -- товар "сети"
            LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = GoodsList.ObjectId
       
            -- Поставщик
            INNER JOIN Object AS Juridical ON Juridical.Id = LastPriceList_View.JuridicalId

            -- Дней отсрочки по договору
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                  ON ObjectFloat_Deferment.ObjectId = LastPriceList_View.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
       
             
        WHERE  COALESCE (JuridicalSettings.isPriceClose, FALSE) <> TRUE 

       ) AS ddd
       -- Установки для ценовых групп (если товар с острочкой - тогда этот процент уравновешивает товары с оплатой по факту)
       LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice
   )
    -- отсортировали по цене и получили первого
  , MinPriceList AS (SELECT *
                     FROM (SELECT FinalList.*
                                , ROW_NUMBER() OVER (PARTITION BY FinalList.GoodsId ORDER BY FinalList.SuperFinalPrice, FinalList.PriceListMovementItemId) AS Ord
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
        MinPriceList.Price,
        MinPriceList.SuperFinalPrice,
        MinPriceList.isTop,
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END ::Boolean AS isOneJuridical
    FROM MinPriceList
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_AllGoods (Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 16.02.16         * add isOneJuridical
 03.12.15                                                                          * 
*/

-- тест
-- SELECT * FROM lpSelectMinPrice_AllGoods (183292, 4, 3) WHERE GoodsCode = 4797
