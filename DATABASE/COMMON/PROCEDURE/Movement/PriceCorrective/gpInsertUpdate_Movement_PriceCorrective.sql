-- Function: gpInsertUpdate_Movement_PriceCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, tvarchar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, tvarchar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceCorrective (integer, integer, tvarchar, tdatetime, boolean, tfloat, tvarchar, tvarchar, integer, integer, integer, integer, integer, integer, tvarchar, tvarchar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceCorrective(
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
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PriceCorrective());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_PriceCorrective
                                       (ioId               := ioId
                                      , inParentId         := inParentId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := inOperDate
                                      , inPriceWithVAT     := inPriceWithVAT
                                      , inVATPercent       := inVATPercent
                                      , inInvNumberPartner := inInvNumberPartner
                                      , inInvNumberMark    := inInvNumberMark
                                      , inFromId           := inFromId
                                      , inToId             := inToId
                                      , inPartnerId        := inPartnerId
                                      , inPaidKindId       := inPaidKindId
                                      , inContractId       := inContractId   
                                      , inBranchId         := inBranchId
                                      , inUserId           := vbUserId
                                       );
     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.04.22         * inBranchId
 02.02.18         *
 17.06.14         * add inInvNumberPartner 
                      , inInvNumberMark  
 29.05.14         *
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PriceCorrective (ioId:= 0, inParentId:=0 , inInvNumber:= '-1', inOperDate:= '01.01.2013', inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2,  inPartnerId:= 0, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
