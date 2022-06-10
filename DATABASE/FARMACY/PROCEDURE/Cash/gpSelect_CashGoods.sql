-- Function: gpSelect_CashGoods()

DROP FUNCTION IF EXISTS gpSelect_CashGoods (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoods(
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               GoodsCode Integer,
               GoodsName TVarChar,
               JuridicalName TVarChar,
               ContractName TVarChar,
               AreaName TVarChar,
               NDS TFloat,
               NDSKindId Integer,
               JuridicalPrice TFloat,
               MarginPercent TFloat,
               ExpirationDate TDateTime,
               Price TFloat,
               MCSValue TFloat,
               IsClose Boolean,
               isFirst  Boolean,
               isSecond Boolean,
               isResolution_224 Boolean,
               isSPRegistry_1303 Boolean,
               PriceOOC1303 TFloat, 
               AmoutDiffUser TFloat,
               AmoutDiff TFloat,
               AmountDiffPrev TFloat)

AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbObjectId    Integer;
  DECLARE vbUnitId      Integer;
  DECLARE vbUnitIdStr   TVarChar;
  DECLARE vbRetailId    Integer;
  DECLARE vbAreaId      Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbPartnerMedicalId  Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');
     vbUnitIdStr := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '0');
     IF vbUnitIdStr <> '' THEN
        vbUnitId := vbUnitIdStr;
     ELSE
     	vbUnitId := 0;
     END IF;


     RAISE notice '1 <%>', CLOCK_TIMESTAMP();

     SELECT ObjectLink_Unit_Juridical.ChildObjectId
          , ObjectLink_Juridical_Retail.ChildObjectId
          , ObjectLink_ObjectLink_Unit_Area.ChildObjectId
          , COALESCE (ObjectLink_Unit_PartnerMedical.ChildObjectId, 0)
     INTO vbJuridicalId, vbRetailId, vbAreaId, vbPartnerMedicalId
     FROM ObjectLink AS ObjectLink_Unit_Juridical
          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          INNER JOIN ObjectLink AS ObjectLink_ObjectLink_Unit_Area
                                ON ObjectLink_ObjectLink_Unit_Area.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                               AND ObjectLink_ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical
                               ON ObjectLink_Unit_PartnerMedical.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                              AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
     WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();

     RAISE notice '2 <%>', CLOCK_TIMESTAMP();
     
    --
    CREATE TEMP TABLE _GoodsPriceAll (
                             GoodsId Integer,
                             JuridicalId Integer,
                             ContractId Integer,
                             AreaId Integer,
                             NDS TFloat,
                             NDSKindId Integer,
                             JuridicalPrice TFloat,
                             MarginPercent TFloat,
                             ExpirationDate TDateTime,
                             Price TFloat,
                             MCSValue TFloat,
                             IsClose Boolean,
                             isFirst  Boolean,
                             isSecond Boolean,
                             isResolution_224 Boolean) ON COMMIT DROP;

     WITH DD AS (SELECT DISTINCT
            Object_MarginCategoryItem_View.MarginPercent,
            Object_MarginCategoryItem_View.MinPrice,
            Object_MarginCategoryItem_View.MarginCategoryId,
            ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
        FROM Object_MarginCategoryItem_View
             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                           AND Object_MarginCategoryItem.isErased = FALSE
                )
        , MarginCondition AS (SELECT
            D1.MarginCategoryId,
            D1.MarginPercent,
            D1.MinPrice,
            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
        FROM DD AS D1
            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1)

          -- Список цены + ТОП
        , GoodsPrice AS
             (SELECT ObjectLink_Price_Goods.ChildObjectId              AS GoodsId,
                     COALESCE (ObjectBoolean_Top.ValueData, FALSE)     AS isTOP,
                     COALESCE (ObjectFloat_PercentMarkup.ValueData, 0) AS PercentMarkup,
                     MCS_Value.ValueData                               AS MCSValue
              FROM ObjectLink AS ObjectLink_Price_Unit
                   INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                         ON ObjectLink_Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND ObjectLink_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                           ON ObjectBoolean_Top.ObjectId  = ObjectLink_Price_Unit.ObjectId
                                          AND ObjectBoolean_Top.DescId    = zc_ObjectBoolean_Price_Top()
                   LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                         ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                   LEFT JOIN ObjectFloat AS MCS_Value
                                         ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
              WHERE ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                AND (ObjectBoolean_Top.ValueData = TRUE OR ObjectFloat_PercentMarkup.ValueData <> 0 OR MCS_Value.ValueData <> 0)
             )
          , tmpContractSettings AS (SELECT Object_ContractSettings.Id               AS Id
                                         , Object_ContractSettings.isErased         AS isErased
                                         , ObjectLink_MainJuridical.ChildObjectId   AS MainJuridicalId
                                         , ObjectLink_Contract.ChildObjectId        AS ContractId
                                         , ObjectLink_Area.ChildObjectId            AS AreaId
                                    FROM ObjectLink AS ObjectLink_MainJuridical
                                       INNER JOIN ObjectLink AS ObjectLink_Contract
                                                             ON ObjectLink_Contract.ObjectId = ObjectLink_MainJuridical.ObjectId
                                                            AND ObjectLink_Contract.DescId = zc_ObjectLink_ContractSettings_Contract()
                                       LEFT JOIN ObjectLink AS ObjectLink_Area
                                                            ON ObjectLink_Area.ObjectId = ObjectLink_MainJuridical.ObjectId
                                                           AND ObjectLink_Area.DescId = zc_ObjectLink_ContractSettings_Area()

                                       LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = ObjectLink_MainJuridical.ObjectId
                                    WHERE ObjectLink_MainJuridical.DescId = zc_ObjectLink_ContractSettings_MainJuridical()
                                    )

          , tmpMainJuridicalArea AS (SELECT DISTINCT ObjectLink_JuridicalRetail.ObjectId      AS MainJuridicalId
                                          , ObjectLink_Unit_Area.ChildObjectId                AS AreaId
                                     FROM ObjectLink AS ObjectLink_JuridicalRetail
                                          LEFT JOIN ObjectLink AS OL_Unit_Juridical
                                                               ON OL_Unit_Juridical.ChildObjectId = ObjectLink_JuridicalRetail.ObjectId
                                                              AND OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                          LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                               ON ObjectLink_Unit_Area.ObjectId = OL_Unit_Juridical.ObjectId
                                                              AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                                                             AND  ObjectLink_Unit_Area.ChildObjectId  <> 0
                                     WHERE ObjectLink_JuridicalRetail.DescId = zc_ObjectLink_Juridical_Retail()
                                       AND ObjectLink_JuridicalRetail.ChildObjectId = vbRetailId
                                     )
          , tmpNDSKind AS
                (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                       , ObjectFloat_NDSKind_NDS.ValueData
                 FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                 WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                )
          , tmpJuridicalPriceBasis AS
                (SELECT LoadPriceList.Id
                 FROM LoadPriceList
                 WHERE LoadPriceList.AreaId = zc_Area_Basis()
                   AND LoadPriceList.JuridicalId NOT IN (SELECT LoadPriceList.JuridicalId
                                                         FROM LoadPriceList
                                                         WHERE COALESCE(LoadPriceList.AreaId, 0) = 0 OR COALESCE(LoadPriceList.AreaId, 0) = vbAreaId)
                )
            -- Отказы поставщиков
          , tmpSupplierFailures AS (SELECT DISTINCT
                                           Object_Goods_Juridical.GoodsMainId AS GoodsId
                                         , SupplierFailures.JuridicalId
                                         , SupplierFailures.ContractId
                                    FROM lpSelect_PriceList_SupplierFailures(vbUnitId, vbUserId) AS SupplierFailures
                                    
                                         INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.Id = SupplierFailures.GoodsId
                                    )
          , tmpLoadPriceList AS
                (SELECT LoadPriceList.*
                 FROM LoadPriceList
                 
                      LEFT JOIN tmpJuridicalPriceBasis ON tmpJuridicalPriceBasis.ID = LoadPriceList.Id

                 WHERE (LoadPriceList.AreaId = vbAreaId OR COALESCE (LoadPriceList.AreaId, 0) = 0 OR 
                        vbAreaId = 5959067 AND COALESCE (LoadPriceList.AreaId, 0) = zc_Area_Basis() AND COALESCE(tmpJuridicalPriceBasis.ID, 0) <> 0))
                        
          , tmpJuridicalSettings AS (SELECT DISTINCT
                                            ObjectLink_JuridicalSettings_Juridical.ChildObjectId                AS JuridicalId
                                          , ObjectLink_JuridicalSettings_MainJuridical.ChildObjectId            AS MainJuridicalId
                                          , COALESCE (ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0)   AS ContractId
                                          , COALESCE (ObjectBoolean_isPriceCloseOrder.ValueData, FALSE)         AS isPriceCloseOrder
                                     FROM ObjectLink AS ObjectLink_JuridicalSettings_Retail

                                          JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical
                                                          ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()
                                                         AND ObjectLink_JuridicalSettings_Juridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId

                                          JOIN ObjectLink AS ObjectLink_JuridicalSettings_MainJuridical
                                                          ON ObjectLink_JuridicalSettings_MainJuridical.DescId = zc_ObjectLink_JuridicalSettings_MainJuridical()
                                                         AND ObjectLink_JuridicalSettings_MainJuridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId

                                          LEFT JOIN ObjectLink AS ObjectLink_JuridicalSettings_Contract
                                                               ON ObjectLink_JuridicalSettings_Contract.DescId = zc_ObjectLink_JuridicalSettings_Contract()
                                                              AND ObjectLink_JuridicalSettings_Contract.ObjectId = ObjectLink_JuridicalSettings_Juridical.ObjectId

                                          LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceCloseOrder
                                                                  ON ObjectBoolean_isPriceCloseOrder.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                                                 AND ObjectBoolean_isPriceCloseOrder.DescId = zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder()

                                     WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                                     AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = vbRetailId)
                                 
          , tmpLoadPriceListItem AS
                (SELECT
                         LoadPriceList.JuridicalId           AS JuridicalId,
                         LoadPriceList.ContractId            AS ContractId,
                         LoadPriceList.AreaId                AS AreaId,
                         LoadPriceListItem.GoodsID           AS GoodsId,
                         LoadPriceListItem.GoodsNDS          AS GoodsNDS,
                         LoadPriceListItem.Price             AS JuridicalPrice,
                         LoadPriceListItem.ExpirationDate    AS ExpirationDate,
                         LoadPriceListItem.Price             AS Price

                       FROM tmpLoadPriceList AS LoadPriceList

                            INNER JOIN tmpMainJuridicalArea ON (LoadPriceList.AreaId = COALESCE (tmpMainJuridicalArea.AreaId, 0)
                                                       OR COALESCE (LoadPriceList.AreaId, 0)  = 0
                                                          )

                            LEFT JOIN tmpContractSettings ON tmpContractSettings.MainJuridicalId = tmpMainJuridicalArea.MainJuridicalId
                                                         AND tmpContractSettings.ContractId = LoadPriceList.ContractId
                                                         AND (COALESCE (tmpContractSettings.AreaId, 0) = COALESCE (LoadPriceList.AreaId, 0))

                            LEFT JOIN tmpJuridicalSettings AS JuridicalSettings
                                                           ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                                                          AND JuridicalSettings.MainJuridicalId = tmpMainJuridicalArea.MainJuridicalId
                                                          AND JuridicalSettings.ContractId = COALESCE (LoadPriceList.ContractId, 0)

                            INNER JOIN LoadPriceListItem ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                            
                            LEFT JOIN tmpSupplierFailures AS SupplierFailures
                                                          ON SupplierFailures.GoodsId = LoadPriceListItem.GoodsId
                                                         AND SupplierFailures.JuridicalId = LoadPriceList.JuridicalId
                                                         AND SupplierFailures.ContractId = LoadPriceList.ContractId

                     WHERE COALESCE (tmpContractSettings.isErased, False) = False
                       AND COALESCE (JuridicalSettings.isPriceCloseOrder, TRUE) = False
                       AND tmpMainJuridicalArea.MainJuridicalId = vbJuridicalId
                       AND COALESCE (SupplierFailures.GoodsId, 0) = 0
                    )
          , tmpExpirationDate AS
                 (SELECT tmpLoadPriceListItem.JuridicalId
                       , tmpLoadPriceListItem.GoodsID  
                       , MAX(tmpLoadPriceListItem.ExpirationDate)     AS ExpirationDate
                  FROM tmpLoadPriceListItem
                  GROUP BY tmpLoadPriceListItem.JuridicalId, tmpLoadPriceListItem.GoodsID)
          , tmpExpirationDateMonth AS
                 (SELECT MAX(ObjectFloat_ExpirationDateMonth.ValueData) AS DateMonth
                  FROM (SELECT DISTINCT tmpExpirationDate.JuridicalId FROM tmpExpirationDate) AS LoadPriceListItem

                       LEFT JOIN ObjectFloat AS ObjectFloat_ExpirationDateMonth
                                             ON ObjectFloat_ExpirationDateMonth.ObjectId = LoadPriceListItem.JuridicalId
                                            AND ObjectFloat_ExpirationDateMonth.DescId = zc_ObjectFloat_Juridical_ExpirationDateMonth())
          , tmpObject_MarginCategoryLink AS (SELECT
                                                     ObjectLink_MarginCategoryLink_MarginCategory.ObjectId      AS Id
                                                   , ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId AS MarginCategoryId
                                                   , ObjectLink_MarginCategoryLink_Unit.ChildObjectId           AS UnitId
                                                   , ObjectLink_MarginCategoryLink_Juridical.ChildObjectId      AS JuridicalId
                                                   , Object_MarginCategoryLink.isErased                         AS isErased

                                             FROM ObjectLink AS ObjectLink_MarginCategoryLink_MarginCategory
                                                   LEFT JOIN Object AS Object_MarginCategoryLink ON Object_MarginCategoryLink.Id = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
                                                   LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId

                                                   LEFT JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                                                                        ON ObjectLink_MarginCategoryLink_Unit.ObjectId = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
                                                                       AND ObjectLink_MarginCategoryLink_Unit.DescId = zc_ObjectLink_MarginCategoryLink_Unit()
                                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_MarginCategoryLink_Unit.ChildObjectId
                                                       
                                                   LEFT JOIN ObjectLink AS ObjectLink_MarginCategoryLink_Juridical
                                                                        ON ObjectLink_MarginCategoryLink_Juridical.ObjectId = ObjectLink_MarginCategoryLink_MarginCategory.ObjectId
                                                                       AND ObjectLink_MarginCategoryLink_Juridical.DescId = zc_ObjectLink_MarginCategoryLink_Juridical()
                                                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_MarginCategoryLink_Juridical.ChildObjectId

                                             WHERE ObjectLink_MarginCategoryLink_MarginCategory.DescId = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                                               AND Object_MarginCategoryLink.isErased    = FALSE
                                               AND (ObjectLink_MarginCategoryLink_Unit.ChildObjectId = vbUnitId OR COALESCE (ObjectLink_MarginCategoryLink_Unit.ChildObjectId, 0) = 0)
                                             )


        INSERT INTO _GoodsPriceAll
        SELECT

           Object_Goods_Retail.Id                  AS GoodsId,
           LoadPriceListItem.JuridicalId           AS JuridicalId,
           LoadPriceListItem.ContractId            AS ContractId,
           LoadPriceListItem.AreaId                AS AreaId,
           COALESCE(CASE WHEN LoadPriceListItem.GoodsNDS LIKE '%2%' THEN 20 
                         WHEN LoadPriceListItem.GoodsNDS LIKE '%7%' THEN 7 
                         WHEN LoadPriceListItem.GoodsNDS IN ('0', 'Без НДС') THEN 0 END,
                         ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat  AS NDS,
           Object_Goods.NDSKindId,
           LoadPriceListItem.Price             AS JuridicalPrice,
           CASE WHEN COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), Object_Goods_Retail.isTop) = TRUE
                     THEN COALESCE (NULLIF (GoodsPrice.PercentMarkup, 0), COALESCE (Object_Goods_Retail.PercentMarkup, 0))
                ELSE COALESCE (MarginCondition.MarginPercent, 0) + COALESCE (ObjectFloat_Juridical_Percent.valuedata, 0)
             END                       :: TFloat AS MarginPercent,
           LoadPriceListItem.ExpirationDate    AS ExpirationDate,

           zfCalc_SalePrice((LoadPriceListItem.Price * (100 + COALESCE(CASE WHEN LoadPriceListItem.GoodsNDS LIKE '%2%' THEN 20 
                                                                            WHEN LoadPriceListItem.GoodsNDS LIKE '%7%' THEN 7 
                                                                            WHEN LoadPriceListItem.GoodsNDS IN ('0', 'Без НДС') THEN 0 END,
                                                                            ObjectFloat_NDSKind_NDS.ValueData, 0))/100),                         -- Цена С НДС
                             CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                      THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.valuedata, 0)
                                  ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.valuedata, 0)
                             END,                                                                             -- % наценки в КАТЕГОРИИ
                             COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), Object_Goods_Retail.isTop),           -- ТОП позиция
                             COALESCE (NULLIF (GoodsPrice.PercentMarkup, 0), Object_Goods_Retail.PercentMarkup),  -- % наценки у товара
                             0.0, --ObjectFloat_Juridical_Percent.valuedata,                                  -- % корректировки у Юр Лица для ТОПа
                             Object_Goods_Retail.Price                                                        -- Цена у товара (фиксированная)
                           )         :: TFloat AS Price,
           GoodsPrice.MCSValue       AS MCSValue,
           Object_Goods.IsClose AS IsClose,
           Object_Goods_Retail.isFirst AS isFirst,
           Object_Goods_Retail.issecond AS isSecond,
           Object_Goods.isResolution_224 AS isResolution_224

         FROM tmpLoadPriceListItem AS LoadPriceListItem

              LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                    ON ObjectFloat_Juridical_Percent.ObjectId = LoadPriceListItem.JuridicalId
                                   AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

              LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                    ON ObjectFloat_Contract_Percent.ObjectId = LoadPriceListItem.ContractId
                                   AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

              LEFT JOIN ObjectFloat AS ObjectFloat_ExpirationDateMonth
                                    ON ObjectFloat_ExpirationDateMonth.ObjectId = LoadPriceListItem.JuridicalId
                                   AND ObjectFloat_ExpirationDateMonth.DescId = zc_ObjectFloat_Juridical_ExpirationDateMonth()

              LEFT JOIN tmpObject_MarginCategoryLink AS Object_MarginCategoryLink
                                                       ON (Object_MarginCategoryLink.UnitId = vbUnitId)
                                                      AND Object_MarginCategoryLink.JuridicalId = LoadPriceListItem.JuridicalId
                                                      AND Object_MarginCategoryLink.isErased    = FALSE

              LEFT JOIN tmpObject_MarginCategoryLink AS Object_MarginCategoryLink_all
                                                       ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                      AND Object_MarginCategoryLink_all.JuridicalId = LoadPriceListItem.JuridicalId
                                                      AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                      AND Object_MarginCategoryLink.JuridicalId IS NULL

              INNER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId
              INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = LoadPriceListItem.GoodsId
                                                                   AND Object_Goods_Retail.RetailId = vbRetailId
              LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

              LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                      AND (LoadPriceListItem.Price * (100 + COALESCE(CASE WHEN LoadPriceListItem.GoodsNDS LIKE '%2%' THEN 20 
                                                                                          WHEN LoadPriceListItem.GoodsNDS LIKE '%7%' THEN 7 
                                                                                          WHEN LoadPriceListItem.GoodsNDS IN ('0', 'Без НДС') THEN 0 END,
                                                                                          ObjectFloat_NDSKind_NDS.ValueData, 0))/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

             LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods_Retail.Id
             
             LEFT JOIN tmpExpirationDate ON tmpExpirationDate.JuridicalId = LoadPriceListItem.JuridicalId
                                        AND tmpExpirationDate.GoodsId = LoadPriceListItem.GoodsId
                                        
             LEFT JOIN tmpExpirationDateMonth ON 1 = 1
             
       WHERE (COALESCE(ObjectFloat_ExpirationDateMonth.ValueData::Integer, 0) = 0 
          OR COALESCE(LoadPriceListItem.ExpirationDate, zc_DateEnd()) > 
             CURRENT_DATE + (COALESCE(ObjectFloat_ExpirationDateMonth.ValueData::Integer, 0)::tvarchar||' MONTH')::INTERVAL
          OR COALESCE(tmpExpirationDate.ExpirationDate, zc_DateEnd()) <=
             CURRENT_DATE + (COALESCE(tmpExpirationDateMonth.DateMonth::Integer, 0)::tvarchar||' MONTH')::INTERVAL);

     RAISE notice '3 <%>', CLOCK_TIMESTAMP();

     ANALYSE _GoodsPriceAll;
     
     RETURN QUERY
     WITH GoodsPriceAll AS (SELECT
                                  ROW_NUMBER() OVER (PARTITION BY _GoodsPriceAll.GoodsId ORDER BY _GoodsPriceAll.Price, _GoodsPriceAll.ContractId)::Integer AS Ord,
                                  _GoodsPriceAll.GoodsId           AS GoodsId,
                                  _GoodsPriceAll.JuridicalId       AS JuridicalId,
                                  _GoodsPriceAll.ContractId        AS ContractId,
                                  _GoodsPriceAll.AreaId            AS AreaId,
                                  _GoodsPriceAll.NDS               AS NDS,
                                  _GoodsPriceAll.NDSKindId         AS NDSKindId,
                                  _GoodsPriceAll.JuridicalPrice    AS JuridicalPrice,
                                  _GoodsPriceAll.MarginPercent     AS MarginPercent,
                                  _GoodsPriceAll.ExpirationDate    AS ExpirationDate,
                                  _GoodsPriceAll.MCSValue          AS MCSValue,
                                  _GoodsPriceAll.Price             AS Price,
                                  _GoodsPriceAll.isClose           AS isClose,
                                  _GoodsPriceAll.isFirst           AS isFirst,
                                  _GoodsPriceAll.isSecond          AS isSecond,
                                  _GoodsPriceAll.isResolution_224  AS isResolution_224
                            FROM _GoodsPriceAll)
       , tmpGoodsDiscountTools AS (SELECT ObjectLink_DiscountExternal.ChildObjectId  AS DiscountExternalID
                                   FROM Object AS Object_DiscountExternalTools
                                         LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                              ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                             AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                         LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                              ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                             AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                    WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                                      AND Object_DiscountExternalTools.isErased = FALSE
                                      AND ObjectLink_Unit.ChildObjectId = vbUnitId)                            
       , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.Id              AS Id
                                   , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                FROM Object AS Object_BarCode
                                    INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                          ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                         AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                    INNER JOIN Object_Goods_Retail AS Object_Goods_4 ON Object_Goods_4.Id = ObjectLink_BarCode_Goods.ChildObjectId
                                    INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_4.GoodsMainId
                                                                                         AND Object_Goods_Retail.RetailId = vbRetailId

                                    LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                         ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                        AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()

                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                            ON ObjectBoolean_GoodsForProject.ObjectId = ObjectLink_BarCode_Object.ChildObjectId 
                                                           AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()
                                    LEFT JOIN tmpGoodsDiscountTools ON tmpGoodsDiscountTools.DiscountExternalID = ObjectLink_BarCode_Object.ChildObjectId
                                WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                  AND Object_BarCode.isErased = False
                                  AND COALESCE(ObjectBoolean_GoodsForProject.ValueData, False) = TRUE
                                  AND COALESCE(tmpGoodsDiscountTools.DiscountExternalID, 0) = 0)
       , tmpGoodsSP_1303 AS (SELECT * 
                             FROM gpSelect_GoodsSPRegistry_1303_Unit (inUnitId := vbUnitId, inGoodsId := 0, inisCalc := COALESCE (vbPartnerMedicalId, 0) > 0, inSession := inSession)
                             )

     SELECT
              GoodsPriceAll.GoodsId             AS Id,
              Object_Goods.ObjectCode           AS GoodsCode,
              Object_Goods.Name                 AS GoodsName,
              Object_Juridical.ValueData        AS JuridicalName,
              Object_Contract.ValueData         AS ContractName,
              Object_Area.ValueData             AS AreaName,
              GoodsPriceAll.NDS                 AS NDS,
              GoodsPriceAll.NDSKindId           AS NDSKindId,
              GoodsPriceAll.JuridicalPrice      AS JuridicalPrice,
              GoodsPriceAll.MarginPercent       AS MarginPercent,
              GoodsPriceAll.ExpirationDate      AS ExpirationDate,
              GoodsPriceAll.Price               AS Price,
              GoodsPriceAll.MCSValue            AS MCSValue,
              GoodsPriceAll.isClose             AS isClose,
              GoodsPriceAll.isFirst             AS isFirst,
              GoodsPriceAll.isSecond            AS isSecond,
              GoodsPriceAll.isResolution_224    AS isResolution_224,
              COALESCE (tmpGoodsSP_1303.GoodsId, 0) <> 0          AS isSPRegistry_1303,
              Round(tmpGoodsSP_1303.PriceOptSP * 1.1, 2)::TFloat  AS PriceOOC1303,
              NULL::TFloat                      AS AmoutDiffUser,
              NULL::TFloat                      AS AmoutDiff,
              NULL::TFloat                      AS AmountDiffPrev

     FROM GoodsPriceAll

          INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = GoodsPriceAll.GoodsId
          INNER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = GoodsPriceAll.JuridicalId
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = GoodsPriceAll.ContractId
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = GoodsPriceAll.AreaId
          LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.ID =  GoodsPriceAll.GoodsId
          LEFT JOIN tmpGoodsSP_1303 ON tmpGoodsSP_1303.GoodsId = GoodsPriceAll.GoodsId

     WHERE GoodsPriceAll.Ord = 1
       AND COALESCE(tmpGoodsDiscount.ID, 0) = 0;

     RAISE notice '4 <%>', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 28.03.20                                                                                     * учет регионов
 18.03.20                                                                                     * оптимизация
 12.02.20                                                                                     *
 20.01.19                                                                                     *
 05.12.18                                                                                     *
 26.11.18                                                                                     *
 11.09.18        *
*/

-- тест 

SELECT * FROM gpSelect_CashGoods('3')