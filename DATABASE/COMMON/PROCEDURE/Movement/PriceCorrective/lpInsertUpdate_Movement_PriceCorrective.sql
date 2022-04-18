-- Function: lpInsertUpdate_Movement_PriceCorrective()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, integer, integer, integer, integer, integer, integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PriceCorrective (integer, integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PriceCorrective (integer, integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PriceCorrective(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inParentId            Integer   , -- Налоговая накладная
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberMark       TVarChar  , -- Номер "перекресленої зеленої марки зi складу"
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPartnerId           Integer   , -- Контрагент
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора      
    IN inBranchId            Integer   , -- Филиал
    IN inUserId              Integer     -- Пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate) 
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;
     -- проверка
     IF COALESCE (inContractId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Договор>.';
     END IF;


     -- определяем ключ доступа
     IF COALESCE (ioId, 0) = 0
     THEN vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_PriceCorrective());
     ELSE vbAccessKeyId:= (SELECT Movement.AccessKeyId FROM Movement WHERE Movement.Id = ioId);
     END IF;


     -- определяется филиал + проверка
     IF COALESCE (inBranchId, 0) = 0 THEN inBranchId:= zfGet_Branch_AccessKey (vbAccessKeyId); ELSE PERFORM zfGet_Branch_AccessKey (vbAccessKeyId); END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PriceCorrective(), inInvNumber, inOperDate, inParentId, vbAccessKeyId);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили свойство <% НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberMark(), ioId, inInvNumberMark);
     
     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Контрагент>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
     
     -- сохранили связь с <Виды форм оплаты >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- сохранили связь с <филиал>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), ioId, inBranchId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.02.18         * add inParentId
 17.06.14         * add inInvNumberPartner 
                      , inInvNumberMark                
 29.05.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PriceCorrective (ioId:= 0, inParentId:=0 ,inInvNumber:= '-1', inOperDate:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inPartnerId:= 1, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
