-- Function: lpInsertUpdate_MI_ProductionUnionTech_Master()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnionTech_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inCount	             TFloat    , -- Количество батонов или упаковок 
    IN inCountReal           TFloat    , -- Количество шт. факт только для схемы "Тушенка"
    IN inRealWeight          TFloat    , -- Фактический вес(информативно)
    IN inRealWeightMsg       TFloat    , -- Фактический вес(после массажера)
    IN inRealWeightShp       TFloat    , -- Фактический вес(после шприцевания)
    IN inCuterCount          TFloat    , -- Количество кутеров
    IN inCuterWeight         TFloat    , -- Вес п/ф факт(куттер) 
    IN inAmountForm          TFloat    , -- кол-во формовка+1день,кг
    IN inAmountForm_two      TFloat    , -- кол-во формовка+2день,кг
    IN inComment             TVarChar  , -- Примечание
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inReceiptId           Integer   , -- Рецептуры
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean;
BEGIN
   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

   -- сохранили связь с <Рецептуры>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), ioId, inReceiptId);
   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили связь с <Виды товаров ГП>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

   -- сохранили свойство <партия закрыта (да/нет)>
   -- PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_PartionClose(), ioId, inPartionClose);

   -- сохранили свойство <Примечание>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

   -- сохранили свойство <Количество батонов>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);

   -- сохранили свойство <Количество шт. факт только для схемы "Тушенка">
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountReal(), ioId, inCountReal);

   -- сохранили свойство <Фактический вес(информативно)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
   -- сохранили свойство <Количество кутеров>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCount(), ioId, inCuterCount);
   -- сохранили свойство <Вес п/ф факт(куттер)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterWeight(), ioId, inCuterWeight);

   -- сохранили свойство <кол-во формовка+1день,кг>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForm(), ioId, inAmountForm);
   -- сохранили свойство <кол-во формовка+2день,кг>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForm_two(), ioId, inAmountForm_two);


   -- закріть доступ корректировки взвешиваний после массажера и  после шприцевания определенным лицам: Гриневич Е. + Пронько Л.
   IF inUserId IN (9031170, 954882)
      -- Ограничение 7 дней пр-во (Гриневич)
      OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  AS UserRole_View WHERE UserRole_View.UserId = inUserId AND UserRole_View.RoleId = 11841068)
   THEN
       IF inRealWeightMsg <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_RealWeightMsg()), 0)
       THEN
           RAISE EXCEPTION 'Ошибка.Нет прав изменять значение <%> %с <%> на <%>'
                         , (SELECT MovementItemFloatDesc.ItemName FROM MovementItemFloatDesc WHERE MovementItemFloatDesc.Id = zc_MIFloat_RealWeightMsg())
                         , CHR (13)
                         , zfConvert_FloatToString (COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_RealWeightMsg()), 0))
                         , zfConvert_FloatToString (inRealWeightMsg)
                            ;
       END IF;

       IF inRealWeightShp <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_RealWeightShp()), 0)
       THEN
           RAISE EXCEPTION 'Ошибка.Нет прав изменять значение <%> %с <%> на <%>'
                         , (SELECT MovementItemFloatDesc.ItemName FROM MovementItemFloatDesc WHERE MovementItemFloatDesc.Id = zc_MIFloat_RealWeightShp())
                         , CHR (13)
                         , zfConvert_FloatToString (COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_RealWeightShp()), 0))
                         , zfConvert_FloatToString (inRealWeightShp)
                            ;
       END IF;

   ELSE
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeightMsg(), ioId, inRealWeightMsg);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeightShp(), ioId, inRealWeightShp);
   END IF;


   IF vbIsInsert = TRUE
   THEN
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
   ELSE
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
   END IF;

   -- пересчитали Итоговые суммы по накладной
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.25         * inAmountForm_two
 30.07.24         * inAmountForm
 25.10.23         *
 13.09.22         * inCountReal
 02.12.20         *
 21.03.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnionTech_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
