-- Function: lpInsertUpdate_Movement_TaxCorrective_DocChild()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TaxCorrective_DocChild (Integer, TVarChar, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TaxCorrective_DocChild(
 INOUT ioId                  Integer   , -- Ключ объекта
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovement_ChildId    Integer   , -- Налоговая накладная
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
  DECLARE vbStatusId  Integer;
  DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем <Статус>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = ioId;
     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- проверка - номер договора должен быть одинаковый
     IF COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = ioId AND DescId = zc_MovementLinkObject_Contract()), 0)
        <> COALESCE ((SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovement_ChildId AND DescId = zc_MovementLinkObject_Contract()), 0)
        AND inMovement_ChildId <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.№ договора в корректировке не соответсвует № договора в налоговой.';
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
 06.06.14                                        * add проверка - проведенные/удаленные документы Изменять нельзя
 10.05.14                                        * add lpInsert_MovementProtocol
 10.05.14                                        * здесь надо сохранить только 1 параметр
 09.04.14                                                       *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TaxCorrective_DocChild (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)
