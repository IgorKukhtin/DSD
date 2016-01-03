-- Function: lpInsertUpdate_Movement_Tax()

DROP FUNCTION IF EXISTS lpInsert_Movement_TaxMedoc (Integer, TVarChar, TVarChar, TDateTime, TFloat, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsert_Movement_TaxMedoc (Integer, TVarChar, TVarChar, TDateTime, TFloat, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_TaxMedoc(
   OUT outId                 Integer   , -- Ключ объекта <Документ Налоговая>
    IN inInvNumberPartner    TVarChar  , -- Номер налогового документа
    IN inInvNumberBranch     TVarChar  , -- Номер филиала
    IN inOperDate            TDateTime , -- Дата документа
    IN inVATPercent          TFloat    , -- % НДС
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inContract            TVarChar  , -- Договор
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBranchId Integer;
   DECLARE vbContractId Integer;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     SELECT Object_Contract_View.ContractId INTO vbContractId 
       FROM Object_Contract_View 
      WHERE Object_Contract_View.JuridicalId = inToId AND Object_Contract_View.InvNumber = inContract;

     IF inOperDate < '01.01.2016'
     THEN
         SELECT ObjectId INTO vbBranchId
         FROM ObjectString AS ObjectString_InvNumber
         WHERE ObjectString_InvNumber.DescId = zc_objectString_Branch_InvNumber()    
           AND ObjectString_InvNumber.ValueData = inInvNumberBranch;   
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert := true;

     -- сохранили <Документ>
     outId := lpInsertUpdate_Movement (outId, zc_Movement_Tax(), inInvNumberPartner, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Номер налогового документа>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), outId, inInvNumberPartner);

     -- сохранили свойство <Номер филиала>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), outId, inInvNumberBranch);

     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Medoc(), outId, true);
     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), outId, false);

     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), outId, inVATPercent);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), outId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), outId, inToId);
     -- сохранили связь с <Тип формирования налогового документа>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), outId, vbContractId);

     -- сохранили связь с <филиал>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), outId, vbBranchId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (outId);

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (outId, inUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.04.15                         *
*/

-- тест
-- SELECT * FROM lpInsert_Movement_TaxMedoc (ioId:= 0, ioInvNumber:= '-1',ioInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)
