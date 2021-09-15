-- Function: gpInsert_MI_OrderGoodsDetail_Master()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderGoodsDetail_Master (Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderGoodsDetail_Master(
    IN inParentId             Integer  , -- ключ Документа OrderGoods
    IN inUnitId               Integer  ,
    IN inOperDateStart        TDateTime, -- 
    IN inOperDateEnd          TDateTime, -- 
    IN inSession              TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate  TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsReportSale());

     --пробуем найти сохраненный док.
     vbMovementId := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_OrderGoodsDetail());
     -- перезаписываем даты или записываем новый док , елси не было
     vbMovementId := lpInsertUpdate_Movement_OrderGoodsDetail (ioId            := COALESCE (vbMovementId,0)::Integer
                                                             , inParentId      := inParentId      ::Integer    -- ключ Документа OrderGoods
                                                             , inOperDate      := CURRENT_Date    ::TDateTime  -- Дата документа
                                                             , inOperDateStart := inOperDateStart ::TDateTime  -- 
                                                             , inOperDateEnd   := inOperDateEnd   ::TDateTime  --
                                                             , inUserId        := vbUserId
                                                             );

   -- сохраненные строки
   CREATE TEMP TABLE tmpGoodsMaster (GoodsId Integer, Amount TFloat) ON COMMIT DROP;
    INSERT INTO tmpGoodsMaster (GoodsId, Amount)
       SELECT MovementItem.ObjectId   AS GoodsId
            , SUM (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
       WHERE MovementItem.MovementId = inParentId
         AND MovementItem.DescId = zc_MI_Master()
         AND MovementItem.isErased = FALSE
       GROUP BY MovementItem.ObjectId;
         
     --
     CREATE TEMP TABLE tmpAll (GoodsId Integer, GoodsKindId Integer, AmountOrder TFloat, AmountOrderPromo TFloat, AmountOrderBranch TFloat, AmountSale TFloat, AmountSalePromo TFloat, AmountBranch TFloat, TotalAmountOrder TFloat) ON COMMIT DROP;
    
     -- Готовая продукция
      WITH tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                             , CASE WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Готовая продукция 
                                         THEN TRUE
                                    ELSE FALSE
                               END AS isGoodsKind
                        FROM Object_InfoMoney_View
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        WHERE (Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция + Готовая продукция and Тушенка and Хлеб
                             --OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье : запечена...
                             --OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                               )
                             
                        OR (Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                             --OR Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Продукция + Готовая продукция
                             --OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                               )
                        )

         , tmpOrder AS (SELECT Movement.OperDate
                             , Movement.UnitId
                             , MovementItem.ObjectId AS GoodsId
                             , MovementItem.Amount   AS Amount
                             , MovementItem.Id       AS MovementItemId
                             , Movement.isUnit
                        FROM ( SELECT Movement.Id
                                    , MD_OperDatePartner.ValueData AS OperDate
                                    , MovementLinkObject_To.ObjectId AS UnitId
                                    , CASE WHEN Object_From.DescId = zc_Object_Unit() THEN TRUE ELSE FALSE END AS isUnit 
                               FROM MovementDate AS MD_OperDatePartner
                                    INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                       AND Movement.DescId   = zc_Movement_OrderExternal()
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()

                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                 AND MovementLinkObject_To.ObjectId = inUnitId
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId 
                                   
                               WHERE MD_OperDatePartner.ValueData BETWEEN inOperDateStart AND inOperDateEnd
                                 AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                              ) AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             INNER JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = MovementItem.ObjectId
                     )
                          
         , tmpSale AS (SELECT Movement.OperDate
                             , Movement.UnitId
                             , MovementItem.ObjectId AS GoodsId
                             , MovementItem.Amount
                             , MovementItem.Id       AS MovementItemId
                        FROM ( SELECT Movement.Id
                                    , Movement.OperDate
                                    , MovementLinkObject_From.ObjectId AS UnitId
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id 
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                 AND MovementLinkObject_From.ObjectId = inUnitId
                                   
                               WHERE Movement.OperDate BETWEEN inOperDateStart AND inOperDateEnd
                                 AND Movement.DescId = zc_Movement_Sale()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              ) AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             INNER JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = MovementItem.ObjectId
                      ) 
                      
         , tmpSendOnPrice AS (SELECT Movement.OperDate
                                   , Movement.UnitId
                                   , MovementItem.ObjectId AS GoodsId
                                   , MovementItem.Amount
                                   , MovementItem.Id       AS MovementItemId
                              FROM ( SELECT Movement.Id
                                          , Movement.OperDate
                                          , MovementLinkObject_From.ObjectId AS UnitId
                                     FROM Movement
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement.Id 
                                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                       AND MovementLinkObject_From.ObjectId = inUnitId
                                         
                                     WHERE Movement.OperDate BETWEEN inOperDateStart AND inOperDateEnd
                                       AND Movement.DescId = zc_Movement_SendOnPrice()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                    ) AS Movement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                                   INNER JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = MovementItem.ObjectId
                            ) 
         , tmpMI AS (SELECT tmpSale.MovementItemId
                     FROM tmpSale
                    UNION
                     SELECT tmpOrder.MovementItemId
                     FROM tmpOrder
                    UNION
                     SELECT tmpSendOnPrice.MovementItemId
                     FROM tmpSendOnPrice
                    )
         , tmpMIFloat AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat 
                          WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.MovementItemId FROM tmpMI)
                          )                      
                          
         , tmpMILinkObject_GoodsKind AS (SELECT MovementItemLinkObject.*
                                         FROM MovementItemLinkObject
                                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.MovementItemId FROM tmpMI)
                                           AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                         )
                                      
         , tmpMIAll AS
           (-- 1.1 Заявки
            SELECT Movement.OperDate                                AS OperDate
                 , Movement.UnitId                                  AS UnitId
                 , Movement.GoodsId                                 AS GoodsId
                 , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId

                 , SUM (CASE WHEN Movement.isUnit = FALSE AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountOrder
                 , SUM (CASE WHEN Movement.isUnit = FALSE AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountOrderPromo
                 , SUM (CASE WHEN Movement.isUnit = TRUE THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END)                                                          AS AmountOrderBranch                       
                 , 0                                                                        AS AmountSale
                 , 0                                                                        AS AmountSalePromo
                 , 0                                                                        AS AmountBranch
            FROM tmpOrder AS Movement 
                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = Movement.GoodsId
                 LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                    AND tmpGoods.isGoodsKind = TRUE
                 LEFT JOIN tmpMIFloat AS MIFloat_AmountSecond
                                      ON MIFloat_AmountSecond.MovementItemId = Movement.MovementItemId
                                     AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                            
                 LEFT JOIN tmpMIFloat AS MIFloat_PromoMovementId
                                      ON MIFloat_PromoMovementId.MovementItemId = Movement.MovementItemId
                                     AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
            GROUP BY Movement.OperDate
                   , Movement.UnitId
                   , Movement.GoodsId 
                   , MILinkObject_GoodsKind.ObjectId
                   , tmpGoods.isGoodsKind
            HAVING SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0
                OR SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0

           UNION ALL
            -- 1.2 Продажи
            SELECT Movement.OperDate                                AS OperDate
                 , Movement.UnitId                                  AS UnitId
                 , Movement.GoodsId                                 AS GoodsId
                 , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId
                 , 0                                                   AS AmountOrder
                 , 0                                                   AS AmountOrderPromo
                 , 0                                                   AS AmountOrderBranch
                 , SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountSale
                 , SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountSalePromo
                 , 0                                                   AS AmountBranch
            FROM tmpSale AS Movement
                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = Movement.GoodsId
 
                 LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                    AND tmpGoods.isGoodsKind = TRUE
                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                             ON MIFloat_AmountPartner.MovementItemId = Movement.MovementItemId
                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                 
                 LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                             ON MIFloat_PromoMovementId.MovementItemId = Movement.MovementItemId
                                            AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                                                                       
            GROUP BY Movement.OperDate
                   , Movement.UnitId
                   , Movement.GoodsId 
                   , MILinkObject_GoodsKind.ObjectId
                   , tmpGoods.isGoodsKind
            HAVING SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) <> 0  
                OR SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) <> 0  

           UNION ALL
            -- 1.3 Перемещение на филиал
            SELECT Movement.OperDate                                AS OperDate
                 , Movement.UnitId                                  AS UnitId
                 , Movement.GoodsId                                 AS GoodsId
                 , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId
                 , 0                                                AS AmountOrder
                 , 0                                                AS AmountOrderPromo
                 , 0                                                AS AmountOrderBranch
                 , 0                                                AS AmountSale
                 , 0                                                AS AmountSalePromo
                 , SUM (COALESCE (Movement.Amount, 0))              AS AmountBranch
            FROM tmpSendOnPrice AS Movement
                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = Movement.GoodsId
 
                 LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                 AND tmpGoods.isGoodsKind = TRUE
            GROUP BY Movement.OperDate
                   , Movement.UnitId
                   , Movement.GoodsId 
                   , MILinkObject_GoodsKind.ObjectId
                   , tmpGoods.isGoodsKind
            HAVING SUM (COALESCE (Movement.Amount, 0)) <> 0   
           )

    INSERT INTO tmpAll (GoodsId, GoodsKindId, AmountOrder, AmountOrderPromo, AmountOrderBranch, AmountSale, AmountSalePromo, AmountBranch, TotalAmountOrder)
            SELECT tmpMIAll.GoodsId
                 , tmpMIAll.GoodsKindId
                 , SUM (tmpMIAll.AmountOrder       ) AS AmountOrder
                 , SUM (tmpMIAll.AmountOrderPromo  ) AS AmountOrderPromo
                 , SUM (tmpMIAll.AmountOrderBranch ) AS AmountOrderBranch
                 , SUM (tmpMIAll.AmountSale        ) AS AmountSale
                 , SUM (tmpMIAll.AmountSalePromo   ) AS AmountSalePromo
                 , SUM (tmpMIAll.AmountBranch      ) AS AmountBranch
                 , SUM (SUM (tmpMIAll.AmountOrder)) OVER (PARTITION BY tmpMIAll.GoodsId) AS TotalAmountOrder
            FROM tmpMIAll
                 INNER JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = tmpMIAll.GoodsId 
            GROUP BY tmpMIAll.GoodsId
                   , tmpMIAll.GoodsKindId
            HAVING SUM (tmpMIAll.AmountOrder       ) <> 0
                OR SUM (tmpMIAll.AmountOrderPromo  ) <> 0
                OR SUM (tmpMIAll.AmountOrderBranch ) <> 0
                OR SUM (tmpMIAll.AmountSale        ) <> 0
                OR SUM (tmpMIAll.AmountSalePromo   ) <> 0
                OR SUM (tmpMIAll.AmountBranch      ) <> 0
   ;

   -- сохраненные строки
   CREATE TEMP TABLE tmpMI_Master (Id Integer, GoodsId Integer, GoodsKindId Integer) ON COMMIT DROP;
    INSERT INTO tmpMI_Master (Id, GoodsId, GoodsKindId)
       SELECT MovementItem.Id
            , MovementItem.ObjectId   AS GoodsId
            , MILO_GoodsKind.ObjectId AS GoodsKindId
       FROM MovementItem
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
       WHERE MovementItem.MovementId = vbMovementId
         AND MovementItem.DescId = zc_MI_Master()
         AND MovementItem.isErased = FALSE;

   -- удаляем строки которых нет в выборке, остальные обновим
   PERFORM gpMovementItem_OrderGoodsDetail_SetErased_Master (inMovementItemId := tmpMI_Master.Id
                                                           , inSession := inSession)
   FROM tmpMI_Master
       LEFT JOIN tmpAll ON tmpAll.GoodsId = tmpMI_Master.GoodsId
                       AND tmpAll.GoodsKindId = tmpMI_Master.GoodsKindId
   WHERE tmpAll.GoodsId IS NULL;

   -- сохраняем/обновляем данные MI_Master
   PERFORM lpInsert_MI_OrderGoodsDetail_Master(inId                       := COALESCE (tmpMI_Master.Id, 0) ::Integer
                                             , inMovementId               := vbMovementId
                                             , inParentId                 := inParentId
                                             , inObjectId                 := tmpAll.GoodsId
                                             , inGoodsKindId              := tmpAll.GoodsKindId
                                             , inAmount                   := CASE WHEN COALESCE (tmpAll.TotalAmountOrder,0) <> 0 
                                                                                  THEN (CAST (tmpAll.AmountSale/tmpAll.TotalAmountOrder AS NUMERIC (16,2))) * tmpGoodsMaster.Amount
                                                                                  ELSE 0
                                                                             END ::TFloat
                                             , inAmountForecast           := tmpAll.AmountSale       ::TFloat
                                             , inAmountForecastOrder      := tmpAll.AmountOrder      ::TFloat
                                             , inAmountForecastPromo      := tmpAll.AmountSalePromo  ::TFloat
                                             , inAmountForecastOrderPromo := tmpAll.AmountOrderPromo ::TFloat
                                             , inUserId                   := vbUserId
                                              )
   FROM tmpAll
       LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId = tmpAll.GoodsId
                             AND tmpMI_Master.GoodsKindId = tmpAll.GoodsKindId
       LEFT JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = tmpAll.GoodsId
       ;                              

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.21         *
*/

-- тест
-- 