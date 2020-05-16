-- Function: gpSelect_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_GoodsAccount_ReturnIn (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_GoodsAccount_ReturnIn (
    IN inMovementId       Integer      , -- ключ Документа
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
             , GoodsSizeName TVarChar
             , Amount TFloat, Amount_ReturnIn TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
             , TotalSumm TFloat, TotalSummPriceList TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , TotalPay_ReturnIn TFloat
             , SummDebt TFloat
             , TotalChangePercent TFloat
             , TotalSummToPay TFloat
             , TotalPay_Grn TFloat, TotalPay_USD TFloat, TotalPay_Eur TFloat, TotalPay_Card TFloat
             , TotalPay TFloat, SummChangePercent TFloat
             , TotalPay_curr TFloat, SummChangePercent_curr TFloat
             
             , Amount_USD_Exc    TFloat
             , Amount_EUR_Exc    TFloat
             , Amount_GRN_Exc    TFloat
             
             , PartionMI_Id Integer
             , ReturnInMI_Id Integer, MovementId_ReturnIn Integer, InvNumber_ReturnIn_Full TVarChar, OperDate_ReturnIn TDatetime , DescName TVarChar
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbUnitId   Integer;
  DECLARE vbClientId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- данные из шапки
     SELECT MovementLinkObject_From.ObjectId AS isErased
          , MovementLinkObject_To.ObjectId   AS ClientId
            INTO vbUnitId, vbClientId
     FROM Movement 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;

     IF inShowAll THEN
     -- Результат такой
     RETURN QUERY 
     WITH 
     tmpMI_ReturnIn AS (--- возврат от покупателя
                        SELECT Movement.Id                                        AS MovementId
                             , Movement.DescId                                    AS DescId
                             , Movement.OperDate                                  AS OperDate
                             , Movement.InvNumber                                 AS InvNumber
                             , MI_Master.Id                                       AS MI_Id
                             , MI_Master.PartionId                                AS PartionId
                             , MI_Master.ObjectId                                 AS GoodsId
                             , MI_Master.Amount                                   AS Amount
                             , COALESCE (MIFloat_OperPrice.ValueData, 0)          AS OperPrice
                             , COALESCE (MIFloat_CountForPrice.ValueData, 1)      AS CountForPrice 
                             , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                             , COALESCE (MIFloat_CurrencyValue.ValueData, 1)      AS CurrencyValue
                             , COALESCE (MIFloat_ParValue.ValueData, 0)           AS ParValue
                             , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay
                             , COALESCE (MIFloat_TotalChangePercent.ValueData, 0) AS TotalChangePercent
                             , zfCalc_SummIn (MI_Master.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSumm
                             , zfCalc_SummPriceList (MI_Master.Amount, MIFloat_OperPriceList.ValueData)                       AS TotalSummPriceList

                             , CAST (zfCalc_SummPriceList (MI_Master.Amount, MIFloat_OperPriceList.ValueData) 
                                    - COALESCE (MIFloat_TotalChangePercent.ValueData, 0) AS TFloat) * (-1)   AS TotalSummToPay

                             , CAST (zfCalc_SummPriceList (MI_Master.Amount, MIFloat_OperPriceList.ValueData)
                                    - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                    - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                    - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                               AS TFloat)                                         AS SummDebt
                        FROM Movement 
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                          AND MovementLinkObject_From.ObjectId   = vbClientId
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                          AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                          AND MovementLinkObject_To.ObjectId   = vbUnitId

                             LEFT JOIN MovementItem AS MI_Master 
                                                    ON MI_Master.MovementId = Movement.Id
                                                   AND MI_Master.DescId     = zc_MI_Master()
                                                   AND MI_Master.isErased   = FALSE

                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MI_Master.Id
                                                        AND MIFloat_CountForPrice.DescId        = zc_MIFloat_CountForPrice()
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
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                         ON MIFloat_TotalPayOth.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth() 
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                         ON MIFloat_TotalChangePercent.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()   
                        WHERE Movement.DescId = zc_Movement_ReturnIn()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                      ) 
 
   , tmpMI_Master AS (SELECT MovementItem.Id                                       AS Id
                           , MovementItem.ObjectId                                 AS GoodsId
                           , MovementItem.PartionId                                AS PartionId
                           , MILinkObject_PartionMI.ObjectId                       AS PartionMI_Id
                           , Object_PartionMI.ObjectCode                           AS MI_Id_ReturnIn
                           , MovementItem.Amount                                   AS Amount
                           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                            --Итого сумма оплаты (в валюте)
                           , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)          AS TotalPay_curr
                            --Сумма дополнительной Скидки (в валюте)
                           , COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0) AS SummChangePercent_curr
                           , COALESCE (MIString_Comment.ValueData,'')              AS Comment
                           , MovementItem.isErased                                 AS isErased
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.isErased ORDER BY MovementItem.Id ASC) AS Ord
                           
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                                             
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                                        AND MIString_Comment.DescId         = zc_MIString_Comment()
                                                       
                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    

                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                                        ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                                        ON MIFloat_TotalPay_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay_curr()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                             ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                            LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                       )

          , tmpMI AS (SELECT COALESCE (tmpMI_Master.Id, 0)                                AS Id
                           , COALESCE (tmpMI_Master.GoodsId, tmpMI_ReturnIn.GoodsId)      AS GoodsId
                           , COALESCE (tmpMI_Master.PartionId, tmpMI_ReturnIn.PartionId)  AS PartionId
                           , COALESCE (tmpMI_Master.PartionMI_Id, 0)                      AS PartionMI_Id
                           , COALESCE (tmpMI_ReturnIn.MI_Id, tmpMI_Master.MI_Id_ReturnIn) AS MI_Id_ReturnIn
                           , tmpMI_ReturnIn.DescId                                        AS DescId_ReturnIn
                           , tmpMI_ReturnIn.OperDate                                      AS OperDate_ReturnIn
                           , tmpMI_ReturnIn.InvNumber                                     AS InvNumber_ReturnIn
                           , COALESCE (tmpMI_Master.Amount, 0)                            AS Amount
                           , COALESCE (tmpMI_ReturnIn.Amount, 0)                          AS Amount_ReturnIn
                           , COALESCE (tmpMI_ReturnIn.OperPrice, 0)                       AS OperPrice
                           , COALESCE (tmpMI_ReturnIn.CountForPrice, 1)                   AS CountForPrice 
                           , COALESCE (tmpMI_ReturnIn.OperPriceList, 0)                   AS OperPriceList
                           , COALESCE (tmpMI_ReturnIn.TotalSumm, 0)                       AS TotalSumm
                           , COALESCE (tmpMI_ReturnIn.TotalSummPriceList, 0)              AS TotalSummPriceList
                           , COALESCE (tmpMI_ReturnIn.CurrencyValue, 1)                   AS CurrencyValue
                           , COALESCE (tmpMI_ReturnIn.ParValue, 0)                        AS ParValue
                           , COALESCE (tmpMI_Master.SummChangePercent, 0)                 AS SummChangePercent
                           , COALESCE (tmpMI_ReturnIn.TotalSummToPay, 0)                  AS TotalSummToPay
                           , COALESCE (tmpMI_ReturnIn.TotalChangePercent, 0)              AS TotalChangePercent
                           , COALESCE (tmpMI_Master.TotalPay, 0)                          AS TotalPay
                           , COALESCE (tmpMI_Master.SummChangePercent_curr, 0)            AS SummChangePercent_curr
                           , COALESCE (tmpMI_Master.TotalPay_curr, 0)                     AS TotalPay_curr
                           , COALESCE (tmpMI_ReturnIn.TotalPay, 0)                        AS TotalPay_ReturnIn
                           , COALESCE (tmpMI_ReturnIn.SummDebt, 0)                        AS SummDebt
                           , COALESCE (tmpMI_Master.Comment, '')                          AS Comment
                           , COALESCE (tmpMI_Master.isErased, FALSE)                      AS isErased
                           , tmpMI_Master.Ord                                             AS Ord
                FROM tmpMI_ReturnIn
                     FULL JOIN tmpMI_Master ON tmpMI_Master.GoodsId        = tmpMI_ReturnIn.GoodsId
                                           AND tmpMI_Master.MI_Id_ReturnIn = tmpMI_ReturnIn.MI_Id  
                WHERE tmpMI_ReturnIn.SummDebt <> 0
                )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0)                                                                                                         AS ParentId
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- Расчетная сумма в грн для обмен
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END)                                                                                                                                   AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END)                                                 AS Amount_Bank
                           
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
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
                      GROUP BY MovementItem.ParentId
                      )

       -- результат
       SELECT
             tmpMI.Id                                    AS Id
           , tmpMI.PartionId                             AS PartionId
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

           , tmpMI.Amount                      :: TFloat AS Amount
           , tmpMI.Amount_ReturnIn             :: TFloat AS Amount_ReturnIn
           , tmpMI.OperPrice                   :: TFloat AS OperPrice
           , tmpMI.CountForPrice               :: TFloat AS CountForPrice
           , tmpMI.OperPriceList               :: TFloat AS OperPriceList

           , tmpMI.TotalSumm                   :: TFloat AS TotalSumm
           , tmpMI.TotalSummPriceList          :: TFloat AS TotalSummPriceList
                                           
           , tmpMI.CurrencyValue               :: TFloat AS CurrencyValue
           , tmpMI.ParValue                    :: TFloat AS ParValue
           , tmpMI.TotalPay_ReturnIn           :: TFloat AS TotalPay_ReturnIn
           , (tmpMI.SummDebt * (CASE WHEN Movement_ReturnIn.DescId = zc_Movement_ReturnIn() THEN 1 ELSE -1 END))  ::TFloat AS SummDebt
           , tmpMI.TotalChangePercent          :: TFloat AS TotalChangePercent
           , tmpMI.TotalSummToPay              :: TFloat AS TotalSummToPay

           , tmpMI_Child.Amount_GRN            :: TFloat AS TotalPay_Grn 
           , tmpMI_Child.Amount_USD            :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR            :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank           :: TFloat AS TotalPay_Card
           , tmpMI.TotalPay                    :: TFloat AS TotalPay
           , tmpMI.SummChangePercent           :: TFloat AS SummChangePercent

           , tmpMI.TotalPay_curr               :: TFloat
           , tmpMI.SummChangePercent_curr      :: TFloat

           , tmpMI_Child_Exc.Amount_USD        :: TFloat AS Amount_USD_Exc    -- Сумма USD - обмен приход
           , tmpMI_Child_Exc.Amount_EUR        :: TFloat AS Amount_EUR_Exc    -- Сумма EUR - обмен приход
           , tmpMI_Child_Exc.Amount_GRN        :: TFloat AS Amount_GRN_Exc    -- Сумма GRN - обмен расход

           , tmpMI.PartionMI_Id                          AS PartionMI_Id
           , COALESCE (MI_ReturnIn.Id, tmpMI.MI_Id_ReturnIn)                   AS MI_Id_ReturnIn
           , Movement_ReturnIn.Id                                              AS MovementId_ReturnIn
           , COALESCE (Movement_ReturnIn.InvNumber, tmpMI.InvNumber_ReturnIn)  AS InvNumber_ReturnIn_Full
           , COALESCE (Movement_ReturnIn.OperDate, tmpMI.OperDate_ReturnIn)    AS OperDate_ReturnIn
           , MovementDesc.ItemName                                             AS DescName 

           , tmpMI.Comment                    ::TVarChar AS Comment
           , tmpMI.isErased                              AS isErased

       FROM tmpMI
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id                    = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

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

           LEFT JOIN Object AS Object_PartionMI    ON Object_PartionMI.Id  = tmpMI.PartionMI_Id
           LEFT JOIN MovementItem AS MI_ReturnIn   ON MI_ReturnIn.Id       = Object_PartionMI.ObjectCode
           LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = MI_ReturnIn.MovementId
           LEFT JOIN MovementDesc                  ON MovementDesc.Id      = tmpMI.DescId_ReturnIn
       ;
     ELSE
     -- Результат такой
     RETURN QUERY 
     WITH 
     tmpMI_Master AS (SELECT MovementItem.Id                                       AS Id
                           , MovementItem.ObjectId                                 AS GoodsId
                           , MovementItem.PartionId                                AS PartionId
                           , MILinkObject_PartionMI.ObjectId                       AS PartionMI_Id
                           , MovementItem.Amount                                   AS Amount
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent
                            --Итого сумма оплаты (в валюте)
                           , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)          AS TotalPay_curr
                            --Сумма дополнительной Скидки (в валюте)
                           , COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0) AS SummChangePercent_curr
                           
                           , COALESCE (MIString_Comment.ValueData,'')              AS Comment
                           , MovementItem.isErased                                 AS isErased
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.isErased ORDER BY MovementItem.Id ASC) AS Ord
                           
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                                             
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                                        AND MIString_Comment.DescId         = zc_MIString_Comment()
                                                        
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                        ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()    

                            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                                        ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent_curr()
                            LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                                        ON MIFloat_TotalPay_curr.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay_curr()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                             ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                       )

    , tmpMI_Child AS (SELECT COALESCE (MovementItem.ParentId, 0)                                                                                                         AS ParentId
                           , SUM (CASE WHEN MovementItem.ParentId IS NULL
                                            -- Расчетная сумма в грн для обмен
                                            THEN -1 * zfCalc_CurrencyFrom (MovementItem.Amount, MIFloat_CurrencyValue.ValueData, MIFloat_ParValue.ValueData)
                                       WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN()
                                            THEN MovementItem.Amount
                                       ELSE 0
                                  END)                                                                                                                                   AS Amount_GRN
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MovementItem.Amount ELSE 0 END) AS Amount_USD
                           , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MovementItem.Amount ELSE 0 END) AS Amount_EUR
                           , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MovementItem.Amount ELSE 0 END)                                                 AS Amount_Bank
                           
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
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
                      GROUP BY MovementItem.ParentId
                      )


       -- результат
       SELECT
             tmpMI.Id                                                     AS Id
           , tmpMI.PartionId                                              AS PartionId
           , Object_Goods.Id                                              AS GoodsId
           , Object_Goods.ObjectCode                                      AS GoodsCode
           , Object_Goods.ValueData                                       AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData                  AS GoodsGroupNameFull
           , Object_Measure.ValueData                                     AS MeasureName
                                                                       
           , Object_CompositionGroup.ValueData                            AS CompositionGroupName  
           , Object_Composition.ValueData                                 AS CompositionName
           , Object_GoodsInfo.ValueData                                   AS GoodsInfoName
           , Object_LineFabrica.ValueData                                 AS LineFabricaName
           , Object_Label.ValueData                                       AS LabelName
           , Object_GoodsSize.ValueData                                   AS GoodsSizeName 

           , tmpMI.Amount                                       :: TFloat AS Amount
           , MI_ReturnIn.Amount                                 :: TFloat AS Amount_ReturnIn
           , COALESCE (MIFloat_OperPrice.ValueData, 0)          :: TFloat AS OperPrice
           , COALESCE (MIFloat_CountForPrice.ValueData, 1)      :: TFloat AS CountForPrice
           , COALESCE (MIFloat_OperPriceList.ValueData, 0)      :: TFloat AS OperPriceList
           , zfCalc_SummIn (MI_ReturnIn.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData) AS TotalSumm
           , zfCalc_SummPriceList (MI_ReturnIn.Amount, MIFloat_OperPriceList.ValueData)                       AS TotalSummPriceList 
           , COALESCE (MIFloat_CurrencyValue.ValueData, 1)      :: TFloat AS CurrencyValue
           , COALESCE (MIFloat_ParValue.ValueData, 0)           :: TFloat AS ParValue
           , CASE WHEN Movement_ReturnIn.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_TotalPay.ValueData, 0) ELSE 0 END        ::TFloat AS TotalPay_ReturnIn
 --          , CASE WHEN Movement_ReturnIn.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_TotalPayReturn.ValueData, 0) ELSE COALESCE (MIFloat_TotalPay.ValueData, 0) END  ::TFloat AS TotalPay_Return
           , CAST ((zfCalc_SummPriceList (MI_ReturnIn.Amount, MIFloat_OperPriceList.ValueData)
                    - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                    - COALESCE (MIFloat_TotalPay.ValueData, 0)
                    - COALESCE (MIFloat_TotalReturn.ValueData, 0))
                * (CASE WHEN Movement_ReturnIn.DescId = zc_Movement_ReturnIn() THEN 1 ELSE -1 END)
               AS TFloat)                                                 AS SummDebt         
           , COALESCE (MIFloat_TotalChangePercent.ValueData, 0) :: TFloat AS TotalChangePercent

           , CAST (zfCalc_SummPriceList (MI_ReturnIn.Amount, MIFloat_OperPriceList.ValueData) - COALESCE (MIFloat_TotalChangePercent.ValueData, 0) AS TFloat) AS TotalSummToPay

           , tmpMI_Child.Amount_GRN                             :: TFloat AS TotalPay_Grn 
           , tmpMI_Child.Amount_USD                             :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR                             :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank                            :: TFloat AS TotalPay_Card
           , tmpMI.TotalPay                                     :: TFloat AS TotalPay
           , tmpMI.SummChangePercent                            :: TFloat AS SummChangePercent

           , tmpMI.TotalPay_curr                                :: TFloat
           , tmpMI.SummChangePercent_curr                       :: TFloat

           , tmpMI_Child_Exc.Amount_USD                         :: TFloat AS Amount_USD_Exc    -- Сумма USD - обмен приход
           , tmpMI_Child_Exc.Amount_EUR                         :: TFloat AS Amount_EUR_Exc    -- Сумма EUR - обмен приход
           , tmpMI_Child_Exc.Amount_GRN                         :: TFloat AS Amount_GRN_Exc    -- Сумма GRN - обмен расход

           , tmpMI.PartionMI_Id                                           AS PartionMI_Id
           , MI_ReturnIn.Id                                               AS MI_Id_ReturnIn
           , Movement_ReturnIn.Id                                         AS MovementId_ReturnIn
           , Movement_ReturnIn.InvNumber                                  AS InvNumber_ReturnIn_Full
           , Movement_ReturnIn.OperDate                                   AS OperDate_ReturnIn
           , MovementDesc.ItemName                                        AS DescName 

           , tmpMI.Comment                                    :: TVarChar AS Comment
           , tmpMI.isErased                                               AS isErased

       FROM tmpMI_Master AS tmpMI
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE
                                                    
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id                    = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

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

           LEFT JOIN Object AS Object_PartionMI    ON Object_PartionMI.Id  = tmpMI.PartionMI_Id
           LEFT JOIN MovementItem AS MI_ReturnIn   ON MI_ReturnIn.Id       = Object_PartionMI.ObjectCode
           LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = MI_ReturnIn.MovementId
           LEFT JOIN MovementDesc                  ON MovementDesc.Id      = Movement_ReturnIn.DescId
           ----         
           LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                       ON MIFloat_CountForPrice.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
           LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                       ON MIFloat_OperPrice.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()    
           LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                       ON MIFloat_OperPriceList.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
           LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                       ON MIFloat_CurrencyValue.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
           LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                       ON MIFloat_ParValue.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue() 
           LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                       ON MIFloat_TotalPay.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
           LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                       ON MIFloat_TotalReturn.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()    
           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                       ON MIFloat_TotalPayReturn.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn() 
           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                       ON MIFloat_TotalChangePercent.MovementItemId = MI_ReturnIn.Id
                                      AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()   
       ;

       END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.05.20         *
 06.07.17         *
 18.05.17         *
*/

-- тест
--select * from gpSelect_MovementItem_GoodsAccount_ReturnIn (inMovementId := 35 , inStartDate := ('NULL')::TDateTime , inEndDate := ('NULL')::TDateTime , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '2');