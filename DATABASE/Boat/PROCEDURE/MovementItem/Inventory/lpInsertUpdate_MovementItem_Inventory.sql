-- Function: lpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                         Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                            Integer   , -- Товары
 INOUT ioAmount                             TFloat    , -- Количество
    IN inTotalCount                         TFloat    , -- Количество Итого
 INOUT ioPrice                              TFloat    , -- Цена
   OUT outAmountSumm                        TFloat    , -- Сумма расчетная
    IN inPartNumber                         TVarChar  , --
    IN inComment                            TVarChar  , -- примечание
    IN inUserId                             Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId   Integer;
BEGIN
     -- замена
     ioPrice:= (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inGoodsId, inUserId) AS lpGet);

     -- определяются параметры из документа
     -- vbUnitId:= (SELECT MLO_Unit.ObjectId FROM MovementLinkObject AS MLO_Unit WHERE MLO_Unit.MovementId = inMovementId AND MLO_Unit.DescId = zc_MovementLinkObject_Unit());

     -- нужен ПОИСК
     IF ioId < 0
     THEN
         -- Проверка
         IF 1 < (SELECT COUNT(*)
                 FROM MovementItem AS MI
                      LEFT JOIN MovementItemString AS MIString_PartNumber
                                                   ON MIString_PartNumber.MovementItemId = MI.Id
                                                  AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                 WHERE MI.MovementId = inMovementId
                   AND MI.DescId     = zc_MI_Master()
                   AND MI.ObjectId   = inGoodsId
                   AND MI.isErased   = FALSE
                   AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                )
         THEN
             RAISE EXCEPTION 'Ошибка.Найдено дублирование <Строка>%<%><%>.', CHR (13), lfGet_Object_ValueData (inGoodsId), inPartNumber;
         END IF;

         -- нашли
         ioId:= (SELECT MI.Id FROM MovementItem AS MI
                             LEFT JOIN MovementItemString AS MIString_PartNumber
                                                          ON MIString_PartNumber.MovementItemId = MI.Id
                                                         AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                 WHERE MI.MovementId = inMovementId
                   AND MI.DescId     = zc_MI_Master()
                   AND MI.ObjectId   = inGoodsId
                   AND MI.isErased   = FALSE
                   AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                );
         -- 

         --могут ввести Итого количество, тогда его сохраняем, иначе + к сохраненному количеству
         IF COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId), 0) <> inTotalCount
         THEN
             ioAmount := inTotalCount;
         ELSE 
             ioAmount:= ioAmount + COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId), 0);
         END IF;

     END IF;


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, ioAmount, NULL, inUserId);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE (ioPrice, 0));

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
     -- сохранили свойство <примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CAST(ioAmount * ioPrice AS NUMERIC (16, 2));


     -- Проверка
     IF 1 < (SELECT COUNT(*)
             FROM MovementItem AS MI
                  LEFT JOIN MovementItemString AS MIString_PartNumber
                                               ON MIString_PartNumber.MovementItemId = MI.Id
                                              AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
             WHERE MI.MovementId = inMovementId
               AND MI.DescId     = zc_MI_Master()
               AND MI.ObjectId   = inGoodsId
               AND MI.isErased   = FALSE
               AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
            )
     THEN
         RAISE EXCEPTION 'Ошибка.Найдено дублирование <Строка>%<%><%>.', CHR (13), lfGet_Object_ValueData (inGoodsId), inPartNumber;
     END IF;

    -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.22         *
*/

-- тест
--