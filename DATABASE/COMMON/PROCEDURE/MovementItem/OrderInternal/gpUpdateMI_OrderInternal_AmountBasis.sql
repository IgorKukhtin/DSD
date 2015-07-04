-- Function: gpUpdateMI_OrderInternal_AmountBasis()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountBasis (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountBasis(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());



    -- таблица -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, ReceiptId Integer, CuterCount TFloat, GoodsId_child Integer, Amount_child TFloat) ON COMMIT DROP;
   --
   INSERT INTO tmpAll (MovementItemId, GoodsId, ReceiptId, CuterCount, GoodsId_child, Amount_child)
                                 WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup)
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                   FROM Object_InfoMoney_View
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                                      OR Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье + Мясное сырье : запечена...
                                                      OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                  )
                                 SELECT tmp.MovementItemId
                                      , tmp.GoodsId
                                      , tmp.ReceiptId
                                      , tmp.CuterCount
                                      , tmp.GoodsId_child
                                      , tmp.Amount_child
                                 FROM (-- !!!!ПРОИЗВОДСТВО!!!
                                       SELECT MovementItem.Id                             AS MovementItemId
                                            , MovementItem.ObjectId                       AS GoodsId
                                            , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0) AS GoodsId_child
                                            , COALESCE (MILO_Receipt.ObjectId, 0)         AS ReceiptId
                                            , COALESCE (MIFloat_CuterCount.ValueData, 0)  AS CuterCount
                                            , COALESCE (MIFloat_CuterCount.ValueData, 0) * COALESCE (ObjectFloat_Value.ValueData, 0) AS Amount_child
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                                        ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                                                       AND MIFloat_CuterCount.ValueData <> 0
                                            LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                                             ON MILO_Receipt.MovementItemId = MovementItem.Id
                                                                            AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_Value_master
                                                                  ON ObjectFloat_Value_master.ObjectId = MILO_Receipt.ObjectId
                                                                 AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                                 AND ObjectFloat_Value_master.ValueData <> 0

                                            INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                                  ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = MILO_Receipt.ObjectId
                                                                 AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                            INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                                    AND Object_ReceiptChild.isErased = FALSE
                                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                                 ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                                AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                                           INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                  ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                                 AND ObjectFloat_Value.ValueData <> 0
                                       WHERE Movement.OperDate = inOperDate
                                         AND Movement.DescId = zc_Movement_ProductionUnion()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                      ) AS tmp
                                     ;

       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmp.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := COALESCE (tmpAll.GoodsId_child, tmp.GoodsId)
                                                 , inGoodsKindId        := NULL
                                                 , inAmount_Param       := COALESCE (tmpAll.Amount_child, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder  := NULL
                                                 , inDescId_ParamOrder  := NULL
                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  ) 
       FROM (SELECT tmpAll.GoodsId_child, SUM (tmpAll.Amount_child) AS Amount_child FROM tmpAll GROUP BY tmpAll.GoodsId_child) AS tmpAll
                                 FULL JOIN
                                (SELECT MAX (MovementItem.Id)                         AS MovementItemId 
                                      , MovementItem.ObjectId                         AS GoodsId
                                 FROM MovementItem 
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                 GROUP BY MovementItem.ObjectId
                                ) AS tmp ON tmp.GoodsId = tmpAll.GoodsId_child
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
 27.06.15                                        * расчет, временно захардкодил
 19.06.15                                        *
 14.02.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountBasis (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
