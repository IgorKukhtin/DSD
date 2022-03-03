-- Function: lpSelectMinPrice_AllGoods()

DROP FUNCTION IF EXISTS lpSelectMinPrice_AllGoods (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_AllGoods(
    IN inUnitId      Integer      , -- Аптека
    IN inObjectId    Integer      , -- Торговая сеть
    IN inUserId      Integer        -- сессия пользователя
)

RETURNS TABLE (
    GoodsId            Integer,
    GoodsId_retail     Integer,
    GoodsCode          Integer,
    GoodsName          TVarChar,
    Remains            TFloat,
    MaxPriceIncome     TFloat,
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

    PricePromo          TFloat
)

AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
  DECLARE vbIsGoodsPromo Boolean;
  DECLARE vbCostCredit TFloat;
  DECLARE vbPercentСhange TFloat;
BEGIN
    -- !!!так "криво" определятся НАДО ЛИ учитывать маркет. контракт!!!
    vbIsGoodsPromo:= inObjectId >=0;
    -- !!!меняется параметр в нормальное значение!!!
    inObjectId:= ABS (inObjectId);

    vbPercentСhange := COALESCE((SELECT tmp.PercentСhange FROM gpSelect_Object_ExchangeRates(False, inUserId::TVarChar) AS tmp WHERE tmp.OperDate = CURRENT_DATE), 0);

    -- Нашли у Аптеки "Главное юр лицо"
    SELECT Object_Unit_View.JuridicalId INTO vbMainJuridicalId FROM Object_Unit_View WHERE Object_Unit_View.Id = inUnitId;

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

--raise notice 'Value 1: %', timenow();

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remains'))
    THEN
      DROP TABLE _tmpMinPrice_Remains;
    END IF;

    -- Остатки - оптимизация
    CREATE TEMP TABLE _tmpMinPrice_Remains ON COMMIT DROP AS
       (WITH 
       tmpContainerPD AS (SELECT Container.ParentId          AS ContainerId
                               , MIN(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))::TDateTime  AS ExpirationDate  
                          FROM Container

                              LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                           AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                              LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                   ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                  AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND Container.WhereObjectId = inUnitId
                            AND  Container.Amount <> 0
                          GROUP BY Container.ParentId)
     , tmp AS
           (SELECT Container.ObjectId
             , Container.Id
             , Container.Amount
        FROM
            Container
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId = inUnitId
          AND Container.Amount <> 0
            )
     ,  tmpContainer AS 
       (SELECT Container.ObjectId AS ObjectId_retail -- здесь товар "сети"
             , Container.Amount
             , Object_PartionMovementItem.ObjectCode ::Integer AS MI_Partion
             , tmpContainerPD.ExpirationDate
        FROM tmp AS Container
            LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                ON CLO_PartionMovementItem.ContainerId = Container.Id
                                               AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem
                                   ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
            LEFT OUTER JOIN tmpContainerPD ON tmpContainerPD.ContainerId = Container.Id
        )
     , tmpMI_Float AS (SELECT *
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpContainer.MI_Partion FROM tmpContainer)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_PriceSale(), zc_MIFloat_Price())
                       )
     , tmpRemains AS
       (SELECT
            Container.ObjectId_retail -- здесь товар "сети"
          , SUM (Container.Amount)       AS Amount
          , MIN (COALESCE (Container.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()))  AS MinExpirationDate -- Срок годности
          , SUM (Container.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0)) / SUM (Container.Amount) AS MidPriceSale -- !!! средняя Цена реал. с НДС!!!
          , MAX (COALESCE (MIFloat_Income_Price.ValueData, 0)) AS MaxPriceIncome
        FROM tmpContainer AS Container
             LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                              ON MIDate_ExpirationDate.MovementItemId = Container.MI_Partion
                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
             -- Цена реал. с НДС
             LEFT JOIN tmpMI_Float AS MIFloat_PriceSale
                                         ON MIFloat_PriceSale.MovementItemId = Container.MI_Partion
                                        AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

             LEFT OUTER JOIN tmpMI_Float AS MIFloat_Income_Price
                                               ON MIFloat_Income_Price.MovementItemId = Container.MI_Partion
                                              AND MIFloat_Income_Price.DescId = zc_MIFloat_Price()
                                              
        GROUP BY Container.ObjectId_retail
        HAVING SUM (Container.Amount) > 0
       )

        --
        SELECT
            ObjectLink_Child_NB.ChildObjectId         AS ObjectID           -- !!!временно захардкодил, будет всегда товар НеБолей!!!
          , tmpRemains.ObjectId_retail                                      -- здесь товар "сети"
          , tmpRemains.Amount ::TFloat                AS Amount
          , tmpRemains.MinExpirationDate :: TDateTime AS MinExpirationDate  -- Срок годности
          , tmpRemains.MidPriceSale       -- !!! средняя Цена реал. с НДС!!!
          , tmpRemains.MaxPriceIncome     -- !!! максимальная цена прихода         
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

  --  raise notice 'Value 2: % %', timenow(), vbPercentСhange;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpminprice_remainslist'))
    THEN
      DROP TABLE _tmpMinPrice_RemainsList;
    END IF;

