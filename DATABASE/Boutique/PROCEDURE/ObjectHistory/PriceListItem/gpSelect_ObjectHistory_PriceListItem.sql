-- Function: gpSelect_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, Integer, Integer, Integer, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem(
    IN inPriceListId        Integer   , -- ключ 
    IN inUnitId             Integer   , -- подразделение 
    IN inBrandId            Integer   , -- торговая марка 
    IN inPeriodId           Integer   , -- сезон
    IN inOperDate           TDateTime , -- Дата действия
    IN inStartYear          Integer   , -- год с
    IN inEndYear            Integer   , -- год по
    IN inShowAll            Boolean,   
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer , ObjectId Integer
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                , GoodsNameFull TVarChar
                , isErased Boolean, GoodsGroupNameFull TVarChar
                , MeasureName TVarChar
                , GoodsGroupId         Integer
                , GoodsGroupName       TVarChar
                , CompositionGroupName TVarChar
                , CompositionName      TVarChar
                , GoodsInfoName        TVarChar
                , LineFabricaId        Integer
                , LineFabricaName      TVarChar
                , LabelId              Integer
                , LabelName            TVarChar
                , UnitId               Integer
                , UnitName             TVarChar
                , BrandId              Integer
                , BrandName            TVarChar
                , PeriodId             Integer
                , PeriodName           TVarChar
                , PeriodYear           Integer
                , FabrikaName          TVarChar
                --, GoodsSizeName        TVarChar
                , CurrencyName         TVarChar
                , CurrencyId_price     Integer
                , CurrencyName_price   TVarChar
                , OperPriceList        TFloat
                , OperPrice            TFloat
                , Remains              TFloat
                , AmountDebt           TFloat
                , RemainsAll           TFloat

                , StartDate TDateTime, EndDate TDateTime
                , ValuePrice       TFloat
                , DiscountTax      TFloat
                , CurrencyValue    TFloat
                , ParValue         TFloat
                , OperPriceBalance TFloat
                , PriceTax         TFloat


                , InsertName TVarChar, UpdateName TVarChar
                , InsertDate TDateTime, UpdateDate TDateTime
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_OH_PriceListItem());
    --vbUserId:= lpGetUserBySession (inSession);
    
    -- !!!замена!!!
    IF COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;
    
    -- Выбираем данные
     RETURN QUERY 
     WITH 
      tmpPrice AS (SELECT ObjectHistory_PriceListItem.Id                   AS PriceListItemId
                        , ObjectHistory_PriceListItem.ObjectId             AS PriceListItemObjectId
                        , ObjectHistoryLink_Currency.ObjectId              AS CurrencyId
                        , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                        , ObjectHistory_PriceListItem.StartDate            AS StartDate
                        , ObjectHistory_PriceListItem.EndDate              AS EndDate
                        , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
 
                   FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                        LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                             ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                            AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
       
                        LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                               AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                               AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                     ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                    AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
 
                        LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                                    ON ObjectHistoryLink_Currency.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                   AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()

                   WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                     AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
                  )

    , tmpPartionGoods AS (SELECT Object_PartionGoods.MovementItemId  AS PartionId
                               , Object_PartiONGoods.PartnerId
                               , Object_PartionGoods.UnitId
                               , Object_PartionGoods.OperDate
                               , Object_PartionGoods.GoodsId
                               , Object_PartionGoods.CurrencyId
                               , Object_PartionGoods.OperPrice
                               , Object_PartionGoods.OperPriceList
                               , Object_PartionGoods.BrandId
                               , Object_PartionGoods.PeriodId
                               , Object_PartionGoods.PeriodYear
                               , Object_PartionGoods.FabrikaId
                               , Object_PartionGoods.GoodsGroupId
                               , Object_PartionGoods.MeasureId   
                               , Object_PartionGoods.CompositionId
                               , Object_PartionGoods.GoodsInfoId
                               , Object_PartionGoods.LineFabricaId
                               , Object_PartionGoods.LabelId
                               , Object_PartionGoods.CompositionGroupId
                               , MF_CurrencyValue.ValueData  AS CurrencyValue
                               , MF_ParValue.ValueData       AS ParValue
                          FROM Object_PartionGoods
                               LEFT JOIN MovementFloat AS MF_ParValue
                                                       ON MF_ParValue.MovementId = Object_PartionGoods.MovementId
                                                      AND MF_ParValue.DescId = zc_MovementFloat_ParValue()
                                                      AND zc_Enum_GlobalConst_isTerry() = FALSE
                               LEFT JOIN MovementFloat AS MF_CurrencyValue
                                                       ON MF_CurrencyValue.MovementId = Object_PartionGoods.MovementId
                                                      AND MF_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                                                      AND zc_Enum_GlobalConst_isTerry() = FALSE
                          WHERE Object_PartionGoods.isErased = FALSE 
                            -- AND (Object_PartionGoods.UnitId = inUnitId OR inUnitId = 0)
                            AND (Object_PartionGoods.BrandId = inBrandId OR inBrandId = 0)
                            AND (Object_PartionGoods.PeriodId = inPeriodId OR inPeriodId = 0)   
                            AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                          )
    -- остаток
    , tmpContainer AS (SELECT Container.PartionId     AS PartionId
                            , Container.ObjectId      AS GoodsId
                            , Container.WhereObjectId AS UnitId
                            , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS Amount
                            , SUM (CASE WHEN CLO_Client.ContainerId > 0     THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS AmountDebt
                       FROM Container
                            INNER JOIN (SELECT DISTINCT tmpPartionGoods.GoodsId 
                                        FROM tmpPartionGoods
                                        ) AS tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                            LEFT JOIN ContainerLinkObject AS CLO_Client
                                                          ON CLO_Client.ContainerId = Container.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                       WHERE Container.DescId        = zc_Container_Count()
                         AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                         AND Container.Amount       <> 0
                       GROUP BY Container.PartionId
                              , Container.ObjectId
                              , Container.WhereObjectId
                       HAVING SUM (Container.Amount) <> 0
                      )

    , tmpGoods AS (SELECT tmpPartionGoods.PartnerId
                        , tmpPartionGoods.UnitId 
                   --   , COALESCE (tmpContainer.UnitId, tmpPartionGoods.UnitId) AS UnitId
                        , tmpContainer.UnitId AS UnitId_Container
                        , tmpPartionGoods.OperDate
                        , tmpPartionGoods.GoodsId
                        , tmpPartionGoods.CurrencyId
                        , tmpPartionGoods.OperPrice
                        , tmpPartionGoods.OperPriceList
                        , tmpPartionGoods.BrandId
                        , tmpPartionGoods.PeriodId
                        , tmpPartionGoods.PeriodYear
                        , tmpPartionGoods.FabrikaId
                        , tmpPartionGoods.GoodsGroupId
                        , tmpPartionGoods.MeasureId
                        , tmpPartionGoods.CompositionId
                        , tmpPartionGoods.GoodsInfoId
                        , tmpPartionGoods.LineFabricaId
                        , tmpPartionGoods.LabelId
                        , tmpPartionGoods.CompositionGroupId
                        , SUM (COALESCE (tmpContainer.Amount, 0))     AS Remains
                        , SUM (COALESCE (tmpContainer.AmountDebt, 0)) AS AmountDebt
                        , MAX (tmpPartionGoods.CurrencyValue)         AS CurrencyValue
                        , MAX (tmpPartionGoods.ParValue)              AS ParValue
                   FROM tmpPartionGoods
                        LEFT JOIN tmpContainer ON tmpContainer.GoodsId   = tmpPartionGoods.GoodsId
                                              AND tmpContainer.PartionId = tmpPartionGoods.PartionId
                                              AND (tmpContainer.UnitId   = tmpPartionGoods.UnitId
                                               OR inUnitId > 0)
                   GROUP BY tmpPartionGoods.PartnerId
                          , tmpPartionGoods.UnitId
                          , tmpContainer.UnitId
                       -- , COALESCE (tmpContainer.UnitId, tmpPartionGoods.UnitId)
                          , tmpPartionGoods.OperDate
                          , tmpPartionGoods.GoodsId
                          , tmpPartionGoods.CurrencyId
                          , tmpPartionGoods.OperPrice
                          , tmpPartionGoods.OperPriceList
                          , tmpPartionGoods.BrandId
                          , tmpPartionGoods.PeriodId
                          , tmpPartionGoods.PeriodYear
                          , tmpPartionGoods.FabrikaId
                          , tmpPartionGoods.GoodsGroupId
                          , tmpPartionGoods.MeasureId
                          , tmpPartionGoods.CompositionId
                          , tmpPartionGoods.GoodsInfoId
                          , tmpPartionGoods.LineFabricaId
                          , tmpPartionGoods.LabelId
                          , tmpPartionGoods.CompositionGroupId
                   HAVING SUM (COALESCE (tmpContainer.Amount, 0)) <> 0 
                       OR SUM (COALESCE (tmpContainer.AmountDebt, 0)) <> 0
                       OR inShowAll = TRUE
                   )

    , tmpDiscountList AS (SELECT DISTINCT tmpGoods.UnitId_Container AS UnitId, tmpGoods.GoodsId FROM tmpGoods)

          , tmpOL1 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                                                  AND ObjectLink.DescId        = zc_ObjectLink_DiscountPeriodItem_Goods()
                      )
          , tmpOL2 AS (SELECT * FROM ObjectLink WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpOL1.ObjectId FROM tmpOL1)
                                                  AND ObjectLink.DescId   = zc_ObjectLink_DiscountPeriodItem_Unit()
                      )

    , tmpDiscount AS (SELECT ObjectLink_DiscountPeriodItem_Unit.ChildObjectId      AS UnitId
                           , ObjectLink_DiscountPeriodItem_Goods.ChildObjectId     AS GoodsId
                           , ObjectHistoryFloat_DiscountPeriodItem_Value.ValueData AS DiscountTax
                      FROM tmpDiscountList
                           INNER JOIN tmpOL1 AS ObjectLink_DiscountPeriodItem_Goods
                                             ON ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = tmpDiscountList.GoodsId
                           INNER JOIN tmpOL2 AS ObjectLink_DiscountPeriodItem_Unit
                                             ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                            AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = tmpDiscountList.UnitId
                           INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                    ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                                                   AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                   AND ObjectHistory_DiscountPeriodItem.EndDate  = zc_DateEnd()
                           LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_DiscountPeriodItem_Value
                                                        ON ObjectHistoryFloat_DiscountPeriodItem_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                       AND ObjectHistoryFloat_DiscountPeriodItem_Value.DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                     )

    , tmpCurrency AS (SELECT lfSelect.*
                      FROM Object
                           CROSS JOIN lfSelect_Movement_Currency_byDate (inOperDate      := inOperDate --CURRENT_DATE
                                                                       , inCurrencyFromId:= zc_Currency_Basis()
                                                                       , inCurrencyToId  := Object.Id
                                                                        ) AS lfSelect
                      WHERE Object.DescId = zc_Object_Currency()
                        AND Object.Id     <> zc_Currency_Basis()
                        AND zc_Enum_GlobalConst_isTerry() = TRUE
                     )

       SELECT
             tmpPrice.PriceListItemId             AS Id
           , tmpPrice.PriceListItemObjectId       AS ObjectId
           , Object_Goods.Id                      AS GoodsId               
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , (ObjectString_Goods_GoodsGroupFull.ValueData ||' - '||Object_Label.ValueData||' - '||Object_Goods.ObjectCode||' - ' || Object_Goods.ValueData) ::TVarChar AS GoodsNameFull
           , Object_Goods.isErased                AS isErased 
           
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           
           , Object_Measure.ValueData             AS MeasureName
           , Object_GoodsGroup.Id                 AS GoodsGroupId
           , Object_GoodsGroup.ValueData          AS GoodsGroupName
           , Object_CompositionGroup.ValueData    AS CompositionGroupName    
           , Object_Composition.ValueData         AS CompositionName
           , Object_GoodsInfo.ValueData           AS GoodsInfoName
           , Object_LineFabrica.Id                AS LineFabricaId
           , Object_LineFabrica.ValueData         AS LineFabricaName
           , Object_Label.Id                      AS LabelId
           , Object_Label.ValueData               AS LabelName
           
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , Object_Brand.Id                      AS BrandId
           , Object_Brand.ValueData               AS BrandName
           , Object_Period.Id                     AS PeriodId
           , Object_Period.ValueData              AS PeriodName
           , tmpPartionGoods.PeriodYear           AS PeriodYear
           , Object_Fabrika.ValueData             AS FabrikaName
           , Object_Currency.ValueData            AS CurrencyName
           , Object_CurrencyPrice.Id              AS CurrencyId_price
           , Object_CurrencyPrice.ValueData       AS CurrencyName_price

           , tmpPartionGoods.OperPriceList   :: TFloat
           , tmpPartionGoods.OperPrice       :: TFloat
           , tmpPartionGoods.Remains         :: TFloat
           , tmpPartionGoods.AmountDebt      :: TFloat

           , (COALESCE(tmpPartionGoods.Remains, 0) + COALESCE(tmpPartionGoods.AmountDebt, 0)) :: TFloat  AS RemainsAll

           , CASE WHEN tmpPrice.StartDate = zc_DateStart() OR tmpPrice.StartDate < '01.01.1980' THEN NULL ELSE tmpPrice.StartDate END :: TDateTime AS StartDate
           , CASE WHEN tmpPrice.EndDate   = zc_DateEnd() THEN NULL ELSE tmpPrice.EndDate END :: TDateTime AS EndDate
           , COALESCE (tmpPrice.ValuePrice, 0) :: TFloat  AS ValuePrice

             -- % Сезонной скидки !!!НА!!! zc_DateEnd
           , tmpDiscount.DiscountTax         :: TFloat AS DiscountTax

