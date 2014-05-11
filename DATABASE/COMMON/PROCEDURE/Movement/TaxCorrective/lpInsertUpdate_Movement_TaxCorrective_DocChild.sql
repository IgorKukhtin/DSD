-- Function: lpInsertUpdate_Movement_TaxCorrective_DocChild()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TaxCorrective_DocChild (Integer, TVarChar, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TaxCorrective_DocChild(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Налоговая>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovement_ChildId    Integer   , -- Налоговая накладная
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- сохранили связь с <Налоговая накладная>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), ioId, inMovement_ChildId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 10.05.14                                        * add lpInsert_MovementProtocol
 10.05.14                                        * здесь надо сохранить только 1 параметр
 09.04.14                                                       *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TaxCorrective_DocChild (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)
