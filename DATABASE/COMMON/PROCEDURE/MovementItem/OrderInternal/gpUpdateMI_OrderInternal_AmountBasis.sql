-- Function: gpUpdateMI_OrderInternal_AmountBasis()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountBasis (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountBasis(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsTushenka Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- расчет, временно захардкодил - From = ЦЕХ Тушенка
    vbIsTushenka:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_From() AND MovementId = inMovementId AND ObjectId = 2790412); -- ЦЕХ Тушенка


    -- таблица -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, ReceiptId Integer, CuterCount TFloat, CuterCount_pf TFloat, GoodsId_child Integer, GoodsKindId_child Integer, Amount_child TFloat, Amount_child_pf TFloat, isOrderSecond Boolean) ON COMMIT DROP;
   --
   INSERT INTO tmpAll (MovementItemId, GoodsId, ReceiptId, CuterCount, CuterCount_pf, GoodsId_child, GoodsKindId_child, Amount_child, Amount_child_pf, isOrderSecond)
      WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup)
         , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                             , CASE WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId  IN (5064881) -- СО-ПОСОЛ
                                      OR ObjectLink_GoodsGroup_parent.ChildObjectId IN (5064881) -- СО-ПОСОЛ
                                         THEN TRUE
                                    ELSE FALSE
                               END AS isPF
                        FROM Object_InfoMoney_View
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                  ON ObjectLink_Goods_GoodsGroup.ObjectId      = ObjectLink_Goods_InfoMoney.ObjectId
                                                 AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                  ON ObjectLink_GoodsGroup_parent.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                 AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                        WHERE ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                             OR Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье + Мясное сырье : запечена...
                             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                               )
                               AND vbIsTushenka = FALSE)
                            OR (Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30102() -- Доходы + Продукция + Тушенка
                               AND vbIsTushenka = TRUE)
                            OR ObjectLink_Goods_GoodsGroup.ChildObjectId  IN (5064881) -- СО-ПОСОЛ
                            OR ObjectLink_GoodsGroup_parent.ChildObjectId IN (5064881) -- СО-ПОСОЛ
                       )
      SELECT 0 AS MovementItemId
           , tmp.GoodsId
           , tmp.ReceiptId
           , tmp.CuterCount
           , tmp.CuterCount_pf
           , tmp.GoodsId_child
           , tmp.GoodsKindId_child
           , tmp.Amount_child
           , tmp.Amount_child_pf
           , tmp.isOrderSecond
      FROM (-- !!!!ПРОИЗВОДСТВО (подтвержденная программа)!!!
            SELECT MovementItem.Id AS MovementItemId
                 , CASE WHEN tmpGoods.isPF = TRUE THEN 0                     ELSE MovementItem.ObjectId                                         END AS GoodsId
                 , CASE WHEN tmpGoods.isPF = TRUE THEN MovementItem.ObjectId ELSE COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)     END AS GoodsId_child
                 , CASE WHEN tmpGoods.isPF = TRUE THEN 0                     ELSE COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) END AS GoodsKindId_child
                 , CASE WHEN tmpGoods.isPF = TRUE THEN 0                     ELSE COALESCE (MILO_Receipt.ObjectId, 0)                           END AS ReceiptId
                   -- все Составляющие без СО-ПОСОЛ
                 , CASE WHEN tmpGoods.isPF = FALSE THEN COALESCE (MIFloat_CuterCount.ValueData, 0) ELSE 0 END AS CuterCount
                 , CASE WHEN tmpGoods.isPF = FALSE THEN COALESCE (MIFloat_CuterCount.ValueData, 0) * COALESCE (ObjectFloat_Value.ValueData, 0) ELSE 0 END AS Amount_child
                   -- СО-ПОСОЛ
                 , CASE WHEN tmpGoods.isPF = TRUE THEN COALESCE (MIFloat_CuterCount.ValueData, 0) ELSE 0 END AS CuterCount_pf
                 , CASE WHEN tmpGoods.isPF = TRUE THEN MovementItem.Amount                        ELSE 0 END AS Amount_child_pf
                   -- дозаказ
                 , CASE WHEN tmpGoods.isPF = TRUE THEN FALSE ELSE COALESCE (MIBoolean_OrderSecond.ValueData, FALSE) END AS isOrderSecond
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                 INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                              AND MovementLinkObject_To.ObjectId = MovementLinkObject_From.ObjectId
                 -- заказ ГП
                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                 LEFT JOIN MovementItemBoolean AS MIBoolean_OrderSecond
                                               ON MIBoolean_OrderSecond.MovementItemId = MovementItem.Id
                                              AND MIBoolean_OrderSecond.DescId = zc_MIBoolean_OrderSecond()

                 LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                             ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                            AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                            AND MIFloat_CuterCount.ValueData <> 0
                 LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                  ON MILO_Receipt.MovementItemId = MovementItem.Id
                                                 AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                                                 AND tmpGoods.isPF = FALSE
                 -- составляющие
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt -- !!!
                                      ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = MILO_Receipt.ObjectId
                                     AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                                     AND tmpGoods.isPF = FALSE
                 LEFT JOIN Object AS Object_ReceiptChild -- !!!
                                  ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                 AND Object_ReceiptChild.isErased = FALSE
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                      ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                      ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Value -- !!!
                                       ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                    --AND ObjectFloat_Value.ValueData <> 0 -- !!!
            WHERE Movement.OperDate = inOperDate
              AND Movement.DescId   = zc_Movement_ProductionUnion()
              AND Movement.StatusId = zc_Enum_Status_Complete()
              AND (ObjectFloat_Value.ValueData <> 0 OR tmpGoods.isPF = TRUE)
           ) AS tmp
          ;

       -- добавили те что разворачиваются по рецептурам
       INSERT INTO tmpAll (MovementItemId, GoodsId, ReceiptId, CuterCount, CuterCount_pf, GoodsId_child, GoodsKindId_child, Amount_child, Amount_child_pf, isOrderSecond)
         WITH tmpGoods AS (SELECT tmpAll.GoodsId_child, SUM (tmpAll.Amount_child) AS Amount_child, SUM (tmpAll.Amount_child_pf) AS Amount_child_pf FROM tmpAll GROUP BY tmpAll.GoodsId_child)
            , tmpReceipt AS (SELECT tmpGoods.GoodsId_child
                                  , MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                                  , CASE WHEN ObjectLink_Goods_GoodsGroup.ChildObjectId  IN (5064881) -- СО-ПОСОЛ
                                           OR ObjectLink_GoodsGroup_parent.ChildObjectId IN (5064881) -- СО-ПОСОЛ
                                              THEN TRUE
                                         ELSE FALSE
                                    END AS isPF
                             FROM tmpGoods
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId      = tmpGoods.GoodsId_child
                                                      AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                                       ON ObjectLink_GoodsGroup_parent.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                      AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_parent()
                                  INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                        ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId_child
                                                       AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                  INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                     AND Object_Receipt.isErased = FALSE
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                           ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                          AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                          AND ObjectBoolean_Main.ValueData = TRUE
                             WHERE ObjectLink_Goods_GoodsGroup.ChildObjectId  IN (1942, 5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                                OR ObjectLink_GoodsGroup_parent.ChildObjectId IN (1942, 5064881) -- СО-ЭМУЛЬСИИ + СО-ПОСОЛ
                             GROUP BY tmpGoods.GoodsId_child
                                    , ObjectLink_Goods_GoodsGroup.ChildObjectId
                                    , ObjectLink_GoodsGroup_parent.ChildObjectId
                            )
          , tmpMIRemains AS (SELECT MovementItem.ObjectId                               AS GoodsId
                                  , SUM (COALESCE (MIFloat_AmountRemains.ValueData, 0)) AS AmountRemains
                             FROM MovementItem
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                              ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountRemains.DescId         = zc_MIFloat_AmountRemains()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                             GROUP BY MovementItem.ObjectId
                            )
         -- Результат
         SELECT 0 AS MovementItemId
              , tmpGoods.GoodsId_child AS GoodsId
              , tmpReceipt.ReceiptId
              , 0 AS CuterCount
              , 0 AS CuterCount_pf
              , COALESCE (ObjectLink_ReceiptChild_Goods.ChildObjectId, 0)     AS GoodsId_child
              , COALESCE (ObjectLink_ReceiptChild_GoodsKind.ChildObjectId, 0) AS GoodsKindId_child
                -- вычитаем остаток ... только для isPF
            --, CASE WHEN COALESCE (tmpMIRemains.AmountRemains, 0) >  tmpGoods.Amount_child THEN 0 ELSE tmpGoods.Amount_child - COALESCE (tmpMIRemains.AmountRemains, 0) END * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData AS Amount_child
              , CASE WHEN tmpReceipt.isPF = TRUE THEN 0 ELSE tmpGoods.Amount_child END * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData AS Amount_child
                -- вычитаем что осталось ... только для isPF
            --, CASE WHEN COALESCE (tmpMIRemains.AmountRemains, 0) <= tmpGoods.Amount_child THEN tmpGoods.Amount_child_pf ELSE tmpGoods.Amount_child_pf - (COALESCE (tmpMIRemains.AmountRemains, 0) - tmpGoods.Amount_child) END * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData AS Amount_child_pf
              , tmpGoods.Amount_child_pf  * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData AS Amount_child_pf
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
              LEFT JOIN tmpMIRemains ON tmpMIRemains.GoodsId = tmpGoods.GoodsId_child
--         WHERE CASE WHEN COALESCE (tmpMIRemains.AmountRemains, 0) >  tmpGoods.Amount_child THEN 0 ELSE tmpGoods.Amount_child - COALESCE (tmpMIRemains.AmountRemains, 0) END * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData > 0
--            OR CASE WHEN COALESCE (tmpMIRemains.AmountRemains, 0) <= tmpGoods.Amount_child THEN tmpGoods.Amount_child_pf ELSE tmpGoods.Amount_child_pf - (COALESCE (tmpMIRemains.AmountRemains, 0) - tmpGoods.Amount_child) END * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData > 0
         WHERE tmpGoods.Amount_child_pf > 0
            OR CASE WHEN tmpReceipt.isPF = TRUE THEN 0 ELSE tmpGoods.Amount_child END > 0
            ;
/*
if inSession = '5'
then
    RAISE EXCEPTION 'Ошибка.<%>   %', (
    select sum (tmpAll.Amount_child_pf) from tmpAll
)
, (--
             SELECT SUM (CASE WHEN isOrderSecond = FALSE AND CuterCount_pf <> 0 THEN tmpAll.Amount_child_pf ELSE 0 END) AS Amount_child_pf

             FROM tmpAll
             
            ) 
;
end if;*/


       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpMI_curr.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := COALESCE (tmpAll.GoodsId_child, tmpMI_curr.GoodsId)
                                                 , inGoodsKindId        := COALESCE (tmpAll.GoodsKindId_child, tmpMI_curr.GoodsKindId)
                                                   -- Программа БЕЗ сырья для эмул. - но сами Эмульсии (только которые нужны для ГП) здесь
                                                 , inAmount_Param       := COALESCE (tmpAll.Amount_child, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                   -- Программа сырьё ДЛЯ эмул. (которые нужны для ГП + добавочные)
                                                 , inAmount_ParamOrder  := COALESCE (tmpAll.Amount_child_add, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder  := zc_MIFloat_AmountPartnerPrior()
                                                   -- Программа дозаказ - (сырье + эмульсии)
                                                 , inAmount_ParamSecond := COALESCE (tmpAll.Amount_child_second, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamSecond := zc_MIFloat_AmountPartnerSecond()
                                                   -- Программа - здесь только Эмульсии (добавочные)
                                                 , inAmount_ParamAdd    := COALESCE (tmpAll.Amount_child_pf, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamAdd    := zc_MIFloat_AmountPartnerNext()
                                                   --
                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  )
       FROM (--
             SELECT tmpAll.GoodsId_child, tmpAll.GoodsKindId_child
                    -- Программа БЕЗ сырья для эмул. - но сами Эмульсии (только которые нужны для ГП) здесь
                  , SUM (CASE WHEN isOrderSecond = FALSE AND CuterCount <> 0 THEN tmpAll.Amount_child    ELSE 0 END) AS Amount_child
                    -- Программа дозаказ - (сырье + эмульсии)
                  , SUM (CASE WHEN isOrderSecond = TRUE  AND CuterCount <> 0 THEN tmpAll.Amount_child ELSE 0 END) AS Amount_child_second
                    -- Программа сырьё ДЛЯ эмул. (которые нужны для ГП + добавочные)
                  , SUM (CASE WHEN COALESCE (CuterCount, 0) = 0              THEN tmpAll.Amount_child + tmpAll.Amount_child_pf ELSE 0 END) AS Amount_child_add
                    -- Программа - здесь только Эмульсии (добавочные)
                  , SUM (CASE WHEN isOrderSecond = FALSE AND CuterCount_pf <> 0 THEN tmpAll.Amount_child_pf ELSE 0 END) AS Amount_child_pf

             FROM tmpAll
             GROUP BY tmpAll.GoodsId_child, tmpAll.GoodsKindId_child
            ) AS tmpAll

            FULL JOIN (SELECT MAX (MovementItem.Id)                         AS MovementItemId
                            , MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM MovementItem
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ObjectId
                              , MILinkObject_GoodsKind.ObjectId
                      ) AS tmpMI_curr ON tmpMI_curr.GoodsId     = tmpAll.GoodsId_child
                                     AND tmpMI_curr.GoodsKindId = tmpAll.GoodsKindId_child

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
 17.03.16                                        *
 27.06.15                                        * расчет, временно захардкодил
 19.06.15                                        *
 14.02.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountBasis (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
-- select * from gpUpdateMI_OrderInternal_AmountBasis(inMovementId := 16187221 , inOperDate := ('20.03.2020')::TDateTime , inFromId := 8447 ,  inSession := '5');
