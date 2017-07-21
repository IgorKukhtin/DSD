-- Function: gpSelect_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer,TDatetime, TDatetime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnIn(
    IN inMovementId       Integer      , -- ключ Документа
    IN inStartDate        TDatetime    , -- нач.дата периода продаж
    IN inEndDate          TDatetime    , -- кон.дата периода продаж
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , CompositionGroupName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , Amount TFloat, Amount_Sale TFloat, Amount_Return TFloat, Remains TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
             , TotalSumm TFloat
             , TotalSummBalance TFloat             
             , TotalSummPriceList TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , TotalChangePercent TFloat
             , TotalSummToPay TFloat, TotalSummPay_Sale TFloat
             , TotalPay_Grn TFloat, TotalPay_USD TFloat, TotalPay_Eur TFloat, TotalPay_Card TFloat
             , TotalPay TFloat, TotalPayOth TFloat

             , Amount_USD_Exc    TFloat
             , Amount_EUR_Exc    TFloat
             , Amount_GRN_Exc    TFloat
             
             , PartionMI_Id Integer, SaleMI_Id Integer, MovementId_Sale Integer, InvNumber_Sale_Full TVarChar
             , BarCode TVarChar
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbClientId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     -- данные из шапки
     SELECT Movement.OperDate
          , MovementLinkObject_To.ObjectId
          , MovementLinkObject_From.ObjectId
    INTO vbOperDate, vbUnitId, vbClientId
     FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


     IF inShowAll THEN
     -- Результат такой
     RETURN QUERY 
     WITH 
            tmpSale AS (SELECT Movement.Id          AS MovementId_Sale
                             , Movement.InvNumber   AS InvNumber_Sale
                        FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId = vbClientId
                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                         AND MovementLinkObject_From.ObjectId = vbUnitId
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                          AND Movement.DescId = zc_Movement_Sale()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        )

      ,  tmpMI_Sale AS (SELECT tmpSale.MovementId_Sale
                             , tmpSale.InvNumber_Sale
                             , MI_Master.Id         AS MI_Id
                             , MI_Master.PartionId  AS PartionId
                             , MI_Master.ObjectId   AS GoodsId
                             , MI_Master.Amount     AS Amount
                             , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                             , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice 
                             , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                             , COALESCE (MIFloat_CurrencyValue.ValueData, 0)   AS CurrencyValue
                             , COALESCE (MIFloat_ParValue.ValueData, 0)        AS ParValue
                             , COALESCE (MIFloat_TotalPay.ValueData, 0)        AS TotalPay
                             , COALESCE (MIFloat_TotalCountReturn.ValueData,0) AS TotalCountReturn
                        FROM tmpSale
                             LEFT JOIN MovementItem AS MI_Master 
                                                    ON MI_Master.MovementId = tmpSale.MovementId_Sale
                                                   AND MI_Master.DescId = zc_MI_Master()
                                                   AND MI_Master.isErased = False
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MI_Master.Id
                                                        AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                             LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                         ON MIFloat_OperPrice.MovementItemId = MI_Master.Id
                                                        AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()    
                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                         ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                             LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                         ON MIFloat_CurrencyValue.MovementItemId = MI_Master.Id
                                                        AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
                             LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                         ON MIFloat_ParValue.MovementItemId = MI_Master.Id
                                                        AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue() 
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                         ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay() 
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                         ON MIFloat_TotalCountReturn.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn() 
                        WHERE MI_Master.Amount - COALESCE (MIFloat_TotalCountReturn.ValueData,0) > 0
                      ) 
 
   , tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId                                 AS GoodsId
                           , MovementItem.PartionId
                           , MILinkObject_PartionMI.ObjectId                       AS PartionMI_Id
                           , Object_PartionMI.ObjectCode                           AS SaleMI_ID
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)             AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)         AS CountForPrice 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS OperPriceList
                           , COALESCE (MIFloat_CurrencyValue.ValueData, 0)         AS CurrencyValue
                           , COALESCE (MIFloat_ParValue.ValueData, 0)              AS ParValue
                           , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth
                           , MIString_BarCode.ValueData                            AS BarCode
                           , MIString_Comment.ValueData                            AS Comment
                           , MovementItem.isErased
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.isErased ORDER BY MovementItem.Id ASC) AS Ord
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased

                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()    
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue() 
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                        ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                        ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()    
                           
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                             ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                            LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId

                            LEFT JOIN MovementItemString AS MIString_BarCode
                                                         ON MIString_BarCode.MovementItemId = MovementItem.Id
                                                        AND MIString_BarCode.DescId         = zc_MIString_BarCode()
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                       )
                       
          , tmpMI AS (SELECT COALESCE (tmpMI_Master.Id,0) AS Id
                           , COALESCE (tmpMI_Master.GoodsId, tmpMI_Sale.GoodsId)     AS GoodsId
                           , COALESCE (tmpMI_Master.PartionId, tmpMI_Sale.PartionId) AS PartionId
                           , COALESCE (tmpMI_Master.PartionMI_Id, 0)                 AS PartionMI_Id
                           , COALESCE (tmpMI_Sale.MI_Id, tmpMI_Master.SaleMI_ID)     AS SaleMI_Id
                           , COALESCE (tmpMI_Master.Amount,0)                        AS Amount
                           , COALESCE (tmpMI_Sale.Amount,0)                          AS Amount_Sale
                           , COALESCE (tmpMI_Sale.TotalCountReturn,0)                AS TotalCountReturn
                           , COALESCE (tmpMI_Master.OperPrice, tmpMI_Sale.OperPrice) AS OperPrice
                           , COALESCE (tmpMI_Master.CountForPrice, tmpMI_Sale.CountForPrice) AS CountForPrice 
                           , COALESCE (tmpMI_Master.OperPriceList, tmpMI_Sale.OperPriceList) AS OperPriceList
                           , zfCalc_SummIn (tmpMI_Master.Amount,  COALESCE (tmpMI_Master.OperPrice, tmpMI_Sale.OperPrice), COALESCE (tmpMI_Master.CountForPrice, tmpMI_Sale.CountForPrice)) AS TotalSumm
                           , zfCalc_SummPriceList (tmpMI_Master.Amount,  COALESCE (tmpMI_Master.OperPriceList, tmpMI_Sale.OperPriceList))                                                   AS TotalSummPriceList
                           , COALESCE (tmpMI_Master.CurrencyValue, tmpMI_Sale.CurrencyValue) AS CurrencyValue
                           , COALESCE (tmpMI_Master.ParValue, tmpMI_Sale.ParValue)           AS ParValue
                           , COALESCE (tmpMI_Master.TotalChangePercent, 0)    AS TotalChangePercent
                           , COALESCE (tmpMI_Master.TotalPay, 0)              AS TotalPay
                           , COALESCE (tmpMI_Sale.TotalPay, 0)                AS TotalSummPay_Sale
                           , COALESCE (tmpMI_Master.TotalPayOth, 0)           AS TotalPayOth
                           , COALESCE (tmpMI_Master.isErased, False)          AS isErased

                           , CAST (zfCalc_SummPriceList (tmpMI_Master.Amount,  COALESCE (tmpMI_Master.OperPriceList, tmpMI_Sale.OperPriceList))  - COALESCE (tmpMI_Master.TotalChangePercent, 0)
                             AS TFloat)                                       AS TotalSummToPay
                           , tmpMI_Master.BarCode
                           , tmpMI_Master.Comment
                           , tmpMI_Master.Ord

                FROM tmpMI_Sale
                     FULL JOIN tmpMI_Master ON tmpMI_Master.GoodsId = tmpMI_Sale.GoodsId
                                           AND tmpMI_Master.SaleMI_ID = tmpMI_Sale.MI_Id  -- уточнить правильную связь
                )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0) AS ParentId
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
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      GROUP BY MovementItem.ParentId
                      )

       -- результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData       AS MeasureName

           , Object_CompositionGroup.ValueData   AS CompositionGroupName  
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.Id            AS GoodsSizeId
           , Object_GoodsSize.ValueData     AS GoodsSizeName 

           , tmpMI.Amount            ::TFloat
           , tmpMI.Amount_Sale       ::TFloat
           , tmpMI.TotalCountReturn  ::TFloat AS Amount_Return
           , Container.Amount        ::TFloat AS Remains

           , tmpMI.OperPrice         ::TFloat
           , tmpMI.CountForPrice     ::TFloat
           , tmpMI.OperPriceList     ::TFloat

           , tmpMI.TotalSumm         ::TFloat
           , zfCalc_CurrencyFrom (tmpMI.TotalSumm, tmpMI.CurrencyValue, tmpMI.ParValue) :: TFloat AS TotalSummBalance
           , tmpMI.TotalSummPriceList       ::TFloat

           , tmpMI.CurrencyValue            ::TFloat
           , tmpMI.ParValue                 ::TFloat
           , tmpMI.TotalChangePercent       ::TFloat

           , CASE WHEN tmpMI.TotalSummToPay > tmpMI.TotalSummPay_Sale
                  THEN tmpMI.TotalSummPay_Sale
                  ELSE tmpMI.TotalSummToPay
             END                            ::TFloat AS TotalSummToPay

           , tmpMI.TotalSummPay_Sale        ::TFloat 

           , tmpMI_Child.Amount_GRN         ::TFloat AS TotalPay_Grn 
           , tmpMI_Child.Amount_USD         ::TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR         ::TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank        ::TFloat AS TotalPay_Card
           , tmpMI.TotalPay                 ::TFloat
           , tmpMI.TotalPayOth              ::TFloat

           , tmpMI_Child_Exc.Amount_USD     :: TFloat AS Amount_USD_Exc    -- Сумма USD - обмен приход
           , tmpMI_Child_Exc.Amount_EUR     :: TFloat AS Amount_EUR_Exc    -- Сумма EUR - обмен приход
           , tmpMI_Child_Exc.Amount_GRN     :: TFloat AS Amount_GRN_Exc    -- Сумма GRN - обмен расход

           , tmpMI.PartionMI_Id
           , COALESCE (MI_Sale.Id, tmpMI.SaleMI_Id)  AS SaleMI_Id
           , Movement_Sale.Id                        AS MovementId_Sale
           , Movement_Sale.InvNumber                 AS InvNumber_Sale_Full
           , tmpMI.BarCode                  ::TVarChar
           , tmpMI.Comment                  ::TVarChar
           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Container ON Container.PartionId     = tmpMI.PartionId
                               AND Container.WhereObjectId = vbUnitId
                               AND Container.DescId        = zc_Container_count()
                               
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE
                                                                
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

           LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = tmpMI.PartionMI_Id
           LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
           LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId
       ;
     ELSE
     -- Результат такой
     RETURN QUERY 
     WITH 
     tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId                                 AS GoodsId
                           , MovementItem.PartionId
                           , MILinkObject_PartionMI.ObjectId                       AS PartionMI_Id
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)             AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)         AS CountForPrice 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)         AS OperPriceList
                           , zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSumm
                           , zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)                       AS TotalSummPriceList
                           , COALESCE (MIFloat_CurrencyValue.ValueData, 0)         AS CurrencyValue
                           , COALESCE (MIFloat_ParValue.ValueData, 0)              AS ParValue
                           , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth
                          
                           , CAST ((CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 1) <> 0
                                         THEN CAST (COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_OperPriceList.ValueData, 0) / COALESCE (MIFloat_CountForPrice.ValueData, 1) AS NUMERIC (16, 2))
                                         ELSE CAST (COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 2))
                                    END) - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                             AS TFloat) AS TotalSummToPay
                           , MIString_BarCode.ValueData                            AS BarCode
                           , COALESCE (MIString_Comment.ValueData,'')              AS Comment
                           , MovementItem.isErased
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.isErased ORDER BY MovementItem.Id ASC) AS Ord
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased

                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()    
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue() 
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                        ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                        ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()    
                           
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                             ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_PartionMI.DescId = zc_MILinkObject_PartionMI()

                            LEFT JOIN MovementItemString AS MIString_BarCode
                                                         ON MIString_BarCode.MovementItemId = MovementItem.Id
                                                        AND MIString_BarCode.DescId         = zc_MIString_BarCode()
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                       )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0) AS ParentId
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
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                      GROUP BY MovementItem.ParentId
                      )

       -- результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData       AS MeasureName

           , Object_CompositionGroup.ValueData   AS CompositionGroupName  
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.Id            AS GoodsSizeId
           , Object_GoodsSize.ValueData     AS GoodsSizeName 

           , tmpMI.Amount                   ::TFloat
           , MI_Sale.Amount                 ::TFloat
           , COALESCE (MIFloat_TotalCountReturn.ValueData,0) ::TFloat  AS Amount_Return
           , Container.Amount               ::TFloat AS Remains

           , tmpMI.OperPrice                ::TFloat
           , tmpMI.CountForPrice            ::TFloat
           , tmpMI.OperPriceList            ::TFloat

           , tmpMI.TotalSumm                ::TFloat
           , zfCalc_CurrencyFrom (tmpMI.TotalSumm, tmpMI.CurrencyValue, tmpMI.ParValue) :: TFloat AS TotalSummBalance
           , tmpMI.TotalSummPriceList       ::TFloat

           , tmpMI.CurrencyValue            ::TFloat
           , tmpMI.ParValue                 ::TFloat
           , tmpMI.TotalChangePercent       ::TFloat

           , CASE WHEN tmpMI.TotalSummToPay > COALESCE (MIFloat_TotalPay.ValueData, 0) 
                  THEN COALESCE (MIFloat_TotalPay.ValueData, 0)
                  ELSE tmpMI.TotalSummToPay
             END                            ::TFloat AS TotalSummToPay

           , COALESCE (MIFloat_TotalPay.ValueData, 0)    ::TFloat  AS TotalSummPay_Sale

           , tmpMI_Child.Amount_GRN         ::TFloat AS TotalPay_Grn 
           , tmpMI_Child.Amount_USD         ::TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR         ::TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank        ::TFloat AS TotalPay_Card
           , tmpMI.TotalPay                 ::TFloat
           , tmpMI.TotalPayOth              ::TFloat

           , tmpMI_Child_Exc.Amount_USD     :: TFloat AS Amount_USD_Exc    -- Сумма USD - обмен приход
           , tmpMI_Child_Exc.Amount_EUR     :: TFloat AS Amount_EUR_Exc    -- Сумма EUR - обмен приход
           , tmpMI_Child_Exc.Amount_GRN     :: TFloat AS Amount_GRN_Exc    -- Сумма GRN - обмен расход

           , tmpMI.PartionMI_Id
           , MI_Sale.Id                     AS SaleMI_Id
           , Movement_Sale.Id               AS MovementId_Sale
           , Movement_Sale.InvNumber        AS InvNumber_Sale_Full
           , tmpMI.BarCode                  ::TVarChar
           , tmpMI.Comment                  ::TVarChar
           , tmpMI.isErased

       FROM tmpMI_Master AS tmpMI
            LEFT JOIN Container ON Container.PartionId     = tmpMI.PartionId
                               AND Container.WhereObjectId = vbUnitId
                               AND Container.DescId        = zc_Container_count()
                               
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = tmpMI.PartionMI_Id
            LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode

            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                        ON MIFloat_TotalPay.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalPay.DescId = zc_MIFloat_TotalPay()

            LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                        ON MIFloat_TotalCountReturn.MovementItemId = MI_Sale.Id
                                       AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn() 
                                                        
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId

         ;

       END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.06.17         *
 15.05.17         *
*/

-- тест
-- select * from gpSelect_MovementItem_ReturnIn(inMovementId := 7 , inIsErased := 'False' ,  inSession := '2');