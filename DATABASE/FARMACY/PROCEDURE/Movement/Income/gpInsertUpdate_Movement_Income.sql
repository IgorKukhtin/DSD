-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Income(Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inNDSKindId           Integer   , -- Типы НДС
    IN inContractId          Integer   , -- Договор
    IN inPaymentDate         TDateTime , -- Дата платежа
    IN inInvNumberBranch     TVarChar  , -- Номер документа
    IN inOperDateBranch      TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE(Id Integer, InvNumberBranch TVarChar) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOldContractId Integer;
   DECLARE vbDeferment Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
     vbUserId := inSession;
     -- Получаем старый договор. Если он отличается от текущего, то берем новую дату платежа

     SELECT ContractId INTO vbOldContractId FROM Movement_Income_View WHERE Movement_Income_View.Id = ioId;

     IF COALESCE(vbOldContractId, 0) <> inContractId THEN 
        SELECT Deferment INTO vbDeferment 
          FROM Object_Contract_View WHERE Object_Contract_View.Id = inContractId;
        inPaymentDate := inOperDate + vbDeferment * interval '1 day';  
     END IF;

     ioId := lpInsertUpdate_Movement_Income(ioId, inInvNumber, inOperDate, inPriceWithVAT
                                          , inFromId, inToId, inNDSKindId, inContractId, inPaymentDate, vbUserId);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), inId, inInvNumberBranch);

     -- 
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inId, inOperDateBranch);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.05.15                         *
 24.12.14                         *
 02.12.14                                                        *
 10.07.14                                                        *


*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
