-- Function: gpSelect_AllGoodsPrice_Site()

DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice_Site (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AllGoodsPrice_Site(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    Id                  Integer,    -- ИД товара  !!!ВСЕГДА СЕТИ, не так как в других запросах!!!
    Id_retail           Integer,    -- ИД товара  !!!ВСЕГДА НБ, не так как в дргих запросах!!!
    Code                Integer,    -- Код товара
    GoodsName           TVarChar,   -- Наименование товара
    LastPrice           TFloat,     -- Текущая цена
    RemainsCount        TFloat,     -- Остаток
    NDS                 TFloat,     -- ставка НДС
    NewPriceCalc        TFloat,     -- Новая цена согласно прайса (прихода)
    NewPriceMidUnit     TFloat,     -- Новая цена от средней цены аптеки
    NewPrice            TFloat,     -- Новая цена для переоценки
    PriceFix_Goods      TFloat  ,   -- фиксированная цена сети
    
    MinMarginPercent    TFloat,     -- минимальный % отклонения
    PriceDiff           TFloat,     -- % отклонения
    ExpirationDate      TDateTime,  -- Срок годности
    JuridicalId         Integer,    -- Поставщик Id
    JuridicalName       TVarChar,   -- Поставщик
    Juridical_Price     TFloat,     -- Цена у поставщика
    MarginPercent       TFloat,     -- % наценки
    Juridical_GoodsName TVarChar,   -- Наименование у поставщика
    ProducerName        TVarChar,   -- производитель
    ContractId          Integer,    -- договор Ид
    
    ContractName        TVarChar,   -- договор
    AreaId              Integer,    -- ренгион ИД
    AreaName            TVarChar,   -- регион
    Juridical_Percent   TFloat,     -- % Корректировки наценки Поставщика
    Contract_Percent    TFloat,     -- % Корректировки наценки Договора
    SumReprice          TFloat,     -- сумма переоценки
    MidPriceIncome      TFloat,     -- ср цена партий
    MinPriceIncome      TFloat,     -- мин цена партий
    MaxPriceIncome      TFloat,     -- макс цена партий
    MidPriceSale        TFloat,     -- средняя цена остатка
    
    MidPriceUnit        TFloat,     -- Средняя отпускная цена в аптеках
    PriceUnitBase       TFloat,     -- Средняя цена в аптеках без наценки
    MidPriceDiff        TFloat,     -- отклонение от средняя цена остатка
    UnitPriceDiff       TFloat,     -- отклонение от минимальной цена подразделений
    MidPriceUnitDiff    TFloat,     -- отклонение цен остатка в подразделениях
    MinExpirationDate   TDateTime,  -- Минимальный срок годности препарата на точке
    isOneJuridical      Boolean ,   -- один поставщик (да/нет)
    isPriceFix          Boolean ,   -- фиксированная цена точки
    PricePercentMarkup  TFloat,     -- Процент наценки по прайсу
    IsTop_Goods         Boolean ,   -- Топ сети
    IsPromo             Boolean ,   -- Акция
    
    isResolution_224    Boolean ,   -- Постановление 224
    isUseReprice        Boolean ,   -- Переоценивать в ночной переоценке
    Reprice             Boolean ,   --
    isNewPrice          Boolean ,   --
    isGoodsReprice      Boolean ,   --
    isPromoBonus         Boolean,   -- По маркетинговому бонусу
    AddPercentRepriceMin TFloat ,   -- Изменение в ночной переоценке низнего предела

    JuridicalPromoOneId     Integer,    -- Поставщик Id
    JuridicalPromoOneName   TVarChar,   -- Поставщик 
    ContractPromoOneId      Integer,    -- договор Ид
    ContractPromoOneName    TVarChar,   -- договор 
    Juridical_PricePromoOne     TFloat,     -- Цена у поставщика
    ExpirationDateOne           TDateTime,  -- Срок годности
    Juridical_PercentPromoOne   TFloat,     -- % Корректировки наценки Поставщика
    Contract_PercentPromoOne    TFloat,     -- % Корректировки наценки Договора
    
    JuridicalPromoTwoId     Integer,    -- Поставщик Id
    JuridicalPromoTwoName   TVarChar,   -- Поставщик 
    ContractPromoTwoId      Integer,    -- договор Ид
    ContractPromoTwoName    TVarChar,   -- договор 
    Juridical_PricePromoTwo     TFloat,     -- Цена у поставщика
    ExpirationDateTwo           TDateTime,  -- Срок годности
    Juridical_PercentPromoTwo   TFloat,     -- % Корректировки наценки Поставщика
    Contract_PercentPromoTwo    TFloat,     -- % Корректировки наценки Договора

    Juridical_PricePromo TFloat,     -- Цена у поставщика средняя
    NewPricePromoCalc    TFloat,     -- Новая цена расчетная
    NewPricePromo        TFloat,     -- Новая цена
    PriceDiffPromo       TFloat,     -- % отклонения
    RepricePromo         Boolean ,   --
    AddPercentRepricePromoMin TFloat    -- Изменение в ночной переоценке низнего предела
    )

AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbObjectId         Integer;
  DECLARE vbUpperLimitPromoBonus TFloat;
  DECLARE vbLowerLimitPromoBonus TFloat;
  DECLARE vbMinPercentPromoBonus TFloat;
  DECLARE vbMarginPercent TFloat;
  DECLARE vbMarginPercentPromo TFloat;
BEGIN
    vbUserId := inSession;
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

  vbMarginPercent := 4;
  vbMarginPercentPromo := 2;

  RETURN QUERY
    WITH ObjectLink_Child_NB
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
                   FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
                -- WHERE 1=0
                  )

  , tmpGoodsView AS (SELECT Object_Goods_View.*
                          , COALESCE (tmpGoodsSP.isSP, False)   ::Boolean   AS isSP
                          , COALESCE (Goods_SummaWages.ValueData, 0) > 0 OR
                            COALESCE (Goods_SummaWages.ValueData, 0) > 0    AS isSpecial
                     FROM Object_Goods_View
                         -- получаем GoodsMainId
                         LEFT JOIN  ObjectLink AS ObjectLink_Child
                                               ON ObjectLink_Child.ChildObjectId = Object_Goods_View.Id
                                              AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                         LEFT JOIN ObjectLink AS ObjectLink_Main
                                              ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                             AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                         LEFT JOIN ObjectFloat AS Goods_SummaWages
                                ON Goods_SummaWages.ObjectId = Object_Goods_View.Id
                               AND Goods_SummaWages.DescId = zc_ObjectFloat_Goods_SummaWages()

                         LEFT JOIN ObjectFloat AS PercentWages
                                ON PercentWages.ObjectId = Object_Goods_View.Id
                               AND PercentWages.DescId = zc_ObjectFloat_Goods_PercentWages()

                         LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId

                     WHERE Object_Goods_View.ObjectId = vbObjectId
                     )

  , tmpPrice_View AS (SELECT Object_PriceSite.Id                        AS Id
                           , ROUND(Price_Value.ValueData,2)::TFloat     AS Price
                           , Price_Goods.ChildObjectId                  AS GoodsId
                           , COALESCE(Price_Fix.ValueData,False)        AS isFix
                           , COALESCE(Price_PercentMarkup.ValueData, 0) AS PercentMarkup
                      FROM Object AS Object_PriceSite
                           LEFT JOIN ObjectLink AS Price_Goods
                                  ON Price_Goods.ObjectId = Object_PriceSite.Id
                                 AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                  ON Price_Value.ObjectId = Object_PriceSite.Id
                                 AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                           LEFT JOIN ObjectBoolean AS Price_Fix
                                  ON Price_Fix.ObjectId = Object_PriceSite.Id
                                 AND Price_Fix.DescId = zc_ObjectBoolean_PriceSite_Fix()
                           LEFT JOIN ObjectFloat AS Price_PercentMarkup
                                  ON Price_PercentMarkup.ObjectId = Object_PriceSite.Id
                                 AND Price_PercentMarkup.DescId = zc_ObjectFloat_PriceSite_PercentMarkup()

                      WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                      )

  , PromoBonus AS (SELECT PromoBonus.Id                            AS Id
                        , PromoBonus.GoodsMainId                   AS GoodsId
                        , PromoBonus.Amount                        AS Amount
                   FROM gpSelect_PromoBonus_GoodsWeek (inSession) AS PromoBonus
                   WHERE vbObjectId = 4)
  , tmpGoodsDiscount AS (SELECT ObjectLink_BarCode_Goods.ChildObjectId                     AS GoodsId
                              , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat   AS MaxPrice 
                         FROM Object AS Object_BarCode
                              INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                    ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                   AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                             -- INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                              INNER JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                     ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                    AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                                                     
                         WHERE Object_BarCode.DescId = zc_Object_BarCode()
                           AND Object_BarCode.isErased = False
                           AND COALESCE(ObjectFloat_MaxPrice.ValueData, 0) > 0
                         GROUP BY ObjectLink_BarCode_Goods.ChildObjectId)
  , ResultSet AS
    (
        SELECT
            SelectMinPrice_AllGoods.GoodsId AS Id
          , SelectMinPrice_AllGoods.GoodsId_retail AS Id_retail
          , SelectMinPrice_AllGoods.GoodsCode AS Code
          , SelectMinPrice_AllGoods.GoodsName AS GoodsName
          , Object_Price.Price                AS LastPrice
          , Object_Price.isFix                AS isPriceFix
          , Object_Price.PercentMarkup        AS PricePercentMarkup
          , SelectMinPrice_AllGoods.Remains   AS RemainsCount
          , Object_Goods.NDS                  AS NDS
          , CASE WHEN COALESCE(PromoBonus.Amount, 0) = 0 THEN vbMarginPercent ELSE vbMarginPercentPromo END::TFloat AS MinMarginPercent
          , COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), COALESCE (Object_Goods.PercentMarkup, 0))::TFloat AS MarginPercent
          , (SelectMinPrice_AllGoods.Price * (100 + Object_Goods.NDS)/100)::TFloat AS Juridical_Price
          , zfCalc_SalePriceSite(
                              (COALESCE(NULLIF(SelectMinPrice_AllGoods.Price, 0), SelectMinPrice_AllGoods.MidPriceIncome) * (100 + Object_Goods.NDS)/100)               -- Цена С НДС
                            , CASE WHEN COALESCE(PromoBonus.Amount, 0) = 0 THEN vbMarginPercent ELSE vbMarginPercentPromo END
                            , Object_Goods.isTop                                                            -- ТОП позиция
                            , Object_Goods.isSpecial                                                        -- позиция спец условия
                            , COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) -- % наценки у товара
                            , Object_Price.PercentMarkup
                            , CASE WHEN Object_Price.isFix = TRUE THEN Object_Price.Price ELSE 0 END -- Цена у товара (почти фиксированная)
                            , Object_Goods.Price   -- % Цена у товара фиксированная
                            , tmpGoodsDiscount.MaxPrice
                             ) ::TFloat AS NewPrice
          , zfCalc_SalePriceSiteUnit(
                              SelectMinPrice_AllGoods.PriceUnitBase            -- Цена С НДС
                            , CASE WHEN COALESCE(PromoBonus.Amount, 0) = 0 THEN vbMarginPercent ELSE vbMarginPercentPromo END
                            , Object_Goods.isTop                                                            -- ТОП позиция
                            , Object_Goods.isSpecial                                                        -- позиция спец условия
                            , COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) -- % наценки у товара
                            , Object_Price.PercentMarkup
                            , CASE WHEN Object_Price.isFix = TRUE THEN Object_Price.Price ELSE 0 END -- Цена у товара (почти фиксированная)
                            , Object_Goods.Price   -- % Цена у товара
                            ,  tmpGoodsDiscount.MaxPrice
                             ) ::TFloat AS NewPriceMidUnit
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
            SelectMinPrice_AllGoods.MidPriceUnit             AS MidPriceUnit,
            SelectMinPrice_AllGoods.PriceUnitBase            AS PriceUnitBase,
            SelectMinPrice_AllGoods.MidPriceUnitDiff         AS MidPriceUnitDiff,
            SelectMinPrice_AllGoods.MidPriceIncome           AS MidPriceIncome,
            SelectMinPrice_AllGoods.MinPriceIncome           AS MinPriceIncome,
            SelectMinPrice_AllGoods.MaxPriceIncome           AS MaxPriceIncome,
            Object_Goods.NDSKindId,
            SelectMinPrice_AllGoods.isOneJuridical,
            SelectMinPrice_AllGoods.isTop AS isTop_calc,
            Object_Goods.IsTop            AS IsTop_Goods,
            Coalesce(ObjectBoolean_Goods_IsPromo.ValueData, False) :: Boolean   AS IsPromo,
            Coalesce(ObjectBoolean_Goods_Resolution_224.ValueData, False) :: Boolean   AS isResolution_224,
            Object_Goods.Price    AS PriceFix_Goods,
            CASE WHEN COALESCE(PromoBonus.Amount, 0) <> 0 
                 THEN TRUE
                 ELSE FALSE  END::Boolean   AS isPromoBonus,

            SelectMinPrice_AllGoods.isJuridicalPromo,
            
            SelectMinPrice_AllGoods.JuridicalPromoOneId,
            Object_JuridicalPromoOne.ValueData                                               AS JuridicalPromoOneName,
            SelectMinPrice_AllGoods.ContractPromoOneId,
            Object_ContractPromoOne.ValueData                                                AS ContractPromoOneName,
            (SelectMinPrice_AllGoods.PricePromoOne * (100 + Object_Goods.NDS)/100)::TFloat  AS Juridical_PricePromoOne,
            SelectMinPrice_AllGoods.PartionGoodsDateOne,
            ObjectFloat_JuridicalPromoOne_Percent.ValueData                                     AS Juridical_PercentPromoOne,
            ObjectFloat_ContractPromoOne_Percent.ValueData                                      AS Contract_PercentPromoOne,

            SelectMinPrice_AllGoods.JuridicalPromoTwoId,
            Object_JuridicalPromoTwo.ValueData                                              AS JuridicalPromoTwoName,
            SelectMinPrice_AllGoods.ContractPromoTwoId,
            Object_ContractPromoTwo.ValueData                                               AS ContractPromoTwoName,
            (SelectMinPrice_AllGoods.PricePromoTwo * (100 + Object_Goods.NDS)/100)::TFloat  AS Juridical_PricePromoTwo,
            SelectMinPrice_AllGoods.PartionGoodsDateTwo,
            ObjectFloat_JuridicalPromoTwo_Percent.ValueData   AS Juridical_PercentPromoTwo,
            ObjectFloat_ContractPromoTwo_Percent.ValueData    AS Contract_PercentPromoTwo,

            SelectMinPrice_AllGoods.PricePromo,
            zfCalc_SalePriceSite(
                              (SelectMinPrice_AllGoods.PricePromo * (100 + Object_Goods.NDS)/100)               -- Цена С НДС
                            , CASE WHEN COALESCE(PromoBonus.Amount, 0) = 0 THEN vbMarginPercent ELSE vbMarginPercentPromo END
                            , Object_Goods.isTop                                                            -- ТОП позиция
                            , Object_Goods.isSpecial                                                        -- позиция спец условия
                            , COALESCE (NULLIF (SelectMinPrice_AllGoods.PercentMarkup, 0), Object_Goods.PercentMarkup) -- % наценки у товара
                            , Object_Price.PercentMarkup
                            , CASE WHEN Object_Price.isFix = TRUE THEN Object_Price.Price ELSE 0 END -- Цена у товара (почти фиксированная)
                            , Object_Goods.Price -- % Цена у товара
                            , tmpGoodsDiscount.MaxPrice
                             ) ::TFloat AS NewPricePromo

        FROM
            lpSelectMinPrice_AllGoodsSite(inObjectId := vbObjectId -- !!!со знаком "-" что бы НЕ учитывать маркет. контракт!!!
                                        , inUserId   := vbUserId
                                          ) AS SelectMinPrice_AllGoods
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = SelectMinPrice_AllGoods.ContractId
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = SelectMinPrice_AllGoods.AreaId

            LEFT JOIN Object AS Object_JuridicalPromoOne ON Object_JuridicalPromoOne.Id = SelectMinPrice_AllGoods.JuridicalPromoOneId
            LEFT JOIN Object AS Object_ContractPromoOne ON Object_ContractPromoOne.Id = SelectMinPrice_AllGoods.ContractPromoOneId

            LEFT JOIN Object AS Object_JuridicalPromoTwo ON Object_JuridicalPromoTwo.Id = SelectMinPrice_AllGoods.JuridicalPromoTwoId
            LEFT JOIN Object AS Object_ContractPromoTwo ON Object_ContractPromoTwo.Id = SelectMinPrice_AllGoods.ContractPromoTwoId

            LEFT OUTER JOIN tmpPrice_View AS Object_Price
                                          ON Object_Price.GoodsId = SelectMinPrice_AllGoods.GoodsId_retail

            LEFT OUTER JOIN tmpGoodsView AS Object_Goods
                                         -- !!!берем из сети!!!
                                         ON Object_Goods.Id = SelectMinPrice_AllGoods.GoodsId_retail -- SelectMinPrice_AllGoods.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                  ON ObjectFloat_Juridical_Percent.ObjectId = SelectMinPrice_AllGoods.JuridicalId
                                 AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
            LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalPromoOne_Percent
                                  ON ObjectFloat_JuridicalPromoOne_Percent.ObjectId = SelectMinPrice_AllGoods.JuridicalPromoOneId
                                 AND ObjectFloat_JuridicalPromoOne_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
            LEFT JOIN ObjectFloat AS ObjectFloat_JuridicalPromoTwo_Percent
                                  ON ObjectFloat_JuridicalPromoTwo_Percent.ObjectId = SelectMinPrice_AllGoods.JuridicalPromoTwoId
                                 AND ObjectFloat_JuridicalPromoTwo_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

            LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                  ON ObjectFloat_Contract_Percent.ObjectId = SelectMinPrice_AllGoods.ContractId
                                 AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

            LEFT JOIN ObjectFloat AS ObjectFloat_ContractPromoOne_Percent
                                  ON ObjectFloat_ContractPromoOne_Percent.ObjectId = SelectMinPrice_AllGoods.ContractPromoOneId
                                 AND ObjectFloat_ContractPromoOne_Percent.DescId = zc_ObjectFloat_Contract_Percent()
            LEFT JOIN ObjectFloat AS ObjectFloat_ContractPromoTwo_Percent
                                  ON ObjectFloat_ContractPromoTwo_Percent.ObjectId = SelectMinPrice_AllGoods.ContractPromoTwoId
                                 AND ObjectFloat_ContractPromoTwo_Percent.DescId = zc_ObjectFloat_Contract_Percent()

            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                     ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                    AND Object_MarginCategoryLink_all.JuridicalId = SelectMinPrice_AllGoods.JuridicalId
                                                    AND Object_MarginCategoryLink_all.isErased    = FALSE

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                    ON ObjectBoolean_Goods_IsPromo.ObjectId = SelectMinPrice_AllGoods.Partner_GoodsId
                                   AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Resolution_224
                                    ON ObjectBoolean_Goods_Resolution_224.ObjectId = SelectMinPrice_AllGoods.GoodsId_Main
                                   AND ObjectBoolean_Goods_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

            LEFT JOIN PromoBonus ON PromoBonus.GoodsId = SelectMinPrice_AllGoods.GoodsId_Main

            LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsId = SelectMinPrice_AllGoods.GoodsId

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
  , tmpPriorities AS (SELECT DISTINCT Object_Goods_Retail.ID AS GoodsId
                      FROM Object AS Object_JuridicalPriorities

                          INNER JOIN ObjectLink AS ObjectLink_JuridicalPriorities_Goods
                                               ON ObjectLink_JuridicalPriorities_Goods.ObjectId = Object_JuridicalPriorities.Id
                                              AND ObjectLink_JuridicalPriorities_Goods.DescId = zc_ObjectLink_JuridicalPriorities_Goods()
                          INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = ObjectLink_JuridicalPriorities_Goods.ChildObjectId

                      WHERE Object_JuridicalPriorities.DescId = zc_Object_JuridicalPriorities()
                        AND Object_JuridicalPriorities.isErased =False  )

    ----
    SELECT
        ResultSet.Id_retail AS Id,
        ResultSet.Id        AS Id_retail,
        ResultSet.Code,
        ResultSet.GoodsName,
        ResultSet.LastPrice,
        ResultSet.RemainsCount,
        ResultSet.NDS,
        ResultSet.NewPrice         AS NewPriceCalc,
        ResultSet.NewPriceMidUnit  AS NewPriceMidUnit,
                
        CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                  COALESCE (ResultSet.NewPrice, 0) > 0 AND ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                  COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
               OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPrice, 0) > 0 AND 
                  ResultSet.NewPrice <= ResultSet.MidPriceUnit AND
                  COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10
             THEN ResultSet.NewPrice
             ELSE ResultSet.NewPriceMidUnit END :: TFloat AS NewPrice,
             
        ResultSet.PriceFix_Goods,
        ResultSet.MinMarginPercent,
        CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                   ELSE (CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                                   COALESCE (ResultSet.NewPrice, 0) > 0 AND ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                                   COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                                OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPrice, 0) > 0 AND 
                                   ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                                   COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10              
                              THEN ResultSet.NewPrice
                              ELSE ResultSet.NewPriceMidUnit END / ResultSet.LastPrice) * 100 - 100
              END AS NUMERIC (16, 1)) :: TFloat AS PriceDiff,
 
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

        ROUND ((CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                          COALESCE (ResultSet.NewPrice, 0) > 0 AND ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                          COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                       OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPrice, 0) > 0 AND  
                          ResultSet.NewPrice <= ResultSet.MidPriceUnit AND
                          COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10              
                     THEN ResultSet.NewPrice
                     ELSE ResultSet.NewPriceMidUnit END - ResultSet.LastPrice) * ResultSet.RemainsCount, 2) :: TFloat AS SumReprice,
       (ResultSet.MidPriceIncome * (100 + ResultSet.NDS)/100)::TFloat AS MidPriceIncome,
       (ResultSet.MinPriceIncome * (100 + ResultSet.NDS)/100)::TFloat AS MinPriceIncome,
       (ResultSet.MaxPriceIncome * (100 + ResultSet.NDS)/100)::TFloat AS MaxPriceIncome,
        ResultSet.MidPriceSale,
        ResultSet.MidPriceUnit,        
        ResultSet.PriceUnitBase,
        CAST (CASE WHEN COALESCE(ResultSet.MidPriceSale,0) = 0 
                   THEN 100 
                   ELSE ((CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                                    COALESCE (ResultSet.NewPrice, 0) > 0 AND ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                                    COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                                 OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPrice, 0) > 0 AND 
                                    ResultSet.NewPrice <= ResultSet.MidPriceUnit AND
                                    COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10              
                               THEN ResultSet.NewPrice
                               ELSE ResultSet.NewPriceMidUnit END
                                  / ResultSet.MidPriceSale) * 100 - 100) END AS NUMERIC (16, 1)) :: TFloat AS MidPriceDiff,
        CAST (CASE WHEN COALESCE(ResultSet.MidPriceUnit,0) = 0 
                   THEN 100 
                   ELSE ((CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                                    COALESCE (ResultSet.NewPrice, 0) > 0 AND ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                                    COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                                 OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPrice, 0) > 0 AND 
                                    ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                                    COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10              
                               THEN ResultSet.NewPrice
                               ELSE ResultSet.NewPriceMidUnit END
                                  / ResultSet.MidPriceUnit) * 100 - 100) END AS NUMERIC (16, 1)) :: TFloat AS UnitPriceDiff,
        ResultSet.MidPriceUnitDiff,
        ResultSet.MinExpirationDate,
        ResultSet.isOneJuridical,
        ResultSet.isPriceFix,
        ResultSet.PricePercentMarkup:: TFloat,
        ResultSet.IsTop_Goods,
        ResultSet.IsPromo,
        ResultSet.isResolution_224,
        COALESCE (ObjectBoolean_Juridical_UseReprice.ValueData, FALSE) OR
          ResultSet.isPromoBonus AND ResultSet.isJuridicalPromo  AS isUseReprice,
                  
          -- Признак переоценки
        COALESCE(CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPrice <= ResultSet.MidPriceUnit  AND 
                           COALESCE (ResultSet.NewPrice, 0) > 0 AND ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                           COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                        OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPrice, 0) > 0 AND 
                           ResultSet.NewPrice <= ResultSet.MidPriceUnit AND
                           COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10              
                      THEN ResultSet.NewPrice
                      ELSE ResultSet.NewPriceMidUnit END, 0) > 0 AS Reprice,

          -- Признак переоценки
        COALESCE(CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPrice <= ResultSet.MidPriceUnit  AND 
                           COALESCE (ResultSet.NewPrice, 0) > 0 AND ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                           COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                        OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPrice, 0) > 0 AND 
                           ResultSet.NewPrice <= ResultSet.MidPriceUnit AND
                           COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10              
                      THEN ResultSet.NewPrice
                      ELSE ResultSet.NewPriceMidUnit END, 0) > 0 AND 
        COALESCE(CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                           COALESCE (ResultSet.NewPrice, 0) > 0 AND ResultSet.NewPrice <= ResultSet.MidPriceUnit AND 
                           COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                        OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPrice, 0) > 0 AND 
                           ResultSet.NewPrice <= ResultSet.MidPriceUnit AND
                           COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPrice) * 100 - 100), 0) <= 10
                      THEN ResultSet.NewPrice
                      ELSE ResultSet.NewPriceMidUnit END, 0) <> COALESCE(ResultSet.LastPrice, 0) AS isNewPrice,

        CASE WHEN tmpGoodsReprice.GoodsId IS NOT NULL THEN TRUE ELSE FALSE END AS isGoodsReprice,

        ResultSet.isPromoBonus                                                 AS isPromoBonus,
        CASE WHEN ResultSet.isPromoBonus AND ResultSet.isJuridicalPromo
             THEN -5 ELSE 0 END::TFloat                                        AS AddPercentRepriceMin,

        ResultSet.JuridicalPromoOneId  ,
        ResultSet.JuridicalPromoOneName  ,
        ResultSet.ContractPromoOneId ,
        ResultSet.ContractPromoOneName ,
        ResultSet.Juridical_PricePromoOne ,
        ResultSet.PartionGoodsDateOne,
        ResultSet.Juridical_PercentPromoOne,
        ResultSet.Contract_PercentPromoOne,

        ResultSet.JuridicalPromoTwoId ,
        ResultSet.JuridicalPromoTwoName ,
        ResultSet.ContractPromoTwoId ,
        ResultSet.ContractPromoTwoName ,
        ResultSet.Juridical_PricePromoTwo ,
        ResultSet.PartionGoodsDateTwo,
        ResultSet.Juridical_PercentPromoTwo,
        ResultSet.Contract_PercentPromoTwo,
        
        ResultSet.PricePromo                                             AS Juridical_PricePromo,
        ResultSet.NewPricePromo                                          AS NewPricePromoCalc,

        CASE WHEN COALESCE (ResultSet.NewPricePromo, 0) = 0 THEN NULL
             ELSE CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND 
                            COALESCE (ResultSet.NewPricePromo, 0) > 0 AND ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND 
                            COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPricePromo) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                         OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPricePromo, 0) > 0 AND 
                            ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND
                            COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPricePromo) * 100 - 100), 0) <= 10
                       THEN ResultSet.NewPricePromo
                       ELSE ResultSet.NewPriceMidUnit END END :: TFloat AS NewPricePromo,

        CASE WHEN COALESCE (ResultSet.NewPricePromo, 0) = 0 THEN NULL
             ELSE CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                             ELSE (CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND 
                                             COALESCE (ResultSet.NewPricePromo, 0) > 0 AND ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND 
                                             COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPricePromo) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                                          OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPricePromo, 0) > 0 AND 
                                             ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND
                                             COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPricePromo) * 100 - 100), 0) <= 10
                                        THEN ResultSet.NewPricePromo
                                        ELSE ResultSet.NewPriceMidUnit END / ResultSet.LastPrice) * 100 - 100
                        END AS NUMERIC (16, 1)) END :: TFloat AS PriceDiffPromo,

        CASE WHEN COALESCE (ResultSet.NewPricePromo, 0) = 0 THEN FALSE ELSE TRUE END
        AND
        CASE WHEN (ResultSet.isPriceFix = TRUE OR ResultSet.PriceFix_Goods <> 0)
                  THEN TRUE
             ELSE TRUE
        END
        -- Временно прикрыл товар постановление для переоценки
        AND (ResultSet.isResolution_224 = FALSE
          OR ResultSet.isResolution_224 = TRUE AND (COALESCE(ResultSet.NDSKindId,0) <> zc_Enum_NDSKind_Common()) AND
             ABS(CAST (CASE WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                             ELSE (CASE WHEN COALESCE (ResultSet.Juridical_Price, 0) > 0 AND (ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND 
                                             COALESCE (ResultSet.NewPricePromo, 0) > 0 AND ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND 
                                             COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPricePromo) * 100 - 100), 0) <= 10 or ResultSet.IsTop_Goods = True)
                                          OR COALESCE (ResultSet.Juridical_Price, 0) = 0 AND COALESCE (ResultSet.NewPricePromo, 0) > 0 AND 
                                             ResultSet.NewPricePromo < ResultSet.MidPriceUnit AND
                                             COALESCE ( Abs((ResultSet.MidPriceUnit / ResultSet.NewPricePromo) * 100 - 100), 0) <= 10
                                        THEN ResultSet.NewPricePromo
                                        ELSE ResultSet.NewPriceMidUnit END / ResultSet.LastPrice) * 100 - 100
                        END AS NUMERIC (16, 1)) :: TFloat) <= 10)
        AND COALESCE(tmpPriorities.GoodsId, 0) = 0                               AS RepricePromo,
        (-5) ::TFloat                                                          AS AddPercentRepricePromoMin


    FROM
        ResultSet

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
                               
        LEFT JOIN tmpPriorities ON tmpPriorities.GoodsId = ResultSet.Id

    WHERE ResultSet.RemainsCount > 0
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. Шаблий О.В.
 08.06.21                                                     *

*/

-- тест
--

select * from gpSelect_AllGoodsPrice_Site(inSession := '3')
--where COALESCE(LastPrice, 0) = 0 