-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderInternalLoad(Integer, TDateTime, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternalLoad(
    IN inUnitId              Integer   , -- Подразделение
    IN inOperDate            TDateTime , -- Дата
    IN inGoodsCode           TVarChar  , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inSumm                TFloat    , -- Сумма заказа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


     SELECT Movement.Id INTO vbMovementId 
       FROM Movement
            JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       WHERE Movement.StatusId = zc_Enum_Status_UnComplete() AND Movement.DescId = zc_Movement_OrderInternal() AND Movement.OperDate = inOperDate 
         AND MovementLinkObject_Unit.ObjectId = inUnitId;

     IF COALESCE(vbMovementId, 0) = 0 THEN 
        vbMovementId := gpInsertUpdate_Movement_OrderInternal(0, '', inOperDate, inUnitId, inSession);
     END IF;

   SELECT 
         Object_Goods_View.Id INTO vbGoodsId
    FROM Object_Goods_View 
   WHERE Object_Goods_View.ObjectId = vbObjectId AND Object_Goods_View.GoodsCode = inGoodsCode;

   SELECT 
         MovementItem.Id INTO vbMovementItemId
    FROM MovementItem 
   WHERE MovementItem.MovementId = vbMovementId AND MovementItem.ObjectId = vbGoodsId;

   IF COALESCE(vbGoodsId, 0) <> 0 THEN
      vbMovementItemId := lpInsertUpdate_MovementItem_OrderInternal(vbMovementItemId, vbMovementId, vbGoodsId, inAmount, inSumm / inAmount, vbUserId);
      PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_Calculated(), vbMovementItemId, true);
   END IF;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.11.14                        * проверка на StatusId 
 12.09.14                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
