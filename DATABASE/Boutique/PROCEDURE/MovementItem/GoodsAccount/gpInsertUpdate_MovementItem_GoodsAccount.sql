-- Function: gpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                Integer   , -- Товары
    IN inPartionId              Integer   , -- Партия
    IN inPartionMI_Id           Integer   , -- Партия элемента продажа/возврат
    IN inSaleMI_Id              Integer   , -- строка док. продажи
    IN inisPay                  Boolean   , -- добавить с оплатой
    IN inAmount                 TFloat    , -- Количество
    IN inSummChangePercent      TFloat    , -- Сумма дополнительной Скидки (в ГРН)
   OUT outTotalPay              TFloat    , -- 
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

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_GoodsAccount   (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inGoodsId            := inGoodsId
                                                      , inPartionId          := COALESCE(inPartionId,0)
                                                      , inPartionMI_Id       := COALESCE(inPartionMI_Id,0)
                                                      , inSaleMI_Id          := COALESCE(inSaleMI_Id,0)
                                                      , inAmount             := inAmount
                                                      , inSummChangePercent  := inSummChangePercent  
                                                      , inUserId             := vbUserId
                                                     );

    IF inisPay THEN
        -- сохранили оплату
       /*     PERFORM lpInsertUpdate_MI_GoodsAccount_Child  (ioId             := COALESCE (_tmpMI.Id,0)
                                                     , inMovementId         := inMovementId
                                                     , inParentId           := inParentId
                                                     , inCashId             := COALESCE (_tmpCash.CashId, _tmpMI.CashId)
                                                     , inCurrencyId         := COALESCE (_tmpCash.CurrencyId, _tmpMI.CurrencyId)
                                                     , inCashId_Exc         := Null
                                                     , inAmount             := COALESCE (_tmpCash.Amount,0)
                                                     , inCurrencyValue      := COALESCE (_tmpCash.CurrencyValue,1)
                                                     , inParValue           := COALESCE (_tmpCash.ParValue,0)
                                                     , inUserId             := vbUserId
                                                      )
             FROM _tmpCash
*/
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