-- RAISE EXCEPTION '<%>', (select count(*) from _tmpMinPrice_Remains);
-- raise notice 'Value 3: %', timenow();

    -- Остатки + коды ...
    CREATE TEMP TABLE _tmpMinPrice_RemainsList ON COMMIT DROP AS
       (SELECT
            _tmpMinPrice_Remains.ObjectId,                  -- здесь товар "сети"
            _tmpMinPrice_Remains.ObjectId_retail,           -- здесь товар "сети"
            Object_LinkGoods_View.GoodsMainId, -- здесь "общий" товар
            PriceList_GoodsLink.GoodsId,       -- здесь товар "поставщика"
            _tmpMinPrice_Remains.Amount,
            _tmpMinPrice_Remains.MinExpirationDate,
            _tmpMinPrice_Remains.MidPriceSale,
            _tmpMinPrice_Remains.MaxPriceIncome
        FROM _tmpMinPrice_Remains
            INNER JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = _tmpMinPrice_Remains.objectid -- Связь товара сети с общим
            LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                            ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
        );

    ANALYZE _tmpMinPrice_RemainsList;
--RAISE notice '<%>', (select count(*) from _tmpMinPrice_RemainsList where  _tmpMinPrice_RemainsList.ObjectId_retail = 472);
--raise notice 'Value 4: %', timenow();


/*    -- Остатки + коды ...
    CREATE TEMP TABLE _tmpMinPrice_RemainsList ON COMMIT DROP AS
       (SELECT
            _tmpMinPrice_Remains.ObjectId,                  -- здесь товар "сети"
            _tmpMinPrice_Remains.ObjectId_retail,           -- здесь товар "сети"
            ObjectLink_LinkGoods_Goods.ChildObjectId as GoodsMainId, -- здесь "общий" товар
            ObjectLink_LinkGoods_Goods2.ChildObjectId as GoodsId,       -- здесь товар "поставщика"
            _tmpMinPrice_Remains.Amount,
            _tmpMinPrice_Remains.MinExpirationDate,
            _tmpMinPrice_Remains.MidPriceSale
        FROM _tmpMinPrice_Remains
                 INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                       ON ObjectLink_LinkGoods_Goods.ChildObjectId = _tmpMinPrice_Remains.objectid -- Связь товара сети с общим
                                      AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()

                 INNER join ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                        ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                       AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()


                 INNER join ObjectLink AS ObjectLink_LinkGoods_GoodsMain2
                                        ON ObjectLink_LinkGoods_GoodsMain2.ChildObjectId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                                       AND ObjectLink_LinkGoods_GoodsMain2.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                 INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods2
                                      ON ObjectLink_LinkGoods_Goods2.ObjectId = ObjectLink_LinkGoods_GoodsMain2.ObjectId
                                     AND ObjectLink_LinkGoods_Goods2.DescId = zc_ObjectLink_LinkGoods_Goods()
       );*/