--         , tmpCurrency.Amount   ::TFloat  AS CurrencyValue
--         , tmpCurrency.ParValue ::TFloat  AS ParValue
           , COALESCE (tmpCurrency.Amount, tmpPartionGoods.CurrencyValue) :: TFloat AS CurrencyValue
           , COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue)    :: TFloat AS ParValue

             -- Цена по входным ценам в ГРН
         --, CAST (tmpPartionGoods.OperPrice * tmpCurrency.Amount / CASE WHEN tmpPartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN tmpCurrency.ParValue <> 0 THEN tmpCurrency.ParValue ELSE 1 END AS NUMERIC (16, 2)) :: TFloat AS OperPriceBalance
           , CAST (tmpPartionGoods.OperPrice * COALESCE (tmpCurrency.Amount, tmpPartionGoods.CurrencyValue) / CASE WHEN tmpPartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue) <> 0 THEN COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue) ELSE 1 END AS NUMERIC (16, 2)) :: TFloat AS OperPriceBalance

             -- % наценки  --Цена прихода в валюте и цена продажи в валюте
           , CAST (CASE WHEN (tmpPartionGoods.OperPrice * COALESCE (tmpCurrency.Amount, tmpPartionGoods.CurrencyValue) / CASE WHEN tmpPartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue) <> 0 THEN COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue) ELSE 1 END)
                              <> 0
                        THEN (100 * tmpPartionGoods.OperPriceList * (COALESCE (tmpCurrency.Amount, tmpPartionGoods.CurrencyValue) / CASE WHEN tmpPartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue) <> 0 THEN COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue) ELSE 1 END)
                            / (tmpPartionGoods.OperPrice * COALESCE (tmpCurrency.Amount, tmpPartionGoods.CurrencyValue) / CASE WHEN tmpPartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue) <> 0 THEN COALESCE (tmpCurrency.ParValue, tmpPartionGoods.ParValue) ELSE 1 END)
                              - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

       FROM tmpGoods AS tmpPartionGoods 
           LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpPartionGoods.GoodsId
           LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = tmpPartionGoods.PartnerId
           LEFT JOIN Object AS Object_Unit        ON Object_Unit.Id        = tmpPartionGoods.UnitId
           LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = tmpPartionGoods.CurrencyId
           LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = tmpPartionGoods.BrandId
           LEFT JOIN Object AS Object_Period      ON Object_Period.Id      = tmpPartionGoods.PeriodId
           LEFT JOIN Object AS Object_Fabrika     ON Object_Fabrika.Id     = tmpPartionGoods.FabrikaId
           LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = tmpPartionGoods.GoodsGroupId
           LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = tmpPartionGoods.MeasureId
           LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = tmpPartionGoods.CompositionId
           LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = tmpPartionGoods.GoodsInfoId
           LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = tmpPartionGoods.LineFabricaId
           LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = tmpPartionGoods.LabelId
           LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpPartionGoods.CompositionGroupId

           LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpPartionGoods.GoodsId
           LEFT JOIN Object AS Object_CurrencyPrice ON Object_CurrencyPrice.Id    = tmpPrice.CurrencyId

           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpPartionGoods.GoodsId
                                 AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

           LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                ON ObjectDate_Protocol_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                               AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
           LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                ON ObjectDate_Protocol_Update.ObjectId = tmpPrice.PriceListItemObjectId
                               AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
 
           LEFT JOIN ObjectLink AS ObjectLink_Insert
                                ON ObjectLink_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   
 
           LEFT JOIN ObjectLink AS ObjectLink_Update
                                ON ObjectLink_Update.ObjectId = tmpPrice.PriceListItemObjectId
                               AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
           LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 


           LEFT JOIN tmpDiscount ON tmpDiscount.UnitId  = tmpPartionGoods.UnitId_Container -- UnitId
                                AND tmpDiscount.GoodsId = tmpPartionGoods.GoodsId    

           LEFT JOIN tmpCurrency  ON tmpCurrency.CurrencyToId = tmpPartionGoods.CurrencyId         
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.18         *
 15.03.18         *
 06.03.18         *
 05.03.18         *
 01.03.18         * новые вх.параметры
 28.04.17         * битики + св-ва товара
 20.08.15         * add inShowAll
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem (inPriceListId := 4306, inUnitId:= 1159, inBrandId:= 710, inPeriodId:= 1174, inOperDate:= CURRENT_DATE, inStartYear:= 2007, inEndYear:= 2007, inShowAll:= FALSE, inSession:= zfCalc_UserAdmin());
