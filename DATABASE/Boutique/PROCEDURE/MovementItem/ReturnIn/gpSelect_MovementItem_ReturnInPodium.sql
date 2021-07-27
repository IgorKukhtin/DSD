-- Function: gpSelect_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, TDatetime, TDatetime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Integer, Integer, TDatetime, TDatetime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnIn(
    IN inMovementId       Integer      , -- ключ Документа
    IN inUnitId           Integer      , --
    IN inClientId         Integer      , --
    IN inStartDate        TDatetime    , -- нач.дата периода продаж
    IN inEndDate          TDatetime    , -- кон.дата периода продаж
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer, isLine TVarChar, PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, NameFull TVarChar, MeasureName TVarChar
             , CompositionGroupName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , BrandName    TVarChar
             , PeriodName   TVarChar
             , PeriodYear   Integer
             , Amount TFloat, AmountPartner TFloat, Amount_Sale TFloat, Remains TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat, OperPriceList_curr TFloat
               -- Итого сумма вх. + прайс (в прод.)
             , TotalSumm TFloat, TotalSummBalance TFloat, TotalSummPriceList TFloat
               -- Итого сумма вх. + прайс (текущий возврат)
             , TotalSumm_return TFloat, TotalSummBalance_return TFloat, TotalSummPriceList_return TFloat

               -- Курс для перевода из валюты партии в ГРН
             , CurrencyValue TFloat, ParValue TFloat

               -- Итого сумма оплаты - для "текущего" документа Продажи
             , TotalPay_Sale TFloat
               -- Итого сумма оплаты - все "Расчеты покупателей"
             , TotalPayOth_Sale TFloat

               -- возвраты
             , Amount_Return TFloat, TotalReturn TFloat, TotalPay_Return TFloat
               -- долг
             , SummDebt TFloat
               -- % Скидки
             , ChangePercent TFloat
             , ChangePercentNext TFloat
               -- Итого сумма Скидки - для "текущего" документа Продажи: 2)дополнительная
             , SummChangePercent_sale TFloat
               -- Итого сумма Скидки - для "текущего" документа Продажи: 1)по %скидки
             , TotalChangePercent_sale TFloat
               -- Итого сумма Скидки - все "Расчеты покупателей"
             , TotalChangePercentPay TFloat

             , TotalSummToPay TFloat

             , TotalChangePercent_curr TFloat
             , TotalPay_curr           TFloat
             , TotalPayOth_curr        TFloat

             , TotalPay_Grn TFloat, TotalPay_USD TFloat, TotalPay_Eur TFloat, TotalPay_Card TFloat
             , TotalPay TFloat, TotalPayOth TFloat, TotalChangePercent TFloat

             , Amount_USD_Exc    TFloat
             , Amount_EUR_Exc    TFloat
             , Amount_GRN_Exc    TFloat

             , SaleMI_Id Integer
             , MovementId_Sale Integer, InvNumber_Sale TVarChar
             , OperDate_Sale TDateTime, InsertDate_Sale TDateTime
             , DescName     TVarChar
             , isOffer      Boolean
             , Comment      TVarChar
             , isErased     Boolean
             , isChecked    Boolean
             , ContainerId  Integer
             , CurrencyName_pl TVarChar
              )
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbStatusId    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     -- Параметры документа
     SELECT Movement.StatusId                AS StatusId
            INTO vbStatusId
     FROM Movement
     WHERE Movement.Id = inMovementId;

     IF inShowAll = TRUE
     THEN
     -- Результат такой
     RETURN QUERY
     WITH
         tmpMI_Sale AS (-- продажа покупателю
                        SELECT Movement.Id                                        AS MovementId
                             , Movement.DescId                                    AS DescId
                             , Movement.OperDate                                  AS OperDate
                             , MovementDate_Insert.ValueData                      AS InsertDate_Sale
                             , Movement.InvNumber                                 AS InvNumber
                             , MovementItem.Id                                    AS SaleMI_Id
                             , MovementItem.PartionId                             AS PartionId
                             , MovementItem.ObjectId                              AS GoodsId
                             , MovementItem.Amount                                AS Amount
                               -- Цена по прайсу, без скидки - в ГРН
                             , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                               -- Цена по прайсу, без скидки - в валюте
                             , COALESCE (MIFloat_OperPriceList_curr.ValueData, 0) AS OperPriceList_curr
                               -- Итого сумма оплаты - для "текущего" документа Продажи
                             , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay
                               -- Итого сумма оплаты - все "Расчеты покупателей"
                             , COALESCE (MIFloat_TotalPayOth.ValueData, 0)        AS TotalPayOth

                               -- Итого количество возврата - все док-ты
                             , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)   AS Amount_Return
                               -- Итого сумма возврата со скидкой  - все док-ты
                             , COALESCE (MIFloat_TotalReturn.ValueData, 0)        AS TotalReturn
                               -- Итого сумма возврата оплаты - все док-ты
                             , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)     AS TotalPayReturn

                               -- Итого сумма Скидки - для "текущего" документа Продажи: 1)по %скидки + 2)дополнительная
                             , COALESCE (MIFloat_TotalChangePercent.ValueData, 0) AS TotalChangePercent
                               -- Итого сумма Скидки - все "Расчеты покупателей"
                             , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)   AS TotalChangePercentPay

                             , COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0) AS TotalChangePercent_curr
                             , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)           AS TotalPay_curr
                             , COALESCE (MIFloat_TotalPayOth_curr.ValueData, 0)        AS TotalPayOth_curr

                             , COALESCE (MIBoolean_Checked.ValueData, FALSE)           AS isChecked

                              -- валюта оригинальной цены, без скидки (из продажи)
                             , Object_Currency_pl.ValueData                            AS CurrencyName_pl
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                                          AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                          AND MovementLinkObject_To.ObjectId   = inClientId
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                          AND MovementLinkObject_From.ObjectId   = inUnitId

                             LEFT JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert() 

                             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                         ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                                         ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                                        AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                         ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                         ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                         ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                         ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                         ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                         ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                         ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_curr
                                                         ON MIFloat_TotalChangePercent_curr.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercent_curr.DescId         = zc_MIFloat_TotalChangePercent_curr()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                                         ON MIFloat_TotalPay_curr.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay_curr()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth_curr
                                                         ON MIFloat_TotalPayOth_curr.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayOth_curr.DescId         = zc_MIFloat_TotalPayOth_curr()

                             -- возврат > 31 д.
                             LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                           ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                                         AND MIBoolean_Checked.DescId         = zc_MIBoolean_Checked()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency_pl
                                                              ON MILinkObject_Currency_pl.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Currency_pl.DescId         = zc_MILinkObject_Currency_pl()
                             LEFT JOIN Object AS Object_Currency_pl ON Object_Currency_pl.Id = COALESCE (MILinkObject_Currency_pl.ObjectId, zc_Currency_Basis())
           
                        WHERE Movement.DescId   = zc_Movement_Sale()
                          -- !!!ВРЕМЕННО - потом оставить только ПРОВЕДЕННЫЕ!!!
                          -- AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          -- ЗА ПЕРИОД
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          -- если ЕСТЬ долг
                          AND MovementItem.Amount > COALESCE (MIFloat_TotalCountReturn.ValueData, 0)
                       )

     , tmpMI_Master AS (SELECT MI_Master.Id                                              AS MovementItemId
                             , ROW_NUMBER() OVER (ORDER BY CASE WHEN MI_Master.isErased = FALSE AND MI_Master.Amount > 0 THEN 0 ELSE 1 END ASC, MI_Master.Id ASC) AS LineNum
                             , MI_Master.PartionId                                       AS PartionId
                             , MI_Master.ObjectId                                        AS GoodsId
                             , MI_Master.Amount                                          AS Amount_master
                             , COALESCE (MIFloat_AmountPartner.ValueData,0)              AS AmountPartner_master
                             , COALESCE (MIFloat_TotalChangePercent_master.ValueData, 0) AS TotalChangePercent_master
                             , COALESCE (MIFloat_TotalPay_master.ValueData, 0)           AS TotalPay_master
                             , COALESCE (MIFloat_TotalPayOth_master.ValueData, 0)        AS TotalPayOth_master
                             , COALESCE (MIString_Comment_master.ValueData,'')           AS Comment_master
                             , MI_Master.isErased                                        AS isErased
                             , COALESCE (MIBoolean_Checked.ValueData, FALSE)             AS isChecked
                             , ROW_NUMBER() OVER (PARTITION BY MI_Master.isErased ORDER BY MI_Master.Id ASC) AS Ord

                             , Movement.Id                                        AS MovementId
                             , Movement.DescId                                    AS DescId
                             , Movement.OperDate                                  AS OperDate
                             , MovementDate_Insert.ValueData                      AS InsertDate_Sale
                             , Movement.InvNumber                                 AS InvNumber
                             , Object_PartionMI.ObjectCode                        AS SaleMI_ID
                             , MovementItem.Amount                                AS Amount_Sale
                             , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                             , COALESCE (MIFloat_OperPriceList_curr.ValueData, 0) AS OperPriceList_curr

                               -- Итого сумма оплаты - для "текущего" документа Продажи
                             , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay
                               -- Итого сумма оплаты - все "Расчеты покупателей"
                             , COALESCE (MIFloat_TotalPayOth.ValueData, 0)        AS TotalPayOth

                               -- Итого количество возврата - все док-ты
                             , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)   AS Amount_Return
                               -- Итого сумма возврата со скидкой  - все док-ты
                             , COALESCE (MIFloat_TotalReturn.ValueData, 0)        AS TotalReturn
                               -- Итого сумма возврата оплаты - все док-ты
                             , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)     AS TotalPayReturn

                               -- Итого сумма Скидки - для "текущего" документа Продажи: 1)по %скидки + 2)дополнительная
                             , COALESCE (MIFloat_TotalChangePercent.ValueData, 0) AS TotalChangePercent
                               -- Итого сумма Скидки - все "Расчеты покупателей"
                             , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay
                             
                             , COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0)    AS TotalChangePercent_curr
                             , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)              AS TotalPay_curr
                             , COALESCE (MIFloat_TotalPayOth_curr.ValueData, 0)           AS TotalPayOth_curr
                        
                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             JOIN MovementItem AS MI_Master
                                               ON MI_Master.MovementId = inMovementId
                                              AND MI_Master.DescId     = zc_MI_Master()
                                              AND MI_Master.isErased   = tmpIsErased.isErased

                             LEFT JOIN MovementItemString AS MIString_Comment_master
                                                          ON MIString_Comment_master.MovementItemId = MI_Master.Id
                                                         AND MIString_Comment_master.DescId         = zc_MIString_Comment()

                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MI_Master.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()

                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                         ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                                         ON MIFloat_OperPriceList_curr.MovementItemId = MI_Master.Id
                                                        AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_master
                                                         ON MIFloat_TotalChangePercent_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalChangePercent_master.DescId         = zc_MIFloat_TotalChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_master
                                                         ON MIFloat_TotalPay_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay_master.DescId         = zc_MIFloat_TotalPay()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth_master
                                                         ON MIFloat_TotalPayOth_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPayOth_master.DescId         = zc_MIFloat_TotalPayOth()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_curr
                                                         ON MIFloat_TotalChangePercent_curr.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalChangePercent_curr.DescId         = zc_MIFloat_TotalChangePercent_curr()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                                         ON MIFloat_TotalPay_curr.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay_curr()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth_curr
                                                         ON MIFloat_TotalPayOth_curr.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPayOth_curr.DescId         = zc_MIFloat_TotalPayOth_curr()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                              ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                             AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                             LEFT JOIN MovementItem ON MovementItem.Id = Object_PartionMI.ObjectCode
                             LEFT JOIN Movement     ON Movement.Id     = MovementItem.MovementId

                             LEFT JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert() 

                             -- возврат > 31 д.
                             LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                           ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                                          AND MIBoolean_Checked.DescId         = zc_MIBoolean_Checked()
                                                         
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                         ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                         ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                         ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                         ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                         ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                         ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                         ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                       )

            , tmpMI AS (SELECT COALESCE (tmpMI_Master.MovementItemId, 0)               AS Id
                             , COALESCE (tmpMI_Master.LineNum, 0)                      AS LineNum
                             , COALESCE (tmpMI_Master.PartionId, tmpMI_Sale.PartionId) AS PartionId
                             , COALESCE (tmpMI_Master.GoodsId, tmpMI_Sale.GoodsId)     AS GoodsId
                             , COALESCE (tmpMI_Master.Amount_master, 0)                AS Amount
                             , COALESCE (tmpMI_Master.AmountPartner_master,0)          AS AmountPartner
                             , COALESCE (tmpMI_Master.TotalChangePercent_master, 0)    AS TotalChangePercent
                             , COALESCE (tmpMI_Master.TotalPay_master, 0)              AS TotalPay
                             , COALESCE (tmpMI_Master.TotalPayOth_master, 0)           AS TotalPayOth
                             , COALESCE (tmpMI_Master.Comment_master, '')              AS Comment
                             , COALESCE (tmpMI_Master.isErased, FALSE)                 AS isErased
                             , COALESCE (tmpMI_Master.isChecked, tmpMI_Sale.isChecked, FALSE)    AS isChecked
                             , COALESCE (tmpMI_Master.Ord, 0)                          AS Ord

                             , COALESCE (tmpMI_Master.MovementId, tmpMI_Sale.MovementId)         AS MovementId_Sale
                             , COALESCE (tmpMI_Master.DescId, tmpMI_Sale.DescId)                 AS DescId_Sale
                             , COALESCE (tmpMI_Master.OperDate, tmpMI_Sale.OperDate)             AS OperDate_Sale
                             , COALESCE (tmpMI_Master.InsertDate_Sale, tmpMI_Sale.InsertDate_Sale) AS InsertDate_Sale
                             , COALESCE (tmpMI_Master.InvNumber, tmpMI_Sale.InvNumber)           AS InvNumber_Sale
                             , COALESCE (tmpMI_Master.SaleMI_ID, tmpMI_Sale.SaleMI_ID)           AS SaleMI_Id
                             , COALESCE (tmpMI_Master.Amount_Sale, tmpMI_Sale.Amount, 0)         AS Amount_Sale
                             , COALESCE (tmpMI_Master.OperPriceList, tmpMI_Sale.OperPriceList)   AS OperPriceList
                             , COALESCE (tmpMI_Master.OperPriceList_curr, tmpMI_Sale.OperPriceList_curr) AS OperPriceList_curr

                             , COALESCE (tmpMI_Master.TotalPay, tmpMI_Sale.TotalPay)             AS TotalPay_Sale
                             , COALESCE (tmpMI_Master.TotalPayOth, tmpMI_Sale.TotalPayOth)       AS TotalPayOth_Sale

                             , COALESCE (tmpMI_Master.Amount_Return, tmpMI_Sale.Amount_Return)   AS Amount_Return
                             , COALESCE (tmpMI_Master.TotalReturn, tmpMI_Sale.TotalReturn)       AS TotalReturn
                             , COALESCE (tmpMI_Master.TotalPayReturn, tmpMI_Sale.TotalPayReturn) AS TotalPay_Return

                               -- Итого сумма Скидки - для "текущего" документа Продажи: 1)по %скидки + 2)дополнительная
                             , COALESCE (tmpMI_Master.TotalChangePercent, tmpMI_Sale.TotalChangePercent)       AS TotalChangePercent_Sale
                               -- Итого сумма Скидки - все "Расчеты покупателей"
                             , COALESCE (tmpMI_Master.TotalChangePercentPay, tmpMI_Sale.TotalChangePercentPay) AS TotalChangePercentPay_Sale
                             
                             , COALESCE (tmpMI_Master.TotalChangePercent_curr, tmpMI_Sale.TotalChangePercent_curr) AS TotalChangePercent_curr
                             , COALESCE (tmpMI_Master.TotalPay_curr, tmpMI_Sale.TotalPay_curr)                     AS TotalPay_curr
                             , COALESCE (tmpMI_Master.TotalPayOth_curr, tmpMI_Sale.TotalPayOth_curr)               AS TotalPayOth_curr
                           
                             , COALESCE (tmpMI_Sale.CurrencyName_pl, Null) :: TVarChar                             AS CurrencyName_pl

                  FROM tmpMI_Master
                       FULL JOIN tmpMI_Sale ON tmpMI_Sale.SaleMI_Id = tmpMI_Master.SaleMI_Id  -- ТОЛЬКО по партии
                                             -- AND tmpMI_Sale.GoodsId   = tmpMI_Master.GoodsId
                  -- WHERE tmpMI_Sale.SummDebt <> 0 OR tmpMI_Master.SaleMI_Id > 0
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
   , tmpContainer AS (SELECT DISTINCT Container.*, CLO_GoodsSize.ObjectId AS GoodsSizeId
                      FROM tmpMI AS tmpMI_Master
                           INNER JOIN Container ON Container.PartionId     = tmpMI_Master.PartionId
                                               AND Container.WhereObjectId = inUnitId
                                               AND Container.DescId        = zc_Container_count()
                                               -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                               AND Container.ObjectId      = tmpMI_Master.GoodsId
                                               -- !!!обязательно условие, т.к. мог меняться GoodsSizeId и тогда в Container - несколько строк!!!
                                               AND Container.Amount        <> 0
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                           LEFT JOIN ContainerLinkObject AS CLO_GoodsSize
                                                         ON CLO_GoodsSize.ContainerId = Container.Id
                                                        AND CLO_GoodsSize.DescId      = zc_ContainerLinkObject_GoodsSize()
                      WHERE CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                     )

       -- результат
       SELECT
             tmpMI.Id                         :: Integer AS Id
           , CASE WHEN tmpMI.isErased = FALSE AND tmpMI.Amount > 0 THEN tmpMI.LineNum ELSE NULL END :: Integer  AS LineNum
           , CASE WHEN tmpMI.isErased = FALSE AND tmpMI.Amount > 0 THEN '*'           ELSE '_'  END :: TVarChar AS isLine
           , tmpMI.PartionId                  :: Integer AS PartionId
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , (COALESCE (ObjectString_GoodsGroupFull.ValueData, '') || ' - ' || COALESCE (Object_GoodsInfo.ValueData, '')) :: TVarChar AS NameFull
           , Object_Measure.ValueData                    AS MeasureName

           , Object_CompositionGroup.ValueData           AS CompositionGroupName
           , Object_Composition.ValueData                AS CompositionName
           , Object_GoodsInfo.ValueData                  AS GoodsInfoName
           , Object_LineFabrica.ValueData                AS LineFabricaName
           , Object_Label.ValueData                      AS LabelName
           , Object_GoodsSize.Id                         AS GoodsSizeId
           , Object_GoodsSize.ValueData                  AS GoodsSizeName

           , Object_Brand.ValueData                      AS BrandName
           , Object_Period.ValueData                     AS PeriodName
           , Object_PartionGoods.PeriodYear              AS PeriodYear

           , tmpMI.Amount                      :: TFloat AS Amount
           , tmpMI.AmountPartner               :: TFloat AS AmountPartner
           , tmpMI.Amount_Sale                 :: TFloat AS Amount_Sale
           , Container.Amount                  :: TFloat AS Remains
           , 0                                 :: TFloat AS OperPrice
           , 0                                 :: TFloat AS CountForPrice
           , tmpMI.OperPriceList               :: TFloat AS OperPriceList
           , tmpMI.OperPriceList_curr          :: TFloat AS OperPriceList_curr

             -- Итого сумма (в прод.)
           , 0                                 :: TFloat AS TotalSumm
           , 0                                 :: TFloat AS TotalSummBalance
           , zfCalc_SummPriceList (tmpMI.Amount_Sale, tmpMI.OperPriceList) AS TotalSummPriceList

             -- Итого сумма (текущий возврат)
           , 0                                 :: TFloat AS TotalSumm_return
           , 0                                 :: TFloat AS TotalSummBalance_return
           , zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList) AS TotalSummPriceList_return

             -- Курс для перевода из валюты партии в ГРН - элемент продажи
           , 0 :: TFloat AS CurrencyValue
           , 0 :: TFloat AS ParValue

             -- Итого сумма оплаты - для "текущего" документа Продажи
           , tmpMI.TotalPay_Sale               :: TFloat AS TotalPay_Sale
             -- Итого сумма оплаты - все "Расчеты покупателей"
           , tmpMI.TotalPayOth_Sale            :: TFloat AS TotalPayOth_Sale

             -- Итого количество возврата - все док-ты
           , tmpMI.Amount_Return               :: TFloat AS Amount_Return
             -- Итого сумма возврата со скидкой  - все док-ты
           , tmpMI.TotalReturn                 :: TFloat AS TotalReturn
             -- Итого сумма возврата оплаты - все док-ты
           , tmpMI.TotalPay_Return             :: TFloat AS TotalPay_Return

             -- Сумма долга
           , (zfCalc_SummPriceList (tmpMI.Amount_Sale, tmpMI.OperPriceList)
            - tmpMI.TotalChangePercent_sale
            - tmpMI.TotalChangePercentPay_sale
            - tmpMI.TotalPay_Sale
            - tmpMI.TotalPayOth_Sale
              -- так минуснули Возвраты (проведенные)
            - tmpMI.TotalReturn
            + tmpMI.TotalPay_Return
              -- если НЕ ПРОВЕЛИ - уменьшаем Долг на сумму из тек. документа
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList) - tmpMI.TotalChangePercent ELSE 0 END
            + CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.TotalPay ELSE 0 END
             ) :: TFloat AS SummDebt

             -- % Скидки
           , COALESCE (MIFloat_ChangePercent.ValueData, 0)      :: TFloat AS ChangePercent
           , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)  :: TFloat AS ChangePercentNext

             -- Итого сумма Скидки - для "текущего" документа Продажи: 2)дополнительная
           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  :: TFloat AS SummChangePercent_sale
             -- Итого сумма Скидки - для "текущего" документа Продажи: 1)по %скидки
           , (tmpMI.TotalChangePercent_sale - COALESCE (MIFloat_SummChangePercent.ValueData, 0)) :: TFloat AS TotalChangePercent_sale
             -- Итого сумма Скидки - все "Расчеты покупателей"
           , tmpMI.TotalChangePercentPay_sale                   :: TFloat AS TotalChangePercentPay

             -- Сумма к возврату оплаты
           , CASE WHEN tmpMI.Amount = 0
                       THEN 0
                  WHEN tmpMI.Amount = tmpMI.Amount_Sale
                       THEN tmpMI.TotalPay_Sale
                          + tmpMI.TotalPayOth_Sale
                          - tmpMI.TotalPay_Return
                            -- если ПРОВЕЛИ - вернем обратно сумму Оплаты из тек. документа
                          + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.TotalPay ELSE 0 END
                  ELSE
             -1 *
             (zfCalc_SummPriceList (tmpMI.Amount_Sale, tmpMI.OperPriceList)
            - tmpMI.TotalChangePercent_sale
            - tmpMI.TotalChangePercentPay_sale
            - tmpMI.TotalPay_Sale
            - tmpMI.TotalPayOth_Sale
              -- так минуснули Возвраты (проведенные)
            - tmpMI.TotalReturn
            + tmpMI.TotalPay_Return
              -- если НЕ ПРОВЕЛИ - уменьшаем Долг на сумму из тек. документа
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN zfCalc_SummPriceList (tmpMI.Amount, tmpMI.OperPriceList) - tmpMI.TotalChangePercent ELSE 0 END
            + CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.TotalPay ELSE 0 END
              -- вернем обратно сумму из тек. документа
            - tmpMI.TotalPay
             ) END :: TFloat AS TotalSummToPay

           , tmpMI.TotalChangePercent_curr :: TFloat
           , tmpMI.TotalPay_curr           :: TFloat
           , tmpMI.TotalPayOth_curr        :: TFloat

           , tmpMI_Child.Amount_GRN            :: TFloat AS TotalPay_Grn
           , tmpMI_Child.Amount_USD            :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR            :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank           :: TFloat AS TotalPay_Card
           , tmpMI.TotalPay                    :: TFloat AS TotalPay
           , tmpMI.TotalPayOth                 :: TFloat AS TotalPayOth
           , tmpMI.TotalChangePercent          :: TFloat AS TotalChangePercent


           , tmpMI_Child_Exc.Amount_USD        :: TFloat AS Amount_USD_Exc    -- Сумма USD - обмен приход
           , tmpMI_Child_Exc.Amount_EUR        :: TFloat AS Amount_EUR_Exc    -- Сумма EUR - обмен приход
           , tmpMI_Child_Exc.Amount_GRN        :: TFloat AS Amount_GRN_Exc    -- Сумма GRN - обмен расход

           , tmpMI.SaleMI_Id                   :: Integer   AS SaleMI_Id
           , tmpMI.MovementId_Sale             :: Integer   AS MovementId_Sale
           , tmpMI.InvNumber_Sale              :: TVarChar  AS InvNumber_Sale
           , tmpMI.OperDate_Sale               :: TDateTime AS OperDate_Sale
           , tmpMI.InsertDate_Sale             :: TDateTime AS InsertDate_Sale
           , MovementDesc.ItemName                          AS DescName
           , COALESCE (MovementBoolean_Offer.ValueData, FALSE) ::Boolean AS isOffer   -- примерка

           , tmpMI.Comment                     :: TVarChar  AS Comment
           , tmpMI.isErased                    :: Boolean   AS isErased
           , tmpMI.isChecked                   :: Boolean   AS isChecked
           
           , Container.Id                                   AS ContainerId

           , tmpMI.CurrencyName_pl             :: TVarChar
       FROM tmpMI
            -- суммы оплаты
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            -- суммы обмена
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

            LEFT JOIN tmpContainer AS Container ON Container.PartionId = tmpMI.PartionId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = COALESCE (Container.GoodsSizeId, Object_PartionGoods.GoodsSizeId)
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMI.DescId_Sale
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = tmpMI.SaleMI_Id
                                       AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercentNext
                                        ON MIFloat_SummChangePercentNext.MovementItemId = tmpMI.SaleMI_Id
                                       AND MIFloat_SummChangePercentNext.DescId         = zc_MIFloat_SummChangePercentNext()

            LEFT JOIN MovementBoolean AS MovementBoolean_Offer
                                      ON MovementBoolean_Offer.MovementId = tmpMI.MovementId_Sale
                                     AND MovementBoolean_Offer.DescId = zc_MovementBoolean_Offer()
       ;

     ELSE
     -- Результат такой
     RETURN QUERY
     WITH
       tmpMI_Master AS (SELECT MI_Master.Id                                              AS Id
                             , ROW_NUMBER() OVER (ORDER BY CASE WHEN MI_Master.isErased = FALSE AND MI_Master.Amount > 0 THEN 0 ELSE 1 END ASC, MI_Master.Id ASC) AS LineNum
                             , MI_Master.PartionId                                       AS PartionId
                             , MI_Master.ObjectId                                        AS GoodsId
                             , MI_Master.Amount                                          AS Amount
                             , MIFloat_AmountPartner.ValueData                           AS AmountPartner
                             , COALESCE (MIFloat_TotalChangePercent_master.ValueData, 0) AS TotalChangePercent
                             , COALESCE (MIFloat_TotalPay_master.ValueData, 0)           AS TotalPay
                             , COALESCE (MIFloat_TotalPayOth_master.ValueData, 0)        AS TotalPayOth
                             , COALESCE (MIString_Comment_master.ValueData,'')           AS Comment
                             , MI_Master.isErased                                        AS isErased
                             , ROW_NUMBER() OVER (PARTITION BY MI_Master.isErased ORDER BY MI_Master.Id ASC) AS Ord

                             , Object_PartionMI.ObjectCode                               AS SaleMI_ID

                             , COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0)    AS TotalChangePercent_curr
                             , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)              AS TotalPay_curr
                             , COALESCE (MIFloat_TotalPayOth_curr.ValueData, 0)           AS TotalPayOth_curr

                        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                             JOIN MovementItem AS MI_Master
                                               ON MI_Master.MovementId = inMovementId
                                              AND MI_Master.DescId     = zc_MI_Master()
                                              AND MI_Master.isErased   = tmpIsErased.isErased

                             LEFT JOIN MovementItemString AS MIString_Comment_master
                                                          ON MIString_Comment_master.MovementItemId = MI_Master.Id
                                                         AND MIString_Comment_master.DescId         = zc_MIString_Comment()

                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MI_Master.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_master
                                                         ON MIFloat_TotalChangePercent_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalChangePercent_master.DescId         = zc_MIFloat_TotalChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_master
                                                         ON MIFloat_TotalPay_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay_master.DescId         = zc_MIFloat_TotalPay()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth_master
                                                         ON MIFloat_TotalPayOth_master.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPayOth_master.DescId         = zc_MIFloat_TotalPayOth()

                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_curr
                                                         ON MIFloat_TotalChangePercent_curr.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalChangePercent_curr.DescId         = zc_MIFloat_TotalChangePercent_curr()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                                         ON MIFloat_TotalPay_curr.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay_curr()
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth_curr
                                                         ON MIFloat_TotalPayOth_curr.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPayOth_curr.DescId         = zc_MIFloat_TotalPayOth_curr()

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                              ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                             AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
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
   , tmpContainer AS (SELECT DISTINCT Container.*
                      FROM tmpMI_Master
                           INNER JOIN Container ON Container.PartionId     = tmpMI_Master.PartionId
                                               AND Container.WhereObjectId = inUnitId
                                               AND Container.DescId        = zc_Container_count()
                                               -- !!!обязательно условие, т.к. мог меняться GoodsId и тогда в Container - несколько строк!!!
                                               AND Container.ObjectId      = tmpMI_Master.GoodsId
                                               -- !!!обязательно условие, т.к. мог меняться GoodsSizeId и тогда в Container - несколько строк!!!
                                               AND Container.Amount        <> 0
                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                      WHERE CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                     )
       -- результат
       SELECT
             tmpMI.Id                                          :: Integer  AS Id
           , CASE WHEN tmpMI.isErased = FALSE AND tmpMI.Amount > 0 THEN tmpMI.LineNum ELSE NULL END :: Integer  AS LineNum
           , CASE WHEN tmpMI.isErased = FALSE AND tmpMI.Amount > 0 THEN '*'           ELSE '_'  END :: TVarChar AS isLine
           , tmpMI.PartionId                                   :: Integer  AS PartionId
           , Object_Goods.Id                                               AS GoodsId
           , Object_Goods.ObjectCode                                       AS GoodsCode
           , Object_Goods.ValueData                                        AS GoodsName
           , ObjectString_GoodsGroupFull.ValueData                   AS GoodsGroupNameFull
           , (COALESCE (ObjectString_GoodsGroupFull.ValueData, '') || ' - ' || COALESCE (Object_GoodsInfo.ValueData, '')) :: TVarChar AS NameFull
           , Object_Measure.ValueData                                      AS MeasureName
           , Object_CompositionGroup.ValueData                             AS CompositionGroupName
           , Object_Composition.ValueData                                  AS CompositionName
           , Object_GoodsInfo.ValueData                                    AS GoodsInfoName
           , Object_LineFabrica.ValueData                                  AS LineFabricaName
           , Object_Label.ValueData                                        AS LabelName
           , Object_GoodsSize.Id                                           AS GoodsSizeId
           , Object_GoodsSize.ValueData                                    AS GoodsSizeName

           , Object_Brand.ValueData                                        AS BrandName
           , Object_Period.ValueData                                       AS PeriodName
           , Object_PartionGoods.PeriodYear                                AS PeriodYear
           
           , tmpMI.Amount                                       :: TFloat  AS Amount
           , tmpMI.AmountPartner                                :: TFloat  AS AmountPartner
           , MI_Sale.Amount                                     :: TFloat  AS Amount_Sale
           , Container.Amount                                   :: TFloat  AS Remains
           , 0                                                  :: TFloat  AS OperPrice
           , 0                                                  :: TFloat  AS CountForPrice
           , COALESCE (MIFloat_OperPriceList.ValueData, 0)      :: TFloat  AS OperPriceList
           , COALESCE (MIFloat_OperPriceList_curr.ValueData, 0) :: TFloat  AS OperPriceList_curr

             -- Итого сумма (в прод.)
           , 0                                                  :: TFloat  AS TotalSumm
           , 0                                                  :: TFloat  AS TotalSummBalance
           , zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData) AS TotalSummPriceList

             -- Итого сумма (текущий возврат)
           , 0                                                  :: TFloat  AS TotalSumm_return
           , 0                                                  :: TFloat  AS TotalSummBalance_return
           , zfCalc_SummPriceList (tmpMI.Amount, MIFloat_OperPriceList.ValueData) AS TotalSummPriceList_return

             -- Курс для перевода из валюты партии в ГРН - элемент продажи
           , 0                                                  :: TFloat  AS CurrencyValue
           , 0                                                  :: TFloat  AS ParValue

             -- Итого сумма оплаты - для "текущего" документа Продажи
           , COALESCE (MIFloat_TotalPay.ValueData, 0)           :: TFloat  AS TotalPay_Sale
             -- Итого сумма оплаты - все "Расчеты покупателей"
           , COALESCE (MIFloat_TotalPayOth.ValueData, 0)        :: TFloat  AS TotalPayOth_Sale

             -- Итого сумма возврата оплаты - все док-ты
           , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)   :: TFloat  AS Amount_Return
             -- Итого сумма возврата оплаты - все док-ты
           , COALESCE (MIFloat_TotalReturn.ValueData, 0)        :: TFloat  AS TotalReturn
             -- Итого сумма возврата оплаты - все док-ты
           , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)     :: TFloat  AS TotalPay_Return

             -- Сумма долга
           , (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
            - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
            - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
              -- так минуснули Возвраты (проведенные)
            - COALESCE (MIFloat_TotalReturn.ValueData, 0)
            + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
              -- если НЕ ПРОВЕЛИ - уменьшаем Долг на сумму из тек. документа
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN zfCalc_SummPriceList (tmpMI.Amount, MIFloat_OperPriceList.ValueData) - tmpMI.TotalChangePercent ELSE 0 END
            + CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.TotalPay ELSE 0 END
             ) :: TFloat AS SummDebt

             -- % Скидки
           , COALESCE (MIFloat_ChangePercent.ValueData, 0)      :: TFloat AS ChangePercent
           , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)  :: TFloat AS ChangePercentNext

             -- Итого сумма Скидки - для "текущего" документа Продажи: 2)дополнительная
           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  :: TFloat AS SummChangePercent_sale
           
             -- Итого сумма Скидки - для "текущего" документа Продажи: 1)по %скидки
           , (COALESCE (MIFloat_TotalChangePercent.ValueData, 0) - COALESCE (MIFloat_SummChangePercent.ValueData, 0)) :: TFloat AS TotalChangePercent_sale
             -- Итого сумма Скидки - все "Расчеты покупателей"
           , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) :: TFloat AS TotalChangePercentPay

             -- Сумма к возврату оплаты
           , CASE WHEN tmpMI.Amount = 0
                       THEN 0
                  WHEN tmpMI.Amount = MI_Sale.Amount
                       THEN COALESCE (MIFloat_TotalPay.ValueData, 0)
                          + COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                          - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                            -- если ПРОВЕЛИ - вернем обратно сумму Оплаты из тек. документа
                          + CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN tmpMI.TotalPay ELSE 0 END
                  ELSE
             -1 *
             (zfCalc_SummPriceList (MI_Sale.Amount, MIFloat_OperPriceList.ValueData)
            - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
            - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPay.ValueData, 0)
            - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
              -- так минуснули Возвраты (проведенные)
            - COALESCE (MIFloat_TotalReturn.ValueData, 0)
            + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
              -- если НЕ ПРОВЕЛИ - уменьшаем Долг на сумму из тек. документа
            - CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN zfCalc_SummPriceList (tmpMI.Amount, MIFloat_OperPriceList.ValueData) - tmpMI.TotalChangePercent ELSE 0 END
            + CASE WHEN vbStatusId = zc_Enum_Status_UnComplete() THEN tmpMI.TotalPay ELSE 0 END
              -- вернем обратно сумму из тек. документа
            - tmpMI.TotalPay
             ) END :: TFloat AS TotalSummToPay

           , tmpMI.TotalChangePercent_curr :: TFloat
           , tmpMI.TotalPay_curr           :: TFloat
           , tmpMI.TotalPayOth_curr        :: TFloat

           , tmpMI_Child.Amount_GRN                             :: TFloat AS TotalPay_Grn
           , tmpMI_Child.Amount_USD                             :: TFloat AS TotalPay_USD
           , tmpMI_Child.Amount_EUR                             :: TFloat AS TotalPay_EUR
           , tmpMI_Child.Amount_Bank                            :: TFloat AS TotalPay_Card
           , tmpMI.TotalPay                                     :: TFloat AS TotalPay
           , tmpMI.TotalPayOth                                  :: TFloat AS TotalPayOth
           , tmpMI.TotalChangePercent                           :: TFloat AS TotalChangePercent


           , tmpMI_Child_Exc.Amount_USD                         :: TFloat AS Amount_USD_Exc    -- Сумма USD - обмен приход
           , tmpMI_Child_Exc.Amount_EUR                         :: TFloat AS Amount_EUR_Exc    -- Сумма EUR - обмен приход
           , tmpMI_Child_Exc.Amount_GRN                         :: TFloat AS Amount_GRN_Exc    -- Сумма GRN - обмен расход

           , tmpMI.SaleMI_ID                                  :: Integer  AS SaleMI_Id
           , Movement_Sale.Id                                             AS MovementId_Sale
           , Movement_Sale.InvNumber                                      AS InvNumber_Sale
           , Movement_Sale.OperDate                                       AS OperDate_Sale
           , MovementDate_Insert.ValueData                                AS InsertDate_Sale
           , MovementDesc.ItemName                                        AS DescName
           , COALESCE (MovementBoolean_Offer.ValueData, FALSE)  ::Boolean AS isOffer   -- примерка
           , tmpMI.Comment                                    :: TVarChar AS Comment

           , tmpMI.isErased                                               AS isErased
           , COALESCE (MIBoolean_Checked.ValueData, FALSE)    :: Boolean  AS isChecked

           , Container.Id                                                 AS ContainerId

            -- валюта оригинальной цены, без скидки (из продажи)
           , Object_Currency_pl.ValueData        AS CurrencyName_pl
       FROM tmpMI_Master AS tmpMI
            -- суммы оплаты
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI.Id
            -- суммы обмена
            LEFT JOIN tmpMI_Child AS tmpMI_Child_Exc ON tmpMI_Child_Exc.ParentId = 0
                                                    AND tmpMI.Ord                = 1
                                                    AND tmpMI.isErased           = FALSE

            LEFT JOIN tmpContainer AS Container ON Container.PartionId = tmpMI.PartionId

            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                        ON MIFloat_OperPriceList.MovementItemId = tmpMI.Id
                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                        ON MIFloat_OperPriceList_curr.MovementItemId = tmpMI.Id
                                       AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

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

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementItem AS MI_Sale    ON MI_Sale.Id          = tmpMI.SaleMI_Id
            LEFT JOIN Movement AS Movement_Sale  ON Movement_Sale.Id    = MI_Sale.MovementId
            LEFT JOIN MovementDesc               ON MovementDesc.Id     = Movement_Sale.DescId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_Sale.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementBoolean AS MovementBoolean_Offer
                                      ON MovementBoolean_Offer.MovementId = Movement_Sale.Id
                                     AND MovementBoolean_Offer.DescId = zc_MovementBoolean_Offer()
           ----
           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                       ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                      AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
           LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentNext
                                       ON MIFloat_ChangePercentNext.MovementItemId = MI_Sale.Id
                                      AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext()
           LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                       ON MIFloat_SummChangePercent.MovementItemId = MI_Sale.Id
                                      AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                       ON MIFloat_TotalChangePercent.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                       ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

           LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                       ON MIFloat_TotalPay.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                       ON MIFloat_TotalPayOth.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

           LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                       ON MIFloat_TotalCountReturn.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                       ON MIFloat_TotalReturn.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
           LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                       ON MIFloat_TotalPayReturn.MovementItemId = MI_Sale.Id
                                      AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

           LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                         ON MIBoolean_Checked.MovementItemId = MI_Sale.Id
                                        AND MIBoolean_Checked.DescId         = zc_MIBoolean_Checked()

           LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency_pl
                                            ON MILinkObject_Currency_pl.MovementItemId = MI_Sale.Id
                                           AND MILinkObject_Currency_pl.DescId         = zc_MILinkObject_Currency_pl()
           LEFT JOIN Object AS Object_Currency_pl ON Object_Currency_pl.Id = COALESCE (MILinkObject_Currency_pl.ObjectId, zc_Currency_Basis())



       ;

       END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.04.21         * isOffer
 26.04.21         * AmountPartner
 15.05.20         *
 23.03.18         *
 21.06.17         *
 15.05.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnIn (inMovementId:= 241258, inUnitId:= 1, inClientId:= 1, inStartDate:= CURRENT_DATE - INTERVAL '100 DAY', inEndDate:= CURRENT_DATE, inShowAll:= TRUE,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MovementItem_ReturnIn (inMovementId:= 241258, inUnitId:= 1, inClientId:= 1, inStartDate:= CURRENT_DATE - INTERVAL '100 DAY', inEndDate:= CURRENT_DATE, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