-- RAISE EXCEPTION '<%>      <%>', (select count(*) from Remains), (select count(*) from _tmpMinPrice_RemainsList);

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
                                   ON ObjectLink_Price_Unit.ChildObjectId = inUnitId
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
                                tmp.UnitId                   AS UnitId
                              , tmp.JuridicalId              AS JuridicalId
                              , tmp.AreaId_Juridical         AS AreaId
                              , tmp.AreaName_Juridical       AS AreaName
                         FROM lpSelect_Object_JuridicalArea_byUnit (inUnitId, 0) AS tmp
                         )
   -- Отказы поставщиков
  , tmpSupplierFailures AS (SELECT SupplierFailures.GoodsId
                                 , SupplierFailures.JuridicalId
                                 , SupplierFailures.ContractId
                                 , SupplierFailures.AreaId
                            FROM lpSelect_PriceList_SupplierFailures(0, inUserId) AS SupplierFailures
                            )
  , tmpMovementItemLastPriceList_View AS (SELECT LastMovement.MovementId
                                               , MovementItem.ID                 
                                               , MILinkObject_Goods.ObjectId      AS GoodsId
                                               , COALESCE(MIFloat_Price.ValueData, MovementItem.Amount)::TFloat  AS Price
                                               , LastMovement.JuridicalId 
                                               , LastMovement.ContractId
                                               , LastMovement.AreaId
                                          FROM
                                              (
                                                  SELECT PriceList.MovementId 
                                                       , PriceList.JuridicalId 
                                                       , PriceList.ContractId
                                                       , PriceList.AreaId
                                                  FROM 
                                                      (
                                                          SELECT 
                                                              MAX (Movement.OperDate) 
                                                              OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId 
                                                                               , COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                                                               , COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                                                   ) AS Max_Date
                                                            , Movement.OperDate                                  AS OperDate
                                                            , Movement.Id                                        AS MovementId
                                                            , MovementLinkObject_Juridical.ObjectId              AS JuridicalId 
                                                            , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                                            , COALESCE (MovementLinkObject_Area.ObjectId, 0)     AS AreaId
                                                          FROM 
                                                              Movement
                                                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                                           ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                                                          AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                                          AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                                                           ON MovementLinkObject_Area.MovementId = Movement.Id
                                                                                          AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area() 
                                                          WHERE 
                                                              Movement.DescId = zc_Movement_PriceList()
                                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                      ) AS PriceList
                                                  WHERE PriceList.Max_Date = PriceList.OperDate 
                                              ) AS LastMovement
                                              INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                                                                     AND MovementItem.DescId = zc_MI_Master()
                                                                     AND MovementItem.isErased = False
                                              INNER JOIN MovementItemLinkObject AS MILinkObject_Goods -- товары в прайс-листе
                                                                                ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                                                               AND MILinkObject_Goods.MovementItemId = MovementItem.Id
                                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                          ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                          )
  , tmpMinPrice_RemainsPrice as (SELECT
            _tmpMinPrice_RemainsList.ObjectId                 AS GoodsId
          , _tmpMinPrice_RemainsList.ObjectId_retail          AS GoodsId_retail
          , Goods.GoodsCodeInt                 AS GoodsCode
          , Goods.GoodsName                    AS GoodsName
          , _tmpMinPrice_RemainsList.Amount                   AS Remains
          , _tmpMinPrice_RemainsList.MinExpirationDate        AS MinExpirationDate
          , _tmpMinPrice_RemainsList.MidPriceSale             AS MidPriceSale
          , _tmpMinPrice_RemainsList.MaxPriceIncome           AS MaxPriceIncome
            -- просто цена поставщика
          , PriceList.Price                                   AS Price
            -- минимальная цена поставщика - для товара "сети"
          , MIN (PriceList.Price) OVER (PARTITION BY _tmpMinPrice_RemainsList.ObjectId) AS MinPrice
          , PriceList.Id                       AS PriceListMovementItemId
          , PriceList.MovementId               AS PriceListMovementId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate

          , CASE -- если Цена поставщика не попадает в ценовые промежутки
                 WHEN tmpJuridicalSettingsItem.JuridicalSettingsId IS NULL
                  THEN PriceList.Price
                       -- учитывается % бонуса из Маркетинговый контракт
                     * (1 - COALESCE (CASE WHEN vbIsGoodsPromo = TRUE THEN GoodsPromo.ChangePercent ELSE 0 END, 0) / 100)

                 ELSE -- иначе учитывается бонус - для ТОП-позиции или НЕ ТОП-позиции
                    (PriceList.Price * (100 - COALESCE (tmpJuridicalSettingsItem.Bonus, 0)) / 100)
                     -- И учитывается % бонуса из Маркетинговый контракт
                  * (1 - COALESCE (CASE WHEN vbIsGoodsPromo = TRUE THEN GoodsPromo.ChangePercent ELSE 0 END, 0) / 100)
            END :: TFloat AS FinalPrice

          , Object_JuridicalGoods.Id           AS Partner_GoodsId
          , Object_JuridicalGoods.GoodsCode    AS Partner_GoodsCode
          , Object_JuridicalGoods.GoodsName    AS Partner_GoodsName
          , Object_JuridicalGoods.MakerName    AS MakerName
          , PriceList.ContractId               AS ContractId
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
             -- Прайс-лист (поставщика)
            JOIN tmpMovementItemLastPriceList_View AS PriceList 
                                                   ON PriceList.GoodsId = _tmpMinPrice_RemainsList.GoodsId

            JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = PriceList.JuridicalId
                                 AND tmpJuridicalArea.AreaId      = COALESCE(PriceList.AreaId, 0)

            LEFT JOIN tmpSupplierFailures AS SupplierFailures 
                                          ON SupplierFailures.GoodsId = _tmpMinPrice_RemainsList.GoodsId
                                         AND SupplierFailures.JuridicalId = PriceList.JuridicalId
                                         AND SupplierFailures.ContractId = PriceList.ContractId
                                         AND COALESCE(SupplierFailures.AreaId, 0) = COALESCE(PriceList.AreaId, 0)
                                          
             -- Срок партии товара (или Срок годности?) в Прайс-лист (поставщика)
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

             -- Установки для юр. лиц (для поставщика определяется договор и т.п)
            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId     = PriceList.JuridicalId
                                       AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId
                                       AND JuridicalSettings.ContractId      = PriceList.ContractId
            LEFT JOIN tmpJuridicalSettingsItem ON tmpJuridicalSettingsItem.JuridicalSettingsId = JuridicalSettings.JuridicalSettingsId
                                              AND PriceList.Price >= tmpJuridicalSettingsItem.PriceLimit_min
                                              AND PriceList.Price <= tmpJuridicalSettingsItem.PriceLimit

            -- товар "поставщика", если он есть в прайсах !!!а он есть!!!
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = _tmpMinPrice_RemainsList.GoodsId
            -- товар "сети"
            LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = _tmpMinPrice_RemainsList.ObjectId
            -- LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = _tmpMinPrice_RemainsList.ObjectId_retail
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                    ON ObjectBoolean_Goods_TOP.ObjectId = _tmpMinPrice_RemainsList.ObjectId_retail
                                   AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = _tmpMinPrice_RemainsList.ObjectId

            -- Поставщик
            INNER JOIN Object AS Juridical ON Juridical.Id = PriceList.JuridicalId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriorityReprice
                                    ON ObjectBoolean_PriorityReprice.ObjectId = Juridical.Id
                                   AND ObjectBoolean_PriorityReprice.DescId = zc_ObjectBoolean_Juridical_PriorityReprice()

            -- Дней отсрочки по договору
            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment
                                  ON ObjectFloat_Deferment.ObjectId = PriceList.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

            -- % бонуса из Маркетинговый контракт
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId     = _tmpMinPrice_RemainsList.ObjectId
                                AND GoodsPromo.JuridicalId = PriceList.JuridicalId
                                
        WHERE COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) > CURRENT_DATE + INTERVAL '200 DAY' 
          AND (COALESCE (Object_JuridicalGoods.MinimumLot, 0) = 0
               OR Object_JuridicalGoods.IsPromo                  = FALSE
              )
          AND COALESCE (SupplierFailures.GoodsId, 0) = 0)
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
      , ddd.GoodsCode
      , ddd.GoodsName
      , ddd.Remains
      , ddd.MinExpirationDate
      , ddd.MidPriceSale
      , ddd.MaxPriceIncome
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

        -- с 07,04,2019
      , (FinalPrice - FinalPrice * ((ddd.Deferment) * COALESCE (tmpCostCredit.Percent, vbCostCredit)) / 100) :: TFloat AS SuperFinalPrice
