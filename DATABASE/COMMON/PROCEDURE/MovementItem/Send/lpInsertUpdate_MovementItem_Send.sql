-- Function: lpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionGoodsDate    TDateTime , -- Дата партии
    IN inCount               TFloat    , -- Количество батонов или упаковок
    IN inHeadCount           TFloat    , -- Количество голов
 INOUT ioPartionGoods        TVarChar  , -- Партия товара/Инвентарный номер
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров  ГП
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inUnitId              Integer   , -- Подразделение (для МО)
    IN inStorageId           Integer   , -- Место хранения
    IN inPartionGoodsId      Integer   , -- Партии товаров (для партии расхода если с МО)
    IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- чтоб не сохранялись пустые строки
     IF COALESCE (inGoodsId,0) = 0
     THEN
        RETURN;
     END IF;
     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- расчет Инвентарный номер: если Инвентарный номер не установлен и это перемещение на МО
     IF (vbIsInsert = TRUE OR COALESCE (ioPartionGoods, '') = '' OR COALESCE (ioPartionGoods, '0') = '0')
        AND EXISTS (SELECT MovementLinkObject_From.ObjectId
                    FROM MovementLinkObject AS MovementLinkObject_From
                         INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                                         AND Object_From.DescId = zc_Object_Unit()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         INNER JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                                                       AND Object_To.DescId = zc_Object_Member()
                    WHERE MovementLinkObject_From.MovementId = inMovementId
                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From())
     THEN
         ioPartionGoods:= lfGet_Object_PartionGoods_InvNumber (inGoodsId);
     ELSE 
         -- находим Инвентарный номер: если это перемещение с МО на МО
         IF EXISTS (SELECT MovementLinkObject_From.ObjectId
                    FROM MovementLinkObject AS MovementLinkObject_From
                         INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                                         AND Object_From.DescId = zc_Object_Member()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         INNER JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                                                           AND Object_To.DescId = zc_Object_Member()
                    WHERE MovementLinkObject_From.MovementId = inMovementId
                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From())
         THEN
             ioPartionGoods:= (SELECT ValueData FROM Object WHERE Id = inPartionGoodsId);
         END IF;
     END IF;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Дата партии>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- сохранили свойство <Количество упаковок>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCount);

     -- сохранили свойство <Количество голов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, ioPartionGoods);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Виды товаров ГП>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

     -- сохранили связь с <Основные средства (для которых закупается ТМЦ)> - почти не используется, т.к. в приходе от пост. этой партии нет
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     -- сохранили связь с <Подразделение (для МО)> - теперь НЕ надо
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <Место хранения> - для партии прихода на МО
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     
     -- сохранили связь с <Партии товаров (для партии расхода если с МО)> - пока НЕ надо
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), ioId, inPartionGoodsId);


     IF inGoodsId <> 0 AND inGoodsKindId <> 0
     THEN
         -- создали объект <Связи Товары и Виды товаров>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     -- !!! времнно откл.!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.08.17         * add inGoodsKindCompleteId
 29.05.15                                        * set lp
 26.07.14                                        * add inPartionGoodsDate and inUnitId and inStorageId and inPartionGoodsId and ioPartionGoods
 23.05.14                                                       *
 18.07.13         * add inAssetId
 16.07.13                                        * del params by SendOnPrice
 12.07.13         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
