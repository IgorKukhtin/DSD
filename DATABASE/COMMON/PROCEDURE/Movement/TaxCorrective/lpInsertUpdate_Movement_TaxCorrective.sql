-- Function: lpInsertUpdate_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_TaxCorrective(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ TaxCorrective>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер налогового документа
    IN inInvNumberBranch     TVarChar  , -- Номер филиала
    IN inOperDate            TDateTime , -- Дата документа
    IN inChecked             Boolean   , -- Проверен
    IN inDocument            Boolean   , -- Есть ли подписанный документ
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPartnerId           Integer   , -- Контрагент
    IN inContractId          Integer   , -- Договора
    IN inDocumentTaxKindId   Integer   , -- Тип формирования документа TaxCorrective
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
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
        AND inDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Prepay()
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен договор.';
     END IF;


     -- определяем ключ доступа
     IF COALESCE (ioId, 0) = 0
        OR (inContractId > 0
        AND inContractId <> COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_Contract()), 0)
        AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
           )
     THEN IF inContractId > 0  AND inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
          THEN -- Для Предоплаты
               vbAccessKeyId:= CASE COALESCE ((SELECT ObjectLink_Unit_Branch.ChildObjectId
                                               FROM ObjectLink AS OL
                                                    INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                          ON ObjectLink_Personal_Unit.ObjectId = OL.ChildObjectId
                                                                         AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                                                    LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                                         ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                                                        AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()

                                               WHERE OL.ObjectId = inContractId
                                                 AND OL.DescId   = zc_ObjectLink_Contract_PersonalCollation()
                                              ), 0)
                          WHEN 8379 -- филиал Киев
                               THEN zc_Enum_Process_AccessKey_DocumentKiev()
                          WHEN 8374     -- филиал Одесса
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa()
                          WHEN 8377 -- филиал Кр.Рог
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog()
                          WHEN 8373 -- филиал Николаев (Херсон)
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev()
                          WHEN 8381 -- филиал Харьков"
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov()
                          WHEN 8375 -- филиал Черкассы
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi()
                          WHEN 301310 -- филиал Запорожье
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye()
                          WHEN 3080683 -- филиал Львов
                               THEN zc_Enum_Process_AccessKey_DocumentLviv()
                          ELSE lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective())
                     END;

          ELSE vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());
          END IF;

     ELSE vbAccessKeyId:= (SELECT Movement.AccessKeyId FROM Movement WHERE Movement.Id = ioId);
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
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_TaxCorrective(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- сохранили свойство <Номер налогового документа>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
     -- сохранили свойство <Номер филиала>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), ioId, inInvNumberBranch);


     -- сохранили свойство <Проверен>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);

     -- сохранили свойство <Есть ли подписанный документ>
     IF vbIsInsert THEN PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), ioId, FALSE); END IF; -- inDocument

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);

     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Контрагент>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- сохранили связь с <Тип формирования налогового документа>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), ioId, inDocumentTaxKindId);

     -- сохранили связь с <филиал>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), ioId, vbBranchId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     END IF;

     -- сохранили "текущая дата", вместо "регистрации" - если нет или убрали электронная (т.е. регистрация медка)
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), tmp.MovementId, CURRENT_DATE)
     FROM (SELECT ioId AS MovementId /*WHERE vbIsInsert = TRUE AND CURRENT_DATE >= '01.04.2016'*/) AS tmp
          LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = tmp.MovementId
                                   AND MovementBoolean.DescId = zc_MovementBoolean_Electron()
     WHERE COALESCE (MovementBoolean.ValueData, FALSE) = FALSE
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.14                                        * add vbBranchId
 13.11.14                                        * add vbAccessKeyId
 02.05.14                                                       * add если надо, создаем <Номер...
 24.04.14                                                       * add inInvNumberBranch
 23.04.14                                        * del <Есть ли подписанный документ>
 16.04.14                                        * add lpInsert_MovementProtocol
 19.03.14                                        * add inPartnerId
 11.02.14                                                       *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_TaxCorrective (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKind:= 0, inUserId:=24)
