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
               JuridicalPrice TFloat,
               MarginPercent TFloat,
               ExpirationDate TDateTime,
               Price TFloat,
               MCSValue TFloat,
               IsClose Boolean,
               isFirst  Boolean,
               isSecond Boolean)

AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbObjectId    Integer;
  DECLARE vbUnitId      Integer;
  DECLARE vbUnitIdStr   TVarChar;
  DECLARE vbRetailId    Integer;
  DECLARE vbAreaId      Integer;
  DECLARE vbJuridicalId Integer;
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

     SELECT ObjectLink_Unit_Juridical.ChildObjectId, ObjectLink_Juridical_Retail.ChildObjectId, ObjectLink_ObjectLink_Unit_Area.ChildObjectId
     INTO vbJuridicalId, vbRetailId, vbAreaId
     FROM ObjectLink AS ObjectLink_Unit_Juridical
          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
          INNER JOIN ObjectLink AS ObjectLink_ObjectLink_Unit_Area
                                ON ObjectLink_ObjectLink_Unit_Area.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                               AND ObjectLink_ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
     WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();

    --
    CREATE TEMP TABLE _GoodsPriceAll (
                             GoodsId Integer,
                             JuridicalId Integer,
                             ContractId Integer,
                             AreaId Integer,
                             NDS TFloat,
                             JuridicalPrice TFloat,
                             MarginPercent TFloat,
                             ExpirationDate TDateTime,
                             Price TFloat,
                             MCSValue TFloat,
                             IsClose Boolean,
                             isFirst  Boolean,
                             isSecond Boolean) ON COMMIT DROP;

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
          , JuridicalSettings AS
             (SELECT DISTINCT JuridicalId, ContractId, isPriceCloseOrder
                           FROM lpSelect_Object_JuridicalSettingsRetail (vbObjectId) AS JuridicalSettings
                     LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = JuridicalSettings.MainJuridicalId
              WHERE COALESCE (Object_ContractSettings.isErased, FALSE) = FALSE
                   AND JuridicalSettings.MainJuridicalId = vbJuridicalId
             )
          , tmpNDSKind AS
                (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                       , ObjectFloat_NDSKind_NDS.ValueData
                 FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                 WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                )

        INSERT INTO _GoodsPriceAll
        SELECT

           Object_Goods_Retail.Id              AS GoodsId,
           LoadPriceList.JuridicalId           AS JuridicalId,
           LoadPriceList.ContractId            AS ContractId,
           LoadPriceList.AreaId                AS AreaId,
           COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat  AS NDS,
           LoadPriceListItem.Price             AS JuridicalPrice,
           CASE WHEN COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), Object_Goods_Retail.isTop) = TRUE
                     THEN COALESCE (NULLIF (GoodsPrice.PercentMarkup, 0), COALESCE (ObjectFloat_Goods_PercentMarkup.ValueData, 0))
                ELSE COALESCE (MarginCondition.MarginPercent, 0) + COALESCE (ObjectFloat_Juridical_Percent.valuedata, 0)
             END                       :: TFloat AS MarginPercent,
           LoadPriceListItem.ExpirationDate    AS ExpirationDate,

           zfCalc_SalePrice((LoadPriceListItem.Price * (100 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0))/100),                         -- Цена С НДС
                             CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData, 0) <> 0
                                      THEN MarginCondition.MarginPercent + COALESCE (ObjectFloat_Contract_Percent.valuedata, 0)
                                  ELSE MarginCondition.MarginPercent + COALESCE (ObjectFloat_Juridical_Percent.valuedata, 0)
                             END,                                                                             -- % наценки в КАТЕГОРИИ
                             COALESCE (NULLIF (GoodsPrice.isTOP, FALSE), Object_Goods_Retail.isTop),           -- ТОП позиция
                             COALESCE (NULLIF (GoodsPrice.PercentMarkup, 0), ObjectFloat_Goods_PercentMarkup.ValueData),  -- % наценки у товара
                             0.0, --ObjectFloat_Juridical_Percent.valuedata,                                  -- % корректировки у Юр Лица для ТОПа
                             ObjectFloat_Goods_Price.valuedata                                                            -- Цена у товара (фиксированная)
                           )         :: TFloat AS Price,
           GoodsPrice.MCSValue       AS MCSValue,
           Object_Goods.IsClose AS IsClose,
           Object_Goods_Retail.isFirst AS isFirst,
           Object_Goods_Retail.issecond AS isSecond

         FROM LoadPriceListItem

              INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

              LEFT JOIN JuridicalSettings
                      ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                     AND JuridicalSettings.ContractId = LoadPriceList.ContractId
