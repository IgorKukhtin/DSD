-- Function: gpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                Integer   , -- Товары
    IN inPartionId              Integer   , -- Партия
    IN inPartionMI_Id           Integer   , -- Партия элемента продажа/возврат
    IN inSaleMI_Id              Integer   , -- строка док. продажи
    IN inisPay                  Boolean   , -- добавить с оплатой
    IN inAmount                 TFloat    , -- Количество
   OUT outOperPrice             TFloat    , -- Цена
   OUT outCountForPrice         TFloat    , -- Цена за количество
   OUT outAmountSumm            TFloat    , -- Сумма расчетная
   OUT outOperPriceList         TFloat    , -- Цена по прайсу
   OUT outAmountPriceListSumm   TFloat    , -- Сумма по прайсу
   OUT outCurrencyValue         TFloat    , -- 
   OUT outParValue              TFloat    , -- 
   OUT outSummChangePercent     TFloat    , -- 
   OUT outTotalPay              TFloat    , -- 
   OUT outTotalSummPay          TFloat    , -- 
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbDiscountGoodsAccountKindId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbClientId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());

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

     -- данные из шапки
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
    INTO vbOperDate, vbClientId
     FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

     -- цена продажи из прайса 
     outOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem(vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);

     -- данные из партии : OperPrice и CountForPrice
     SELECT COALESCE (Object_PartionGoods.CountForPrice,1)
          , COALESCE (Object_PartionGoods.OperPrice,0)
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis())
    INTO outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;
     
    IF vbCurrencyId <> zc_Currency_Basis() THEN
        SELECT COALESCE (tmp.Amount,1) , COALESCE (tmp.ParValue,0)
       INTO outCurrencyValue, outParValue
        FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDate, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= vbCurrencyId ) AS tmp;
    END IF;
    outCurrencyValue := COALESCE(outCurrencyValue,1);
    outParValue      := COALESCE(outParValue,0);

    -- определяем скидку
  /*  SELECT tmp.ChangePercent, tmp.DiscountGoodsAccountKindId, tmp.DiscountGoodsAccountKindName
   INTO outChangePercent, vbDiscountGoodsAccountKindId, outDiscountGoodsAccountKindName
    FROM zfSelect_DiscountGoodsAccountKind (vbOperDate, vbUnitId, inGoodsId, vbClientId, vbUserId) AS tmp;
*/
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

     --outTotalChangePercent := outAmountPriceListSumm / 100 * COALESCE(outChangePercent,0) + COALESCE(inSummChangePercent,0) ;

     outTotalSummPay := COALESCE(outAmountPriceListSumm,0) - COALESCE(outTotalChangePercent,0) ;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_GoodsAccount   (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inGoodsId            := inGoodsId
                                                      , inPartionId          := COALESCE(inPartionId,0)
                                                      , inPartionMI_Id       := COALESCE(inPartionMI_Id,0)
                                                      , inSaleMI_Id          := COALESCE(inSaleMI_Id,0)
                                                      , inAmount             := inAmount
                                                      , inSummChangePercent     := COALESCE(outSummChangePercent,0)    ::TFloat     
                                                      , inTotalPay              := COALESCE(outTotalPay,0)              ::TFloat              
                                                      , inUserId                := vbUserId
                                               );

    IF inisPay THEN
       
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.17         *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_GoodsAccount(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');