-- Function: gpInsertUpdate_MI_OrderIncome()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderIncome (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderIncome(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioMeasureId           Integer   , -- 
   OUT outMeasureName        TVarChar  , -- 
    IN inAmount              TFloat    , -- Количество
 INOUT ioCountForPrice       TFloat    , -- 
    IN inPrice               TFloat    , -- 
  OUT outAmountSumm          TFloat    , -- Сумма расчетная
 INOUT ioGoodsId             Integer   , -- Товар
   OUT outGoodsName          TVarChar  , -- 
    IN inAssetId             Integer   ,
    IN inUnitId              Integer   ,
    IN inNameBeforeName      TVarChar  ,
    IN inComment             TVarChar ,   -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbNameBeforeId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderIncome());


     -- замена
     inNameBeforeName:= COALESCE (TRIM (inNameBeforeName), '');
     -- проверка
     IF COALESCE (ioGoodsId, 0) = 0 AND inNameBeforeName = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Название (Товар/ОС/Работы)> или <Товар>.';
     END IF;

     -- замена
     IF ioGoodsId > 0 AND inNameBeforeName <> (SELECT ValueData FROM Object WHERE Id = ioGoodsId)
     THEN
         ioGoodsId:= 0;
     END IF;
     outGoodsName:= (SELECT ValueData FROM Object WHERE Id = ioGoodsId);
     -- замена
     IF COALESCE (ioMeasureId, 0) = 0
     THEN
         ioMeasureId:= zc_Measure_Sht();
     END IF;
     outMeasureName:= (SELECT ValueData FROM Object WHERE Id = ioMeasureId);
     -- замена
     IF COALESCE (ioCountForPrice, 0) = 0
     THEN
         ioCountForPrice:= 1;
     END IF;
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), ioMeasureId, inMovementId, inAmount, NULL);


     -- если надо ...
     IF COALESCE (ioGoodsId, 0) = 0 AND inNameBeforeName <> ''
     THEN 
         -- ищем Товар/ОС/работы
         vbNameBeforeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_NameBefore() AND Object.ValueData = inNameBeforeName);
     END IF;
     -- если надо ...
     IF COALESCE (ioGoodsId, 0) = 0 AND COALESCE (vbNameBeforeId, 0) = 0 AND inNameBeforeName <> ''
     THEN
         -- сохранение
         vbNameBeforeId:= gpInsertUpdate_Object_NameBefore   (ioId              := 0
                                                            , inCode            := lfGet_ObjectCode (0, zc_Object_NameBefore()) 
                                                            , inName            := inNameBeforeName
                                                            , inSession         := inSession
                                                             );
     END IF;



     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, ioGoodsId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NameBefore(), ioId, vbNameBeforeId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inPrice AS NUMERIC (16, 2))
                      END;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.07.15         *
*/

-- тест
-- 