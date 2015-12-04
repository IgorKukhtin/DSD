DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_AllGoodsPrice (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_AllGoodsPrice(
    --IN inGoodsCode     Integer    -- поиск товаров
    IN inUnitId        Integer     -- Подразделение
  , IN inMinPercent    TFloat      -- Минимальный % для подразделений, у которых категория переоценки не установлена
  , IN inVAT20         Boolean     -- Переоценивать товары с 20% НДС
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    Id                  Integer,    --ИД товара
    Code                Integer,    --Код товара
    GoodsName           TVarChar,   --Наименование товара
    LastPrice           TFloat,     --Текущая цена
    RemainsCount        TFloat,     --Остаток
    NDS                 TFloat,     --ставка НДС
    NewPrice            TFloat,     --Новая цена
    MinMarginPercent    TFloat,     --минимальный % отклонения
    PriceDiff           TFloat,     --% отклонения
    ExpirationDate      TDateTime,  --Срок годности
    JuridicalName       TVarChar,   --Поставщик
    Juridical_Price     TFloat,     --Цена у поставщика
    MarginPercent       TFloat,     --% наценки по точке
    Juridical_GoodsName TVarChar,   --Наименование у поставщика
    ProducerName        TVarChar,   --производитель
    SumReprice          TFloat,     --сумма переоценки
    MinExpirationDate   TDateTime   --Минимальный срок годности препарата на точке
    )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbMarginCategoryId Integer;
BEGIN
    vbUserId := inSession;
    vbObjectId := COALESCE(lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

    SELECT
        COALESCE(Object_Unit_View.MarginCategoryId,0)
    INTO
        vbMarginCategoryId
    FROM
        Object_Unit_View
    WHERE
        Object_Unit_View.Id = inUnitId;
  RETURN QUERY
    WITH DD 
    AS 
    (
        SELECT DISTINCT 
            Object_MarginCategoryItem_View.MarginPercent, 
            Object_MarginCategoryItem_View.MinPrice, 
            Object_MarginCategoryItem_View.MarginCategoryId,
            ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
        FROM 
            Object_MarginCategoryItem_View
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
    ), 
    -- DDD 
    -- AS 
    -- (
        -- SELECT 
            -- DD.Id,
            -- DD.Juridical_Price,
            -- DD.MarginPercent,
            -- DD.NewPrice,
            -- DD.LoadPriceListItemId
        -- FROM(
                -- SELECT
                    -- ObjectGoodsView.Id   AS Id,
                    -- LoadPriceListItem.Id AS LoadPriceListItemId,
                    -- CASE 
                      -- WHEN ObjectGoodsView.isTop = TRUE
                          -- THEN  COALESCE(ObjectGoodsView.PercentMarkup, 0)
                                -- - COALESCE(ObjectFloat_Percent.valuedata, 0)
                    -- ELSE COALESCE(MarginCondition.MarginPercent,0)
                         -- + COALESCE(ObjectFloat_Percent.valuedata, 0)
                    -- END::TFloat AS MarginPercent,
                    -- (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat AS Juridical_Price,
                    -- zfCalc_SalePrice((LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100), -- Цена С НДС
                                      -- MarginCondition.MarginPercent + COALESCE(ObjectFloat_Percent.valuedata, 0), -- % наценки
                                      -- ObjectGoodsView.isTop, -- ТОП позиция
                                      -- ObjectGoodsView.PercentMarkup, -- % наценки у товара
                                      -- ObjectFloat_Percent.valuedata,
                                      -- ObjectGoodsView.Price)::TFloat AS NewPrice
                -- FROM 
                    -- LoadPriceListItem 
                    -- JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId
                    -- LEFT JOIN(
                                -- SELECT DISTINCT 
                                -- JuridicalId, 
                                -- ContractId, 
                                -- isPriceClose
                            -- FROM 
                                -- lpSelect_Object_JuridicalSettingsRetail(vbObjectId)) AS JuridicalSettings
                                                                                     -- ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId 
                                                                                    -- AND JuridicalSettings.ContractId = LoadPriceList.ContractId 
                    -- LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                          -- ON ObjectFloat_Percent.ObjectId = LoadPriceList.JuridicalId
                                         -- AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

                    -- LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                             -- ON (Object_MarginCategoryLink.UnitId = inUnitId)    
                                                            -- AND Object_MarginCategoryLink.JuridicalId = LoadPriceList.JuridicalId

                    -- LEFT JOIN Object_Goods_Main_View AS Object_Goods 
                                                     -- ON Object_Goods.Id = LoadPriceListItem.GoodsId
                    -- LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = Object_MarginCategoryLink.MarginCategoryId
                                             -- AND (LoadPriceListItem.Price * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
                    -- LEFT JOIN Object AS Object_Juridical 
                                     -- ON Object_Juridical.Id = LoadPriceList.JuridicalId
                    -- LEFT JOIN Object AS Object_Contract 
                                     -- ON Object_Contract.Id = LoadPriceList.ContractId
                    -- LEFT JOIN Object_Goods_View AS PartnerGoods 
                                                -- ON PartnerGoods.ObjectId = LoadPriceList.JuridicalId 
                                               -- AND PartnerGoods.GoodsCode = LoadPriceListItem.GoodsCode
                    -- LEFT JOIN Object_LinkGoods_View AS LinkGoods 
                                                    -- ON LinkGoods.GoodsMainId = Object_Goods.Id 
                                                   -- AND LinkGoods.GoodsId = PartnerGoods.Id
                    -- LEFT JOIN Object_LinkGoods_View AS LinkGoodsObject 
                                                    -- ON LinkGoodsObject.GoodsMainId = Object_Goods.Id 
                                                   -- AND LinkGoodsObject.ObjectId = vbObjectId
                    -- LEFT JOIN Object_Goods_View AS ObjectGoodsView 
                                                -- ON ObjectGoodsView.Id = LinkGoodsObject.GoodsId
                -- WHERE 
                    -- COALESCE(JuridicalSettings.isPriceClose, FALSE) <> TRUE
                    -- AND
                    -- (
                        -- (
                            -- ObjectGoodsView.isTop = FALSE
                            -- AND
                            -- MarginCondition.MarginCategoryId is not null
                        -- )
                        -- OR
                        -- (
                            -- ObjectGoodsView.isTop = TRUE
                            -- AND
                            -- COALESCE(ObjectGoodsView.PercentMarkup, 0) > 0
                        -- )
                    -- )
            -- ) AS DD
        -- WHERE DD.NewPrice > 0.01
    -- ),
    -- PriceResult AS 
    -- (
        -- Select 
            -- DDDD.Id
           -- ,DDDD.LoadPriceListItemId 
           -- ,DDDD.Juridical_Price
           -- ,DDDD.MarginPercent
           -- ,DDDD.NewPrice
        -- From(
                -- SELECT 
                    -- *, 
                    -- row_number()over(partition by DDD.Id Order By DDD.NewPrice) as ord 
                -- FROM DDD
            -- ) as DDDD
        -- Where 
            -- DDDD.ord = 1
    -- ),
    -- ResultSet AS 
    -- (
        -- SELECT
            -- Object_Goods.Id                  AS Id,
            -- Object_Goods.GoodsCodeInt        AS Code,
            -- Object_Goods.GoodsName           AS GoodsName,
            -- Object_Price.Price               AS LastPrice,
            -- SUM(Container.Amount)::TFloat    AS RemainsCount,
            -- Object_Goods.NDS                 AS NDS,
            -- Object_Goods.NDSKindId           AS NDSKindId,
            -- PriceResult.NewPrice             AS NewPrice,
            -- PriceResult.MarginPercent        AS MarginPercent,
            -- PriceResult.Juridical_Price      AS Juridical_Price,
            -- PriceResult.LoadPriceListItemId  AS LoadPriceListItemId,
            -- MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate
        -- FROM
            -- Object_Goods_View AS Object_Goods
            -- LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              -- ON Object_Price.GoodsId = Object_Goods.ID
                                             -- AND Object_Price.UnitId = inUnitId
            -- LEFT OUTER JOIN Container ON Container.ObjectId = Object_Goods.Id
                                     -- AND Container.DescId = zc_Container_Count()
                                     -- AND Container.WhereObjectId = inUnitId
                                     -- AND Container.Amount <> 0
            -- LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                -- ON CLO_PartionMovementItem.ContainerId = Container.Id
                                               -- AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
            -- LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem 
                                   -- ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
            -- LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                              -- ON MIDate_ExpirationDate.MovementItemId = Object_PartionMovementItem.ObjectCode
                                             -- AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()    
            -- LEFT OUTER JOIN PriceResult ON PriceResult.Id = Object_Goods.Id
        -- WHERE
            -- Object_Goods.ObjectId = vbObjectId
        -- GROUP BY
            -- Object_Goods.Id,
            -- Object_Goods.GoodsCodeInt,
            -- Object_Goods.GoodsName,
            -- Object_Price.Price,
            -- Object_Goods.NDS,
            -- Object_Goods.NDSKindId,
            -- PriceResult.NewPrice,
            -- PriceResult.MarginPercent,
            -- PriceResult.Juridical_Price,
            -- PriceResult.LoadPriceListItemId
    -- )
    ResultSet AS
    (
        SELECT
            SelectMinPrice_AllGoods.GoodsId AS Id,
            SelectMinPrice_AllGoods.GoodsCode AS Code,
            SelectMinPrice_AllGoods.GoodsName AS GoodsName,
            Object_Price.Price                AS LastPrice,
            SelectMinPrice_AllGoods.Remains   AS RemainsCount,
            Object_Goods.NDS                  AS NDS,
            CASE 
                WHEN SelectMinPrice_AllGoods.isTop = TRUE
                    THEN  COALESCE(Object_Goods.PercentMarkup, 0) - COALESCE(ObjectFloat_Percent.valuedata, 0)
                ELSE COALESCE(MarginCondition.MarginPercent,0) + COALESCE(ObjectFloat_Percent.valuedata, 0)
            END::TFloat AS MarginPercent,
            (SelectMinPrice_AllGoods.SuperFinalPrice * (100 + Object_Goods.NDS)/100)::TFloat AS Juridical_Price,
            zfCalc_SalePrice((SelectMinPrice_AllGoods.SuperFinalPrice * (100 + Object_Goods.NDS)/100), -- Цена С НДС
                              MarginCondition.MarginPercent + COALESCE(ObjectFloat_Percent.valuedata, 0), -- % наценки
                              SelectMinPrice_AllGoods.isTop, -- ТОП позиция
                              Object_Goods.PercentMarkup, -- % наценки у товара
                              ObjectFloat_Percent.valuedata,
                              Object_Goods.Price)::TFloat AS NewPrice,
            SelectMinPrice_AllGoods.PartionGoodsDate         AS ExpirationDate,
            SelectMinPrice_AllGoods.JuridicalName            AS JuridicalName,
            SelectMinPrice_AllGoods.Partner_GoodsName        AS Partner_GoodsName,
            SelectMinPrice_AllGoods.MakerName                AS ProducerName,
            SelectMinPrice_AllGoods.MinExpirationDate        AS MinExpirationDate,
            Object_Goods.NDSKindId
        FROM
            lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                     inObjectId := vbObjectId, 
                                     inUserId := vbUserId) as SelectMinPrice_AllGoods
            LEFT OUTER JOIN Object_Price_View AS Object_Price
                                              ON Object_Price.GoodsId = SelectMinPrice_AllGoods.GoodsId
                                             AND Object_Price.UnitId = inUnitId
            LEFT OUTER JOIN Object_Goods_View AS Object_Goods
                                              ON Object_Goods.ObjectId = vbObjectId
                                             AND Object_Goods.Id = SelectMinPrice_AllGoods.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                  ON ObjectFloat_Percent.ObjectId = SelectMinPrice_AllGoods.JuridicalId
                                 AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
            LEFT JOIN Object_MarginCategoryLink_View AS Object_MarginCategoryLink
                                                     ON (Object_MarginCategoryLink.UnitId = inUnitId)    
                                                    AND Object_MarginCategoryLink.JuridicalId = SelectMinPrice_AllGoods.JuridicalId
            LEFT JOIN MarginCondition ON MarginCondition.MarginCategoryId = Object_MarginCategoryLink.MarginCategoryId
                                      AND (SelectMinPrice_AllGoods.SuperFinalPrice * (100 + Object_Goods.NDS)/100)::TFloat BETWEEN MarginCondition.MinPrice AND MarginCondition.MaxPrice
    )

    SELECT
        ResultSet.Id,
        ResultSet.Code,
        ResultSet.GoodsName,
        ResultSet.LastPrice,
        ResultSet.RemainsCount,
        ResultSet.NDS,
        ResultSet.NewPrice,
        COALESCE(MarginCondition.MarginPercent,inMinPercent)::TFloat AS MinMarginPercent,
        CASE 
            WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
            ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
        END::TFloat AS PriceDiff,
        ResultSet.ExpirationDate         AS ExpirationDate,
        ResultSet.JuridicalName          AS JuridicalName,
        ResultSet.Juridical_Price        AS Juridical_Price,
        ResultSet.MarginPercent          AS MarginPercent,
        ResultSet.Partner_GoodsName      AS Juridical_GoodsName,
        ResultSet.ProducerName           AS ProducerName,
        ROUND(((ResultSet.NewPrice - ResultSet.LastPrice)*ResultSet.RemainsCount),2)::TFloat AS SumReprice,
        ResultSet.MinExpirationDate
    FROM
        ResultSet
        LEFT OUTER JOIN MarginCondition ON MarginCondition.MarginCategoryId = vbMarginCategoryId
                                       AND ResultSet.LastPrice >= MarginCondition.MinPrice 
                                       AND ResultSet.LastPrice < MarginCondition.MaxPrice
    WHERE
        COALESCE(ResultSet.NewPrice,0) > 0
        AND
        (
            COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Medical()
            OR
            (
                inVAT20 = TRUE
                AND
                COALESCE(ResultSet.NDSKindId,0) = zc_Enum_NDSKind_Common()
            )
        )
        AND
        (
            ResultSet.ExpirationDate IS NULL
            OR
            ResultSet.ExpirationDate = '1899-12-30'::TDateTime
            OR
            ResultSet.ExpirationDate > (CURRENT_DATE + Interval '6 month')
        )
        AND
        (
            COALESCE(ResultSet.LastPrice,0) = 0
            OR
            ABS(CASE 
                  WHEN COALESCE(ResultSet.LastPrice,0) = 0 THEN 0.0
                  ELSE (ResultSet.NewPrice / ResultSet.LastPrice) * 100 - 100
                END) >= COALESCE(MarginCondition.MarginPercent,inMinPercent)
        )
        AND
        COALESCE(ResultSet.RemainsCount,0) > 0
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_AllGoodsPrice (Integer,  TFloat, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 19.11.15                                                                      *
 01.07.15                                                                      *
 30.06.15                        *
 
*/

-- тест
-- SELECT * FROM gpSelect_AllGoodsPrice (183293, 30, True, '3')