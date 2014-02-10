-- Function: lpInsertUpdate_Movement_Tax()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax (integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean,
                                                      TFloat, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Tax(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Налоговая>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер налогового документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inDateRegistered      TDateTime , -- Дата регистрации
    IN inChecked             Boolean   , -- Проверен
    IN inRegistered          Boolean   , -- Зарегестрирована (да/нет)
    IN inDocument            Boolean   , -- Есть ли подписанный документ
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inContractId          Integer   , -- Договора
    IN inDocumentTaxKind     Integer   , -- Тип формирования налогового документа
    IN inUserId              Integer     -- пользователь
)
RETURNS INTEGER AS
$BODY$
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- определяем ключ доступа
--      vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Tax(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     --Date
     -- сохранили свойство <Дата регистрации>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), ioId, inDateRegistered);

     --String
     -- сохранили свойство <Номер накладной у контрагента>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     --Boolean
     -- сохранили свойство <Проверен>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
     -- сохранили свойство <Зарегестрирована (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), ioId, inRegistered);
     -- сохранили свойство <Есть ли подписанный документ>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), ioId, inDocument);
     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);

     --Float
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);

     --Link
     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Тип формирования налогового документа>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), ioId, inDocumentTaxKind);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.02.14                                                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Tax (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inChecked:= FALSE, inRegistered:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)

