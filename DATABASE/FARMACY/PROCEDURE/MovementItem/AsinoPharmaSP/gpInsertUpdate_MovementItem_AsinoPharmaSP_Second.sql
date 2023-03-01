-- Function: gpInsertUpdate_MovementItem_AsinoPharmaSP_Second ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_AsinoPharmaSP_Second (Integer, Integer, Integer, TFloat, Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_AsinoPharmaSP_Second(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inGoodsId             Integer   , -- Главный товар
    IN inAmount              TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
 )
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверяем может такой товар уже есть
    IF EXISTS(SELECT 1
              FROM MovementItem
              WHERE MovementItem.DescId = zc_MI_Second()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.ParentId = inParentId
                AND MovementItem.Id <> COALESCE (ioId, 0)
                AND MovementItem.ObjectId = inGoodsId) 
    THEN
      RAISE EXCEPTION 'Ошибка.Товар <%> уже использован в подарках .', lfGet_Object_ValueData (inGoodsId);
    END IF;  
    
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Second(), inGoodsId, inMovementId, inAmount, inParentId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.23                                                       *
*/

-- select * from gpInsertUpdate_MovementItem_AsinoPharmaSP_Second(ioId := 0 , inMovementId := 31198092 , inParentId := 579203891 , inGoodsId := 1005720 , inAmount := 1 ,  inSession := '3');