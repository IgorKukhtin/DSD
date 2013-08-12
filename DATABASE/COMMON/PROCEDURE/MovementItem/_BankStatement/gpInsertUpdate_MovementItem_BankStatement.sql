-- Function: gpInsertUpdate_MovementItem_BankStatement()

-- DROP FUNCTION gpInsertUpdate_MovementItem_BankStatement();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_BankStatement(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inAmount              TFloat    , -- Сумма операции
    IN inOKPO                TVarChar  , -- ОКПО
    IN inInfoMoneyId         Integer   , -- Управленческие статьи
    IN inContractId          Integer   , -- Договор
    IN inUnitId              Integer   , -- Подразделение 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_BankStatement());
     vbUserId := inSession;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   
     -- сохранили свойство <ОКПО>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_OKPO(), ioId, inOKPO);

     -- сохранили связь с <Управленческие статьи>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);     

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_BankStatement (ioId:= 0, inMovementId:= 10, inAmount:= 0, , inSession:= '2')
