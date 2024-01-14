-- Function: gpInsertUpdate_MovementItem_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_BankAccount_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <> 
    IN inParentId            Integer   ,
    IN inMovementId          Integer   , 
    IN inMovementId_invoice  Integer   , -- 
    IN inObjectId            Integer   , -- 
    IN inAmount              TFloat    , -- 
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Invoice());
     vbUserId := lpGetUserBySession (inSession);

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MI_BankAccount_Child (ioId
                                                , inParentId
                                                , inMovementId
                                                , inMovementId_invoice
                                                , inObjectId
                                                , inAmount
                                                , inComment
                                                , vbUserId
                                                 );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.24         *
*/

-- тест
--