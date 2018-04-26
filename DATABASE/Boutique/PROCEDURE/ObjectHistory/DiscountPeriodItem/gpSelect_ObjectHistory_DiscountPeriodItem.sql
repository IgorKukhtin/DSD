-- Function: gpSelect_ObjectHistory_DiscountPeriodItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_DiscountPeriodItem (Integer, Integer, Integer, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_DiscountPeriodItem(
    IN inUnitId             Integer   , -- подразделение
    IN inBrandId            Integer   , -- торговая марка
    IN inPeriodId           Integer   , -- сезон
    IN inOperDate           TDateTime , -- Дата действия
    IN inStartYear          Integer   , -- год с
    IN inEndYear            Integer   , -- год по
    IN inShowAll            Boolean,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE  (  Id Integer , ObjectId Integer
                , StartDate TDateTime, EndDate TDateTime
                , ValueDiscount TFloat
                , InsertName TVarChar, UpdateName TVarChar
                , InsertDate TDateTime, UpdateDate TDateTime

                , PartnerName          TVarChar
                , UnitName_in          TVarChar
                , InvNumber_Partion    TVarChar
                , OperDate_Partion     TDateTime
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                , isErased Boolean
                , GroupNameFull        TVarChar
                , CurrencyName         TVarChar
                , OperPrice            TFloat
                , OperPriceList        TFloat
                , Remains              TFloat
                , AmountDebt           TFloat
                , RemainsAll           TFloat
                , BrandName            TVarChar
                , PeriodName           TVarChar
                , PeriodYear           Integer
                , FabrikaName          TVarChar
                , GoodsGroupName       TVarChar
                , MeasureName          TVarChar
                , CompositionName      TVarChar
                , GoodsInfoName        TVarChar
                , LineFabricaName      TVarChar
                , LabelName            TVarChar
                , GoodsSizeName        TVarChar
               )
AS
$BODY$
BEGIN

    -- !!!замена!!!
    IF COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;


    -- Выбираем данные
     RETURN QUERY
       WITH tmpPartionGoods AS
                           (SELECT Object_PartionGoods.MovementId      AS MovementId
                                 , Object_PartionGoods.MovementItemId  AS PartionId
                                 , Object_PartionGoods.GoodsId         AS GoodsId
                                 , Object_Partner.ValueData            AS PartnerName
                                 , Object_Unit_in.ValueData            AS UnitName_in
                                 , Object_PartionGoods.OperDate        AS OperDate
                                 , Object_Currency.ValueData           AS CurrencyName
                                 , Object_PartionGoods.OperPrice       AS OperPrice
                                 , Object_PartionGoods.OperPriceList   AS OperPriceList
                                 , Object_Brand.ValueData              AS BrandName
                                 , Object_Period.ValueData             AS PeriodName
                                 , Object_PartionGoods.PeriodYear      AS PeriodYear
                                 , Object_Fabrika.ValueData            AS FabrikaName
                                 , Object_GoodsGroup.ValueData         AS GoodsGroupName
                                 , Object_Measure.ValueData            AS MeasureName
                                 , Object_Composition.ValueData        AS CompositionName
                                 , Object_GoodsInfo.ValueData          AS GoodsInfoName
                                 , Object_LineFabrica.ValueData        AS LineFabricaName
                                 , Object_Label.ValueData              AS LabelName
                                 , Object_GoodsSize.ValueData          AS GoodsSizeName
                            FROM Object_PartionGoods
                                 LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = Object_PartiONGoods.PartnerId
                                 LEFT JOIN Object AS Object_Unit_in     ON Object_Unit_in.Id     = Object_PartionGoods.UnitId
                                 LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = Object_PartionGoods.CurrencyId
                                 LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = Object_PartionGoods.BrandId
                                 LEFT JOIN Object AS Object_Period      ON Object_Period.Id      = Object_PartionGoods.PeriodId
                                 LEFT JOIN Object AS Object_Fabrika     ON Object_Fabrika.Id     = Object_PartionGoods.FabrikaId
                                 LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
                                 LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId
                                 LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
                                 LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
                                 LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
                                 LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
                                 LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
                            WHERE Object_PartionGoods.isErased    = FALSE
                              -- AND Object_PartionGoods.UnitId      = inUnitId
                              AND (Object_PartionGoods.BrandId    = inBrandId  OR inBrandId  = 0)
                              AND (Object_PartionGoods.PeriodId   = inPeriodId OR inPeriodId = 0)
                              AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                           )
          , tmpList AS (SELECT DISTINCT tmpPartionGoods.GoodsId FROM tmpPartionGoods)
          , tmpDiscount AS (SELECT ObjectHistory_DiscountPeriodItem.Id        AS Id
                                 , ObjectHistory_DiscountPeriodItem.ObjectId  AS ObjectId
                                 , ObjectLink_Goods.ChildObjectId             AS GoodsId

                                 , ObjectHistory_DiscountPeriodItem.StartDate
                                 , ObjectHistory_DiscountPeriodItem.EndDate
                                 , ObjectHistoryFloat_Value.ValueData        AS ValueDiscount

                            FROM ObjectLink AS ObjectLink_Unit
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                      ON ObjectLink_Goods.ObjectId = ObjectLink_Unit.ObjectId
                                                     AND ObjectLink_Goods.DescId   = zc_ObjectLink_DiscountPeriodItem_Goods()
                                 INNER JOIN tmpList ON tmpList.GoodsId = ObjectLink_Goods.ChildObjectId

                                 LEFT JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                         ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_Unit.ObjectId
                                                        AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                        AND inOperDate >= ObjectHistory_DiscountPeriodItem.StartDate AND inOperDate < ObjectHistory_DiscountPeriodItem.EndDate
                                 LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                              ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                             AND ObjectHistoryFloat_Value.DescId          = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()

                            WHERE ObjectLink_Unit.DescId        = zc_ObjectLink_DiscountPeriodItem_Unit()
                              AND ObjectLink_Unit.ChildObjectId = inUnitId
                              AND (ObjectHistoryFloat_Value.ValueData <> 0
                                OR ObjectHistory_DiscountPeriodItem.StartDate > zc_DateStart()
                                  )
                           )

      -- остаток
    , tmpContainer AS (SELECT Container.PartionId     AS PartionId
                            , Container.ObjectId      AS GoodsId
                            , Container.WhereObjectId AS UnitId
                            , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS Amount
                            , SUM (CASE WHEN CLO_Client.ContainerId > 0     THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS AmountDebt
                       FROM Container
                            INNER JOIN tmpList ON tmpList.GoodsId = Container.ObjectId
                            LEFT JOIN ContainerLinkObject AS CLO_Client
                                                          ON CLO_Client.ContainerId = Container.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                       WHERE Container.DescId        = zc_Container_Count()
                         AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                         AND Container.Amount       <> 0
                         -- !!!отбросили Долги Покупателей!!!
                         -- AND CLO_Client.ContainerId IS NULL
                       GROUP BY Container.PartionId
                              , Container.ObjectId
                              , Container.WhereObjectId
                       HAVING SUM (Container.Amount)<> 0
                      )

    , tmpGoods AS (SELECT tmpPartionGoods.MovementId
                        , tmpPartionGoods.GoodsId
                        , tmpPartionGoods.OperDate
                        , tmpPartionGoods.UnitName_in
                        , tmpPartionGoods.PartnerName
                        , tmpPartionGoods.CurrencyName
                        , tmpPartionGoods.OperPrice
                        , tmpPartionGoods.OperPriceList
                        , tmpPartionGoods.BrandName
                        , tmpPartionGoods.PeriodName
                        , tmpPartionGoods.PeriodYear
                        , tmpPartionGoods.FabrikaName
                        , tmpPartionGoods.GoodsGroupName
                        , tmpPartionGoods.MeasureName
                        , tmpPartionGoods.CompositionName
                        , tmpPartionGoods.GoodsInfoName
                        , tmpPartionGoods.LineFabricaName
                        , tmpPartionGoods.LabelName
                        , tmpPartionGoods.GoodsSizeName
                        , SUM (COALESCE (tmpContainer.Amount, 0))        AS Remains
                        , SUM (COALESCE (tmpContainer.AmountDebt, 0))    AS AmountDebt
                   FROM tmpPartionGoods
                        LEFT JOIN tmpContainer ON tmpContainer.GoodsId   = tmpPartionGoods.GoodsId
                                              AND tmpContainer.PartionId = tmpPartionGoods.PartionId
                                              -- AND tmpContainer.UnitId    = tmpPartionGoods.UnitId
                   GROUP BY tmpPartionGoods.MovementId
                          , tmpPartionGoods.GoodsId
                          , tmpPartionGoods.OperDate
                          , tmpPartionGoods.UnitName_in
                          , tmpPartionGoods.PartnerName
                          , tmpPartionGoods.CurrencyName
                          , tmpPartionGoods.OperPrice
                          , tmpPartionGoods.OperPriceList
                          , tmpPartionGoods.BrandName
                          , tmpPartionGoods.PeriodName
                          , tmpPartionGoods.PeriodYear
                          , tmpPartionGoods.FabrikaName
                          , tmpPartionGoods.GoodsGroupName
                          , tmpPartionGoods.MeasureName
                          , tmpPartionGoods.CompositionName
                          , tmpPartionGoods.GoodsInfoName
                          , tmpPartionGoods.LineFabricaName
                          , tmpPartionGoods.LabelName
                          , tmpPartionGoods.GoodsSizeName
                   )

       -- Результат
       SELECT
             tmpDiscount.Id
           , tmpDiscount.ObjectId

           , CASE WHEN tmpDiscount.StartDate IN (zc_DateStart(), zc_DateEnd()) THEN NULL ELSE tmpDiscount.StartDate END ::TDateTime  AS StartDate
           , CASE WHEN tmpDiscount.EndDate   IN (zc_DateStart(), zc_DateEnd()) THEN NULL ELSE tmpDiscount.EndDate   END ::TDateTime  AS EndDate

           , COALESCE(tmpDiscount.ValueDiscount, NULL) :: TFloat  AS ValueDiscount

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , tmpPartionGoods.PartnerName
           , tmpPartionGoods.UnitName_in
           , Movement.InvNumber                  AS InvNumber_Partion
           , tmpPartionGoods.OperDate            AS OperDate_Partion

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_Goods.isErased               AS Goods_isErased
           , Object_GroupNameFull.ValueData      As GroupNameFull
           , tmpPartionGoods.CurrencyName
           , tmpPartionGoods.OperPrice     :: TFloat
           , tmpPartionGoods.OperPriceList :: TFloat

           , tmpPartionGoods.Remains         :: TFloat
           , tmpPartionGoods.AmountDebt      :: TFloat
           , (COALESCE (tmpPartionGoods.Remains, 0) + COALESCE (tmpPartionGoods.AmountDebt, 0)) :: TFloat  AS RemainsAll

           , tmpPartionGoods.BrandName
           , tmpPartionGoods.PeriodName
           , tmpPartionGoods.PeriodYear
           , tmpPartionGoods.FabrikaName
           , tmpPartionGoods.GoodsGroupName
           , tmpPartionGoods.MeasureName
           , tmpPartionGoods.CompositionName
           , tmpPartionGoods.GoodsInfoName
           , tmpPartionGoods.LineFabricaName
           , tmpPartionGoods.LabelName
           , tmpPartionGoods.GoodsSizeName

       FROM tmpGoods AS tmpPartionGoods
            LEFT JOIN tmpDiscount ON tmpDiscount.GoodsId= tmpPartionGoods.GoodsId

            LEFT JOIN Movement ON Movement.Id= tmpPartionGoods.MovementId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpPartionGoods.GoodsId
            LEFT JOIN ObjectString AS Object_GroupNameFull
                                   ON Object_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND Object_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                 ON ObjectDate_Protocol_Insert.ObjectId = tmpDiscount.ObjectId
                                AND ObjectDate_Protocol_Insert.DescId   = zc_ObjectDate_Protocol_Insert()
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = tmpDiscount.ObjectId
                                AND ObjectDate_Protocol_Update.DescId   = zc_ObjectDate_Protocol_Update()

            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = tmpDiscount.ObjectId
                                AND ObjectLink_Insert.DescId   = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = tmpDiscount.ObjectId
                                AND ObjectLink_Update.DescId   = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId
       WHERE inShowAll = TRUE
          OR (inShowAll = FALSE AND tmpDiscount.GoodsId > 0)
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.03.18         *
 23.02.18         *
 01.07.17         *
 28.04.17         * битики + св-ва товара
 20.08.15         * add inShowAll
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_DiscountPeriodItem (inUnitId:= 506, inBrandId:= 1, inPeriodId:= 0, inOperDate:= CURRENT_DATE, inStartYear:= 0, inEndYear:= 0, inShowAll:= FALSE, inSession:= zfCalc_UserAdmin());
