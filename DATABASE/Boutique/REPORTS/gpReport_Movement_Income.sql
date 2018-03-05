-- Function:  gpReport_Movement_Income()

DROP FUNCTION IF EXISTS gpReport_Movement_Income (TDateTime, TDateTime, Integer,Integer,Integer,Boolean, Boolean,Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Income (TDateTime, TDateTime, Integer,Integer,Integer, Integer,Integer,Integer,Boolean, Boolean,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Income(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inBrandId          Integer  ,  -- Бренд
    IN inPartnerId        Integer  ,  -- Поставщик

    IN inPeriodId         Integer  ,  --
    IN inStartYear        Integer  ,  --
    IN inEndYear          Integer  ,  --

    IN inisPartion        Boolean,    --
    IN inisSize           Boolean,    --
    IN inisPartner        Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId     Integer,
               InvNumber      TVarChar,
               OperDate       TDateTime,
               DescName       TVarChar,
               FromName       TVarChar,
               ToName         TVarChar,
               BrandName      TVarChar,
               FabrikaName    TVarChar,
               PeriodName     TVarChar,
               PeriodYear     Integer,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar,
               JuridicalName TVarChar,
               CompositionGroupName TVarChar,
               CompositionName TVarChar,
               GoodsInfoName TVarChar,
               LineFabricaName TVarChar,
               LabelName TVarChar,
               GoodsSizeId Integer, GoodsSizeName TVarChar,
               CurrencyName  TVarChar,

               OperPrice           TFloat,
               CountForPrice       TFloat,
               OperPriceBalance    TFloat,
               OperPriceList       TFloat,
               OperPriceListLast   TFloat,
               Amount              TFloat,

               TotalSumm           TFloat,
               TotalSummBalance    TFloat,
               TotalSummPriceList  TFloat,
               TotalSummPriceListLast TFloat
  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!замена!!!
    IF inIsPartion = TRUE THEN
       inIsPartner:= TRUE;
       inIsSize   := TRUE;
    END IF;
    -- !!!замена!!!
    IF COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;


    -- Результат
    RETURN QUERY
    WITH
         tmpMovementIncome AS ( SELECT Movement_Income.Id AS MovementId
                                     , CASE WHEN inIsPartion = TRUE THEN MovementDesc_Income.ItemName ELSE CAST (NULL AS TVarChar)  END    AS DescName
                                     , CASE WHEN inIsPartion = TRUE THEN Movement_Income.InvNumber    ELSE CAST (NULL AS TVarChar)  END    AS InvNumber
                                     , CASE WHEN inIsPartion = TRUE THEN Movement_Income.OperDate     ELSE CAST (NULL AS TDateTime) END    AS OperDate
                                     , CASE WHEN inisPartner = TRUE THEN MovementLinkObject_From.ObjectId ELSE 0 END                       AS FromId
                                     , MovementLinkObject_To.ObjectId                                                                      AS ToId
                                     , ObjectLink_Partner_Brand.ChildObjectId                                                              AS BrandId
                                     , ObjectLink_Partner_Fabrika.ChildObjectId                                                            AS FabrikaId
                                     , ObjectLink_Partner_Period.ChildObjectId                                                             AS PeriodId

                                     , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                                                 AS CurrencyValue
                                     , COALESCE (MovementFloat_ParValue.ValueData, 0)                                                      AS ParValue
                                FROM Movement AS Movement_Income
                                     -- куда был приход
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                     -- от кого приход    Поставщик
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     -- бренд
                                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Brand
                                                           ON ObjectLink_Partner_Brand.ObjectId = MovementLinkObject_From.ObjectId
                                                          AND ObjectLink_Partner_Brand.DescId = zc_ObjectLink_Partner_Brand()

                                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                                          ON ObjectLink_Partner_Fabrika.ObjectId = MovementLinkObject_From.ObjectId
                                                         AND ObjectLink_Partner_Fabrika.DescId = zc_ObjectLink_Partner_Fabrika()

                                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                                          ON ObjectLink_Partner_Period.ObjectId = MovementLinkObject_From.ObjectId
                                                         AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()

                                     LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                             ON MovementFloat_ParValue.MovementId = Movement_Income.Id
                                                            AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                                     LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                             ON MovementFloat_CurrencyValue.MovementId = Movement_Income.Id
                                                            AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

                                     LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId

                                WHERE Movement_Income.DescId = zc_Movement_Income()
                                  AND Movement_Income.OperDate BETWEEN inStartDate AND inEndDate
                                  AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                                  AND (MovementLinkObject_From.ObjectId        = inPartnerId OR inPartnerId = 0)
                                  AND (MovementLinkObject_To.ObjectId          = inUnitId    OR inUnitId    = 0)
                                  AND (ObjectLink_Partner_Brand.ChildObjectId  = inBrandId   OR inBrandId   = 0)
                                  AND (ObjectLink_Partner_Period.ChildObjectId = inPeriodId  OR inPeriodId  = 0)
                              )

     , tmpData  AS  (SELECT CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.MovementId ELSE -1 END  AS MovementId
                          , tmpMovementIncome.InvNumber
                          , tmpMovementIncome.OperDate
                          , tmpMovementIncome.DescName
                          , tmpMovementIncome.FromId
                          , tmpMovementIncome.ToId
                          , tmpMovementIncome.BrandId
                          , tmpMovementIncome.FabrikaId
                          , tmpMovementIncome.PeriodId
                          , MI_Income.ObjectId             AS GoodsId
                          , CASE WHEN inisSize = TRUE THEN Object_PartionGoods.GoodsSizeId  ELSE 0 END  AS GoodsSizeId
                          , Object_PartionGoods.MeasureId
                          , Object_PartionGoods.GoodsGroupId
                          , Object_PartionGoods.CompositionId
                          , Object_PartionGoods.CompositionGroupId
                          , Object_PartionGoods.GoodsInfoId
                          , Object_PartionGoods.LineFabricaId
                          , Object_PartionGoods.LabelId
                          , Object_PartionGoods.JuridicalId
                          , Object_PartionGoods.CurrencyId
                          , Object_PartionGoods.PeriodYear

                          , tmpMovementIncome.CurrencyValue
                          , tmpMovementIncome.ParValue

                          , COALESCE (MIFloat_CountForPrice.ValueData, 1)       AS CountForPrice
                          , SUM (COALESCE (MI_Income.Amount, 0))                AS Amount
                          , SUM (zfCalc_SummIn (MI_Income.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData)) AS TotalSumm
                          , SUM (zfCalc_SummPriceList (MI_Income.Amount, MIFloat_OperPriceList.ValueData))                       AS TotalSummPriceList
                          , SUM (zfCalc_SummPriceList (MI_Income.Amount, Object_PartionGoods.OperPriceList))                     AS TotalSummPriceListLast

                     FROM tmpMovementIncome
                          INNER JOIN MovementItem AS MI_Income
                                                  ON MI_Income.MovementId = tmpMovementIncome.MovementId
                                                 AND MI_Income.isErased   = False
                          INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MI_Income.PartionId

                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MI_Income.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                      ON MIFloat_OperPrice.MovementItemId = MI_Income.Id
                                                     AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                      ON MIFloat_OperPriceList.MovementItemId = MI_Income.Id
                                                     AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                     WHERE (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                     GROUP BY CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.MovementId ELSE -1 END
                            , tmpMovementIncome.InvNumber
                            , tmpMovementIncome.OperDate
                            , tmpMovementIncome.DescName
                            , tmpMovementIncome.FromId
                            , tmpMovementIncome.ToId
                            , tmpMovementIncome.CurrencyValue
                            , tmpMovementIncome.ParValue
                            , MI_Income.ObjectId
                            , CASE WHEN inisSize = TRUE THEN Object_PartionGoods.GoodsSizeId  ELSE 0 END
                            , Object_PartionGoods.MeasureId
                            , Object_PartionGoods.GoodsGroupId
                            , Object_PartionGoods.CompositionId
                            , Object_PartionGoods.CompositionGroupId
                            , Object_PartionGoods.GoodsInfoId
                            , Object_PartionGoods.LineFabricaId
                            , Object_PartionGoods.LabelId
                            , Object_PartionGoods.JuridicalId
                            , COALESCE (MIFloat_CountForPrice.ValueData, 1)
                            , tmpMovementIncome.BrandId
                            , tmpMovementIncome.FabrikaId
                            , tmpMovementIncome.PeriodId
                            , Object_PartionGoods.CurrencyId
                            , Object_PartionGoods.PeriodYear
              )


        SELECT
             tmpData.MovementId
           , tmpData.InvNumber
           , tmpData.OperDate
           , tmpData.DescName
           , Object_From.ValueData          AS FromName
           , Object_To.ValueData            AS ToName

           , Object_Brand.ValueData         AS BrandName
           , Object_Fabrika.ValueData       AS FabrikaName
           , Object_Period.ValueData        AS PeriodName
           , tmpData.PeriodYear

           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , Object_Juridical.ValueData     AS JuridicalName
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.Id            AS GoodsSizeId
           , Object_GoodsSize.ValueData     AS GoodsSizeName
           , Object_Currency.ValueData      AS CurrencyName

           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm  / tmpData.Amount ELSE 0 END          ::TFloat AS OperPrice
           , tmpData.CountForPrice           ::TFloat
           , (CAST ( (CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm / tmpData.Amount ELSE 0 END)
                      * tmpData.CurrencyValue / CASE WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END  AS NUMERIC (16, 2))) :: TFloat  AS OperPriceBalance

           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSummPriceList     / tmpData.Amount ELSE 0 END :: TFloat AS OperPriceList
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSummPriceListLast / tmpData.Amount ELSE 0 END :: TFloat AS OperPriceListLast
           , tmpData.Amount                  :: TFloat
           , tmpData.TotalSumm               :: TFloat
           , (CAST (tmpData.TotalSumm * tmpData.CurrencyValue / CASE WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS TotalSummBalance
           , tmpData.TotalSummPriceList      :: TFloat  AS TotalSummPriceList
           , tmpData.TotalSummPriceListLast  :: TFloat  AS TotalSummPriceListLast

        FROM tmpData
            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
            LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpData.ToId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = tmpData.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpData.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpData.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = tmpData.JuridicalId
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId

            LEFT JOIN Object AS Object_Brand   ON Object_Brand.Id   = tmpData.BrandId
            LEFT JOIN Object AS Object_Fabrika ON Object_Fabrika.Id = tmpData.FabrikaId
            LEFT JOIN Object AS Object_Period  ON Object_Period.Id  = tmpData.PeriodId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 30.05.17         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_Income(inStartDate := ('01.11.2016')::TDateTime , inEndDate := ('01.07.2018')::TDateTime , inUnitId := 506 , inBrandId := 0 , inPartnerId := 0 , inPeriodId := 0 , inStartYear := 0 , inEndYear := 2017 , inisPartion := 'False' , inisSize := 'False' , inisPartner := 'False' ,  inSession := '2');
