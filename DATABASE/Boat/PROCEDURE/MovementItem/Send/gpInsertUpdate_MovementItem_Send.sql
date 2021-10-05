-- Function: gpInsertUpdate_MovementItem_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , -- Цена со скидкой
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inPartNumber          TVarChar  , --№ по тех паспорту
    IN inComment             TVarChar  , --
    IN inIsOn                Boolean   , -- вкл
   OUT outIsErased           Boolean   , -- удален
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Send());
     vbUserId := lpGetUserBySession (inSession);


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- замена
     IF vbIsInsert = TRUE THEN inIsOn:= TRUE; END IF;

     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE)
     THEN
         -- надо восстановить
         outIsErased := gpMovementItem_Send_SetUnErased (ioId, inSession);
     ENd IF;


     -- сохранили <Элемент документа>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MovementItem_Send (ioId
                                          , inMovementId
                                          , inGoodsId
                                          , inAmount
                                          , inOperPrice
                                          , inCountForPrice
                                          , inPartNumber
                                          , inComment
                                          , vbUserId
                                          ) AS tmp;
     
     -- (разделила т.к. если внесут еще какие-то изменения в строку то ощибка что элемент удален)
     IF COALESCE (inIsOn, FALSE) = FALSE
     THEN
         --ставим отметку об удалении 
         outIsErased := gpMovementItem_Send_SetErased (ioId, inSession);
     ENd IF;


     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.21         *
 23.06.21         *
*/

-- тест
--