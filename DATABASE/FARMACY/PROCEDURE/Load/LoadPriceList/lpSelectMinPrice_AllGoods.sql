DROP FUNCTION IF EXISTS lpSelectMinPrice_AllGoods (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelectMinPrice_AllGoods(
    IN inUnitId      Integer      , -- ключ Документа
    IN inObjectId    Integer      , 
    IN inUserId      Integer        -- сессия пользователя
)

RETURNS TABLE (
    GoodsId            integer,
    GoodsCode          integer,
    GoodsName          TVarChar,
    Remains            TFloat,
    MinExpirationDate  TDateTime,
    PartionGoodsDate   TDateTime,
    Partner_GoodsCode  TVarChar,
    Partner_GoodsName  TVarChar,
    MakerName          TVarChar,
    JuridicalId        Integer,
    JuridicalName      TVarChar,
    Price              TFloat,
    SuperFinalPrice    TFloat,
    isTop              Boolean
)

AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
BEGIN

    SELECT 
        Object_Unit_View.JuridicalId 
    INTO 
        vbMainJuridicalId
    FROM 
        Object_Unit_View
    WHERE 
        Object_Unit_View.Id = inUnitId;
        
    RETURN QUERY
    WITH 
    PriceSettings AS 
    (
        SELECT * 
        FROM gpSelect_Object_PriceGroupSettingsInterval (inUserId::TVarChar)
    ),
    JuridicalSettings AS 
    (
        SELECT * 
        FROM lpSelect_Object_JuridicalSettingsRetail (inObjectId)
    ),
    Remains AS
    (
        Select
            Container.ObjectId,
            SUM(Container.Amount)::TFloat as Amount,
            MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate
        from 
            Container
            LEFT OUTER JOIN ContainerLinkObject AS CLO_PartionMovementItem
                                                ON CLO_PartionMovementItem.ContainerId = Container.Id
                                               AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem 
                                   ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
            LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                              ON MIDate_ExpirationDate.MovementItemId = Object_PartionMovementItem.ObjectCode
                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
        WHERE
            Container.DescId = zc_Container_Count()
            AND
            Container.WhereObjectId = inUnitId
            AND
            Container.Amount <> 0
        GROUP BY
            Container.ObjectId
        HAVING
            SUM(Container.Amount) > 0
    ),
    GoodsList AS 
    (
        SELECT 
            Remains.ObjectId,
            Object_LinkGoods_View.GoodsMainId, 
            PriceList_GoodsLink.GoodsId,
            Remains.Amount,
            Remains.MinExpirationDate
        FROM 
            Remains
            JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = Remains.objectid -- Связь товара сети с общим
            LEFT JOIN Object_LinkGoods_View AS PriceList_GoodsLink -- связь товара в прайсе с главным товаром
                                            ON PriceList_GoodsLink.GoodsMainId = Object_LinkGoods_View.GoodsMainId
    ),
    FinalList AS
    (
    SELECT 
        ddd.GoodsId                  --Код товара
      , ddd.GoodsCode
      , ddd.GoodsName  
      , ddd.Remains
      , ddd.MinExpirationDate
      , ddd.Price
      , ddd.PartionGoodsDate
      , ddd.Partner_GoodsCode
      , ddd.Partner_GoodsName
      , ddd.MakerName
      , ddd.JuridicalId
      , ddd.JuridicalName 
      , ddd.Deferment
      , ddd.PriceListMovementItemId
      , CASE 
            WHEN ddd.Deferment = 0 OR ddd.isTOP
                THEN FinalPrice
        ELSE FinalPrice * (100 - PriceSettings.Percent)/100
        END::TFloat AS SuperFinalPrice
      , ddd.isTOP
    FROM (
        SELECT DISTINCT 
            GoodsList.ObjectId                 AS GoodsId
          , Goods.GoodsCodeInt                 AS GoodsCode
          , Goods.GoodsName                    AS GoodsName  
          , GoodsList.Amount                   AS Remains
          , GoodsList.MinExpirationDate        AS MinExpirationDate
          , PriceList.Amount                   AS Price
          , Min(PriceList.Amount) OVER (PARTITION BY GoodsList.ObjectId) AS MinPrice
          , PriceList.Id                       AS PriceListMovementItemId
          , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
          , CASE
                WHEN Goods.isTOP
                    THEN PriceList.Amount
            ELSE (PriceList.Amount * (100 - COALESCE(JuridicalSettings.Bonus, 0))/100)::TFloat 
            END AS FinalPrice
          , Object_JuridicalGoods.GoodsCode    AS Partner_GoodsCode
          , Object_JuridicalGoods.GoodsName    AS Partner_GoodsName
          , Object_JuridicalGoods.MakerName    AS MakerName
          , Juridical.Id                       AS JuridicalId
          , Juridical.ValueData                AS JuridicalName
          , COALESCE(ObjectFloat_Deferment.ValueData, 0)::Integer AS Deferment
          , Goods.isTOP
        
        FROM GoodsList 
                  
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods -- товары в прайс-листе
                                             ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                            AND MILinkObject_Goods.ObjectId = GoodsList.GoodsId 

            JOIN  MovementItem AS PriceList  -- Прайс-лист
                               ON PriceList.Id = MILinkObject_Goods.MovementItemId
            JOIN LastPriceList_View  -- Прайс-лист
                                   ON LastPriceList_View.MovementId  = PriceList.MovementId

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  PriceList.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN JuridicalSettings ON JuridicalSettings.JuridicalId = LastPriceList_View.JuridicalId 
                                       AND JuridicalSettings.MainJuridicalId = vbMainJuridicalId 
                                       AND JuridicalSettings.ContractId = LastPriceList_View.ContractId 

                  
            LEFT JOIN Object_Goods_View AS Object_JuridicalGoods 
                                        ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
       
            JOIN OBJECT AS Juridical 
                        ON Juridical.Id = LastPriceList_View.JuridicalId

            LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                  ON ObjectFloat_Deferment.ObjectId = LastPriceList_View.ContractId
                                 AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()
       
            LEFT JOIN Object_Goods_View AS Goods  -- Элемент документа заявка
                                        ON Goods.Id = GoodsList.ObjectId
             
        WHERE  
           COALESCE(JuridicalSettings.isPriceClose, FALSE) <> TRUE 
        ) AS ddd
       
       LEFT JOIN PriceSettings ON ddd.MinPrice BETWEEN PriceSettings.MinPrice AND PriceSettings.MaxPrice
    ),
    MinPriceList AS
    (
        Select *
        from(
               Select *, ROW_NUMBER()OVER(PARTITION BY FinalList.GoodsId Order By FinalList.SuperFinalPrice, FinalList.PriceListMovementItemId) AS Ord
               from FinalList
        ) as T0
        Where T0.Ord = 1
    )
    Select
        MinPriceList.GoodsId,
        MinPriceList.GoodsCode,
        MinPriceList.GoodsName,
        MinPriceList.Remains,
        MinPriceList.MinExpirationDate,
        MinPriceList.PartionGoodsDate,
        MinPriceList.Partner_GoodsCode,
        MinPriceList.Partner_GoodsName,
        MinPriceList.MakerName,
        MinPriceList.JuridicalId,
        MinPriceList.JuridicalName,
        MinPriceList.Price,
        MinPriceList.SuperFinalPrice,
        MinPriceList.isTop
    from MinPriceList;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelectMinPrice_AllGoods (Integer, Integer, Integer) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 03.12.15                                                                          * 
*/
-- SELECT * FROM lpSelectMinPrice_AllGoods (183293, 4, 3)