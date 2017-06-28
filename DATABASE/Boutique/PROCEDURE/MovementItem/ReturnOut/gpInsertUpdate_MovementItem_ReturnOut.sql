-- Function: gpInsertUpdate_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товар
    IN inPartionId           Integer   , -- Партия
    IN inAmount              TFloat    , -- Количество
   OUT outOperPrice          TFloat    , -- Цена
   OUT outCountForPrice      TFloat    , -- Цена за количество
   OUT outTotalSumm          TFloat    , -- Сумма вх.
   OUT outTotalSummBalance   TFloat    , -- Сумма вх. (ГРН)
 INOUT ioOperPriceList       TFloat    , -- Цена (прайс)
   OUT outTotalSummPriceList TFloat    , -- Сумма (прайс)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnOut());

     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;


     -- Цена (прайс)
     IF ioOperPriceList <> 0
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF vbUserId <> zfCalc_UserAdmin() :: Integer THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
     ELSE
         -- из Истории
         ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                                                   , zc_PriceList_Basis()
                                                                                                   , inGoodsId
                                                                                                    ) AS tmp), 0);
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Цена (прайс)>.';
     END IF;


     -- данные из партии : OperPrice и CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice, 1) AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)     AS OperPrice
            INTO outCountForPrice, outOperPrice
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;


     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_ReturnOut (ioId              := ioId
                                                 , inMovementId      := inMovementId
                                                 , inGoodsId         := inGoodsId
                                                 , inPartionId       := inPartionId
                                                 , inAmount          := inAmount
                                                 , inOperPrice       := outOperPrice
                                                 , inCountForPrice   := outCountForPrice
                                                 , inOperPriceList   := ioOperPriceList
                                                 , inUserId          := vbUserId
                                                  );

     -- расчитали <Сумма вх.> для грида
     outTotalSumm := CASE WHEN outCountForPrice > 0
                                THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                      END;
     -- расчитали <Сумма вх. (ГРН)> для грида
     outTotalSummBalance := (SELECT CASE WHEN MLO_CurrencyDocument.ObjectId = zc_Currency_Basis()
                                              THEN outTotalSumm
                                         ELSE CAST (CASE WHEN MF_ParValue.ValueData > 0 THEN outTotalSumm * MF_CurrencyValue.ValueData / MF_ParValue.ValueData ELSE outTotalSumm * MF_CurrencyValue.ValueData
                                                    END AS NUMERIC (16, 2))
                                    END
                             FROM MovementLinkObject AS MLO_CurrencyDocument
                                  LEFT JOIN MovementFloat AS MF_CurrencyValue
                                                          ON MF_CurrencyValue.MovementId = MLO_CurrencyDocument.MovementId
                                                         AND MF_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
                                  LEFT JOIN MovementFloat AS MF_ParValue
                                                          ON MF_ParValue.MovementId = MLO_CurrencyDocument.MovementId
                                                         AND MF_ParValue.DescId     = zc_MovementFloat_ParValue()
                             WHERE MLO_CurrencyDocument.MovementId = inMovementId
                               AND MLO_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
                            );
     -- расчитали <Сумма (прайс)> для грида
     outTotalSummPriceList := CAST (inAmount * ioOperPriceList AS NUMERIC (16, 2));
     

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.17         *
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnOut(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 ,  inSession := '2');
