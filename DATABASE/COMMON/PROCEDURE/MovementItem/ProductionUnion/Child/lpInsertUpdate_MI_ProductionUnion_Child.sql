 -- Function: lpInsertUpdate_MI_ProductionUnion_Child()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Производство - смешивание>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inParentId            Integer   , -- Главный элемент документа
    IN inPartionGoodsDate    TDateTime , -- Партия товара	
    IN inPartionGoods        TVarChar  , -- Партия товара        
    IN inGoodsKindId         Integer   , -- Виды товаров            
    IN inCount_onCount       TFloat    , -- Количество батонов
    IN inUserId              Integer     -- пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определён элемент прихода.';
   END IF;

   -- меняем параметр
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId           := ioId
                                      , inDescId       := zc_MI_Child()
                                      , inObjectId     := inGoodsId
                                      , inMovementId   := inMovementId
                                      , inAmount       := inAmount
                                      , inParentId     := inParentId
                                      , inUserId       := inUserId
                                       );
  
   -- сохранили свойство <Партия товара>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   -- сохранили свойство <Партия товара>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
   
   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

   -- сохранили свойство <Количество батонов>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioId, inCount_onCount);

   -- !!!только при создании!!!
   IF vbIsInsert = TRUE AND inUserId IN (zc_Enum_Process_Auto_PartionDate(), zc_Enum_Process_Auto_PartionClose())
   THEN
       PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, TRUE);
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
 11.07.15                                        * add inUserId:=
 05.07.15                                        * add inCount_onCount
 21.03.15                                        * all
 11.12.14         * из gp
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnion_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
