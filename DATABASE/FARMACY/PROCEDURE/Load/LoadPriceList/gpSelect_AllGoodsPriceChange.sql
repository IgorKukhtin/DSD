-- Function: gpSelect_AllGoodsPriceChange()

DROP FUNCTION IF EXISTS gpSelect_AllGoodsPriceChange (Integer, Integer, TFloat, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AllGoodsPriceChange(
--  IN inGoodsCode     Integer     -- поиск товаров
    IN inUnitId        Integer     -- !!!Торговая сеть!!!
  , IN inUnitId_to     Integer     -- !!!Торговая сеть!!! (с которым есть сравнение цен)
  , IN inMinPercent    TFloat      -- Минимальный % для подразделений, у которых категория переоценки не установлена
  , IN inVAT20         Boolean     -- Переоценивать товары с 20% НДС

  , IN inTaxTo         TFloat      -- % отклонения ТОЛЬКО при уравнивании цен
  , IN inPriceMaxTo    TFloat      -- Цена до ТОЛЬКО при уравнивании цен
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    Id                  Integer,    -- ИД товара  !!!ВСЕГДА СЕТИ, не так как в других запросах!!!
    Id_retail           Integer,    -- ИД товара  !!!ВСЕГДА НБ, не так как в дргих запросах!!!
    Code                Integer,    -- Код товара
    GoodsName           TVarChar,   -- Наименование товара
    LastPrice           TFloat,     -- !!! Текущая цена со скидкой !!!
--    LastPrice_to        TFloat,     -- Текущая цена - inUnitId_to
    RemainsCount        TFloat,     -- Остаток
--    RemainsCount_to     TFloat,     -- Остаток - Подразделение (с которым есть сравнение цен)
    NDS                 TFloat,     -- ставка НДС
    NewPrice            TFloat,     -- Новая цена
--    NewPrice_to         TFloat,     -- Новая цена
    PriceFix_Goods      TFloat  ,   -- фиксированная цена сети
    MinMarginPercent    TFloat,     -- минимальный % отклонения
    PriceDiff           TFloat,     -- % отклонения
--    PriceDiff_to        TFloat,     -- % отклонения - inUnitId_to
    ExpirationDate      TDateTime,  -- Срок годности
    JuridicalId         Integer,    -- Поставщик Id
    JuridicalName       TVarChar,   -- Поставщик
    Juridical_Price     TFloat,     -- Цена у поставщика
    MarginPercent       TFloat,     -- !!! % наценки для цены со скидкой !!!
    Juridical_GoodsName TVarChar,   -- Наименование у поставщика
    ProducerName        TVarChar,   -- производитель
    ContractId          Integer,    -- договор Ид
    ContractName        TVarChar,   -- договор
    AreaId              Integer,    -- регион ИД
    AreaName            TVarChar,   -- регион
    Juridical_Percent   TFloat,     -- % Корректировки наценки Поставщика
    Contract_Percent    TFloat,     -- % Корректировки наценки Договора
    SumReprice          TFloat,     -- сумма переоценки
    MidPriceSale        TFloat,     -- средняя цена остатка
    MidPriceDiff        TFloat,     -- отклонение от средняя цена остатка
    MinExpirationDate   TDateTime,  -- Минимальный срок годности препарата на точке
--    MinExpirationDate_to TDateTime, -- Минимальный срок годности препарата на точке  - Подразделение (с которым есть сравнение цен)
    isOneJuridical      Boolean ,   -- один поставщик (да/нет)
--    isPriceFix          Boolean ,   -- фиксированная цена точки
--    isIncome            Boolean ,   -- приход сегодня
--    IsTop               Boolean ,   -- Топ точки
    IsTop_Goods         Boolean ,   -- Топ сети
--    IsPromo             Boolean ,   -- Акция
    Reprice             Boolean     --
    )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN
    vbUserId := inSession;
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');


    -- Список - товары по которым ЕСТЬ цены СО СКИДКОЙ + PercentMarkup - оптимизация
    CREATE TEMP TABLE _tmpPriceChange ON COMMIT DROP AS
       (SELECT
            Object_PriceChange.Id                                  AS Id
          , OL_PriceChange_Retail.ChildObjectId                    AS UnitId
          , OL_PriceChange_Goods.ChildObjectId                     AS GoodsId       -- здесь товар "сети"
          , COALESCE (OF_PriceChange_Value.ValueData, 0) :: TFloat AS Price         -- текущая цена со скидкой
          , COALESCE (OF_PercentMarkup.ValueData, 0)     :: TFloat AS PercentMarkup -- % наценки
          , COALESCE (OF_FixValue.ValueData, 0)          :: TFloat AS FixValue      -- Фиксированная цена
        FROM Object AS Object_PriceChange
             INNER JOIN ObjectLink AS OL_PriceChange_Retail
                                   ON OL_PriceChange_Retail.ObjectId      = Object_PriceChange.Id
                                  AND OL_PriceChange_Retail.DescId        = zc_ObjectLink_PriceChange_Retail()
                                  AND OL_PriceChange_Retail.ChildObjectId = inUnitId
                                  -- AND OL_PriceChange_Retail.ChildObjectId = IN (inUnitId_to, inUnitId)
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
        WHERE Object_PriceChange.DescId   = zc_Object_PriceChange()
          AND Object_PriceChange.isErased = FALSE
          AND OF_PercentMarkup.ValueData > 0          -- !!! только если установлен % наценки для цены со скидкой
          AND COALESCE (OF_FixValue.ValueData, 0) = 0 -- !!! только если НЕ установлена фиксированная цена со скидкой !!!
       );

    ANALYZE _tmpPriceChange;


  -- Результат
  RETURN QUERY
    WITH -- Товар НБ + Товар "сети"
         ObjectLink_Child_NB AS
             (SELECT
                 ObjectLink_Child.ChildObjectId,
                 ObjectLink_Child_NB.ChildObjectId as ChildObjectIdNB
              FROM _tmpPriceChange
                 INNER JOIN ObjectLink AS ObjectLink_Child
                                       ON ObjectLink_Child.ChildObjectId = _tmpPriceChange.GoodsId
                                      AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                 INNER JOIN ObjectLink AS ObjectLink_Main
                                       ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                      AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                 INNER JOIN ObjectLink AS ObjectLink_Main_NB
                                       ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                      AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                 INNER JOIN ObjectLink AS ObjectLink_Child_NB
                                       ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                      AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
                 INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                       ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                      AND ObjectLink_Goods_Object.DescId   = zc_ObjectLink_Goods_Object()
                                      AND ObjectLink_Goods_Object.ChildObjectId = 4
             )
  , tmpGoodsView AS (SELECT Object_Goods_View.*
                          -- , COALESCE (ObjectBoolean_Goods_SP.ValueData, False) :: Boolean  AS isSP
                     FROM Object_Goods_View
                         INNER JOIN _tmpPriceChange ON _tmpPriceChange.GoodsId = Object_Goods_View.Id
                         -- получаем GoodsMainId
                         /*LEFT JOIN  ObjectLink AS ObjectLink_Child
                                               ON ObjectLink_Child.ChildObjectId = Object_Goods_View.Id
                                              AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                         LEFT JOIN  ObjectLink AS ObjectLink_Main
                                               ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                              AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()

                         LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP
                                                  ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId
                                                 AND ObjectBoolean_Goods_SP.DescId   = zc_ObjectBoolean_Goods_SP()*/
                     WHERE Object_Goods_View.ObjectId = inUnitId
                    )

  , tmpPrice_View AS (SELECT _tmpPriceChange.Id
                           , _tmpPriceChange.UnitId
                           , _tmpPriceChange.GoodsId
                           , ROUND (_tmpPriceChange.Price, 2) :: TFloat AS Price
                           , ObjectLink_Main.ChildObjectId              AS GoodsMainId
                           , FALSE                                      AS Fix
                           , FALSE                                      AS isTop
                      FROM _tmpPriceChange
                           -- получаем GoodsMainId
                           LEFT JOIN  ObjectLink AS ObjectLink_Child
                                                 ON ObjectLink_Child.ChildObjectId = _tmpPriceChange.GoodsId
                                                AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                           LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                     )
  , ResultSet AS
    (
        SELECT
            SelectMinPrice_AllGoods.GoodsId AS Id,
            SelectMinPrice_AllGoods.GoodsId_retail AS Id_retail,
            SelectMinPrice_AllGoods.GoodsCode AS Code,
            SelectMinPrice_AllGoods.GoodsName AS GoodsName,
            Object_Price.Price                AS LastPrice,
            Object_Price_to.Price             AS LastPrice_to,
            ROUND (Object_Price_to.Price * (1 + CASE WHEN Object_Price_to.Price >= inPriceMaxTo AND inPriceMaxTo > 0 THEN 0 ELSE inTaxTo END / 100), 1) :: TFloat AS NewPrice_to,
            Object_Price.Fix                  AS isPriceFix,
            SelectMinPrice_AllGoods.Remains   AS RemainsCount,
            RemainsTo.Amount                  AS RemainsCount_to,
            Object_Goods.NDS                  AS NDS
          , CASE WHEN SelectMinPrice_AllGoods.isTop = TRUE
                      THEN COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), COALESCE (Object_Goods.PercentMarkup, 0)) /*- COALESCE(ObjectFloat_Juridical_Percent.ValueData, 0)*/
                 ELSE CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                THEN COALESCE (SelectMinPrice_AllGoods.PercentMarkup,0) + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                           ELSE COALESCE (SelectMinPrice_AllGoods.PercentMarkup,0) + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)
                      END
            END::TFloat AS MarginPercent
          , SelectMinPrice_AllGoods.PercentMarkup
          , (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)::TFloat AS Juridical_Price
          , zfCalc_SalePrice((SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)               -- Цена С НДС
                            , CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                       THEN SelectMinPrice_AllGoods.PercentMarkup + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) -- % наценки в КАТЕГОРИИ
                                   ELSE SelectMinPrice_AllGoods.PercentMarkup + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0) -- % наценки в КАТЕГОРИИ
                              END
                            , SelectMinPrice_AllGoods.isTop                                               -- ТОП позиция
                            , COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) -- % наценки у товара
                            , 0 /*ObjectFloat_Juridical_Percent.ValueData*/                                         -- % корректировки у Юр Лица для ТОПа
                            , CASE WHEN Object_Price.Fix = TRUE THEN Object_Price.Price ELSE Object_Goods.Price END -- Цена у товара (почти фиксированная)
                             ) ::TFloat AS NewPrice
          , SelectMinPrice_AllGoods.PartionGoodsDate         AS ExpirationDate,
            SelectMinPrice_AllGoods.JuridicalId              AS JuridicalId,
            SelectMinPrice_AllGoods.JuridicalName            AS JuridicalName,
            SelectMinPrice_AllGoods.Partner_GoodsName        AS Partner_GoodsName,
            SelectMinPrice_AllGoods.MakerName                AS ProducerName,
            Object_Contract.Id                               AS ContractId,
            Object_Contract.ValueData                        AS ContractName,
            Object_Area.Id                                   AS AreaId,
            Object_Area.ValueData                            AS AreaName,
            SelectMinPrice_AllGoods.MinExpirationDate        AS MinExpirationDate,
            RemainsTo.MinExpirationDate                      AS MinExpirationDate_to,
            SelectMinPrice_AllGoods.MidPriceSale             AS MidPriceSale,
            Object_Goods.NDSKindId,
            SelectMinPrice_AllGoods.isOneJuridical,
            CASE WHEN Select_Income_AllGoods.IncomeCount > 0 THEN TRUE ELSE FALSE END :: Boolean AS isIncome,
            SelectMinPrice_AllGoods.isTop AS isTop_calc,
            Object_Price.IsTop    AS IsTop,
            Object_Goods.IsTop    AS IsTop_Goods,
            Coalesce(ObjectBoolean_Goods_IsPromo.ValueData, False) :: Boolean   AS IsPromo,
            Object_Goods.Price    AS PriceFix_Goods
        FROM
            lpSelectMinPrice_AllGoods_retail (inObjectId := inUnitId
                                            , inUserId   := vbUserId
                                             ) AS SelectMinPrice_AllGoods
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = SelectMinPrice_AllGoods.ContractId
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = SelectMinPrice_AllGoods.AreaId

            LEFT OUTER JOIN RemainsTo ON RemainsTo.GoodsId = SelectMinPrice_AllGoods.GoodsId


            LEFT OUTER JOIN tmpPrice_View AS Object_Price
                                          ON Object_Price.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail
                                         AND Object_Price.UnitId = inUnitId

            LEFT OUTER JOIN tmpPrice_View AS Object_Price_to
                                          ON Object_Price_to.GoodsMainId = Object_Price.GoodsMainId --SelectMinPrice_AllGoods.GoodsId_retail
                                         AND Object_Price_to.UnitId = CASE WHEN inUnitId_to = 0 THEN NULL ELSE inUnitId_to END

            LEFT OUTER JOIN tmpGoodsView AS Object_Goods
                                         -- !!!берем из сети!!!
                                         ON Object_Goods.Id = SelectMinPrice_AllGoods.GoodsId_retail -- SelectMinPrice_AllGoods.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                  ON ObjectFloat_Juridical_Percent.ObjectId = SelectMinPrice_AllGoods.JuridicalId
                                 AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

            LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                  ON ObjectFloat_Contract_Percent.ObjectId = SelectMinPrice_AllGoods.ContractId
                                 AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

            LEFT JOIN lpSelect_Income_AllGoods(inUnitId := inUnitId,
                                               inUserId := vbUserId) AS Select_Income_AllGoods
                                                                     ON Select_Income_AllGoods.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                    ON ObjectBoolean_Goods_IsPromo.ObjectId = SelectMinPrice_AllGoods.Partner_GoodsId
                                   AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()

        -- WHERE Object_Goods.isSp = FALSE
    )

    SELECT
        ResultSet.Id_retail AS Id,
        ResultSet.Id        AS Id_retail,
        ResultSet.Code,
        ResultSet.GoodsName,
        ResultSet.LastPrice,
        ResultSet.LastPrice_to,
        ResultSet.RemainsCount,
        ResultSet.RemainsCount_to,
        ResultSet.NDS,
        ResultSet.NewPrice,
        ResultSet.NewPrice_to,
        ResultSet.PriceFix_Goods,
        COALESCE(ResultSet.PercentMarkup,inMinPercent)::TFloat AS MinMarginPercent,
        CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                   ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
              END AS NUMERIC (16, 1)) :: TFloat AS PriceDiff,
        CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                   ELSE (ResultSet.NewPrice_to / ResultSet.LastPrice) * 100 - 100

              END AS NUMERIC (16, 1)) :: TFloat AS PriceDiff_to,

        ResultSet.ExpirationDate         AS ExpirationDate,
        ResultSet.JuridicalId            AS JuridicalId,
        ResultSet.JuridicalName          AS JuridicalName,
        ResultSet.Juridical_Price        AS Juridical_Price,
        ResultSet.MarginPercent          AS MarginPercent,
        ResultSet.Partner_GoodsName      AS Juridical_GoodsName,
        ResultSet.ProducerName           AS ProducerName,
        ResultSet.ContractId,
        ResultSet.ContractName,
        ResultSet.AreaId,
        ResultSet.AreaName,
        ObjectFloat_Juridical_Percent.ValueData  ::TFloat AS Juridical_Percent,
        ObjectFloat_Contract_Percent.ValueData   ::TFloat AS Contract_Percent,

        ROUND ((CASE WHEN inUnitId_to <> 0 THEN CASE WHEN ResultSet.NewPrice_to > 0 THEN (ResultSet.NewPrice_to - ResultSet.LastPrice) ELSE 0 END ELSE (ResultSet.NewPrice - ResultSet.LastPrice) END
               * ResultSet.RemainsCount
               )
           , 2) :: TFloat AS SumReprice,
        ResultSet.MidPriceSale,
        CAST (CASE WHEN COALESCE(ResultSet.MidPriceSale,0) = 0 THEN 0 ELSE ((ResultSet.NewPrice / ResultSet.MidPriceSale) * 100 - 100) END AS NUMERIC (16, 1)) :: TFloat AS MidPriceDiff,
        ResultSet.MinExpirationDate,
        ResultSet.MinExpirationDate_to,
        ResultSet.isOneJuridical,
        ResultSet.isPriceFix,
        ResultSet.isIncome,
        ResultSet.IsTop,
        -- CASE WHEN ResultSet.isTop_calc = TRUE THEN ResultSet.isTop_calc ELSE ResultSet.IsTop END :: Boolean AS IsTop,
        ResultSet.IsTop_Goods,
        ResultSet.IsPromo,
        CASE WHEN ResultSet.MinExpirationDate < (CURRENT_DATE + Interval '6 month')
                  THEN FALSE
             WHEN COALESCE (inUnitId_to, 0) = 0 AND (ResultSet.isPriceFix = TRUE OR ResultSet.PriceFix_Goods <> 0)
                  THEN TRUE
             WHEN -- COALESCE (inUnitId_to, 0) = 0 AND (ResultSet.isIncome = TRUE /*OR ResultSet.isTop_calc = TRUE*/ OR ResultSet.isPriceFix = TRUE OR ResultSet.PriceFix_Goods <> 0)
                  COALESCE (inUnitId_to, 0) = 0 AND ResultSet.isIncome = TRUE
                  THEN FALSE
             WHEN COALESCE (inUnitId_to, 0) = 0
                  THEN TRUE

             WHEN inUnitId_to <> 0 AND (ResultSet.MinExpirationDate < (CURRENT_DATE + Interval '6 month')
                                    OR  ResultSet.MinExpirationDate_to < (CURRENT_DATE + Interval '6 month')
                                    OR  ResultSet.isIncome = TRUE)
                  THEN FALSE

             WHEN inUnitId_to <> 0
              AND ResultSet.NewPrice_to > 0
              AND 0 <> CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                                  ELSE (ResultSet.NewPrice_to / ResultSet.LastPrice) * 100 - 100
                             END AS NUMERIC (16, 1))
                  THEN TRUE

             ELSE FALSE
        END  AS Reprice
    FROM
        ResultSet
        LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                              ON ObjectFloat_Juridical_Percent.ObjectId = ResultSet.JuridicalId
                             AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
        LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                              ON ObjectFloat_Contract_Percent.ObjectId = ResultSet.ContractId
                             AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

    WHERE
       ((inUnitId_to > 0 AND ResultSet.NewPrice_to > 0 AND 0 <> CAST (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                                                                            ELSE (ResultSet.NewPrice_to / ResultSet.LastPrice) * 100 - 100
                                                                       END AS NUMERIC (16, 1))
        )
     -- OR inSession = '3'
     OR (COALESCE(ResultSet.NewPrice,0) > 0
         AND (COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Medical()
              OR (inVAT20 = TRUE
                  AND COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Common()
                 )
             )
         AND (ResultSet.ExpirationDate IS NULL
           OR ResultSet.ExpirationDate = '1899-12-30'::TDateTime
           OR ResultSet.ExpirationDate > (CURRENT_DATE + Interval '6 month')
             )
         AND (COALESCE(ResultSet.LastPrice,0) = 0
           OR ABS (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                        ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
                   END
                  ) >= COALESCE (ResultSet.PercentMarkup, inMinPercent)
             )
       ))
   AND (inUnitId_to = 0 or ResultSet.isPriceFix = FALSE)
   AND ResultSet.RemainsCount > 0
   AND (ResultSet.RemainsCount_to > 0 OR COALESCE (inUnitId_to, 0) = 0)
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_AllGoodsPriceChange (Integer,  Integer,  TFloat, Boolean, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Шаблий О.В.
 18.08.17                                        *
*/

-- тест
-- SELECT * FROM gpSelect_AllGoodsPriceChange (183292, 0, 30, True, 0, 0, '3')  -- Аптека_1 пр_Правды_6
