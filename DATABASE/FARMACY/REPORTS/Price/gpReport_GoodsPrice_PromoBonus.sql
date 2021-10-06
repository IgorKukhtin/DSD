-- Function: gpReport_GoodsPrice_PromoBonus()

DROP FUNCTION IF EXISTS gpReport_GoodsPrice_PromoBonus (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsPrice_PromoBonus(
    IN inMovementId    Integer     -- Документ для расчета
  , IN inUnitId        Integer     -- Подразделение
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    Id                  Integer,    -- ИД товара  !!!ВСЕГДА СЕТИ, не так как в других запросах!!!
    Id_retail           Integer,    -- ИД товара  !!!ВСЕГДА НБ, не так как в дргих запросах!!!
    Code                Integer,    -- Код товара
    GoodsName           TVarChar,   -- Наименование товара
    LastPrice           TFloat,     -- Текущая цена
    RemainsCount        TFloat,     -- Остаток
    NDS                 TFloat,     -- ставка НДС
    NewPrice            TFloat,     -- Новая цена
    NewPriceNew         TFloat,     -- Новая цена с учетом Корректировка цены реализации с учетом бонуса
    PriceFix_Goods      TFloat  ,   -- фиксированная цена сети
    MinMarginPercent    TFloat,     -- минимальный % отклонения
    PriceDiff           TFloat,     -- % отклонения
    ExpirationDate      TDateTime,  -- Срок годности
    JuridicalId         Integer,    -- Поставщик Id
    JuridicalName       TVarChar,   -- Поставщик
    Juridical_Price     TFloat,     -- Цена у поставщика
    MarginPercent       TFloat,     -- % наценки по точке
    MarginPercentBonus  TFloat,     -- % наценки по точке с учетом Корректировка цены реализации с учетом бонуса
    PromoBonus          TFloat,     -- % Корректировка цены реализации с учетом бонуса
    Juridical_GoodsName TVarChar,   -- Наименование у поставщика
    ProducerName        TVarChar,   -- производитель
    ContractId          Integer,    -- договор Ид
    ContractName        TVarChar,   -- договор
    AreaId              Integer,    -- ренгион ИД
    AreaName            TVarChar,   -- регион
    Juridical_Percent   TFloat,     -- % Корректировки наценки Поставщика
    Contract_Percent    TFloat,     -- % Корректировки наценки Договора
    SumReprice          TFloat,     -- сумма переоценки
    MaxPriceIncome      TFloat,     -- макс цена партий
    MidPriceSale        TFloat,     -- средняя цена остатка
    MidPriceDiff        TFloat,     -- отклонение от средняя цена остатка
    MinExpirationDate   TDateTime,  -- Минимальный срок годности препарата на точке
    isOneJuridical      Boolean ,   -- один поставщик (да/нет)
    isPriceFix          Boolean ,   -- фиксированная цена точки
    isIncome            Boolean ,   -- приход сегодня
    IsTop               Boolean ,   -- Топ точки
    IsTop_Goods         Boolean ,   -- Топ сети
    isTopNo_Unit        Boolean ,   -- Не учитывать ТОП для подразделения
    IsPromo             Boolean ,   -- Акция
    isResolution_224    Boolean ,   -- Постановление 224
    isUseReprice        Boolean ,   -- Переоценивать в ночной переоценке
    Reprice             Boolean ,   --
    isGoodsReprice      Boolean ,   --
    isTop_calc          Boolean 
    )

AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbObjectId         Integer;
  DECLARE vbMarginCategoryId Integer;
  DECLARE vbMarginPercent_ExpirationDate TFloat;
  DECLARE vbInterval_ExpirationDate      Interval;
  DECLARE vbisTopNo_Unit       Boolean;
  DECLARE vbisMinPercentMarkup Boolean;
  DECLARE vbUpperLimitPromoBonus TFloat;
  DECLARE vbLowerLimitPromoBonus TFloat;
  DECLARE vbMinPercentPromoBonus TFloat;
BEGIN
    vbUserId := inSession;
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');


    SELECT ObjectFloat_CashSettings_UpperLimitPromoBonus.ValueData                  AS UpperLimitPromoBonus
         , ObjectFloat_CashSettings_LowerLimitPromoBonus.ValueData                  AS LowerLimitPromoBonus
         , ObjectFloat_CashSettings_MinPercentPromoBonus.ValueData                  AS MinPercentPromoBonus
    INTO vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_UpperLimitPromoBonus
                               ON ObjectFloat_CashSettings_UpperLimitPromoBonus.ObjectId = Object_CashSettings.Id
                              AND ObjectFloat_CashSettings_UpperLimitPromoBonus.DescId = zc_ObjectFloat_CashSettings_UpperLimitPromoBonus()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_LowerLimitPromoBonus
                               ON ObjectFloat_CashSettings_LowerLimitPromoBonus.ObjectId = Object_CashSettings.Id
                              AND ObjectFloat_CashSettings_LowerLimitPromoBonus.DescId = zc_ObjectFloat_CashSettings_LowerLimitPromoBonus()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_MinPercentPromoBonus
                               ON ObjectFloat_CashSettings_MinPercentPromoBonus.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_MinPercentPromoBonus.DescId = zc_ObjectFloat_CashSettings_MinPercentPromoBonus()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;

--    raise notice 'Value: % %', vbUpperLimitPromoBonus, vbLowerLimitPromoBonus;


    -- % наценки для срока годности < 6 мес.
    vbMarginPercent_ExpirationDate:= (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_Retail_MarginPercent() AND ObjectFloat.ObjectId = vbObjectId);
    --
    -- vbInterval_ExpirationDate:= zc_Interval_ExpirationDate();
    vbInterval_ExpirationDate:= '6 MONTH' :: Interval;

    --
    SELECT COALESCE(Object_Unit_View.MarginCategoryId,0) AS MarginCategoryId
         , COALESCE (ObjectBoolean_TopNo.ValueData, FALSE) :: Boolean AS isTopNo
         , COALESCE (ObjectBoolean_MinPercentMarkup.ValueData, FALSE) :: Boolean AS isMinPercentMarkup
    INTO vbMarginCategoryId, vbisTopNo_Unit, vbisMinPercentMarkup
    FROM Object_Unit_View
         LEFT JOIN ObjectBoolean AS ObjectBoolean_TopNo
                                 ON ObjectBoolean_TopNo.ObjectId = inUnitId
                                AND ObjectBoolean_TopNo.DescId = zc_ObjectBoolean_Unit_TopNo()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_MinPercentMarkup
                                 ON ObjectBoolean_MinPercentMarkup.ObjectId = inUnitId
                                AND ObjectBoolean_MinPercentMarkup.DescId = zc_ObjectBoolean_Unit_MinPercentMarkup()
    WHERE Object_Unit_View.Id = inUnitId;

  RETURN QUERY
    WITH DD
    AS
    (
        SELECT DISTINCT
            Object_MarginCategoryItem_View.MarginPercent,
            Object_MarginCategoryItem_View.MinPrice,
            Object_MarginCategoryItem_View.MarginCategoryId,
            ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
        FROM Object_MarginCategoryItem_View
             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                           AND Object_MarginCategoryItem.isErased = FALSE
    ),
    MarginCondition
    AS
    (
        SELECT
            D1.MarginCategoryId,
            D1.MarginPercent,
            D1.MinPrice,
            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
        FROM DD AS D1
            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
    )
  , ObjectLink_Child_NB
    AS
        (SELECT
            ObjectLink_Child.ChildObjectId,
            ObjectLink_Child_NB.ChildObjectId as ChildObjectIdNB
         FROM ObjectLink AS ObjectLink_Child
            INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                 AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                 AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
            INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                 AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
            INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                 AND ObjectLink_Goods_Object.ChildObjectId = 4
         WHERE ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods())

    -- Товары соц-проект (документ)
  , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                   FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE, inUnitId := inUnitId) AS tmp
                -- WHERE 1=0
                  )

  , tmpGoodsView AS (SELECT Object_Goods_View.*
                          , COALESCE (tmpGoodsSP.isSP, False)   ::Boolean AS isSP
                     FROM Object_Goods_View
                         -- получаем GoodsMainId
                         LEFT JOIN  ObjectLink AS ObjectLink_Child
                                               ON ObjectLink_Child.ChildObjectId = Object_Goods_View.Id
                                              AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                         LEFT JOIN ObjectLink AS ObjectLink_Main
                                              ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                             AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                         LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId

                         /*LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP
                                                  ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId
                                                 AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()*/

                     WHERE Object_Goods_View.ObjectId = vbObjectId
                     )

  , tmpPrice_View AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                           , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                           , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                           , Price_Goods.ChildObjectId               AS GoodsId
                           , ObjectLink_Main.ChildObjectId           AS GoodsMainId
                           , COALESCE(Price_Fix.ValueData,False)     AS Fix
                           , COALESCE(Price_Top.ValueData,False)     AS isTop
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                  ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectBoolean AS Price_Fix
                                  ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                           LEFT JOIN ObjectBoolean AS Price_Top
                                  ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()

                           -- получаем GoodsMainId
                           LEFT JOIN  ObjectLink AS ObjectLink_Child
                                                 ON ObjectLink_Child.ChildObjectId = Price_Goods.ChildObjectId
                                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                           LEFT JOIN  ObjectLink AS ObjectLink_Main
                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                      )
  , PromoBonus AS (SELECT MovementItem.Id                            AS Id
                        , Object_Goods_Retail.GoodsMainId            AS GoodsId
                        , MovementItem.Amount                        AS Amount
                   FROM MovementItem
                        INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.ObjectId
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.isErased = False
                     AND MovementItem.Amount > 0)

  , ResultSet AS
    (
        SELECT
            SelectMinPrice_AllGoods.GoodsId AS Id,
            SelectMinPrice_AllGoods.GoodsId_retail AS Id_retail,
            SelectMinPrice_AllGoods.GoodsCode AS Code,
            SelectMinPrice_AllGoods.GoodsName AS GoodsName,
            Object_Price.Price                AS LastPrice,
            Object_Price.Fix                  AS isPriceFix,
            SelectMinPrice_AllGoods.Remains   AS RemainsCount,
            Object_Goods.NDS                  AS NDS
          , CASE WHEN SelectMinPrice_AllGoods.isTop = TRUE
                      THEN COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), COALESCE (Object_Goods.PercentMarkup, 0)) /*- COALESCE(ObjectFloat_Juridical_Percent.ValueData, 0)*/

                 ELSE CASE -- % наценки для срока годности < 6 мес.
                           WHEN vbMarginPercent_ExpirationDate > 0
                            AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                            AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                            AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                            AND COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                THEN vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                           -- % наценки для срока годности < 6 мес.
                           WHEN vbMarginPercent_ExpirationDate > 0
                            AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                            AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                            AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                THEN vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)

                           WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                THEN COALESCE (MarginCondition.MarginPercent,0) + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)

                           ELSE COALESCE (MarginCondition.MarginPercent,0) + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)
                      END
            END::TFloat AS MarginPercent
          , CASE WHEN SelectMinPrice_AllGoods.isTop = TRUE
                      THEN COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), COALESCE (Object_Goods.PercentMarkup, 0)) /*- COALESCE(ObjectFloat_Juridical_Percent.ValueData, 0)*/

                 ELSE CASE -- % наценки для срока годности < 6 мес.
                           WHEN vbMarginPercent_ExpirationDate > 0
                            AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                            AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                            AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                            AND COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                THEN zfCalc_MarginPercent_PromoBonus (vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0),
                                                                      PromoBonus.Amount, vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus)
                           -- % наценки для срока годности < 6 мес.
                           WHEN vbMarginPercent_ExpirationDate > 0
                            AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                            AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                            AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                THEN zfCalc_MarginPercent_PromoBonus (vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0),
                                                                      PromoBonus.Amount, vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus)

                           WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                THEN zfCalc_MarginPercent_PromoBonus (COALESCE (MarginCondition.MarginPercent,0) + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0),
                                                                      PromoBonus.Amount, vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus)

                           ELSE zfCalc_MarginPercent_PromoBonus (COALESCE (MarginCondition.MarginPercent,0) + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0),
                                                                 PromoBonus.Amount, vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus)
                      END
            END::TFloat AS MarginPercentBonus
          , COALESCE(PromoBonus.Amount, 0)::TFloat AS PromoBonus
          , (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)::TFloat AS Juridical_Price
          , zfCalc_SalePrice(
                              (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)               -- Цена С НДС
                             --  * CASE WHEN vbObjectId = 4 THEN 1.015 ELSE 1 END                          -- 23.03. убрали  -- для сети НЕ БОЛЕЙ!!! к цене поставщика дополнительные +1.5 19.03.2020      ----  +3% - 17,03,2020 Люба
                            , CASE -- % наценки для срока годности < 6 мес.
                                   WHEN vbMarginPercent_ExpirationDate > 0
                                    AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                    AND COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                        THEN vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                                   -- % наценки для срока годности < 6 мес.
                                   WHEN vbMarginPercent_ExpirationDate > 0
                                    AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                        THEN vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)

                                   WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                       THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) -- % наценки в КАТЕГОРИИ
                                   ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)    -- % наценки в КАТЕГОРИИ
                              END
                            , CASE WHEN vbisTopNo_Unit = TRUE THEN SelectMinPrice_AllGoods.isTOP_Price   ELSE SelectMinPrice_AllGoods.isTop END                  -- ТОП позиция
                            , CASE WHEN vbisTopNo_Unit = TRUE THEN SelectMinPrice_AllGoods.PercentMarkup
                                   WHEN vbisMinPercentMarkup = TRUE THEN CASE WHEN COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) >
                                                                                   COALESCE (NULLIF (Object_Goods.PercentMarkup, 0), SelectMinPrice_AllGoods.PercentMarkup)
                                                                              THEN COALESCE (NULLIF (Object_Goods.PercentMarkup, 0), SelectMinPrice_AllGoods.PercentMarkup)
                                                                              ELSE COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) END
                                   ELSE COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) END -- % наценки у товара
                            , 0 /*ObjectFloat_Juridical_Percent.ValueData*/                                         -- % корректировки у Юр Лица для ТОПа
                            , CASE WHEN vbisTopNo_Unit = TRUE THEN
                                        CASE WHEN Object_Price.Fix = TRUE
                                             THEN Object_Price.Price ELSE 0
                                        END
                                   ELSE CASE WHEN Object_Price.Fix = TRUE
                                             THEN Object_Price.Price ELSE Object_Goods.Price
                                        END -- Цена у товара (почти фиксированная)
                              END
                             ) ::TFloat AS NewPrice

          , zfCalc_SalePrice(
                              (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)               -- Цена С НДС
                             --  * CASE WHEN vbObjectId = 4 THEN 1.015 ELSE 1 END                          -- 23.03. убрали  -- для сети НЕ БОЛЕЙ!!! к цене поставщика дополнительные +1.5 19.03.2020      ----  +3% - 17,03,2020 Люба
                            , CASE -- % наценки для срока годности < 6 мес.
                                   WHEN vbMarginPercent_ExpirationDate > 0
                                    AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                    AND COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                        THEN zfCalc_MarginPercent_PromoBonus (vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0),
                                                                              PromoBonus.Amount, vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus)
                                   -- % наценки для срока годности < 6 мес.
                                   WHEN vbMarginPercent_ExpirationDate > 0
                                    AND SelectMinPrice_AllGoods.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > zc_DateStart()
                                    AND SelectMinPrice_AllGoods.MinExpirationDate > CURRENT_DATE
                                        THEN zfCalc_MarginPercent_PromoBonus (vbMarginPercent_ExpirationDate + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0),
                                                                              PromoBonus.Amount, vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus)

                                   WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                       THEN zfCalc_MarginPercent_PromoBonus (MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0),
                                                                             PromoBonus.Amount, vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus) -- % наценки в КАТЕГОРИИ
                                   ELSE zfCalc_MarginPercent_PromoBonus (MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0),
                                                                         PromoBonus.Amount, vbUpperLimitPromoBonus, vbLowerLimitPromoBonus, vbMinPercentPromoBonus)    -- % наценки в КАТЕГОРИИ
                              END
                            , CASE WHEN vbisTopNo_Unit = TRUE THEN SelectMinPrice_AllGoods.isTOP_Price   ELSE SelectMinPrice_AllGoods.isTop END                  -- ТОП позиция
                            , CASE WHEN vbisTopNo_Unit = TRUE THEN SelectMinPrice_AllGoods.PercentMarkup
                                   WHEN vbisMinPercentMarkup = TRUE THEN CASE WHEN COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) >
                                                                                   COALESCE (NULLIF (Object_Goods.PercentMarkup, 0), SelectMinPrice_AllGoods.PercentMarkup)
                                                                              THEN COALESCE (NULLIF (Object_Goods.PercentMarkup, 0), SelectMinPrice_AllGoods.PercentMarkup)
                                                                              ELSE COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) END
                                   ELSE COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) END -- % наценки у товара
                            , 0 /*ObjectFloat_Juridical_Percent.ValueData*/                                         -- % корректировки у Юр Лица для ТОПа
                            , CASE WHEN vbisTopNo_Unit = TRUE THEN
                                        CASE WHEN Object_Price.Fix = TRUE
                                             THEN Object_Price.Price ELSE 0
                                        END
                                   ELSE CASE WHEN Object_Price.Fix = TRUE
                                             THEN Object_Price.Price ELSE Object_Goods.Price
                                        END -- Цена у товара (почти фиксированная)
                              END
                             ) ::TFloat AS NewPriceNew

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
            SelectMinPrice_AllGoods.MidPriceSale             AS MidPriceSale,
            SelectMinPrice_AllGoods.MaxPriceIncome           AS MaxPriceIncome,
            Object_Goods.NDSKindId,
            SelectMinPrice_AllGoods.isOneJuridical,
            CASE WHEN Select_Income_AllGoods.IncomeCount > 0 THEN TRUE ELSE FALSE END :: Boolean AS isIncome,
            SelectMinPrice_AllGoods.isTop AS isTop_calc,
            Object_Price.IsTop    AS IsTop,
            Object_Goods.IsTop    AS IsTop_Goods,
            Coalesce(ObjectBoolean_Goods_IsPromo.ValueData, False) :: Boolean   AS IsPromo,
            Coalesce(ObjectBoolean_Goods_Resolution_224.ValueData, False) :: Boolean   AS isResolution_224,
            Object_Goods.Price    AS PriceFix_Goods
        FROM
            lpSelectMinPrice_AllGoods(inUnitId   := inUnitId
                                    , inObjectId := -1 * vbObjectId -- !!!со знаком "-" что бы НЕ учитывать маркет. контракт!!!
                                    , inUserId   := vbUserId
                                    ) AS SelectMinPrice_AllGoods
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = SelectMinPrice_AllGoods.ContractId
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = SelectMinPrice_AllGoods.AreaId

            LEFT OUTER JOIN tmpPrice_View AS Object_Price
                                          ON Object_Price.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail
                                         AND Object_Price.UnitId = inUnitId

            LEFT OUTER JOIN tmpGoodsView AS Object_Goods
                                         -- !!!берем из сети!!!
                                         ON Object_Goods.Id = SelectMinPrice_AllGoods.GoodsId_retail -- SelectMinPrice_AllGoods.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                  ON ObjectFloat_Juridical_Percent.ObjectId = SelectMinPrice_AllGoods.JuridicalId
                                 AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

            LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                  ON ObjectFloat_Contract_Percent.ObjectId = SelectMinPrice_AllGoods.ContractId
                                 AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_unit
                                                     ON Object_MarginCategoryLink_unit.UnitId      = inUnitId
                                                    AND Object_MarginCategoryLink_unit.JuridicalId = SelectMinPrice_AllGoods.JuridicalId
                                                    AND Object_MarginCategoryLink_unit.isErased    = FALSE
            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                     ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                    AND Object_MarginCategoryLink_all.JuridicalId = SelectMinPrice_AllGoods.JuridicalId
                                                    AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                    AND Object_MarginCategoryLink_unit.JuridicalId IS NULL

            LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink_unit.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                      AND (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

            LEFT JOIN lpSelect_Income_AllGoods(inUnitId := inUnitId,
                                               inUserId := vbUserId) AS Select_Income_AllGoods
                                                                     ON Select_Income_AllGoods.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                    ON ObjectBoolean_Goods_IsPromo.ObjectId = SelectMinPrice_AllGoods.Partner_GoodsId
                                   AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Resolution_224
                                    ON ObjectBoolean_Goods_Resolution_224.ObjectId = Object_Price.GoodsMainId
                                   AND ObjectBoolean_Goods_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

            LEFT JOIN PromoBonus ON PromoBonus.GoodsId = Object_Price.GoodsMainId

        WHERE Object_Goods.isSp = FALSE
         -- AND COALESCE (ObjectBoolean_Juridical_UseReprice.ValueData, FALSE) = True
    )

  , tmpGoodsRepriceAll AS (SELECT tmp.Name
                           FROM gpSelect_Object_GoodsReprice (inSession) AS tmp
                           WHERE tmp.isErased = FALSE
                             AND tmp.isEnabled = TRUE
                           )
  , tmpGoodsReprice AS (SELECT DISTINCT ResultSet.Id_retail AS GoodsId
                        FROM ResultSet
                             INNER JOIN tmpGoodsRepriceAll ON UPPER (ResultSet.GoodsName) Like ('%'|| UPPER (tmpGoodsRepriceAll.Name) ||'%')
                        )


    ----
    SELECT
        ResultSet.Id_retail AS Id,
        ResultSet.Id        AS Id_retail,
        ResultSet.Code,
        ResultSet.GoodsName,
        ResultSet.LastPrice,
        ResultSet.RemainsCount,
        ResultSet.NDS,
        ResultSet.NewPrice,
        ResultSet.NewPriceNew,
        ResultSet.PriceFix_Goods,
        COALESCE(MarginCondition.MarginPercent,30)::TFloat AS MinMarginPercent,
        CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                   ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
              END AS NUMERIC (16, 1)) :: TFloat AS PriceDiff,

        ResultSet.ExpirationDate         AS ExpirationDate,
        ResultSet.JuridicalId            AS JuridicalId,
        ResultSet.JuridicalName          AS JuridicalName,
        ResultSet.Juridical_Price        AS Juridical_Price,
        ResultSet.MarginPercent          AS MarginPercent,
        ResultSet.MarginPercentBonus     AS MarginPercentBonus,
        ResultSet.PromoBonus             AS PromoBonus,
        ResultSet.Partner_GoodsName      AS Juridical_GoodsName,
        ResultSet.ProducerName           AS ProducerName,
        ResultSet.ContractId,
        ResultSet.ContractName,
        ResultSet.AreaId,
        ResultSet.AreaName,
        ObjectFloat_Juridical_Percent.ValueData  ::TFloat AS Juridical_Percent,
        ObjectFloat_Contract_Percent.ValueData   ::TFloat AS Contract_Percent,
        ROUND ((ResultSet.NewPrice - ResultSet.LastPrice) * ResultSet.RemainsCount, 2) :: TFloat AS SumReprice,
        ResultSet.MaxPriceIncome :: TFloat,
        ResultSet.MidPriceSale,
        CAST (CASE WHEN COALESCE(ResultSet.MidPriceSale,0) = 0 THEN 0 ELSE ((ResultSet.NewPrice / ResultSet.MidPriceSale) * 100 - 100) END AS NUMERIC (16, 1)) :: TFloat AS MidPriceDiff,
        ResultSet.MinExpirationDate,
        ResultSet.isOneJuridical,
        ResultSet.isPriceFix,
        ResultSet.isIncome,
        ResultSet.IsTop,
        -- CASE WHEN ResultSet.isTop_calc = TRUE THEN ResultSet.isTop_calc ELSE ResultSet.IsTop END :: Boolean AS IsTop,
        ResultSet.IsTop_Goods,
        vbisTopNo_Unit AS isTopNo_Unit,
        ResultSet.IsPromo,
        ResultSet.isResolution_224,
        COALESCE (ObjectBoolean_Juridical_UseReprice.ValueData, FALSE) :: Boolean  AS isUseReprice,
        CASE WHEN      (ResultSet.ExpirationDate + INTERVAL '6 month' < ResultSet.MinExpirationDate)
                   AND (ResultSet.ExpirationDate < CURRENT_DATE + INTERVAL '6 month')
                  THEN FALSE
             WHEN COALESCE (ResultSet.IsTop_Goods, FALSE) = FALSE
                        AND ResultSet.MinExpirationDate > zc_DateStart()
                        AND ResultSet.MinExpirationDate <= CURRENT_DATE
                  THEN FALSE
             WHEN COALESCE (ResultSet.IsTop_Goods, FALSE) = FALSE
                        AND ResultSet.MinExpirationDate <= (CURRENT_DATE + vbInterval_ExpirationDate)
                        AND ResultSet.MinExpirationDate > zc_DateStart()
                        AND COALESCE (vbMarginPercent_ExpirationDate, 0) = 0
                  THEN FALSE
             WHEN ResultSet.isPriceFix = TRUE OR ResultSet.PriceFix_Goods <> 0
                  THEN TRUE
             ELSE TRUE
        END
        -- Временно прикрыл товар постановление для переоценки
        AND (ResultSet.isResolution_224 = FALSE
          OR ResultSet.isResolution_224 = TRUE AND (COALESCE(ResultSet.NDSKindId,0) <> zc_Enum_NDSKind_Common() OR ResultSet.IsTop = FALSE) AND
             ABS(CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                             ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
                        END AS NUMERIC (16, 1)) :: TFloat) <= 10
          OR ResultSet.isResolution_224 = TRUE AND COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Common() AND ResultSet.IsTop = TRUE AND
             CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                             ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
                        END AS NUMERIC (16, 1)) :: TFloat BETWEEN - 10 AND 0) AS Reprice,

        CASE WHEN tmpGoodsReprice.GoodsId IS NOT NULL THEN TRUE ELSE FALSE END AS isGoodsReprice,
        
        ResultSet.isTop_calc

    FROM
        ResultSet
        LEFT OUTER JOIN MarginCondition ON MarginCondition.MarginCategoryId = vbMarginCategoryId
                                       AND ResultSet.LastPrice >= MarginCondition.MinPrice
                                       AND ResultSet.LastPrice < MarginCondition.MaxPrice

        LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                              ON ObjectFloat_Juridical_Percent.ObjectId = ResultSet.JuridicalId
                             AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
        LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                              ON ObjectFloat_Contract_Percent.ObjectId = ResultSet.ContractId
                             AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

        LEFT JOIN tmpGoodsReprice ON tmpGoodsReprice.GoodsId = ResultSet.Id_retail

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Juridical_UseReprice
                                ON ObjectBoolean_Juridical_UseReprice.ObjectId = ResultSet.JuridicalId
                               AND ObjectBoolean_Juridical_UseReprice.DescId = zc_ObjectBoolean_Juridical_UseReprice()


    WHERE
/*       ((COALESCE(ResultSet.NewPrice,0) > 0
         AND (ResultSet.ExpirationDate IS NULL
           OR ResultSet.ExpirationDate = '1899-12-30'::TDateTime
           OR ResultSet.ExpirationDate <= zc_DateStart()
           OR ResultSet.ExpirationDate > (CURRENT_DATE + vbInterval_ExpirationDate)
           OR (vbMarginPercent_ExpirationDate > 0
           AND ResultSet.ExpirationDate > CURRENT_DATE
              )
             )
         AND (COALESCE(ResultSet.LastPrice,0) = 0
           OR ABS (CASE WHEN COALESCE (ResultSet.LastPrice,0) = 0 THEN 0.0
                        ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
                   END
                  ) >= COALESCE (MarginCondition.MarginPercent, 30)
             )
       ))
   AND*/ ResultSet.isPriceFix = FALSE
   AND ResultSet.RemainsCount > 0
   AND ResultSet.PromoBonus <> 0
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.02.21                                                       *

*/

-- тест
--
SELECT MarginPercentBonus, * FROM gpReport_GoodsPrice_PromoBonus (22188745, 375626, '3') order by ID