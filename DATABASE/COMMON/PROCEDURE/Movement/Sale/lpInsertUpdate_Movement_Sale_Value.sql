-- Function: lpInsertUpdate_Movement_Sale_Value()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale_Value (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Sale_Value (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Sale_Value(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inInvNumberPartner      TVarChar   , -- Номер накладной у контрагента
    IN inInvNumberOrder        TVarChar   , -- Номер заявки контрагента
    IN inOperDate              TDateTime  , -- Дата документа
    IN inOperDatePartner       TDateTime  , -- Дата накладной у контрагента
    IN inChecked               Boolean    , -- Проверен
    IN inChangePercent         TFloat     , -- (-)% Скидки (+)% Наценки
    IN inFromId                Integer    , -- От кого (в документе)
    IN inToId                  Integer    , -- Кому (в документе)
    IN inPaidKindId            Integer    , -- Виды форм оплаты
    IN inContractId            Integer    , -- Договора
    IN inRouteSortingId        Integer    , -- Сортировки маршрутов
    IN inCurrencyDocumentId    Integer    , -- Валюта (документа)
    IN inCurrencyPartnerId     Integer    , -- Валюта (контрагента)
    IN inMovementId_Order      Integer    , -- ключ Документа
    IN inMovementId_ReturnIn   Integer    , -- ключ Документа Возврат
    IN ioPriceListId           Integer    , -- Прайс лист
    IN ioCurrencyPartnerValue  TFloat     , -- Курс для расчета суммы операции
    IN ioParPartnerValue       TFloat     , -- Номинал для расчета суммы операции
    IN inUserId                Integer      -- пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN

     -- сохранили <Документ>
     ioId:=
    (SELECT tmp.ioId
     FROM lpInsertUpdate_Movement_Sale (ioId                   := ioId
                                      , inInvNumber            := inInvNumber
                                      , inInvNumberPartner     := inInvNumberPartner
                                      , inInvNumberOrder       := inInvNumberOrder
                                      , inOperDate             := inOperDate
                                      , inOperDatePartner      := inOperDatePartner
                                      , inChecked              := inChecked
                                      , ioChangePercent        := inChangePercent
                                      , inFromId               := inFromId
                                      , inToId                 := inToId
                                      , inPaidKindId           := inPaidKindId
                                      , inContractId           := inContractId
                                      , inRouteSortingId       := inRouteSortingId
                                      , inCurrencyDocumentId   := inCurrencyDocumentId
                                      , inCurrencyPartnerId    := inCurrencyPartnerId
                                      , inMovementId_Order     := inMovementId_Order
                                      , inMovementId_ReturnIn  := inMovementId_ReturnIn
                                      , ioPriceListId          := ioPriceListId
                                      , ioCurrencyPartnerValue := ioCurrencyPartnerValue
                                      , ioParPartnerValue      := ioParPartnerValue
                                      , inUserId               := inUserId
                                       ) AS tmp);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.02.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Sale_Value (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inCarId:= 0, inPaidKindId:= 1, inContractId:= 0, inPersonalDriverId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
