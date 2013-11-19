-- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS gpinsertupdate_movement_service(integer, tvarchar, tdatetime, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpinsertupdate_movement_service(integer, tvarchar, tdatetime, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Service(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inAmount              TFloat    , -- Сумма операции 
    IN inComment             TVarChar  , -- Комментарий
    IN inBusinessId          Integer   , -- Бизнес    
    IN inContractId          Integer   , -- Договор
    IN inInfoMoneyId         Integer   , -- Статьи назначения 
    IN inJuridicalId         Integer   , -- Юр. лицо	
    IN inJuridicalBasisId    Integer   , -- Главное юр. лицо	
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inUnitId              Integer   , -- Подразделение
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Service());
     vbUserId := inSession;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Service(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <Сумма операции>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);

     -- сохранили свойство <Комментарий>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- сохранили связь с <Юр. лицо>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- сохранили связь с <Главное юр. лицо>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JuridicalBasis(), ioId, inJuridicalBasisId);

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Бизнес>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Business(), ioId, inBusinessId);
     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.08.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Service (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inJuridicalId:= 1, inMainJuridicalId:= 1, inBusinessId:= 2, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inSession:= '2')
