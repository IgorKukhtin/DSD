-- Function: gpInsertUpdate_Movement_SaleAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SaleAsset (Integer, TVarChar, TDateTime,TDateTime, Boolean
                                                         , Integer, Integer, Integer, Integer, Integer, Integer
                                                         , TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);


gpInsertUpdate_Movement_SaleAsset
(ioId := 0 , inInvNumber := '4' , inOperDate := ('19.06.2020')::TDateTime , inOperDatePartner := ('19.06.2020')::TDateTime
 , inPriceWithVAT := 'False' , inFromId := 8395 , inToId := 8395 , inContractId := 0 , inCurrencyDocumentId := 14461 , inCurrencyPartnerId := 0 , inVATPercent := 20 , ioCurrencyValue := 1 , inCurrencyPartnerValue := 1 , inParPartnerValue := 1 , inComment := '' ,  inSession := '5');



CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SaleAsset(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inOperDatePartner      TDateTime , -- Дата накладной у контрагента
    IN inPriceWithVAT         Boolean   , -- Цена с НДС (да/нет)

    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inContractId           Integer   , -- Договора
    IN inPaidKindId           Integer   , -- Виды форм оплаты 

    IN inCurrencyDocumentId   Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId    Integer   , -- Валюта (контрагента)
    IN inVATPercent           TFloat    , -- % НДС
 INOUT ioCurrencyValue        TFloat    , -- курс валюты
 INOUT ioParValue             TFloat    , -- номинал
    IN inCurrencyPartnerValue TFloat    , -- курс валюты
    IN inParPartnerValue      TFloat    , -- номинал
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SaleAsset());
                                              
     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.ioCurrencyValue, tmp.ioParValue
            INTO ioId, ioCurrencyValue, ioParValue
     FROM lpInsertUpdate_Movement_SaleAsset (ioId                := ioId
                                           , inInvNumber            := inInvNumber
                                           , inOperDate             := inOperDate
                                           , inOperDatePartner      := inOperDatePartner
                                           , inPriceWithVAT         := inPriceWithVAT
                                           , inFromId               := inFromId
                                           , inToId                 := inToId
                                           , inContractId           := inContractId
                                           , inPaidKindId           := inPaidKindId
                                           , inCurrencyDocumentId   := inCurrencyDocumentId
                                           , inCurrencyPartnerId    := inCurrencyPartnerId
                                           , inVATPercent           := inVATPercent
                                           , ioCurrencyValue        := ioCurrencyValue
                                           , ioParValue             := ioParValue
                                           , inCurrencyPartnerValue := inCurrencyPartnerValue
                                           , inParPartnerValue      := inParPartnerValue
                                           , inComment              := inComment
                                           , inUserId               := vbUserId
                                           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.06.20         *
*/

-- тест
-- функция gpinsertupdate_movement_saleasset(integer, tvarchar, tdatetime, tdatetime, boolean, integer, integer, integer, integer, integer, tfloat, tfloat, tfloat, tfloat, tvarchar, tvarchar) не существует
LINE 1: select * from gpInsertUpdate_Movement_SaleAsset($1::integer,...
                      ^
HINT:  Функция с данными именем и типами аргументов не найдена. Возможно, вам следует добавить явные приведения типов.
 context: select * from 