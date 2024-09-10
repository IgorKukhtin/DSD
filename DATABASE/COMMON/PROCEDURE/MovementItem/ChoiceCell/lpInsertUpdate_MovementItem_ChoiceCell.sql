-- Function: lpInsertUpdate_MovementItem_ChoiceCell()
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ChoiceCell (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ChoiceCell(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <>
    IN inChoiceCellId        Integer   , --
    IN inGoodsId             Integer   ,
    IN inGoodsKindId         Integer   ,
    IN inPartionGoodsDate    TDateTime ,
    IN inPartionGoodsDate_next TDateTime ,
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- Проверка
     IF EXISTS (SELECT lpSelect.MovementItemId
                FROM lpSelect_Movement_ChoiceCell_mi (inUserId) AS lpSelect
                WHERE lpSelect.GoodsId     = inGoodsId
                  AND lpSelect.GoodsKindId = inGoodsKindId
                  AND lpSelect.MovementItemId <> COALESCE (ioId, 0)
               )
     THEN
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), lpSelect.MovementItemId, FALSE)
                 -- сохранили связь с <>
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), lpSelect.MovementItemId, inUserId)
                 -- сохранили свойство <>
               , lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), lpSelect.MovementItemId, CURRENT_TIMESTAMP)

         FROM -- снимаем предыдущие Места отбора для хранения 
              (SELECT lpSelect.MovementItemId
               FROM lpSelect_Movement_ChoiceCell_mi (inUserId) AS lpSelect
               WHERE lpSelect.GoodsId     = inGoodsId
                 AND lpSelect.GoodsKindId = inGoodsKindId
              ) AS lpSelect;

         /*RAISE EXCEPTION 'Ошибка.%Для партии <%> <%> %ячейка = <%> %уже установлен признак <Снять с хранения>.%'
                        , CHR (13)
                        , lfGet_Object_ValueData (inGoodsId)
                        , lfGet_Object_ValueData_sh (inGoodsKindId)
                        , CHR (13)
                        , lfGet_Object_ValueData_sh (inChoiceCellId)
                        , CHR (13)
                        , CHR (13)
                        , (SELECT lpSelect.MovementItemId
                         ;*/
     END IF;

     -- Проверка
     IF COALESCE (inGoodsId, 0) = 0 -- OR inUserId = 602817
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не установлен для Ячейки отбора = <%>.(%)(%)', lfGet_Object_ValueData_sh (inChoiceCellId), inGoodsId, inGoodsKindId;
     END IF;

     -- Проверка
     IF COALESCE (inGoodsKindId, 0) = 0 -- OR inUserId = 602817
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не установлен для Ячейки отбора = <%>.(%)', lfGet_Object_ValueData_sh (inChoiceCellId), inGoodsKindId;
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inChoiceCellId, inMovementId, 0, NULL);
     


     -- сохранили связь с <товар>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     --
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
     --
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_next(), ioId, inPartionGoodsDate_next);
     -- Отметили что ждет по этому товару перемещение из места хранения
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Checked(), ioId, TRUE);

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


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.24         *
*/

-- тест
--