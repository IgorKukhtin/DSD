-- Function: lpInsert_Movement_TaxCorrective_isAutoPrepay()

DROP FUNCTION IF EXISTS lpInsert_Movement_TaxCorrective_isAutoPrepay (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_TaxCorrective_isAutoPrepay(
    IN inId                  Integer   , -- Ключ объекта <Документ TaxCorrective>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер налогового документа
    IN inInvNumberBranch     TVarChar  , -- Номер филиала
    IN inOperDate            TDateTime , -- Дата документа
    IN inisAuto              Boolean   , -- Автоматически
    IN inChecked             Boolean   , -- Проверен
    IN inDocument            Boolean   , -- Есть ли подписанный документ
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inAmount              TFloat    , -- сумма предоплаты
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPartnerId           Integer   , -- Контрагент
    IN inContractId          Integer   , -- Договора
    IN inDocumentTaxKindId   Integer   , -- Тип формирования документа TaxCorrective
    IN inUserId              Integer     -- пользователь
)


RETURNS VOID AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBranchId Integer;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;
     -- проверка
     IF COALESCE (inContractId, 0) = 0 -- AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен договор.';
     END IF;


     -- определяем ключ доступа
     IF COALESCE (inId, 0) = 0
     THEN vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());
     ELSE vbAccessKeyId:= (SELECT Movement.AccessKeyId FROM Movement WHERE Movement.Id = inId);
     END IF;

     -- определяется филиал
     vbBranchId:= CASE WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentBread()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportDnepr())
                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportDnepr())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentKiev()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKiev())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentOdessa()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportOdessa())
                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentZaporozhye()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportZaporozhye())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentKrRog()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKrRog())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentNikolaev()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportNikolaev())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentKharkov()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKharkov())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentCherkassi()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportCherkassi())

                       WHEN vbAccessKeyId = zc_Enum_Process_AccessKey_DocumentLviv()
                            THEN (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportLviv())
                  END;
     -- проверка
     IF COALESCE (vbBranchId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Невозможно определить <Филиал>.';
     END IF;

     -- определяется  Номер филиала
     IF inOperDate < '01.01.2016'
     THEN
         inInvNumberBranch:= (SELECT ObjectString.ValueData FROM ObjectString WHERE ObjectString.DescId = zc_objectString_Branch_InvNumber() AND ObjectString.ObjectId = vbBranchId);
     ELSE
         inInvNumberBranch:='';
     END IF;

     -- если надо, создаем <Номер документа>
     IF COALESCE (inInvNumber, '') = ''
     THEN
         inInvNumber:= NEXTVAL ('movement_taxcorrective_seq') ::TVarChar;
     END IF;
     -- если надо, создаем <Номер налогового документа>
     IF COALESCE (inInvNumberPartner, '') = ''
     THEN
         inInvNumberPartner:= lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective(), inOperDate, inInvNumberBranch) ::TVarChar;
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (inId, 0) = 0;

     -- сохранили <Документ>
     inId := lpInsertUpdate_Movement (inId, zc_Movement_TaxCorrective(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Номер налогового документа>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), inId, inInvNumberPartner);
     -- сохранили свойство <Номер филиала>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), inId, inInvNumberBranch);

     -- сохранили свойство <Автоматически>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), inId, inisAuto);

     -- сохранили свойство <Проверен>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inId, inChecked);

     -- сохранили свойство <Есть ли подписанный документ>
     IF vbIsInsert THEN PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), inId, FALSE); END IF; -- inDocument

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), inId, inPriceWithVAT);

     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inId, inVATPercent);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);
     -- сохранили связь с <Контрагент>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), inId, inPartnerId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inId, inContractId);
     -- сохранили связь с <Тип формирования налогового документа>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), inId, inDocumentTaxKindId);

     -- сохранили связь с <филиал>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inId, vbBranchId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (inId, inUserId, vbIsInsert);
     END IF;


    --строка документа 
    PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                     , inMovementId         := inId
                                                     , inGoodsId            := inDocumentTaxKindId
                                                     , inAmount             := inAmount
                                                     , inPrice              := 1
                                                     , inPriceTax_calc      := 0
                                                     , ioCountForPrice      := 1
                                                     , inGoodsKindId        := NULL
                                                     , inUserId             := inUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.21         *
*/

-- тест
--