/* */
      , ddd.isTOP
      , ddd.isTOP_Price
      , ddd.PercentMarkup
      , ddd.isJuridicalPromo

    FROM (SELECT DISTINCT
          tmpMinPrice_RemainsPrice.GoodsId
          , tmpMinPrice_RemainsPrice.GoodsId_retail
          , tmpMinPrice_RemainsPrice.GoodsCode
          , tmpMinPrice_RemainsPrice.GoodsName
          , tmpMinPrice_RemainsPrice.Remains
          , tmpMinPrice_RemainsPrice.MinExpirationDate
          , tmpMinPrice_RemainsPrice.MidPriceSale
          , tmpMinPrice_RemainsPrice.MaxPriceIncome
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
        COALESCE(MinPriceList.GoodsId, _tmpMinPrice_Remains.ObjectId),
        COALESCE(MinPriceList.GoodsId_retail, _tmpMinPrice_Remains.ObjectId_retail),
        COALESCE(MinPriceList.GoodsCode, Goods.GoodsCodeInt),
        COALESCE(MinPriceList.GoodsName, Goods.GoodsName),
        COALESCE(MinPriceList.Remains,  _tmpMinPrice_Remains.Amount),
        COALESCE(MinPriceList.MaxPriceIncome,  _tmpMinPrice_Remains.MaxPriceIncome) ::TFloat,
        COALESCE(MinPriceList.MidPriceSale,  _tmpMinPrice_Remains.MidPriceSale) ::TFloat,
        COALESCE(MinPriceList.MinExpirationDate,  _tmpMinPrice_Remains.MinExpirationDate),
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
        COALESCE (MinPriceList.isTop, NULLIF (GoodsPrice.isTOP, FALSE), COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE) :: Boolean) AS isTOP,
        COALESCE (MinPriceList.isTOP_Price, GoodsPrice.isTOP, FALSE) :: Boolean AS isTOP_Price,
        
        CASE WHEN tmpCountJuridical.CountJuridical > 1 THEN FALSE ELSE TRUE END :: Boolean AS isOneJuridical,
        
        COALESCE (MinPriceList.PercentMarkup, GoodsPrice.PercentMarkup, 0) :: TFloat  AS PercentMarkup,
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
    FROM MinPriceList
    
         FULL JOIN _tmpMinPrice_Remains ON _tmpMinPrice_Remains.ObjectId_retail = MinPriceList.GoodsId_retail

         -- товар "сети"
         LEFT JOIN Object_Goods_View AS Goods ON Goods.Id = _tmpMinPrice_Remains.ObjectId
         LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = _tmpMinPrice_Remains.ObjectId
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                 ON ObjectBoolean_Goods_TOP.ObjectId = _tmpMinPrice_Remains.ObjectId_retail
                                AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
         
         LEFT JOIN tmpCountJuridical ON tmpCountJuridical.GoodsId = MinPriceList.GoodsId

         LEFT JOIN FinalListPromo AS FinalListOne ON FinalListOne.GoodsId = MinPriceList.GoodsId
                                 AND FinalListOne.Ord = 1
         LEFT JOIN FinalListPromo AS FinalListTwo ON FinalListTwo.GoodsId = MinPriceList.GoodsId
                                 AND FinalListTwo.Ord = 2
    WHERE COALESCE(MinPriceList.Ord, 1) = 1 
      AND (COALESCE(MinPriceList.Ord, 0) = 1 OR
           COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)) = FALSE AND
           COALESCE (GoodsPrice.isTOP, FALSE) = FALSE)
      AND (vbPercentСhange <> 0 OR COALESCE(MinPriceList.JuridicalId, 0) <> 0)
    ;

