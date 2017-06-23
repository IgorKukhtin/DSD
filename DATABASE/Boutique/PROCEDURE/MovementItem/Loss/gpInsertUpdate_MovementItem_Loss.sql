-- Function: gpInsertUpdate_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpinsertupdate_movementitem_loss (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loss (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loss(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inPartionId           Integer   , -- Партия
    IN inAmount              TFloat    , -- Количество
   OUT outCountForPrice      TFloat    , -- Цена за количество
   OUT outOperPrice          TFloat    , -- Цена
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
   OUT outOperPriceList      TFloat    , -- Цена по прайсу
   OUT outAmountPriceListSumm TFloat    , -- Сумма по прайсу
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Loss());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     -- 
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- цена продажи из прайса 
     outOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem(vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);
     -- данные из партии : OperPrice и CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice,1)
          , COALESCE (Object_PartionGoods.OperPrice,0)
    INTO outCountForPrice, outOperPrice
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

     -- Заменили свойство <Цена за количество>
     --IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);
      
     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- сохранили свойство <Цена за количество>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, outOperPriceList);


     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN outCountForPrice > 0
                                THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                      END;
     -- расчитали сумму по прайсу по элементу, для грида
     outAmountPriceListSumm := CASE WHEN outCountForPrice > 0
                                         THEN CAST (inAmount * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * outOperPriceList AS NUMERIC (16, 2))
                               END;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.04.17         *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_Loss(ioId := 56 , inMovementId := 17 , inGoodsId := 446 , inPartionId := 50 , inAmount := 3 , ioCountForPrice := 1 , inOperPrice := 100 ,  inSession := '2');