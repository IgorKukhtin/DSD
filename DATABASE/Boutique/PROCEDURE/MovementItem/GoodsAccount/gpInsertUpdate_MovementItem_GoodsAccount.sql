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
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяем Партию элемента продажи/возврата
     vbPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);


     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inSaleMI_Id, 0) = 0 AND  vbUserId <> zc_User_Sybase() THEN
        RAISE EXCEPTION 'Ошибка.Не определен элемент Продажи.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF inAmount < 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Кол-во>.';
     END IF;
     -- проверка - Уникальный vbPartionMI_Id
     IF EXISTS (SELECT 1 FROM MovementItem AS MI INNER JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_PartionMI() AND MILO.ObjectId = vbPartionMI_Id WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Id <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION 'Ошибка.В документе уже есть Товар <% %> р.<%>.Дублирование запрещено.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                       ;
     END IF;


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

     -- расчитали Итого оплата для грида
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

         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     ELSE
         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
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
