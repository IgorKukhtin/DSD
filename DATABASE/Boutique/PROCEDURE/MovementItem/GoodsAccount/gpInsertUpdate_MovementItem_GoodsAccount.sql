-- Function: gpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inPartionId              Integer   , -- Партия
    IN inSaleMI_Id              Integer   , -- Партия элемента продажа/возврат
    IN inIsPay                  Boolean   , -- добавить с оплатой
    IN inAmount                 TFloat    , -- Количество
   OUT outTotalPay              TFloat    , -- 
    IN inComment                TVarChar  , -- примечание
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionMI_Id Integer;
   DECLARE vbGoodsId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());


     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;


     -- определяем Партию элемента продажи/возврата
     vbPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);

     -- данные из партии : GoodsId
     vbGoodsId:= (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId);
    
    
     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_GoodsAccount (ioId                 := ioId
                                                    , inMovementId         := inMovementId
                                                    , inGoodsId            := vbGoodsId
                                                    , inPartionId          := COALESCE (inPartionId, 0)
                                                    , inPartionMI_Id       := COALESCE (vbPartionMI_Id, 0)
                                                    , inAmount             := inAmount
                                                    , inComment            := COALESCE (inComment,'') :: TVarChar 
                                                    , inUserId             := vbUserId
                                                     );

    IF inIsPay = TRUE THEN
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
-- SELECT * FROM gpInsertUpdate_MovementItem_GoodsAccount (ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');
