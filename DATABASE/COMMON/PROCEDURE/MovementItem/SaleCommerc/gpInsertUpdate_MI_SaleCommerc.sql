-- Function: gpInsertUpdate_MI_SaleCommerc()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SaleCommerc (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SaleCommerc(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
    IN inContractId           Integer   , -- 
    IN inBranchId             Integer   , --
    IN inPartnerId            Integer   , --
    IN inPaidKindId           Integer   , -- 
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleCommerc());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inContractId, inMovementId, 0, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioId, inBranchId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioId, inPaidKindId);
     

     -- сохранили протокол !!!после изменений!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.26         *
*/

-- тест
-- 