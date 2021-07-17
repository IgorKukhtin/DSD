 -- Function: gpUpdate_MI_Income_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_Price (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_Price(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inOperPrice             TFloat    , -- Цена (со скидкой)
    IN inOperPriceList         TFloat    , -- Цена по прайсу (со скидкой)
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId       Integer;
--   DECLARE vbOperPriceList_old TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());


     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inOperPriceList, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Цена продажи>.';
     END IF;

     -- Запомнили !!!ДО изменений!!!
     --vbOperPriceList_old:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_OperPriceList());

     -- Поиск Товара текущего Элемента
     vbGoodsId = (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inId);
     
     -- ВСЕ строки с выбранным товаром
     CREATE TEMP TABLE _tmpMI (Id Integer) ON COMMIT DROP;    
     INSERT INTO _tmpMI ( Id )
            SELECT MovementItem.Id
            FROM MovementItem
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.ObjectId   = vbGoodsId
              AND MovementItem.isErased   = FALSE; 
     
     -- сохранили свойства ВСЕХ строк документа приход с текущим товаром 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), _tmpMI.Id, inOperPrice)               -- сохранили свойство <Цена прихода >
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), _tmpMI.Id, inOperPriceList)       -- сохранили свойство <Цена продажи >
     FROM _tmpMI;

     -- сохранили свойства ВСЕХ строк документа приход с текущим товаром 
     IF NOT EXISTS (SELECT 1 FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent() AND MF.ValueData <> 0)
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceJur(), _tmpMI.Id, inOperPrice)               -- сохранили свойство <Цена прихода >
         FROM _tmpMI;
     END IF;
     
     -- Здесь еще Update - Object_PartionGoods.OperPriceList
     PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := NULL                  -- сам найдет нужный Id
                                                           , inPriceListId:= zc_PriceList_Basis()  -- !!!Базовый Прайс!!!
                                                           , inGoodsId    := vbGoodsId
                                                           , inOperDate   := zc_DateStart()
                                                           , inValue      := inOperPriceList
                                                           , inIsLast     := TRUE
                                                           , inIsDiscountDelete:= FALSE
                                                           , inSession    := vbUserId :: TVarChar
                                                            );

     -- !!! ДА !!! изменили цены в партиях - по значению <Ключ партии>
     UPDATE Object_PartionGoods
            SET OperPrice            = inOperPrice
     --       , OperPriceList        = inOperPriceList
     WHERE Object_PartionGoods.MovementItemId IN (SELECT _tmpMI.Id FROM _tmpMI);


     -- 1.1. дальше перепроводим все док. где эта партия участвовала
     PERFORM CASE WHEN Movement.DescId = zc_Movement_Sale() THEN gpReComplete_Movement_Sale (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_Inventory() THEN gpReComplete_Movement_Inventory (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_ReturnOut() THEN gpReComplete_Movement_ReturnOut (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_Send() THEN gpReComplete_Movement_Send (Movement.Id, inSession)
                  WHEN Movement.DescId = zc_Movement_Loss() THEN gpReComplete_Movement_Loss (Movement.Id, inSession)
             END
     FROM MovementItem
          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                             -- !!!только НЕ Приход от постав.!!!
                             AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_Inventory(), zc_Movement_ReturnOut(), zc_Movement_Send(), zc_Movement_Loss())
     WHERE MovementItem.PartionId IN (SELECT _tmpMI.Id FROM _tmpMI)
       AND MovementItem.isErased = FALSE -- !!!только НЕ удаленные!!!
       -- AND MovementItem.DescId= ...   -- !!!любой Desc!!!
     ORDER BY Movement.OperDate, Movement.Id;

     -- 1.2. дальше перепроводим все док. где эта партия участвовала
     PERFORM CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN gpReComplete_Movement_ReturnIn (Movement.Id, inSession)
             END
     FROM MovementItem
          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                             AND Movement.DescId   = zc_Movement_ReturnIn()
     WHERE MovementItem.PartionId IN (SELECT _tmpMI.Id FROM _tmpMI)
       AND MovementItem.isErased = FALSE -- !!!только НЕ удаленные!!!
       -- AND MovementItem.DescId= ...   -- !!!любой Desc!!!
     ORDER BY Movement.OperDate, Movement.Id;

     -- 1.3. дальше перепроводим все док. где эта партия участвовала
     PERFORM CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN gpReComplete_Movement_GoodsAccount (Movement.Id, inSession)
             END
     FROM MovementItem
          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete() -- !!!только проведенные!!!
                             AND Movement.DescId   = zc_Movement_GoodsAccount()
     WHERE MovementItem.PartionId IN (SELECT _tmpMI.Id FROM _tmpMI)
       AND MovementItem.isErased = FALSE -- !!!только НЕ удаленные!!!
       -- AND MovementItem.DescId= ...   -- !!!любой Desc!!!
     ORDER BY Movement.OperDate, Movement.Id;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (_tmpMI.Id, vbUserId, FALSE)
     FROM _tmpMI;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Полятыкин А.А.
 29.10.18         *
*/

-- тест
-- 