--raise notice 'Value 5: %', timenow();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_AllGoods (Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 31.10.19                                                                                      * isTopNo_Unit только для TOP сети
 07.02.19         * если isBonusClose = true бонусы не учитываем
 14.01.19         * tmpJuridicalSettingsItem - теперь значения Бонус берем из Итемов
 11.10.17         * add area
 16.02.16         * add isOneJuridical
 03.12.15                                                                          *
 14.04.18                                                                                       *
*/

-- тест
-- SELECT * FROM lpSelectMinPrice_AllGoods (3031072, 3031066, 3) WHERE GoodsCode = 1069 -- !!!Никополь!!!
-- SELECT * FROM lpSelectMinPrice_AllGoods (2144918, 2140932, 3) WHERE GoodsCode = 4797 -- !!!Никополь!!!
-- SELECT * FROM lpSelectMinPrice_AllGoods (1781716 , 4, 3) WHERE GoodsCode = 8969 -- "Аптека_"
-- SELECT * FROM lpSelectMinPrice_AllGoods (183292, 4, 3) WHERE GoodsCode = 8969 -- "Аптека_1 пр_Правды_6"
-- SELECT * FROM lpSelectMinPrice_AllGoods (183292, 4, 3) 

-- 
SELECT * FROM lpSelectMinPrice_AllGoods (183289 , 4, 3)
; 

