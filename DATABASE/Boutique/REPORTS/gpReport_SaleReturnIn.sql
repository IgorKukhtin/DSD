-- Function:  gpReport_SaleReturnIn()

DROP FUNCTION IF EXISTS gpReport_SaleReturnIn (TDateTime,TDateTime,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleReturnIn (TDateTime,TDateTime,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_SaleReturnIn (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inIsShowAll        Boolean  ,  -- Показывать все документы / только проведенные
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , StatusCode            Integer
             , DescName              TVarChar
             , OperDate              TDateTime
             , InvNumber             TVarChar
             , MovementId_Sale       Integer
             , DescName_Sale         TVarChar
             , OperDate_Sale         TDateTime
             , InvNumber_Sale        TVarChar
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
             , TotalSumm           TFloat
             , TotalSummPriceList  TFloat
             , TotalPay            TFloat
             , SummChangePercent   TFloat
             , TotalChangePercent  TFloat
             , TotalPayOth         TFloat  
             
             , TotalPay_Grn        TFloat
             , TotalPay_USD        TFloat
             , TotalPay_Eur        TFloat
             , TotalPay_Card       TFloat

             , TotalCountReturn    TFloat
             , TotalReturn         TFloat
             , TotalPayReturn      TFloat
             , TotalSummToPay      TFloat
             , TotalSummDebt       TFloat
             , InsertDate          TDateTime
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- определяем магазин по принадлежности пользователя к сотруднику
     --vbUnitId:= lpGetUnitBySession (inSession);
     -- подразделение пользователя
     vbUnitId := lpGetUnitByUser(vbUserId);

     -- если у пользователя = 0, тогда может смотреть любой магазин, иначе только свой
     IF vbUnitId <> 0 AND vbUnitId <> inUnitId AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Child() AND OL.ChildObjectid = inUnitId AND OL.Objectid = vbUnitId)
     THEN
         RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав просмотра данных по подразделению <%> .', lfGet_Object_ValueData (vbUserId), lfGet_Object_ValueData (inUnitId);
     END IF;
     
    -- Результат
    RETURN QUERY
    WITH
    tmpStatus AS (SELECT tmp.StatusId              AS StatusId
                       , Object_Status.ObjectCode  AS StatusCode
                  FROM (SELECT zc_Enum_Status_Complete()   AS StatusId
                        UNION SELECT zc_Enum_Status_UnComplete() AS StatusId WHERE inIsShowAll = TRUE
                        UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsShowAll = TRUE
                        ) AS tmp
                        LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmp.StatusId
                 )

  , tmpSale AS (SELECT Movement_Sale.Id                    AS MovementId
                     , zc_Movement_Sale()                  AS MovementDescId
                     , tmpStatus.StatusCode                AS StatusCode
                     , Movement_Sale.OperDate              AS OperDate
                     , Movement_Sale.Invnumber             AS Invnumber
                     , Movement_Sale.Id                    AS MovementId_Sale
                     , Movement_Sale.DescId                AS MovementDescId_Sale
                     , Movement_Sale.OperDate              AS OperDate_Sale
                     , Movement_Sale.Invnumber             AS Invnumber_Sale
                     , MovementLinkObject_To.ObjectId      AS PartnerId
                     , MI_Master.ObjectId                  AS GoodsId
                     , MI_Master.PartionId
                     , COALESCE (MIFloat_ChangePercent.ValueData, 0)  AS ChangePercent
                     , COALESCE (MIFloat_OperPriceList.ValueData, 0)  AS OperPriceList
                     , MI_Master.Amount                               AS Amount
                     
                     , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent
                     , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent
                     , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay
                     , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                     , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth
                     , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      AS TotalCountReturn
                     , COALESCE (MIFloat_TotalReturn.ValueData, 0)           AS TotalReturn
                     , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        AS TotalPayReturn
                     , zfCalc_SummIn (MI_Master.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSumm
                     
                FROM Movement AS Movement_Sale
                     INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_Sale.StatusId
                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                  AND (MovementLinkObject_From.ObjectId = inUnitId OR inUnitId = 0)
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                     INNER JOIN MovementItem AS MI_Master
                                             ON MI_Master.MovementId = Movement_Sale.Id
                                            AND MI_Master.DescId     = zc_MI_Master()
                                            AND MI_Master.isErased   = FALSE
                                            AND MI_Master.Amount    <> 0
                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                 ON MIFloat_CountForPrice.MovementItemId = MI_Master.Id
                                                AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                                                       
                     LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                 ON MIFloat_ChangePercent.MovementItemId = MI_Master.Id
                                                 AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent() 
                     LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                 ON MIFloat_OperPrice.MovementItemId = MI_Master.Id
                                                AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                                                AND vbUnitId = 0                                             --  продавцам в магазинах ограничиваем инфу
                     LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                 ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList() 
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                 ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()


                     LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                 ON MIFloat_SummChangePercent.MovementItemId = MI_Master.Id
                                                AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()         
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                 ON MIFloat_TotalChangePercent.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                 ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()    
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
                  AND Movement_Sale.OperDate BETWEEN inStartDate AND inEndDate
                  --AND Movement_Sale.StatusId = zc_Enum_Status_Complete() 
              )     
  , tmpReturnIn AS (SELECT Movement_ReturnIn.Id                AS MovementId
                         , zc_Movement_ReturnIn()              AS MovementDescId
                         , tmpStatus.StatusCode                AS StatusCode
                         , Movement_ReturnIn.OperDate          AS OperDate
                         , Movement_ReturnIn.Invnumber         AS Invnumber
                         , Movement_Sale.Id                    AS MovementId_Sale
                         , Movement_Sale.DescId                AS MovementDescId_Sale
                         , Movement_Sale.OperDate              AS OperDate_Sale
                         , Movement_Sale.Invnumber             AS Invnumber_Sale
                         , MovementLinkObject_From.ObjectId    AS PartnerId
                         , MI_Master.ObjectId                  AS GoodsId
                         , MI_Master.PartionId
                         , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                         , COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS OperPriceList
                         , (MI_Master.Amount) * (-1)                             AS Amount
                         , COALESCE (MIFloat_TotalPay.ValueData, 0) * (-1)       AS TotalPay
                         , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent
                         , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent
                         , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth
                         , zfCalc_SummIn (MI_Master.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSumm
                    FROM Movement AS Movement_ReturnIn
                         INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_ReturnIn.StatusId
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement_ReturnIn.Id
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                      AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId = 0)
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement_ReturnIn.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
    
                         INNER JOIN MovementItem AS MI_Master
                                                 ON MI_Master.MovementId = Movement_ReturnIn.Id
                                                AND MI_Master.DescId     = zc_MI_Master()
                                                AND MI_Master.isErased   = FALSE  
                                                AND MI_Master.Amount    <> 0
                         LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                     ON MIFloat_CountForPrice.MovementItemId = MI_Master.Id
                                                    AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

                         LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                     ON MIFloat_OperPrice.MovementItemId = MI_Master.Id
                                                    AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                                                    AND vbUnitId = 0                                             --  продавцам в магазинах ограничиваем инфу

                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                     ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                    AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList() 
                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                     ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                     ON MIFloat_TotalPayOth.MovementItemId = MI_Master.Id
                                                    AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
                                                    
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                          ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                         AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI() 
                         LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                         LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
                         LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId
                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                     ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                                    AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                         LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                     ON MIFloat_SummChangePercent.MovementItemId = MI_Sale.Id
                                                    AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()         
                         LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                     ON MIFloat_TotalChangePercent.MovementItemId = MI_Sale.Id
                                                    AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent() 
                    WHERE Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
                      AND Movement_ReturnIn.OperDate BETWEEN inStartDate AND inEndDate
                      --AND Movement_ReturnIn.StatusId = zc_Enum_Status_Complete() 
                  )
 
     , tmpData  AS  (SELECT tmp.MovementId
                          , tmp.MovementDescId
                          , tmp.StatusCode
                          , tmp.OperDate
                          , tmp.Invnumber
                          , tmp.MovementId_Sale
                          , tmp.MovementDescId_Sale
                          , tmp.OperDate_Sale
                          , tmp.Invnumber_Sale
                          , tmp.PartnerId
                          , tmp.GoodsId
                          , tmp.PartionId
                          , tmp.ChangePercent
                          , tmp.OperPriceList
                          , tmp.Amount
                          , tmp.TotalPay
                          , tmp.SummChangePercent
                          , tmp.TotalChangePercent
                          , tmp.TotalPayOth
                          , tmp.TotalCountReturn
                          , tmp.TotalReturn
                          , tmp.TotalPayReturn
                          , tmp.TotalSumm
                     FROM tmpSale AS tmp
                   UNION ALL
                     SELECT tmp.MovementId
                          , tmp.MovementDescId
                          , tmp.StatusCode
                          , tmp.OperDate
                          , tmp.Invnumber
                          , tmp.MovementId_Sale
                          , tmp.MovementDescId_Sale
                          , tmp.OperDate_Sale
                          , tmp.Invnumber_Sale
                          , tmp.PartnerId
                          , tmp.GoodsId
                          , tmp.PartionId
                          , tmp.ChangePercent
                          , tmp.OperPriceList
                          , tmp.Amount
                          , tmp.TotalPay
                          , tmp.SummChangePercent
                          , tmp.TotalChangePercent
                          , tmp.TotalPayOth
                          , 0 :: TFloat AS TotalCountReturn
                          , 0 :: TFloat AS TotalReturn
                          , 0 :: TFloat AS TotalPayReturn
                          , tmp.TotalSumm
                     FROM tmpReturnIn AS tmp
                    )
    -- cуммы оплат / возврата по валютам
    , tmpMI_Child AS (SELECT tmpData.MovementId
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- Расчетная сумма в грн для обмен
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END) AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END) AS Amount_Bank
                           --, MovementItem.isErased
                      FROM tmpData
                            JOIN MovementItem ON MovementItem.MovementId = tmpData.MovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = FALSE
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      GROUP BY tmpData.MovementId
                     )            

        SELECT tmpData.MovementId
             , tmpData.StatusCode             AS StatusCode
             , MovementDesc.ItemName          AS DescName
             , tmpData.OperDate
             , tmpData.Invnumber
             , tmpData.MovementId_Sale
             , MovementDesc_Sale.ItemName     AS DescName_Sale
             , tmpData.OperDate_Sale
             , tmpData.Invnumber_Sale
             
             , Object_Partner.ValueData       AS PartnerName
             , tmpData.PartionId
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
               
             , tmpData.ChangePercent       ::TFloat
             , tmpData.OperPriceList       ::TFloat
             , tmpData.Amount              ::TFloat
             , tmpData.TotalSumm           ::TFloat
             , (tmpData.OperPriceList * tmpData.Amount) ::TFloat AS TotalSummPriceList
             , tmpData.TotalPay            ::TFloat
             , tmpData.SummChangePercent   ::TFloat
             , tmpData.TotalChangePercent  ::TFloat
             , tmpData.TotalPayOth         ::TFloat

             , (tmpMI_Child.Amount_GRN  * ( CASE WHEN tmpData.MovementDescId = zc_Movement_ReturnIn() THEN (-1) ELSE 1 END))   :: TFloat AS TotalPay_Grn
             , (tmpMI_Child.Amount_USD  * ( CASE WHEN tmpData.MovementDescId = zc_Movement_ReturnIn() THEN (-1) ELSE 1 END))   :: TFloat AS TotalPay_USD
             , (tmpMI_Child.Amount_EUR  * ( CASE WHEN tmpData.MovementDescId = zc_Movement_ReturnIn() THEN (-1) ELSE 1 END))   :: TFloat AS TotalPay_EUR
             , (tmpMI_Child.Amount_Bank * ( CASE WHEN tmpData.MovementDescId = zc_Movement_ReturnIn() THEN (-1) ELSE 1 END))   :: TFloat AS TotalPay_Card

             , tmpData.TotalCountReturn    ::TFloat
             , tmpData.TotalReturn         ::TFloat
             , tmpData.TotalPayReturn      ::TFloat

               -- Сумма к оплате ГРН
             , CASE WHEN tmpData.MovementDescId = zc_Movement_Sale() THEN (zfCalc_SummPriceList (tmpData.Amount, tmpData.OperPriceList) - tmpData.TotalChangePercent) ELSE 0 END :: TFloat AS TotalSummToPay
               -- Сумма долга в продаже ГРН
             , CASE WHEN tmpData.MovementDescId = zc_Movement_Sale() THEN (zfCalc_SummPriceList (tmpData.Amount, tmpData.OperPriceList) - tmpData.TotalChangePercent - tmpData.TotalPay) ELSE 0 END :: TFloat AS TotalSummDebt
             
             , MovementDate_Insert.ValueData               AS InsertDate

        FROM tmpData
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
            LEFT JOIN MovementDesc AS MovementDesc_Sale ON MovementDesc_Sale.Id = tmpData.MovementDescId_Sale
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpData.GoodsId
            
            LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpData.PartionId  
             
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
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = tmpData.MovementId
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementId = tmpData.MovementId
;
 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 19.02.18         *
 04.07.17         *
*/

-- тест
-- select * from gpReport_SaleReturnIn (inStartDate := ('01.01.2017')::TDateTime , inEndDate := ('13.07.2017')::TDateTime , inUnitId := 506 ,  , inIsShowAll:= 'TRUE'::Boolean inSession := '2');