--                     AND JuridicalSettings.ArId = LoadPriceList.AreaId

              LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                    ON ObjectFloat_Juridical_Percent.ObjectId = LoadPriceList.JuridicalId
                                   AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

              LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                    ON ObjectFloat_Contract_Percent.ObjectId = LoadPriceList.ContractId
                                   AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

              LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                       ON (Object_MarginCategoryLink.UnitId = 183292)
                                                      AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

              LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink_all
                                                       ON COALESCE (Object_MarginCategoryLink_all.UnitId, 0) = 0
                                                      AND Object_MarginCategoryLink_all.JuridicalId = LoadPriceList.JuridicalId
                                                      AND Object_MarginCategoryLink_all.isErased    = FALSE
                                                      AND Object_MarginCategoryLink.JuridicalId IS NULL

              INNER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId
              INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = LoadPriceListItem.GoodsId
                                                                   AND Object_Goods_Retail.RetailId = vbRetailId
              LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId
              LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                                     ON ObjectFloat_Goods_PercentMarkup.ObjectId = Object_Goods_Retail.Id
                                    AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()
              LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                                    ON ObjectFloat_Goods_Price.ObjectId = Object_Goods_Retail.Id
                                   AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()

              LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = COALESCE (Object_MarginCategoryLink.MarginCategoryId, Object_MarginCategoryLink_all.MarginCategoryId)
                                      AND (LoadPriceListItem.Price * (100 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0))/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice

           LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = Object_Goods_Retail.Id


        WHERE COALESCE(JuridicalSettings.isPriceCloseOrder, TRUE)  = FALSE
          AND (LoadPriceList.AreaId = 0 OR COALESCE (LoadPriceList.AreaId, 0) = vbAreaId OR COALESCE(vbAreaId, 0) = 0/* OR 
               COALESCE (LoadPriceList.AreaId, 0) = zc_Area_Basis()*/);

     ANALYSE _GoodsPriceAll;

     RETURN QUERY
     WITH GoodsPriceAll AS (
         SELECT
              ROW_NUMBER() OVER (PARTITION BY _GoodsPriceAll.GoodsId ORDER BY _GoodsPriceAll.Price, _GoodsPriceAll.ContractId)::Integer AS Ord,
              _GoodsPriceAll.GoodsId           AS GoodsId,
              _GoodsPriceAll.JuridicalId       AS JuridicalId,
              _GoodsPriceAll.ContractId        AS ContractId,
              _GoodsPriceAll.AreaId            AS AreaId,
              _GoodsPriceAll.NDS               AS NDS,
              _GoodsPriceAll.JuridicalPrice    AS JuridicalPrice,
              _GoodsPriceAll.MarginPercent     AS MarginPercent,
              _GoodsPriceAll.ExpirationDate    AS ExpirationDate,
              _GoodsPriceAll.MCSValue          AS MCSValue,
              _GoodsPriceAll.Price             AS Price,
              _GoodsPriceAll.isClose           AS isClose,
              _GoodsPriceAll.isFirst           AS isFirst,
              _GoodsPriceAll.isSecond          AS isSecond
         FROM _GoodsPriceAll)

     SELECT
              GoodsPriceAll.GoodsId             AS Id,
              Object_Goods.ObjectCode           AS GoodsCode,
              Object_Goods.ValueData            AS GoodsName,
              Object_Juridical.ValueData        AS JuridicalName,
              Object_Contract.ValueData         AS ContractName,
              Object_Area.ValueData             AS AreaName,
              GoodsPriceAll.NDS                 AS NDS,
              GoodsPriceAll.JuridicalPrice      AS JuridicalPrice,
              GoodsPriceAll.MarginPercent       AS MarginPercent,
              GoodsPriceAll.ExpirationDate      AS ExpirationDate,
              GoodsPriceAll.Price               AS Price,
              GoodsPriceAll.MCSValue            AS MCSValue,
              GoodsPriceAll.isClose             AS isClose,
              GoodsPriceAll.isFirst             AS isFirst,
              GoodsPriceAll.isSecond            AS isSecond

     FROM GoodsPriceAll

          INNER JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsPriceAll.GoodsId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = GoodsPriceAll.JuridicalId
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = GoodsPriceAll.ContractId
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = GoodsPriceAll.AreaId

     WHERE Ord = 1;

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

-- тест SELECT * FROM gpSelect_CashGoods('3');