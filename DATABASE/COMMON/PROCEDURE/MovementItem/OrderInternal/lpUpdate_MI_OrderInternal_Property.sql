-- Function: lpUpdate_MI_OrderInternal_Property()

DROP FUNCTION IF EXISTS lpUpdate_MI_OrderInternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_OrderInternal_Property(
    IN ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAmount_Param        TFloat    , -- 
    IN inDescId_Param        Integer   ,
    IN inAmount_ParamOrder   TFloat    , -- 
    IN inDescId_ParamOrder   Integer   ,
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMonth Integer;
BEGIN
     -- определяется
     SELECT EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
            INTO vbMonth
     FROM Movement
     WHERE Movement.Id = inMovementId;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF COALESCE (ioId, 0) = 0
     THEN
         -- проверка уникальности
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId = inGoodsId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                      AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                    )
         THEN
             RAISE EXCEPTION 'Ошибка.В документе уже существует <%> <%>.Дублирование запрещено.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
         END IF;

         -- сохранили <Элемент документа>
         ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);

         -- сохранили связь с <Виды товаров>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
  
     END IF;


     IF vbIsInsert = TRUE OR 1=1
     THEN
         -- сохранили связь с <Рецептуры>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), ioId, tmp.ReceiptId_basis)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      ioId, tmp.ReceiptId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(),   ioId, ObjectLink_Receipt_Goods_basis.ChildObjectId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(),        ioId, ObjectLink_Receipt_Goods.ChildObjectId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, ObjectLink_Receipt_GoodsKind.ChildObjectId)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TermProduction(),         ioId, COALESCE (ObjectFloat_TermProduction.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NormInDays(),             ioId, COALESCE (ObjectFloat_NormInDays.ValueData, 2))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(),                  ioId, COALESCE (ObjectFloat_Koeff.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartProductionInDays(),  ioId, COALESCE (ObjectFloat_StartProductionInDays.ValueData, 1))
         FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods
              LEFT JOIN (SELECT inGoodsId AS GoodsId
                              , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                END AS ReceiptId_basis
                              , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_0.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_1.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_2.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_3.ObjectId
                                END AS ReceiptId
                         FROM ObjectLink AS ObjectLink_Receipt_Goods
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                   AND ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                   ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                   ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_1.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                   ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_2.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                   ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_3.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId = zc_ObjectLink_Receipt_GoodsKind()

                         WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                           AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        ) AS tmp ON tmp.GoodsId = inGoodsId


                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_basis
                                             ON ObjectLink_Receipt_Goods_basis.ObjectId = tmp.ReceiptId_basis
                                            AND ObjectLink_Receipt_Goods_basis.DescId = zc_ObjectLink_Receipt_Goods()

                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                             ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                            AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                             ON ObjectLink_OrderType_Goods.ChildObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                            AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Koeff
                                              ON ObjectFloat_Koeff.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_Koeff.DescId = CASE vbMonth WHEN 1 THEN zc_ObjectFloat_OrderType_Koeff1()
                                                                                         WHEN 2 THEN zc_ObjectFloat_OrderType_Koeff2()
                                                                                         WHEN 3 THEN zc_ObjectFloat_OrderType_Koeff3()
                                                                                         WHEN 4 THEN zc_ObjectFloat_OrderType_Koeff4()
                                                                                         WHEN 5 THEN zc_ObjectFloat_OrderType_Koeff5()
                                                                                         WHEN 6 THEN zc_ObjectFloat_OrderType_Koeff6()
                                                                                         WHEN 7 THEN zc_ObjectFloat_OrderType_Koeff7()
                                                                                         WHEN 8 THEN zc_ObjectFloat_OrderType_Koeff8()
                                                                                         WHEN 9 THEN zc_ObjectFloat_OrderType_Koeff9()
                                                                                         WHEN 10 THEN zc_ObjectFloat_OrderType_Koeff10()
                                                                                         WHEN 11 THEN zc_ObjectFloat_OrderType_Koeff11()
                                                                                         WHEN 12 THEN zc_ObjectFloat_OrderType_Koeff12()
                                                                            END
                                             AND ObjectFloat_Koeff.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                              ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
                                             AND ObjectFloat_TermProduction.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                              ON ObjectFloat_NormInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays() 
                                             AND ObjectFloat_NormInDays.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                                              ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays() 
                       ;
     END IF;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementItemFloat (inDescId_Param, ioId, inAmount_Param);
     -- сохранили свойство
     IF inDescId_ParamOrder <> 0
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamOrder, ioId, inAmount_ParamOrder);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.06.15                                        * all
 02.03.15         *
*/

-- тест
-- SELECT * FROM lpUpdate_MI_OrderInternal_Property (ioId:= 10696633, inMovementId:= 869524, inGoodsId:= 7402,  inGoodsKindId := 8328 , inAmount:= 45::TFloat, inAmountParam:= 777::TFloat, inDescCode:= 'zc_MIFloat_AmountRemains'::TVarChar, inSession:= lpCheckRight ('5', zc_Enum_Process_InsertUpdate_MI_OrderExternal()))
