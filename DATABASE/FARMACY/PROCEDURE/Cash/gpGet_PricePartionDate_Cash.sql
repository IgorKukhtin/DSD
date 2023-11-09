-- Function: gpGet_PricePartionDate_Cash()

DROP FUNCTION IF EXISTS gpGet_PricePartionDate_Cash (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PricePartionDate_Cash (
    IN inUnitId             Integer,    -- Подразделение
    IN inGoodsId            Integer,    -- Тщвар
    IN inPartionDateKindId  Integer   , -- 
   OUT outPricePartionDate  TFloat,     --      
    IN inSession            TVarChar    -- сессия пользователя
)

RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbAreaId   Integer;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbPriceSamples TFloat;
   DECLARE vbSamples21 TFloat;
   DECLARE vbSamples22 TFloat;
   DECLARE vbSamples3 TFloat;
   DECLARE vbCat_5 TFloat;

   DECLARE vbDividePartionDate   boolean;
   DECLARE vbDiscountExternal    boolean;
   DECLARE vbDivisionParties     Boolean;
BEGIN
-- if inSession = '3' then return; end if;


    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');
    -- проверяем регион пользователя
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inSession));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inSession));
    END IF;


    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

    SELECT COALESCE(ObjectFloat_CashSettings_PriceSamples.ValueData, 0)                          AS PriceSamples
         , COALESCE(ObjectFloat_CashSettings_Samples21.ValueData, 0)                             AS Samples21
         , COALESCE(ObjectFloat_CashSettings_Samples22.ValueData, 0)                             AS Samples22
         , COALESCE(ObjectFloat_CashSettings_Samples3.ValueData, 0)                              AS Samples3
         , COALESCE(ObjectFloat_CashSettings_Cat_5.ValueData, 0)                                 AS Cat_5
    INTO vbPriceSamples, vbSamples21, vbSamples22, vbSamples3, vbCat_5
    FROM Object AS Object_CashSettings

         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceSamples
                               ON ObjectFloat_CashSettings_PriceSamples.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_PriceSamples.DescId = zc_ObjectFloat_CashSettings_PriceSamples()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples21
                               ON ObjectFloat_CashSettings_Samples21.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples21.DescId = zc_ObjectFloat_CashSettings_Samples21()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples22
                               ON ObjectFloat_CashSettings_Samples22.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples22.DescId = zc_ObjectFloat_CashSettings_Samples22()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples3
                               ON ObjectFloat_CashSettings_Samples3.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Samples3.DescId = zc_ObjectFloat_CashSettings_Samples3()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Cat_5
                               ON ObjectFloat_CashSettings_Cat_5.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_Cat_5.DescId = zc_ObjectFloat_CashSettings_Cat_5()

    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;    

    IF EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
              WHERE ObjectBoolean_DividePartionDate.ObjectId = inUnitId
                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate())
    THEN

      SELECT COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)
      INTO vbDividePartionDate
      FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
      WHERE ObjectBoolean_DividePartionDate.ObjectId = inUnitId
        AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate();

    ELSE
      vbDividePartionDate := False;
    END IF;

    IF  zfGet_Unit_DiscountExternal (13216391, inUnitId, vbUserId) = 13216391
    THEN
      vbDiscountExternal := True;
    ELSE
      vbDiscountExternal := False;
    END IF;

    vbDivisionParties := vbRetailId = 4;

    -- Цена со скидкой
    CREATE TEMP TABLE tmpPriceChange ON COMMIT DROP AS 
    SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId                                                    AS GoodsId
                  , COALESCE (PriceChange_Value_Unit.ValueData, PriceChange_Value_Retail.ValueData)                        AS PriceChange
                  , COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData)::TFloat      AS FixPercent
                  , COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData)::TFloat    AS FixDiscount
                  , COALESCE (PriceChange_Multiplicity_Unit.ValueData, PriceChange_Multiplicity_Retail.ValueData) ::TFloat AS Multiplicity
                  , COALESCE (PriceChange_FixEndDate_Unit.ValueData, PriceChange_FixEndDate_Retail.ValueData)              AS FixEndDate
                  , COALESCE (ObjectLink_PriceChange_PartionDateKind_Unit.ChildObjectId, ObjectLink_PriceChange_PartionDateKind_Retail.ChildObjectId) AS PartionDateKindId
             FROM Object AS Object_PriceChange
                  -- скидка по подразд
                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Unit
                                       ON ObjectLink_PriceChange_Unit.ObjectId = Object_PriceChange.Id
                                      AND ObjectLink_PriceChange_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                                      AND ObjectLink_PriceChange_Unit.ChildObjectId = inUnitId
                  -- цена со скидкой по подразд.
                  LEFT JOIN ObjectFloat AS PriceChange_Value_Unit
                                        ON PriceChange_Value_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                       AND PriceChange_Value_Unit.DescId = zc_ObjectFloat_PriceChange_Value()
                                       AND COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0
                  -- процент скидки по подразд.
                  LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Unit
                                        ON PriceChange_FixPercent_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                       AND PriceChange_FixPercent_Unit.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                       AND COALESCE (PriceChange_FixPercent_Unit.ValueData, 0) <> 0
                  -- сумма скидки по подразд.
                  LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Unit
                                        ON PriceChange_FixDiscount_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                       AND PriceChange_FixDiscount_Unit.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                       AND COALESCE (PriceChange_FixDiscount_Unit.ValueData, 0) <> 0
                  -- Кратность отпуска
                  LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Unit
                                        ON PriceChange_Multiplicity_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                       AND PriceChange_Multiplicity_Unit.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                       AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, 0) <> 0
                  -- Дата окончания действия скидки
                  LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Unit
                                       ON PriceChange_FixEndDate_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                      AND PriceChange_FixEndDate_Unit.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                                                            
                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Unit
                                        ON ObjectLink_PriceChange_PartionDateKind_Unit.ObjectId  = ObjectLink_PriceChange_Unit.ObjectId
                                       AND ObjectLink_PriceChange_PartionDateKind_Unit.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()
                                                            

                  -- скидка по сети
                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                       ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                      AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                      AND ObjectLink_PriceChange_Retail.ChildObjectId = vbRetailId
                  -- цена со скидкой по сети
                  LEFT JOIN ObjectFloat AS PriceChange_Value_Retail
                                        ON PriceChange_Value_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND PriceChange_Value_Retail.DescId = zc_ObjectFloat_PriceChange_Value()
                                       AND COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0
                  -- процент скидки по сети.
                  LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Retail
                                        ON PriceChange_FixPercent_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND PriceChange_FixPercent_Retail.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                       AND COALESCE (PriceChange_FixPercent_Retail.ValueData, 0) <> 0
                  -- сумма скидки по сети.
                  LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Retail
                                        ON PriceChange_FixDiscount_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND PriceChange_FixDiscount_Retail.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                       AND COALESCE (PriceChange_FixDiscount_Retail.ValueData, 0) <> 0
                  -- Кратность отпуска по сети.
                  LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Retail
                                        ON PriceChange_Multiplicity_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND PriceChange_Multiplicity_Retail.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                       AND COALESCE (PriceChange_Multiplicity_Retail.ValueData, 0) <> 0
                  -- Дата окончания действия скидки по сети.
                  LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Retail
                                       ON PriceChange_FixEndDate_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                      AND PriceChange_FixEndDate_Retail.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Retail
                                        ON ObjectLink_PriceChange_PartionDateKind_Retail.ObjectId  = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                       AND ObjectLink_PriceChange_PartionDateKind_Retail.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()

                  LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                       ON ObjectLink_PriceChange_Goods.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                      AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()

             WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
               AND Object_PriceChange.isErased = FALSE
               AND (COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0 OR COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0 OR
                   COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData, 0) <> 0 OR
                   COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData, 0) <> 0) -- выбираем только цены <> 0
             ;

    ANALYZE tmpPriceChange;
    
    CREATE TEMP TABLE tmpMIPromoBonus ON COMMIT DROP AS 
     SELECT MI.GoodsId               AS GoodsId
          , MI.MarginPercent         AS MarginPercent
          , MI.PromoBonus            AS PromoBonus
     FROM gpSelect_PromoBonus_MarginPercent(inUnitId, inSession) AS MI;

    ANALYZE tmpMIPromoBonus;    

         -- спец-цены
    CREATE TEMP TABLE tmpCashGoodsPriceWithVAT ON COMMIT DROP AS     
    WITH
                    DD AS (SELECT DISTINCT Object_MarginCategoryItem_View.MarginPercent,
                                           Object_MarginCategoryItem_View.MinPrice,
                                           Object_MarginCategoryItem_View.MarginCategoryId,
                                           ROW_NUMBER() OVER (PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId
                                                             ORDER BY Object_MarginCategoryItem_View.MinPrice) AS ORD
                           FROM Object_MarginCategoryItem_View
                                INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id       = Object_MarginCategoryItem_View.Id
                                                                              AND Object_MarginCategoryItem.isErased = FALSE
                          )
                  , MarginCondition AS (SELECT
                                            D1.MarginCategoryId,
                                            D1.MarginPercent,
                                            D1.MinPrice,
                                            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
                                        FROM DD AS D1
                                            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1
                                       )

                  , JuridicalSettings AS (SELECT DISTINCT JuridicalId, ContractId, isPriceCloseOrder
                                        FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS JuridicalSettings
                                             LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = JuridicalSettings.MainJuridicalId
                                        WHERE COALESCE (Object_ContractSettings.isErased, FALSE) = FALSE
                                         AND JuridicalSettings.MainJuridicalId <> 5603474
                                       )
                  , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                        , ObjectFloat_NDSKind_NDS.ValueData
                                  FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                  )
                  , tmpGoods_PD AS (SELECT inGoodsId AS GoodsId)
                     -- !!!товары из списка tmpGoods_PD!!!
                   , tmpGoodsPartner AS (SELECT tmpGoods_PD.GoodsId                               AS GoodsId_retail -- товар сети
                                              , Object_Goods.GoodsMainId                          AS GoodsId_main   -- товар главный
                                              , Object_Goods_Juridical.Id                         AS GoodsId_jur    -- товар поставщика
                                              , Object_Goods_Juridical.Code                       AS GoodsCode_jur  -- товар поставщика
                                              , Object_Goods_Juridical.JuridicalId                AS JuridicalId    -- поставщик
                                              , Object_Goods.isTop                                AS isTOP          -- топ у тов. сети
                                              , COALESCE (Object_Goods.PercentMarkup, 0)          AS PercentMarkup  -- % нац. у тов. сети
                                              , COALESCE (Object_Goods.Price, 0)                  AS Price_retail   -- фиксированная цена у тов. сети
                                              , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)   AS NDS            -- NDS у тов. главный
                                         FROM tmpGoods_PD
                                              -- объект - линк
                                              LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id =  tmpGoods_PD.GoodsId
                                              LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
                                              LEFT JOIN Object_Goods_Juridical AS Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods.GoodsMainId

                                              LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                                                --   AND ObjectFloat_NDSKind_NDS.DescId   = zc_ObjectFloat_NDSKind_NDS()
                                        )

                   , _GoodsPriceAll AS (SELECT tmpGoodsPartner.GoodsId_retail         AS GoodsId, -- товар сети
                                               zfCalc_SalePrice ((LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS) / 100),                         -- Цена С НДС
                                                                 CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                                                          THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.ValueData, 0)
                                                                      ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.ValueData, 0)
                                                                 END,                                                                             -- % наценки в КАТЕГОРИИ
                                                                 COALESCE (tmpGoodsPartner.isTOP, FALSE),                                         -- ТОП позиция
                                                                 COALESCE (tmpGoodsPartner.PercentMarkup, 0),                                     -- % наценки у товара
                                                                 0.0, --ObjectFloat_Juridical_Percent.ValueData,                                  -- % корректировки у Юр Лица для ТОПа
                                                                 tmpGoodsPartner.Price_retail                                                            -- Цена у товара (фиксированная)
                                                               )         :: TFloat AS Price,
                                               LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS)/100 AS PriceWithVAT

                                        FROM LoadPriceListItem

                                             INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                                             LEFT JOIN JuridicalSettings
                                                     ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                                                    AND JuridicalSettings.ContractId  = LoadPriceList.ContractId

                                             -- !!!ограничили только этим списком!!!
                                             INNER JOIN tmpGoodsPartner ON tmpGoodsPartner.JuridicalId   = LoadPriceList.JuridicalId
                                                                       AND tmpGoodsPartner.GoodsId_main  = LoadPriceListItem.GoodsId
                                                                       AND tmpGoodsPartner.GoodsCode_jur = LoadPriceListItem.GoodsCode

                                             LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                                                   ON ObjectFloat_Juridical_Percent.ObjectId = LoadPriceList.JuridicalId
                                                                  AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                                             LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                                                   ON ObjectFloat_Contract_Percent.ObjectId = LoadPriceList.ContractId
                                                                  AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

                                             LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                                                      ON Object_MarginCategoryLink.UnitId = inUnitId
                                                                                     AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

                                             LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                                                      ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                                                     AND Object_MarginCategoryLink_all.JuridicalId = LoadPriceList.JuridicalId
                                                                                     AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                                                     AND Object_MarginCategoryLink.JuridicalId IS NULL

                                             LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                                                  -- AND (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
                                                                     AND (LoadPriceListItem.Price * (100 + tmpGoodsPartner.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

                                        WHERE COALESCE(JuridicalSettings.isPriceCloseOrder, TRUE)  = FALSE
                                          AND (LoadPriceList.AreaId = 0 OR COALESCE (LoadPriceList.AreaId, 0) = vbAreaId OR COALESCE(vbAreaId, 0) = 0
                                            OR COALESCE (LoadPriceList.AreaId, 0) = zc_Area_Basis()
                                              )
                                       )
                              , GoodsPriceAll AS (SELECT
                                                       ROW_NUMBER() OVER (PARTITION BY _GoodsPriceAll.GoodsId ORDER BY _GoodsPriceAll.Price)::Integer AS Ord,
                                                       _GoodsPriceAll.GoodsId           AS GoodsId,
                                                       _GoodsPriceAll.PriceWithVAT      AS PriceWithVAT
                                                  FROM _GoodsPriceAll
                                                 )
                            -- Результат - спец-цены
                            SELECT GoodsPriceAll.GoodsId      AS Id,
                                   GoodsPriceAll.PriceWithVAT AS PriceWithVAT
                            FROM GoodsPriceAll
                            WHERE Ord = 1;
     
    ANALYSE tmpCashGoodsPriceWithVAT;    

    WITH
         tmpObject_Goods AS (SELECT Object_Goods_Retail.id  AS GoodsId
                                  , Object_Goods_Retail.GoodsMainId 
                                  , Object_Goods_Main.NDSKindId
                                  , Object_Goods_Retail.Price
                                  , Object_Goods_Retail.isTop
                                  , COALESCE (Object_Goods_Retail.PercentMarkup, 0)   AS PercentMarkup
                                  , COALESCE (Object_Goods_Retail.Price, 0)           AS Price_retail
                             FROM Object_Goods_Retail
                                  LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                             WHERE Object_Goods_Retail.RetailId = vbRetailId
                               AND Object_Goods_Retail.ID = inGoodsId)              
       , tmpContainerAll AS (SELECT Container.DescId
                                  , Container.Id
                                  , Container.ParentId
                                  , Container.ObjectId
                                  , Container.Amount
                                  , ContainerLinkObject.ObjectId                                      AS PartionGoodsId
                                  , ContainerLinkObject_DivisionParties.ObjectId                      AS DivisionPartiesId
                             FROM Container

                                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                                ON ContainerLinkObject_DivisionParties.Containerid = COALESCE(Container.ParentId, Container.Id)
                                                               AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()

                             WHERE Container.DescId = zc_Container_CountPartionDate()
                               AND Container.ObjectId = inGoodsId
                               AND Container.WhereObjectId = inUnitId
                             ORDER BY Container.Id
                            )

       , tmpContainerPD AS (SELECT Container.Id
                                 , Container.ParentId
                                 , Container.ObjectId
                                 , Container.Amount
                                 , Container.DivisionPartiesId                                   AS DivisionPartiesId
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                                 , COALESCE (ObjectFloat_PartionGoods_ValueMin.ValueData, 0)     AS PercentMin
                                 , COALESCE (ObjectFloat_PartionGoods_ValueLess.ValueData, 0)    AS PercentLess
                                 , COALESCE (ObjectFloat_PartionGoods_Value.ValueData, 0)        AS Percent
                                 , COALESCE (ObjectFloat_PartionGoods_PriceWithVAT.ValueData, 0) AS PriceWithVAT
                                 , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_3  THEN zc_Enum_PartionDateKind_3()      -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                        ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                            FROM tmpContainerAll AS Container
                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = Container.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                                                       ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueLess
                                                       ON ObjectFloat_PartionGoods_ValueLess.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_ValueLess.DescId = zc_ObjectFloat_PartionGoods_ValueLess()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                                                       ON ObjectFloat_PartionGoods_Value.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                                                       ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()
                             )
       , tmpPDPriceWithVAT AS (SELECT ROW_NUMBER()OVER(PARTITION BY Container.ObjectId, Container.PartionDateKindId ORDER BY Container.Id DESC) as ORD
                                    , Container.ObjectId
                                    , Container.PartionDateKindId
                                    , CASE WHEN Container.PriceWithVAT <= 15
                                           THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                           ELSE Container.PriceWithVAT END       AS PriceWithVAT
                                    , CASE WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_Good(), zc_Enum_PartionDateKind_0())
                                           THEN 0
                                           WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_6())
                                           THEN Container.Percent
                                           WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_Cat_5())
                                           THEN Container.PercentLess
                                           WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_1())
                                           THEN Container.PercentMin
                                           ELSE Null END::TFloat                  AS PartionDateDiscount
                               FROM tmpContainerPD AS Container
                                    LEFT JOIN tmpCashGoodsPriceWithVAT ON tmpCashGoodsPriceWithVAT.ID = Container.ObjectId
                               WHERE Container.PartionDateKindId = inPartionDateKindId
                               )

       , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                          AND Price_Goods.ChildObjectId           = inGoodsId
                        )
       , tmpPriceWithVAT AS (SELECT tmpPDPriceWithVAT.ObjectId                AS GoodsId
                                  , tmpPDPriceWithVAT.PriceWithVAT::TFloat    AS PriceWithVAT
                                  , tmpPDPriceWithVAT.PartionDateDiscount 
                                  , tmpPDPriceWithVAT.PartionDateKindId
                             FROM tmpPDPriceWithVAT 
                             WHERE tmpPDPriceWithVAT.ObjectId = inGoodsId
                               AND tmpPDPriceWithVAT.PartionDateKindId = inPartionDateKindId
                               AND tmpPDPriceWithVAT.Ord = 1)
       , tmpMedicalProgramSPUnit AS (SELECT  ObjectLink_MedicalProgramSP.ChildObjectId         AS MedicalProgramSPId
                                       FROM Object AS Object_MedicalProgramSPLink
                                            INNER JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                                                  ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                                            INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                  ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                                                 AND ObjectLink_Unit.ChildObjectId = inUnitId 
                                        WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
                                          AND Object_MedicalProgramSPLink.isErased = False)
         , tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                               , MI_IntenalSP.ObjectId         AS IntenalSPId
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_PaymentSP.ValueData   AS PaymentSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIFloat_CountSPMin.ValueData  AS CountSPMin
                               , MIString_IdSP.ValueData       AS IdSP
                               , COALESCE (MIString_ProgramIdSP.ValueData, '')::TVarChar AS ProgramIdSP
                               , COALESCE (ObjectBoolean_ElectronicPrescript.ValueData, False) AS isElectronicPrescript
                                                                -- № п/п - на всякий случай
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId 
                                                    ORDER BY COALESCE (ObjectBoolean_ElectronicPrescript.ValueData, False), Movement.OperDate DESC, MIFloat_CountSPMin.ValueData DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                               INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                             ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                            AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                               LEFT JOIN tmpMedicalProgramSPUnit ON tmpMedicalProgramSPUnit.MedicalProgramSPId = MLO_MedicalProgramSP.ObjectId

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_ElectronicPrescript
                                                       ON ObjectBoolean_ElectronicPrescript.ObjectId = COALESCE (MLO_MedicalProgramSP.ObjectId, 18076882)
                                                      AND ObjectBoolean_ElectronicPrescript.DescId = zc_ObjectBoolean_MedicalProgramSP_ElectronicPrescript()

                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE

                               LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                                ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                               AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                               -- Роздрібна  ціна за упаковку, грн
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                           ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
                               -- Розмір відшкодування за упаковку (Соц. проект) - (15)
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                           ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                               -- Сума доплати за упаковку, грн (Соц. проект) - 16)
                               LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                           ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()

                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                           ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSPMin
                                                           ON MIFloat_CountSPMin.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSPMin.DescId = zc_MIFloat_CountSPMin()
                               -- ID лікарського засобу
                               LEFT JOIN MovementItemString AS MIString_IdSP
                                                            ON MIString_IdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_IdSP.DescId = zc_MIString_IdSP()
                               LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                                            ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                            AND COALESCE (MIFloat_PriceSP.ValueData, 0) <> 0
                            AND (COALESCE (tmpMedicalProgramSPUnit.MedicalProgramSPId, 0) <> 0 OR vbUserId = 3)
                         )

                 , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                             , Object_Object.Id                                          AS GoodsDiscountId
                                             , Object_Object.ValueData                                   AS GoodsDiscountName
                                             , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                             , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                                          FROM Object AS Object_BarCode
                                              INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                    ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                                   AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                              INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                              LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                   ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                                  AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                              LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                              LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                                      ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id 
                                                                     AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()

                                              LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                                    ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                                   AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                          WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                            AND Object_BarCode.isErased = False
                                          GROUP BY Object_Goods_Retail.GoodsMainId
                                                 , Object_Object.Id
                                                 , Object_Object.ValueData
                                                 , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False))
                                                 
                 , tmpPricePartionDate AS (SELECT
                                                CashSessionSnapShot.GoodsId,
                                                CashSessionSnapShot.PartionDateKindId,
                                                
                                                CASE WHEN zfCalc_PriceCash(tmpObject_Price.Price, 
                                                         CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                                                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) > CashSessionSnapShot.PriceWithVAT
                                                         AND CashSessionSnapShot.PriceWithVAT <= vbPriceSamples 
                                                         AND vbPriceSamples > 0
                                                         AND CashSessionSnapShot.PriceWithVAT > 0
                                                         AND CashSessionSnapShot.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_6())
                                                      THEN ROUND(zfCalc_PriceCash(tmpObject_Price.Price *
                                                                 CASE WHEN CashSessionSnapShot.PartionDateKindId = zc_Enum_PartionDateKind_6() THEN 100.0 - vbSamples21
                                                                      WHEN CashSessionSnapShot.PartionDateKindId = zc_Enum_PartionDateKind_3() THEN 100.0 - vbSamples22
                                                                      WHEN CashSessionSnapShot.PartionDateKindId = zc_Enum_PartionDateKind_1() THEN 100.0 - vbSamples3
                                                                      ELSE 100 END  / 100, 
                                                                 CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True THEN FALSE ELSE TRUE END), 2)
                                                      WHEN CashSessionSnapShot.PartionDateKindId = zc_Enum_PartionDateKind_6() AND COALESCE(CashSessionSnapShot.PartionDateDiscount, 0) > 0 AND
                                                         zfCalc_PriceCash(tmpObject_Price.Price, 
                                                         CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                                                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) > CashSessionSnapShot.PriceWithVAT
                                                         AND CashSessionSnapShot.PriceWithVAT > 0
                                                      THEN ROUND(zfCalc_PriceCash(tmpObject_Price.Price, 
                                                         CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                                                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) - (zfCalc_PriceCash(tmpObject_Price.Price, 
                                                         CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                                                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0) - CashSessionSnapShot.PriceWithVAT) *
                                                                 CashSessionSnapShot.PartionDateDiscount / 100, 2)
                                                      WHEN CashSessionSnapShot.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_3()) AND COALESCE(CashSessionSnapShot.PartionDateDiscount, 0) > 0
                                                      THEN zfCalc_PriceCash(Round(tmpObject_Price.Price * (100.0 - COALESCE(CashSessionSnapShot.PartionDateDiscount, 0)) / 100.0, 2), 
                                                                       CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 
                                                                            THEN FALSE ELSE TRUE END OR
                                                                       COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                                      WHEN CashSessionSnapShot.PartionDateKindId IN (zc_Enum_PartionDateKind_Cat_5()) AND COALESCE(vbCat_5, 0) > 0
                                                      THEN zfCalc_PriceCash(Round(tmpObject_Price.Price * (100.0 - vbCat_5) / 100.0, 2), 
                                                                       CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 
                                                                            THEN FALSE ELSE TRUE END OR
                                                                       COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                                      ELSE zfCalc_PriceCash(tmpObject_Price.Price, 
                                                         CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                                                         COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                                                 END :: TFloat AS PricePartionDate
                                             FROM
                                                tmpPriceWithVAT AS CashSessionSnapShot

                                                -- получается GoodsMainId
                                                LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = CashSessionSnapShot.GoodsId
                                                
                                                -- Соц Проект
                                                LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Retail.GoodsMainId
                                                                    AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай

                                                LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                
                                                LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = CashSessionSnapShot.GoodsId
                                                
                                             WHERE COALESCE(CashSessionSnapShot.PartionDateKindId, 0) <> 0
                                               AND CashSessionSnapShot.PartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_6(), zc_Enum_PartionDateKind_Cat_5())
                                             )


    SELECT  CASE WHEN tmpObject_Goods.IsTop = TRUE
                  AND tmpObject_Goods.Price > 0
                   OR COALESCE(tmpPriceChange.PartionDateKindId, 0) <> 0
                 THEN zfCalc_PriceCash(tmpObject_Goods.Price, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                 WHEN inPartionDateKindId IN (zc_Enum_PartionDateKind_1(), zc_Enum_PartionDateKind_3(), zc_Enum_PartionDateKind_6(), zc_Enum_PartionDateKind_Cat_5())
                  AND COALESCE(tmpMIPromoBonus.PromoBonus, 0) <> 0
                  AND tmpObject_Goods.IsTop = False 
                  AND (COALESCE(tmpPriceChange.PriceChange, 0) = 0 AND
                       COALESCE(tmpPriceChange.FixPercent, 0) = 0 AND
                       COALESCE(tmpPriceChange.FixDiscount, 0) = 0 OR
                       COALESCE(tmpPriceChange.Multiplicity, 0) > 1)
                  AND COALESCE ( tmpPricePartionDate.PricePartionDate, 0) > 0
                  AND COALESCE ( tmpPricePartionDate.PricePartionDate, 0) > 
                       zfCalc_PriceCash(Round(tmpObject_Price.Price * 100.0 / (100.0 + tmpMIPromoBonus.MarginPercent) * 
                                       (100.0 - tmpMIPromoBonus.PromoBonus + tmpMIPromoBonus.MarginPercent) / 100, 2), 
                                       CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 
                                            THEN FALSE ELSE TRUE END OR
                                       COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                 THEN zfCalc_PriceCash(Round(tmpObject_Price.Price * 100.0 / (100.0 + tmpMIPromoBonus.MarginPercent) * 
                                       (100.0 - tmpMIPromoBonus.PromoBonus + tmpMIPromoBonus.MarginPercent) / 100, 2), 
                                       CASE WHEN tmpGoodsSP.GoodsId IS NULL OR tmpGoodsSP.isElectronicPrescript = True OR COALESCE (tmpGoodsSP.PriceSP, 0) = 0 
                                            THEN FALSE ELSE TRUE END OR
                                       COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)
                 ELSE tmpPricePartionDate.PricePartionDate 
                 END :: TFloat                                     AS PricePartionDate                        
    INTO outPricePartionDate
    FROM tmpPriceWithVAT
         LEFT JOIN tmpPricePartionDate ON tmpPricePartionDate.GoodsId = inGoodsId
         LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = inGoodsId
         LEFT JOIN tmpObject_Goods ON tmpObject_Goods.GoodsId = inGoodsId
         LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = inGoodsId
         LEFT JOIN tmpMIPromoBonus ON tmpMIPromoBonus.GoodsId = inGoodsId
         LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = tmpObject_Goods.GoodsMainId
         -- Соц Проект
         LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = tmpObject_Goods.GoodsMainId
                             AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай
    ;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_CashSession (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.08.21                                                       *
*/

--тест
--
SELECT * FROM gpGet_PricePartionDate_Cash (inUnitId := lpGet_DefaultValue('zc_Object_Unit', '3')::Integer , inGoodsId := 18200689 , inPartionDateKindId := 14542625, inSession := '3');