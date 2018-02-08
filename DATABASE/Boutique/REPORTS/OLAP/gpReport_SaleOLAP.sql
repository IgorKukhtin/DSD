-- Function:  gpReport_SalesOLAP()
DROP FUNCTION IF EXISTS gpReport_SaleOLAP (TDateTime, TDateTime, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleOLAP (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inPartnerId        Integer  ,  -- Покупатель
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inPeriodYearStart  TFloat  ,
    IN inPeriodYearEnd    TFloat  ,
    IN inIsSize           Boolean ,
    IN inIsGoods          Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (BrandName          TVarChar
             , PeriodName         TVarChar
             , PeriodYear         Integer
             , PartnerId          Integer
             , PartnerName        TVarChar

             , GoodsGroupName_all TVarChar
             , GoodsGroupName     TVarChar
             , LabelName          TVarChar
             , CompositionGroupName  TVarChar
             , CompositionName       TVarChar

             , GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , GoodsInfoName      TVarChar
             , LineFabricaName    TVarChar
             , FabrikaName        TVarChar
             , GoodsSizeId        Integer
             , GoodsSizeName      TVarChar

             , OperDate           TDateTime
             , UnitName           TVarChar
             , ClientName         TVarChar

             , UnitName_In        TVarChar
             , CurrencyName       TVarChar

             , OperPrice          TFloat
             , Income_Amount      TFloat

             , Debt_Amount        TFloat
             , Sale_Amount        TFloat
             , Sale_Summ          TFloat
             , Sale_SummCost      TFloat
             , Sale_Summ_10100    TFloat
             , Sale_Summ_10201    TFloat
             , Sale_Summ_10202    TFloat
             , Sale_Summ_10203    TFloat
             , Sale_Summ_10204    TFloat
             , Sale_Summ_10200    TFloat
             , Return_Amount      TFloat
             , Return_Summ        TFloat
             , Return_SummCost    TFloat
             , Return_Summ_10200  TFloat
             , Result_Amount      TFloat
             , Result_Summ        TFloat
             , Result_SummCost    TFloat
             , Result_Summ_10200  TFloat
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH tmpData AS (SELECT SoldTable.BrandId
                          , SoldTable.PeriodId
                          , SoldTable.PeriodYear
                          , SoldTable.PartnerId

                          , SoldTable.GoodsGroupId
                          , SoldTable.LabelId
                          , SoldTable.CompositionGroupId
                          , SoldTable.CompositionId

                          , CASE WHEN inisGoods = TRUE THEN SoldTable.GoodsId     ELSE 0 END AS GoodsId
                          , CASE WHEN inisGoods = TRUE THEN SoldTable.GoodsInfoId ELSE 0 END AS GoodsInfoId
                          , SoldTable.LineFabricaId
                          , CASE WHEN inisSize  = TRUE THEN SoldTable.GoodsSizeId ELSE 0 END AS GoodsSizeId

                          , SoldTable.OperDate
                          , SoldTable.UnitId
                          , SoldTable.ClientId

                          , SoldTable.UnitId_in
                          , SoldTable.CurrencyId

                          , SoldTable.OperPrice
                          , SUM (CASE WHEN SoldTable.Ord = 1 THEN SoldTable.Income_Amount ELSE 0 END) AS Income_Amount

                          , SUM (SoldTable.Debt_Amount)         AS Debt_Amount
                          , SUM (SoldTable.Sale_Amount)         AS Sale_Amount
                          , SUM (SoldTable.Sale_Summ)           AS Sale_Summ
                          , SUM (SoldTable.Sale_SummCost)       AS Sale_SummCost
                          , SUM (SoldTable.Sale_Summ_10100)     AS Sale_Summ_10100
                          , SUM (SoldTable.Sale_Summ_10201)     AS Sale_Summ_10201
                          , SUM (SoldTable.Sale_Summ_10202)     AS Sale_Summ_10202
                          , SUM (SoldTable.Sale_Summ_10203)     AS Sale_Summ_10203
                          , SUM (SoldTable.Sale_Summ_10204)     AS Sale_Summ_10204
                          , SUM (SoldTable.Sale_Summ_10200)     AS Sale_Summ_10200
                          , SUM (SoldTable.Return_Amount)       AS Return_Amount
                          , SUM (SoldTable.Return_Summ)         AS Return_Summ
                          , SUM (SoldTable.Return_SummCost)     AS Return_SummCost
                          , SUM (SoldTable.Return_Summ_10200)   AS Return_Summ_10200
                          , SUM (SoldTable.Result_Amount)       AS Result_Amount
                          , SUM (SoldTable.Result_Summ)         AS Result_Summ
                          , SUM (SoldTable.Result_SummCost)     AS Result_SummCost
                          , SUM (SoldTable.Result_Summ_10200)   AS Result_Summ_10200
                     FROM SoldTable
                     WHERE (SoldTable.PartnerId  = inPartnerId        OR inPartnerId        = 0)
                       AND (SoldTable.BrandId    = inBrandId          OR inBrandId         = 0)
                       AND (SoldTable.PeriodId   = inPeriodId         OR inPeriodId        = 0)
                       AND (SoldTable.PeriodYear >= inPeriodYearStart OR inPeriodYearStart = 0)
                       AND (SoldTable.PeriodYear <= inPeriodYearEnd   OR inPeriodYearEnd   = 0)
                       -- AND SoldTable.OperDate BETWEEN inStartDate AND inEndDate

                     GROUP BY SoldTable.BrandId
                            , SoldTable.PeriodId
                            , SoldTable.PeriodYear
                            , SoldTable.PartnerId

                            , SoldTable.GoodsGroupId
                            , SoldTable.LabelId
                            , SoldTable.CompositionGroupId
                            , SoldTable.CompositionId

                            , CASE WHEN inisGoods = TRUE THEN SoldTable.GoodsId     ELSE 0 END
                            , CASE WHEN inisGoods = TRUE THEN SoldTable.GoodsInfoId ELSE 0 END
                            , SoldTable.LineFabricaId
                            , CASE WHEN inisSize  = TRUE THEN SoldTable.GoodsSizeId ELSE 0 END

                            , SoldTable.OperDate
                            , SoldTable.UnitId
                            , SoldTable.ClientId

                            , SoldTable.UnitId_in
                            , SoldTable.CurrencyId
                            , SoldTable.OperPrice
                     )

        -- результат
        SELECT Object_Brand.ValueData             AS BrandName
             , Object_Period.ValueData            AS PeriodName
             , tmpData.PeriodYear      :: Integer AS PeriodYear
             , Object_Partner.Id                  AS PartnerId
             , Object_Partner.ValueData           AS PartnerName

             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupName_all
             , Object_GoodsGroup.ValueData        AS GoodsGroupName
             , Object_Label.ValueData             AS LabelName
             , Object_CompositionGroup.ValueData  AS CompositionGroupName
             , Object_Composition.ValueData       AS CompositionName

             , Object_Goods.Id                    AS GoodsId
             , Object_Goods.ObjectCode            AS GoodsCode
             , Object_Goods.ValueData             AS GoodsName
             , Object_GoodsInfo.ValueData         AS GoodsInfoName
             , Object_LineFabrica.ValueData       AS LineFabricaName
             , Object_Fabrika.ValueData           AS FabrikaName
             , Object_GoodsSize.Id                AS GoodsSizeId
             , Object_GoodsSize.ValueData         AS GoodsSizeName

             , tmpData.OperDate :: TDateTime      AS OperDate
             , Object_Unit.ValueData              AS UnitName
             , Object_Client.ValueData            AS ClientName

             , Object_Unit_In.ValueData           AS UnitName_In
             , Object_Currency.ValueData          AS CurrencyName

             , tmpData.OperPrice          :: TFloat
             , tmpData.Income_Amount      :: TFloat

             , tmpData.Debt_Amount        :: TFloat
             , tmpData.Sale_Amount        :: TFloat
             , tmpData.Sale_Summ          :: TFloat

             , tmpData.Sale_SummCost      :: TFloat
             , tmpData.Sale_Summ_10100    :: TFloat
             , tmpData.Sale_Summ_10201    :: TFloat
             , tmpData.Sale_Summ_10202    :: TFloat
             , tmpData.Sale_Summ_10203    :: TFloat
             , tmpData.Sale_Summ_10204    :: TFloat
             , tmpData.Sale_Summ_10200    :: TFloat

             , tmpData.Return_Amount      :: TFloat
             , tmpData.Return_Summ        :: TFloat
             , tmpData.Return_SummCost    :: TFloat
             , tmpData.Return_Summ_10200  :: TFloat

             , tmpData.Result_Amount      :: TFloat
             , tmpData.Result_Summ        :: TFloat
             , tmpData.Result_SummCost    :: TFloat
             , tmpData.Result_Summ_10200  :: TFloat

        FROM tmpData
            LEFT JOIN Object AS Object_Client   ON Object_Client.Id   = tmpData.ClientId
            LEFT JOIN Object AS Object_Partner  ON Object_Partner.Id  = tmpData.PartnerId
            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_In  ON Object_Unit_In.Id  = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = tmpData.CurrencyId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpData.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpData.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = tmpData.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = tmpData.PeriodId
            LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = NULL -- tmpData.FabrikaId
           ;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.02.18         *
*/

-- тест
-- SELECT * FROM gpReport_SaleOLAP (inStartDate:= '01.03.2017', inEndDate:= '31.03.2017', inPartnerId:= 2628, inBrandId:= 0, inPeriodId:= 0, inPeriodYearStart:= 2017, inPeriodYearEnd:= 2017, inIsSize:= FALSE, inIsGoods:= FALSE, inSession:= zfCalc_UserAdmin());
