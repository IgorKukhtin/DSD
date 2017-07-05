-- Function:  gpReport_PartnerDebt()

DROP FUNCTION IF EXISTS gpReport_PartnerDebt (Integer,TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_PartnerDebt (
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , DescName              TVarChar
             , OperDate              TDateTime
             , Invnumber             TVarChar
             , PartnerName           TVarChar
             , PartionId             Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , MeasureName      TVarChar
             , JuridicalName    TVarChar
             , CompositionGroupName TVarChar
             , CompositionName  TVarChar
             , GoodsInfoName    TVarChar
             , LineFabricaName  TVarChar
             , LabelName        TVarChar
             , GoodsSizeId Integer, GoodsSizeName    TVarChar
             , CurrencyName     TVarChar
             , BrandName        TVarChar
             , FabrikaName      TVarChar
             , PeriodName       TVarChar
             , PeriodYear       Integer
             , ChangePercent    TFloat
             , OperPriceList    TFloat
             , Amount           TFloat
             , TotalSummPriceList TFloat
             , SummChangePercent  TFloat
             , TotalPay           TFloat
             , TotalPayOth        TFloat
             , TotalCountReturn   TFloat
             , TotalReturn        TFloat
             , TotalPayReturn     TFloat
             , SummDebt           TFloat
  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH
    tmpSale AS (SELECT Movement_Sale.Id                    AS MovementId
                     , zc_Movement_Sale()                  AS MovementDescId
                     , Movement_Sale.OperDate              AS OperDate
                     , Movement_Sale.Invnumber             AS Invnumber
                     , MovementLinkObject_To.ObjectId      AS PartnerId
                     , MI_Master.ObjectId                  AS GoodsId
                     , MI_Master.PartionId
                     , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                     , COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS OperPriceList
                     , MI_Master.Amount                                      AS Amount
                     , CAST (MI_Master.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 2)) AS TotalSummPriceList
                     , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent
                     , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent
                     , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay
                     , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                     , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth
                     , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      AS TotalCountReturn
                     , COALESCE (MIFloat_TotalReturn.ValueData, 0)           AS TotalReturn
                     , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        AS TotalPayReturn
                     , (MI_Master.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0)) 
                      - COALESCE (MIFloat_TotalPay.ValueData, 0) 
                      - COALESCE (MIFloat_TotalPayOth.ValueData, 0) 
                      - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                      - COALESCE (MIFloat_SummChangePercent.ValueData, 0)    AS Debt
                FROM Movement AS Movement_Sale
                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                  AND MovementLinkObject_From.ObjectId = inUnitId
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                     INNER JOIN MovementItem AS MI_Master
                                             ON MI_Master.MovementId = Movement_Sale.Id
                                            AND MI_Master.DescId     = zc_MI_Master()
                                            AND MI_Master.isErased   = FALSE
                                            AND MI_Master.Amount    <> 0
                     
                     LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                 ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                     LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                 ON MIFloat_ChangePercent.MovementItemId = MI_Master.Id
                                                AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()  
                     LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                 ON MIFloat_SummChangePercent.MovementItemId = MI_Master.Id
                                                AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()         
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                 ON MIFloat_TotalChangePercent.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                 ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()    
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                 ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                 ON MIFloat_TotalPayOth.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()    
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                 ON MIFloat_TotalCountReturn.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()    
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                 ON MIFloat_TotalReturn.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()    
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                 ON MIFloat_TotalPayReturn.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()    
                                                       
                WHERE Movement_Sale.DescId = zc_Movement_Sale()
                  --AND Movement_Sale.StatusId = zc_Enum_Status_Complete() 
                )     

        SELECT tmpSale.MovementId
             , MovementDesc.ItemName          AS DescName
             , tmpSale.OperDate
             , tmpSale.Invnumber
             
             , Object_Partner.ValueData       AS PartnerName
             , tmpSale.PartionId
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
             , Object_Brand.ValueData         AS BrandName
             , Object_Fabrika.ValueData       AS FabrikaName
             , Object_Period.ValueData        AS PeriodName
             , Object_PartionGoods.PeriodYear ::Integer
               
             , tmpSale.ChangePercent            ::TFloat
             , tmpSale.OperPriceList            ::TFloat
             , tmpSale.Amount                   ::TFloat
             , tmpSale.TotalSummPriceList       ::TFloat
             , tmpSale.SummChangePercent        ::TFloat
             , tmpSale.TotalPay                 ::TFloat
             , tmpSale.TotalPayOth              ::TFloat
             , tmpSale.TotalCountReturn         ::TFloat
             , tmpSale.TotalReturn              ::TFloat
             , tmpSale.TotalPayReturn           ::TFloat
             , tmpSale.Debt                     ::TFloat AS SummDebt
        FROM tmpSale
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpSale.MovementDescId
            
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpSale.PartnerId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpSale.GoodsId
            
            LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpSale.PartionId  
             
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = Object_PartionGoods.JuridicalId
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
            LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId
            
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpSale.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
        WHERE tmpSale.Debt <> 0

;
 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 04.07.17         *
*/

-- тест
-- select * from gpReport_PartnerDebt (inUnitId := 506 ,  inSession := '2');