-- Function: lpInsertUpdate_Movement_Tax_Params()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax_Params (Integer, TVarChar, TDateTime, TDateTime, Boolean, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax_Params (Integer, TVarChar, TDateTime, TDateTime, Boolean, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Tax_Params(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Налоговая>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inDateRegistered      TDateTime , -- Дата регистрации
    IN inIsElectron          Boolean   , -- Электронная (да/нет)
    IN inInvNumberRegistered TVarChar  , -- Номер регистрации документа 
    IN inContractId          Integer   , -- Договора
    IN inUserId              Integer     -- пользователь
)
RETURNS INTEGER AS
$BODY$
BEGIN
     -- сохранили свойство <Дата регистрации>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), ioId, inDateRegistered);

     -- сохранили свойство <Зарегестрирован (да/нет)>
     --PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Electron(), ioId, inIsElectron);

     -- сохранили свойство <Номер налогового документа регистрации>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberRegistered(), ioId, inInvNumberRegistered);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.06.15         * add inInvNumberRegistered
 01.05.14                                        * здесь надо сохранить только 2 параметра
 09.02.14                                                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Tax_Params (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inUserId:=24)
