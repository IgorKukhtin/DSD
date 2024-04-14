-- Function: gpInsertUpdate_MI_Invoice_Edit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Invoice_Edit (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Invoice_Edit(
 INOUT ioId                  Integer   , -- Ключ объекта <>
    IN inMovementId          Integer   , -- Ключ объекта <>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , --
    IN inSummMVAT            TFloat    , --
    IN inSummPVAT            TFloat    , --     
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbIsInsert          Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Invoice());
     vbUserId := lpGetUserBySession (inSession);

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_Invoice (ioId
                                                , inMovementId
                                                , inGoodsId
                                                , inAmount
                                                , inOperPrice 
                                                , inSummMVAT
                                                , inSummPVAT
                                                , inComment
                                                , vbUserId
                                                );


     --формировать сумму с ндс автоматом и записывать в zc_MovementFloat_Amount
     PERFORM lpInsertUpdate_Movement_Invoice_Amount (inMovementId, vbUserId);
     
     -- пересчитали Итоговые суммы по накладной
     --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.24         *
*/

-- тест
--