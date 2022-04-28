-- Function: gpInsertUpdate_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, tdatetime, tdatetime, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, integer, tdatetime, tdatetime, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, TVarChar, tvarchar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, integer, tdatetime, tdatetime, boolean, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, TVarChar, tvarchar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, integer, tdatetime, tdatetime, boolean, boolean, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, TVarChar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (integer, tvarchar, tvarchar, tvarchar, integer, tdatetime, tdatetime, boolean, boolean, boolean, boolean, tfloat, tfloat, integer, integer, integer, integer, integer, integer, integer, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnIn(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер накладной у контрагента
    IN inInvNumberMark       TVarChar  , -- Номер "перекресленої зеленої марки зi складу"
    IN inParentId            Integer   , -- 
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата накладной у контрагента
    IN inChecked             Boolean   , -- Проверен
    IN inIsPartner           Boolean   , -- основание - Акт недовоза
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inisList              Boolean   , -- Только для списка
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента) 
   OUT outCurrencyValue      TFloat    , -- курс валюты 
    IN inMovementId_OrderReturnTare    Integer   , --
    In inComment             TVarChar  , -- примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());


     -- рассчитали и свойство <Курс для перевода в валюту баланса>
     outCurrencyValue := 1.00;
     IF inCurrencyDocumentId <> inCurrencyPartnerId -- AND inCurrencyDocumentId > 0 AND inCurrencyPartnerId > 0
     THEN
        outCurrencyValue := (SELECT MovementItem.Amount
                             FROM (SELECT MAX (Movement.OperDate) AS maxOperDate
                                   FROM Movement 
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                              AND MovementItem.DescId = zc_MI_Master()
                                                              AND MovementItem.ObjectId = inCurrencyDocumentId
                                                              AND MovementItem.isErased = FALSE
                                       INNER JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                         ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                                        AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                                                                        AND MILinkObject_CurrencyTo.ObjectId = inCurrencyPartnerId
                                   WHERE Movement.DescId = zc_Movement_Currency()
                                     AND Movement.OperDate <= inOperDate
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                   ) AS tmpCurrency
                                   INNER JOIN Movement ON Movement.OperDate = tmpCurrency.maxOperDate
                                                      AND Movement.DescId = zc_Movement_Currency()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.isErased = FALSE
                            );
     END IF;


     -- сохранили <Документ>
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_Movement_ReturnIn
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inInvNumberPartner := inInvNumberPartner
                                      , inInvNumberMark    := inInvNumberMark
                                      , inParentId         := inParentId
                                      , inOperDate         := inOperDate
                                      , inOperDatePartner  := CASE WHEN vbUserId = 5 AND ioId > 0 AND 1 = 0 THEN COALESCE ((SELECT ValueData FROM MovementDate WHERE MovementId = ioId AND DescId = zc_MovementDate_OperDatePartner()), inOperDatePartner) ELSE inOperDatePartner END
                                      , inChecked          := CASE WHEN vbUserId = 5 AND ioId > 0 AND 1 = 0 THEN COALESCE ((SELECT ValueData FROM MovementBoolean WHERE MovementId = ioId AND DescId = zc_MovementBoolean_Checked()), inChecked) ELSE inChecked END
                                      , inIsPartner        := inIsPartner
                                      , inPriceWithVAT     := inPriceWithVAT
                                      , inisList           := inisList
                                      , inVATPercent       := inVATPercent
                                      , inChangePercent    := inChangePercent
                                      , inFromId           := inFromId
                                      , inToId             := inToId
                                      , inPaidKindId       := inPaidKindId
                                      , inContractId       := inContractId
                                      , inCurrencyDocumentId := inCurrencyDocumentId
                                      , inCurrencyPartnerId  := inCurrencyPartnerId
                                      , inCurrencyValue    := outCurrencyValue 
                                      , inMovementId_OrderReturnTare := inMovementId_OrderReturnTare
                                      , inComment          := inComment
                                      , inUserId           := vbUserId
                                       )AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.04.22         * inMovementId_OrderReturnTare
 14.05.16         *
 21.08.15         * ADD inIsPartner
 26.06.15         * add
 26.08.14                                        * add только в GP - рассчитали свойство <Курс для перевода в валюту баланса>
 24.07.14         * add inCurrencyDocumentId
                        inCurrencyPartnerId
 23.04.14                                        * add inInvNumberMark
 26.03.14                                        * add inInvNumberPartner
 14.02.14                                                         * del DocumentTaxKind
 14.02.14                        * move to lp
 13.01.14                                        * add/del property from redmain
 17.07.13         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ReturnIn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inChecked:=TRUE, inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 1, inSession:= zfCalc_UserAdmin())
