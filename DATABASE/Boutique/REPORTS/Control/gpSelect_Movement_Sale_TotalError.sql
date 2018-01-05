-- Function: gpSelect_Movement_Sale_TotalError()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_TotalError (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_TotalError(
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSummPay    TFloat
             , TotalSummChange TFloat
             , FromName        TVarChar
             , ToName          TVarChar
             , Comment         TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             
             , PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , CompositionGroupName       TVarChar
             , CompositionName            TVarChar
             , GoodsInfoName              TVarChar
             , LineFabricaName            TVarChar
             , LabelName                  TVarChar
             , GoodsSizeName              TVarChar
             , BrandName                  TVarChar
             , FabrikaName                TVarChar
             , PeriodName                 TVarChar
             , PeriodYear                 Integer
             , Amount                     TFloat
             , TotalPay                   TFloat
             , TotalPay_Calc              TFloat
             , TotalPayOth                TFloat
             , TotalPayOth_Calc           TFloat
             , TotalChangePercentPay      TFloat
             , TotalCountReturn           TFloat
             , TotalReturn                TFloat
             , TotalPayReturn             TFloat
             , TotalChangePercentPay_Calc TFloat
             , TotalCountReturn_Calc      TFloat
             , TotalReturn_Calc           TFloat
             , TotalPayReturn_Calc        TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpData AS (SELECT Movement.Id                                 AS MovementId
                           , Movement.InvNumber                          AS InvNumber
                           , Movement.OperDate                           AS OperDate
                           , Movement.StatusId                           AS StatusId
                           , MI_Master.Id                                AS MI_Id
                           , MI_Master.ObjectId                          AS GoodsId
                           , MI_Master.PartionId                         AS PartionId
                           , MI_Master.Amount                            AS Amount
                            
                           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay -- Дополнительная скидка в расчетах ГРН
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay              -- Итого оплата в продаже ГРН
                           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth           -- Итого оплата в расчетах ГРН
                           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      AS TotalCountReturn      -- Кол-во возврат
                           , COALESCE (MIFloat_TotalReturn.ValueData, 0)           AS TotalReturn           -- Сумма возврата ГРН
                           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        AS TotalPayReturn        -- Сумма возврата оплаты ГРН                           
                           
                           , CAST (COALESCE (SUM (MI_Child.Amount * CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_GRN() 
                                                                         THEN 1 
                                                                         ELSE MIFloat_CurrencyValue.ValueData / (CASE WHEN COALESCE(MIFloat_ParValue.ValueData, 1) <> 0 THEN COALESCE(MIFloat_ParValue.ValueData, 1) ELSE 1 END)
                                                                    END), 0) AS NUMERIC (16, 2)) AS TotalPay_Calc
                                                                    
                           , tmpOth.TotalPayOth                 AS TotalPayOth_Calc
                           , tmpOth.TotalChangePercentPay       AS TotalChangePercentPay_Calc
                           , tmpOth.TotalCountReturn            AS TotalCountReturn_Calc
                           , tmpOth.TotalReturn                 AS TotalReturn_Calc
                           , tmpOth.TotalPayReturn              AS TotalPayReturn_Calc
                       FROM Movement
                            -- мастер
                            INNER JOIN MovementItem AS MI_Master 
                                                    ON MI_Master.MovementId = Movement.Id
                                                   AND MI_Master.DescId     = zc_MI_Master()
                                                   AND MI_Master.isErased   = FALSE

                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                        ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                        ON MIFloat_TotalPayOth.MovementItemId = MI_Master.Id
                                                       AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth() 
                                                        
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                        ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Master.Id
                                                       AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                            LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                        ON MIFloat_TotalCountReturn.MovementItemId = MI_Master.Id
                                                       AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                            LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                        ON MIFloat_TotalReturn.MovementItemId = MI_Master.Id
                                                       AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()

                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                        ON MIFloat_TotalPayReturn.MovementItemId = MI_Master.Id
                                                       AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                                                       
                            --оплата / возвраты в др. документах
                            LEFT JOIN (SELECT  Object_PartionMI.ObjectCode      AS MI_Id
                                               -- Дополнительная скидка в расчетах ГРН
                                             , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN COALESCE (MIFloat_SummChangePercent.ValueData, 0) ELSE 0 END), 0) AS TotalChangePercentPay
                                               -- оплата в расчетах ГРН
                                             , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN COALESCE (MIFloat_TotalPay.ValueData, 0)  ELSE 0         END), 0) AS TotalPayOth
                                               -- Кол-во возврат
                                             , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()     THEN MovementItem.Amount                       ELSE 0         END), 0) AS TotalCountReturn
                                               -- Сумма возврата со скидкой (в ГРН)
                                             , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()     THEN zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData) - COALESCE (MIFloat_TotalChangePercent.ValueData, 0) ELSE 0 END), 0) AS TotalReturn
                                               -- Сумма возврата оплаты ГРН + Итого сумма возврата оплаты из Расчетов
                                             , COALESCE (SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()     THEN COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) ELSE 0 END), 0) AS TotalPayReturn
                                        FROM  Object AS Object_PartionMI
                                              INNER JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                                ON MILinkObject_PartionMI.ObjectId =  Object_PartionMI.Id
                                                                               AND MILinkObject_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                              INNER JOIN MovementItem ON MovementItem.Id       = MILinkObject_PartionMI.MovementItemId
                                                                     AND MovementItem.DescId   = zc_MI_Master()
                                                                     AND MovementItem.isErased = FALSE

                                              INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                 AND Movement.StatusId = zc_Enum_Status_Complete()

                                              LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                                          ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                                         AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                              LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                          ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                         AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                              LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                                          ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                                         AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                                              LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                          ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                         AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                              LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                                          ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                                         AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()

                                       WHERE /*Object_PartionMI.ObjectCode = inMovementItemId
                                         AND */Object_PartionMI.DescId     = zc_Object_PartionMI()
                                      ) AS tmpOth ON tmpOth.MI_Id = MI_Master.Id

                            -- чайлд
                            LEFT JOIN MovementItem AS MI_Child
                                                   ON MI_Child.MovementId = Movement.Id
                                                  AND MI_Child.ParentId   = MI_Master.Id
                                                  AND MI_Child.DescId     = zc_MI_Child()
                                                  AND MI_Child.isErased   = FALSE
                            
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MI_Child.Id
                                                            AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                                            
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MI_Child.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MI_Child.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                
                       WHERE Movement.DescId = zc_Movement_Sale()
                       GROUP BY Movement.Id
                           , Movement.InvNumber
                           , Movement.OperDate
                           , Movement.StatusId
                           , MI_Master.Id
                           , MI_Master.ObjectId
                           , MI_Master.PartionId
                           , MI_Master.Amount
                           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)
                           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)
                           , COALESCE (MIFloat_TotalReturn.ValueData, 0)
                           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                           , tmpOth.TotalPayOth
                           , tmpOth.TotalChangePercentPay
                           , tmpOth.TotalCountReturn
                           , tmpOth.TotalReturn
                           , tmpOth.TotalPayReturn
                           
                       HAVING (COALESCE (MIFloat_TotalPay.ValueData, 0) <> CAST (COALESCE (SUM (MI_Child.Amount * CASE WHEN MILinkObject_Currency.ObjectId = zc_Currency_GRN() 
                                                                                                         THEN 1 
                                                                                                         ELSE MIFloat_CurrencyValue.ValueData / (CASE WHEN COALESCE(MIFloat_ParValue.ValueData, 1) <> 0 THEN COALESCE(MIFloat_ParValue.ValueData, 1) ELSE 1 END)
                                                                                                    END), 0) AS NUMERIC (16, 2)))
                           OR (COALESCE (MIFloat_TotalPayOth.ValueData, 0)           <> tmpOth.TotalPayOth)
                           OR (COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) <> tmpOth.TotalChangePercentPay)
                           OR (COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      <> tmpOth.TotalCountReturn)
                           OR (COALESCE (MIFloat_TotalReturn.ValueData, 0)           <> tmpOth.TotalReturn)
                           OR (COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        <> tmpOth.TotalPayReturn)
                       )

       SELECT
             tmpData.MovementId                          AS Id
           , tmpData.InvNumber                           AS InvNumber
           , tmpData.OperDate                            AS OperDate
           , Object_Status.ObjectCode                    AS StatusCode
           , Object_Status.ValueData                     AS StatusName

           , MovementFloat_TotalSummPay.ValueData        AS TotalSummPay
           , MovementFloat_TotalSummChange.ValueData     AS TotalSummChange

           , Object_From.ValueData                       AS FromName
           , Object_To.ValueData                         AS ToName

           , MovementString_Comment.ValueData            AS Comment

           , Object_Insert.ValueData                     AS InsertName
           , MovementDate_Insert.ValueData               AS InsertDate
           
           --
           , tmpData.PartionId                           AS PartionId
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName
                                                   
           , Object_CompositionGroup.ValueData           AS CompositionGroupName  
           , Object_Composition.ValueData                AS CompositionName
           , Object_GoodsInfo.ValueData                  AS GoodsInfoName
           , Object_LineFabrica.ValueData                AS LineFabricaName
           , Object_Label.ValueData                      AS LabelName
           , Object_GoodsSize.ValueData                  AS GoodsSizeName 
           , Object_Brand.ValueData                      AS BrandName
           , Object_Fabrika.ValueData                    AS FabrikaName
           , Object_Period.ValueData                     AS PeriodName
           , Object_PartionGoods.PeriodYear    ::Integer AS PeriodYear
           
           , tmpData.Amount                    :: TFloat AS Amount
           , tmpData.TotalPay                  :: TFloat AS TotalPay
           , tmpData.TotalPay_Calc             :: TFloat AS TotalPay_Calc
           , tmpData.TotalPayOth               :: TFloat AS TotalPayOth
           , tmpData.TotalPayOth_Calc          :: TFloat AS TotalPayOth_Calc 

           , tmpData.TotalChangePercentPay     :: TFloat
           , tmpData.TotalCountReturn          :: TFloat
           , tmpData.TotalReturn               :: TFloat
           , tmpData.TotalPayReturn            :: TFloat
           
           , tmpData.TotalChangePercentPay_Calc :: TFloat
           , tmpData.TotalCountReturn_Calc      :: TFloat
           , tmpData.TotalReturn_Calc           :: TFloat
           , tmpData.TotalPayReturn_Calc        :: TFloat   
           
       FROM tmpData

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpData.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = tmpData.MovementId
                                   AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId = tmpData.MovementId
                                   AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = tmpData.MovementId
                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
            INNER JOIN Object AS Object_From ON Object_From.Id     = MovementLinkObject_From.ObjectId
                                            AND Object_From.DescId = zc_Object_Client()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = tmpData.MovementId
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = tmpData.MovementId
                                  AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
    
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = tmpData.MovementId
                                        AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = tmpData.MovementId
                                    AND MovementString_Comment.DescId     = zc_MovementString_Comment()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpData.PartionId                                 

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
            LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId
            
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()                   
            ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 04.01.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_TotalError (inSession:= zfCalc_UserAdmin())
