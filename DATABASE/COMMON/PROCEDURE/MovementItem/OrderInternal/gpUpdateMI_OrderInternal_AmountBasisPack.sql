-- Function: gpUpdateMI_OrderInternal_AmountBasisPack()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountBasisPack (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountBasisPack(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     vbStartDate := inOperDate - INTERVAL '28 day'; 
     vbEndDate := inOperDate - INTERVAL '1 day';

    -- таблица -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, ReceiptId Integer, CuterCount TFloat, GoodsId_child Integer, GoodsKindId_child Integer, Amount_child TFloat, isOrderSecond Boolean) ON COMMIT DROP;
   --
   INSERT INTO tmpAll (MovementItemId, GoodsId, ReceiptId, CuterCount, GoodsId_child, GoodsKindId_child, Amount_child, isOrderSecond)
                                 WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup)
                                    , tmpGoods AS (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1917) AS lfSelect)    -- группа СД-СЫРЬЕ (1917)
                                                  
                                 SELECT 0 AS MovementItemId
                                      , tmp.GoodsId
                                      , tmp.CuterCount
                                      , tmp.Amount
                                 FROM (-- !!!!ПРОИЗВОДСТВО
                                       SELECT MovementItem.Id                               AS MovementItemId
                                            , MovementItem.ObjectId                         AS GoodsId
                                            , COALESCE (MIFloat_CuterCount.ValueData, 0)    AS CuterCount
                                            , COALESCE (MovementItem.Amount, 0)             AS Amount
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                         --AND MovementLinkObject_To.ObjectId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                       WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                         AND Movement.DescId = zc_Movement_ProductionUnion()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                      ) AS tmp
                                     ;

       -- добавили те что разворачиваются по рецептурам
       INSERT INTO tmpAll (MovementItemId, GoodsId, ReceiptId, CuterCount, GoodsId_child, GoodsKindId_child, Amount_child, isOrderSecond)
         WITH tmpGoods AS (SELECT tmpAll.GoodsId_child, SUM (tmpAll.Amount_child) AS Amount_child FROM tmpAll GROUP BY tmpAll.GoodsId_child)
            , tmpReceipt AS (SELECT tmpGoods.GoodsId_child
                                  , MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                             FROM tmpGoods
                                  INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                        ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId_child
                                                       AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                  INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                     AND Object_Receipt.isErased = FALSE
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                           ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                          AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                          AND ObjectBoolean_Main.ValueData = TRUE
                             GROUP BY tmpGoods.GoodsId_child
                            )
                                       -- Результат
                                       SELECT 0 AS MovementItemId
                                            , tmpGoods.GoodsId_child AS GoodsId
                                            , tmpReceipt.ReceiptId
                                            , 0 AS CuterCount
                                            , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)     AS GoodsId_child
                                            , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId_child
                                            , tmpGoods.Amount_child * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData AS Amount_child
                                            , FALSE AS isOrderSecond
                                       FROM tmpGoods
                                            INNER JOIN tmpReceipt ON tmpReceipt.GoodsId_child = tmpGoods.GoodsId_child
                                            INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                                   ON ObjectFloat_Value_master.ObjectId = tmpReceipt.ReceiptId
                                                                  AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                                  AND ObjectFloat_Value_master.ValueData <> 0

                                            INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                                  ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = tmpReceipt.ReceiptId
                                                                 AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                            INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                                    AND Object_ReceiptChild.isErased = FALSE
                                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                                 ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                                AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                                 ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                                AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                                            INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                   ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                                  AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                                  AND ObjectFloat_Value.ValueData <> 0
                                                                 ;
       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmp.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := COALESCE (tmpAll.GoodsId_child, tmp.GoodsId)
                                                 , inGoodsKindId        := COALESCE (tmpAll.GoodsKindId_child, tmp.GoodsKindId)
                                                 , inAmount_Param       := COALESCE (tmpAll.Amount_child, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder  := COALESCE (tmpAll.Amount_child_add, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder  := zc_MIFloat_AmountPartnerPrior()
                                                 , inAmount_ParamSecond := COALESCE (tmpAll.Amount_child_second, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamSecond := zc_MIFloat_AmountPartnerSecond()
                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  ) 
       FROM (SELECT tmpAll.GoodsId_child, tmpAll.GoodsKindId_child
                  , SUM (CASE WHEN isOrderSecond = FALSE AND CuterCount <> 0 THEN tmpAll.Amount_child ELSE 0 END) AS Amount_child
                  , SUM (CASE WHEN isOrderSecond = TRUE  AND CuterCount <> 0 THEN tmpAll.Amount_child ELSE 0 END) AS Amount_child_second
                  , SUM (CASE WHEN COALESCE (CuterCount, 0) = 0              THEN tmpAll.Amount_child ELSE 0 END) AS Amount_child_add
             FROM tmpAll
             GROUP BY tmpAll.GoodsId_child, tmpAll.GoodsKindId_child
            ) AS tmpAll
                                 FULL JOIN
                                (SELECT MAX (MovementItem.Id)                         AS MovementItemId 
                                      , MovementItem.ObjectId                         AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 FROM MovementItem 
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                 GROUP BY MovementItem.ObjectId
                                        , MILinkObject_GoodsKind.ObjectId
                                ) AS tmp ON tmp.GoodsId = tmpAll.GoodsId_child
                                        AND tmp.GoodsKindId = tmpAll.GoodsKindId_child
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId_child
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId_child
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.12.19         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountBasisPack (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
