-- Function:  gpReport_GoodsMI_Account()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Account (TDateTime,TDateTime,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_GoodsMI_Account(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               PartnerName TVarChar,
               GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsSizeId Integer, GoodsSizeName TVarChar,
               
               Amount              TFloat,
               OperPriceList       TFloat,
               ChangePercent       TFloat,
               TotalSummPay        TFloat,
               TotalPay_Grn        TFloat,
               TotalPay_Card       TFloat,
               TotalPay_USD        TFloat,
               TotalPay_Eur        TFloat
  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReturnOut());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH
    tmpMovementSale AS (SELECT Movement_Sale.Id                    AS MovementId
                             , zc_Movement_Sale()                  AS MovementDescId
                             , MovementLinkObject_To.ObjectId      AS PartnerId

                        FROM Movement AS Movement_Sale
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                          AND MovementLinkObject_From.ObjectId = inUnitId
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                        WHERE Movement_Sale.DescId = zc_Movement_Sale()
                          AND Movement_Sale.OperDate BETWEEN inStartDate AND inEndDate
                         -- AND Movement_Sale.StatusId = zc_Enum_Status_Complete() 
                      )    
  , tmpMovementReturnOut AS (SELECT Movement_ReturnOut.Id                    AS MovementId
                                  , zc_Movement_ReturnOut()                  AS MovementDescId
                                  , MovementLinkObject_From.ObjectId         AS PartnerId

                             FROM Movement AS Movement_ReturnOut
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement_ReturnOut.Id
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                               AND MovementLinkObject_To.ObjectId = inUnitId
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_ReturnOut.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             WHERE Movement_ReturnOut.DescId = zc_Movement_ReturnOut()
                               AND Movement_ReturnOut.OperDate BETWEEN inStartDate AND inEndDate
                              -- AND Movement_ReturnOut.StatusId = zc_Enum_Status_Complete() 
                           )

  , tmpMovement AS (SELECT MovementItem.ObjectId    AS GoodsId
                         , MovementItem.PartionId
                         , MI_Master.Amount
                         , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                         , COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS OperPriceList

                         , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN MI_Child.Amount ELSE 0 END) AS Amount_GRN
                         , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MI_Child.Amount ELSE 0 END) AS Amount_USD
                         , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MI_Child.Amount ELSE 0 END) AS Amount_EUR
                         , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MI_Child.Amount ELSE 0 END) AS Amount_Bank

                    FROM (SELECT tmpMovementSale.MovementId
                               , tmpMovementSale.MovementDescId
                               , tmpMovementSale.PartnerId
                          FROM tmpMovementSale
                         UNION ALL
                          SELECT tmpMovementReturnOut.MovementId
                               , tmpMovementReturnOut.MovementDescId
                               , tmpMovementReturnOut.PartnerId
                          FROM tmpMovementReturnOut
                         ) AS tmp
                         INNER JOIN MovementItem AS MI_Child
                                                 ON MI_Child.MovementId = tmp.MovementId
                                                AND MI_Child.DescId     = zc_MI_Child()
                                                AND MI_Child.isErased   = FALSE
                         LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                          ON MILinkObject_Currency.MovementItemId = MI_Child.Id
                                                         AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()    
                         LEFT JOIN MovementItem AS MI_Master
                                                ON MI_Master.Id         = MI_Child.ParentId
                                               AND MI_Master.DescId     = zc_MI_Master()
                                               AND MI_Master.isErased   = FALSE   
                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                     ON MIFloat_ChangePercent.MovementItemId = MI_Master.Id
                                                    AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()                                                                                         
                    )
     , tmpData  AS  (SELECT tmpMovementReturnOut.InvNumber
                          , tmpMovementReturnOut.OperDate
                          , tmpMovementReturnOut.DescName
                          , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE CAST (NULL AS TVarChar)  END    AS DescName_Partion
                          , CASE WHEN inisPartion = TRUE THEN Movement_Partion.Id           ELSE -1 END                          AS MovementId_Partion
                          , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE CAST (NULL AS TVarChar)  END    AS InvNumber_Partion
                          , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE CAST (NULL AS TDateTime) END    AS OperDate_Partion

                          , tmpMovementReturnOut.FromId
                          , tmpMovementReturnOut.ToId
                          , tmpMovementReturnOut.BrandId
                          , tmpMovementReturnOut.FabrikaId
                          , tmpMovementReturnOut.PeriodId
                          , Object_PartionGoods.PeriodYear

                          , MI_ReturnOut.ObjectId             AS GoodsId
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

                          , COALESCE (MIFloat_CountForPrice.ValueData, 1)      AS CountForPrice
                          , SUM (COALESCE (MI_ReturnOut.Amount, 0))            AS Amount
                          , SUM (CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 1) <> 0
                                          THEN CAST (COALESCE (MI_ReturnOut.Amount, 0) * COALESCE (MIFloat_OperPrice.ValueData, 0) / COALESCE (MIFloat_CountForPrice.ValueData, 1) AS NUMERIC (16, 2))
                                      ELSE CAST ( COALESCE (MI_ReturnOut.Amount, 0) * COALESCE (MIFloat_OperPrice.ValueData, 0) AS NUMERIC (16, 2))
                                 END) AS AmountSumm

                          , SUM (COALESCE (MI_ReturnOut.Amount, 0) * COALESCE (MIFloat_OperPriceList.ValueData, 0))  AS AmountPriceListSumm
                          , SUM (COALESCE (MI_ReturnOut.Amount, 0) * COALESCE (Object_PartionGoods.PriceSale,0))     AS SaleSumm

                     FROM tmpMovementReturnOut
                          INNER JOIN MovementItem AS MI_ReturnOut 
                                                  ON MI_ReturnOut.MovementId = tmpMovementReturnOut.MovementId
                                                 AND MI_ReturnOut.isErased   = False
                          INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MI_ReturnOut.PartionId
                                                  --      AND (Object_PartionGoods.BrandId = inBrandId OR inBrandId = 0)
                          LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = Object_PartionGoods.MovementId
                          LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId 

                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MI_ReturnOut.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                      ON MIFloat_OperPrice.MovementItemId = MI_ReturnOut.Id
                                                     AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                      ON MIFloat_OperPriceList.MovementItemId = MI_ReturnOut.Id
                                                     AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                     GROUP BY tmpMovementReturnOut.InvNumber
                            , tmpMovementReturnOut.OperDate
                            , tmpMovementReturnOut.DescName
                            , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE CAST (NULL AS TVarChar)  END
                            , CASE WHEN inisPartion = TRUE THEN Movement_Partion.Id           ELSE -1                       END  
                            , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE CAST (NULL AS TVarChar)  END
                            , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE CAST (NULL AS TDateTime) END
                            , tmpMovementReturnOut.FromId
                            , tmpMovementReturnOut.ToId
                            , MI_ReturnOut.ObjectId
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
                            , tmpMovementReturnOut.BrandId
                            , tmpMovementReturnOut.FabrikaId
                            , tmpMovementReturnOut.PeriodId
                            , Object_PartionGoods.CurrencyId
                            , Object_PartionGoods.PeriodYear
              )
              

        SELECT
             tmpData.InvNumber
           , tmpData.OperDate
           , tmpData.DescName
           , tmpData.MovementId_Partion
           , tmpData.InvNumber_Partion
           , tmpData.OperDate_Partion
           , tmpData.DescName_Partion
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
           
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.AmountSumm  / tmpData.Amount ELSE 0 END          ::TFloat AS OperPrice
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.AmountPriceListSumm  / tmpData.Amount ELSE 0 END ::TFloat AS OperPriceList
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SaleSumm  / tmpData.Amount ELSE 0 END            ::TFloat AS PriceSale
           , tmpData.Amount                  ::TFloat
           , tmpData.AmountSumm              ::TFloat
           , tmpData.AmountPriceListSumm     ::TFloat
           , tmpData.SaleSumm                ::TFloat
           
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
--SELECT * from gpReport_GoodsMI_Account(    inStartDate := '01.12.2016' :: TDateTime, inEndDate:= '01.12.2018' :: TDateTime, inUnitId :=311,inBrandId  := 0 ,inPartnerId  := 0 , inisPartion  := TRUE,inisSize:=  TRUE, inisPartner := TRUE, inSession := '2':: TVarChar )
--SELECT * from gpReport_GoodsMI_Account(    inStartDate := '01.12.2016' :: TDateTime, inEndDate:= '01.12.2018' :: TDateTime, inUnitId :=230,inBrandId  := 0 ,inPartnerId  := 0 , inisPartion  :=False,inisSize:=  False, inisPartner := False, inSession := '2':: TVarChar )

--select * from gpGet_Movement_ReturnOut(inMovementId := 22 , inOperDate := ('04.02.2018')::TDateTime ,  inSession := '2');
--select * from gpGet_Movement_ReturnOut(inMovementId := 22 , inOperDate := ('04.02.2018')::TDateTime ,  inSession := '2');