-- Function: gpInsertUpdate_MI_BankAccount_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Detail (Integer, Integer, Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_BankAccount_Detail(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inInfoMoneyId         Integer   , -- 
    IN inAmount              TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

       -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inInfoMoneyId, inMovementId, inAmount, NULL);

        -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

    /* if vbUserId = 9457 --AND 1=1 -- OR  inMovementId = 15504781
     then
         RAISE EXCEPTION 'Test. Ok';
     end if;
    */
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.24         *
*/

-- тест
-- 