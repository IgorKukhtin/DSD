-- Function: gpSelect_Object_Goods_PrintSticker ()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_PrintSticker (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_PrintSticker(
    IN inPriceListId       Integer   ,   -- 
    IN inUnitId            Integer   ,   -- 
    IN inGoodsId           Integer   ,   -- 
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     OPEN Cursor1 FOR
       WITH 
       tmpPriceList AS (SELECT DISTINCT
                              tmp.GoodsId
                            , tmp.Price
                            , tmp.CurrencyId
                        FROM (SELECT DISTINCT
                                     inGoodsId                                        AS GoodsId
                                   , ObjectHistoryFloat_PriceListItem_Value.ValueData AS Price
                                   , OL_currency.ChildObjectId                        AS CurrencyId
                                   , ObjectHistory_PriceListItem.StartDate
                                   , MIN (ObjectHistory_PriceListItem.StartDate) OVER () AS FirstDate
                              FROM ObjectLink AS OL_currency
                                   INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                         ON ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                                                        AND ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                         ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                                        AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                                                        AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()

                                   LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                           ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                          AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()

                                   LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                               AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                              WHERE OL_currency.ObjectId = inPriceListId
                                AND OL_currency.DescId   = zc_ObjectLink_PriceList_Currency()
                              ) AS tmp
                        WHERE tmp.StartDate = tmp.FirstDate
                       )
    -- остаток
     , tmpContainer AS (SELECT Container.PartionId     AS PartionId
                             , Container.ObjectId      AS GoodsId
                             , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS Amount
                        FROM Container
                             LEFT JOIN ContainerLinkObject AS CLO_Client
                                                           ON CLO_Client.ContainerId = Container.Id
                                                          AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                        WHERE Container.DescId        = zc_Container_Count()
                          AND Container.ObjectId      = inGoodsId
                          AND Container.WhereObjectId = inUnitId
                          AND Container.Amount       <> 0
                        GROUP BY Container.PartionId
                               , Container.ObjectId
                        HAVING SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN COALESCE (Container.Amount, 0) ELSE 0 END) <> 0
                       )
     , tmpList AS (SELECT tmp.Amount, GENERATE_SERIES (1, tmp.Amount :: Integer) AS Ord
                   FROM (SELECT DISTINCT tmpContainer.Amount FROM tmpContainer) AS tmp
                  )

           -- Результат
           SELECT
                 Object_PartionGoods.MovementItemId AS PartionId
               , Object_Goods.Id                AS GoodsId
               , Object_Goods.ObjectCode        AS GoodsCode
               , Object_Goods.ValueData         AS GoodsName
               , (CASE WHEN Object_Composition.ValueData NOT IN ('-', '') THEN CASE WHEN LENGTH (Object_Composition.ValueData) <= 25 AND zc_Enum_GlobalConst_isTerry() = TRUE THEN 'сост: ' ELSE '' END || Object_Composition.ValueData ELSE '' END) :: TVarChar AS CompositionName
               , Object_GoodsInfo.ValueData     AS GoodsInfoName
               , Object_LineFabrica.ValueData   AS LineFabricaName
               , CASE WHEN TRIM (ObjectString_Label_UKR.ValueData) <> '' THEN ObjectString_Label_UKR.ValueData ELSE Object_Label.ValueData END :: TVarChar AS LabelName
               , ObjectString_Label_UKR.ValueData AS LabelName_UKR
               , Object_GoodsSize.ValueData     AS GoodsSizeName
               , Object_Brand.ValueData         AS BrandName
               , Object_CountryBrand.ValueData  AS CountryBrandName
               , zfFormat_BarCode (zc_BarCodePref_Object(), Object_PartionGoods.MovementItemId) AS IdBarCode

               , COALESCE (tmpPriceList.Price, 0) :: TFloat AS OperPriceList_fp

               , (SUBSTR ((Object_PartionGoods.PeriodYear :: Integer) :: TVarChar, 3, 1)
               || CASE WHEN Object_Period.ObjectCode = 1 THEN 'L' ELSE 'Z' END
               || SUBSTR ((Object_PartionGoods.PeriodYear :: Integer) :: TVarChar, 4, 1)
                 ) AS PeriodName

               , CASE WHEN COALESCE (tmpPriceList.CurrencyId, zc_Currency_GRN()) = zc_Currency_GRN()
                           THEN 'Грн '
                      ELSE '-экв. '
                 END :: TVarChar AS ValutaName

           FROM tmpPriceList
                INNER JOIN tmpContainer ON tmpContainer.GoodsId = tmpPriceList.GoodsId
                LEFT JOIN tmpList ON tmpList.Amount = tmpContainer.Amount

                LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpContainer.PartionId

                LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpPriceList.GoodsId
                LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
                LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
                LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
                LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
                LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
                LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = Object_PartionGoods.BrandId

                LEFT JOIN ObjectString AS ObjectString_Label_UKR
                                       ON ObjectString_Label_UKR.ObjectId = Object_PartionGoods.LabelId
                                      AND ObjectString_Label_UKR.DescId   = zc_ObjectString_Label_UKR()
                                      AND 1=0

                LEFT JOIN ObjectLink AS Object_Brand_CountryBrand
                                     ON Object_Brand_CountryBrand.ObjectId = Object_Brand.Id
                                    AND Object_Brand_CountryBrand.DescId = zc_ObjectLink_Brand_CountryBrand()
                LEFT JOIN Object AS Object_CountryBrand ON Object_CountryBrand.Id = Object_Brand_CountryBrand.ChildObjectId

                LEFT JOIN Object AS Object_Period          ON Object_Period.Id     = Object_PartionGoods.PeriodId

           ORDER BY Object_Goods.ObjectCode, Object_GoodsSize.ValueData
           ;

         RETURN NEXT Cursor1;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
08.11.20          *
*/

-- тест
--