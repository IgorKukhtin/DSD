-- Function: gpUpdate_Movement_Income_Currency()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_Currency (Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_Currency(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
 INOUT ioCurrencyValue       TFloat    , -- курс валюты
 INOUT ioParValue            TFloat    , -- номинал 
    IN inisCurrencyUser      Boolean   ,
    IN inSession             TVarChar     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert           Boolean;
   DECLARE vbCurrencyValue      TFloat;
   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyPartnerId  Integer;
   DECLARE vbPaidKindId         Integer;
   DECLARE vbUserId             Integer;
   DECLARE vbOperDatePartner    TDateTime; 
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_Currency());

     -- сохраненная валюта документа
     vbCurrencyDocumentId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument()), zc_Enum_Currency_Basis());
     -- сохраненная Валюта (контрагента)
     vbCurrencyPartnerId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_CurrencyPartner()), zc_Enum_Currency_Basis());    

     -- форма оплаты
     vbPaidKindId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_PaidKind());    
     -- дата поставщика
     vbOperDatePartner := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inId AND MD.DescId = zc_MovementDate_OperDatePartner());    

     IF COALESCE (inisCurrencyUser,FALSE) = FALSE
     THEN

         -- рассчитали и свойство <Курс для перевода в валюту баланса>   -- ну как-то так
         --outCurrencyValue := 1.00;
         IF (inCurrencyDocumentId <> inCurrencyPartnerId) OR (inCurrencyDocumentId <> zc_Enum_Currency_Basis() AND inCurrencyPartnerId <> zc_Enum_Currency_Basis())
         THEN
             IF (inCurrencyDocumentId <> inCurrencyPartnerId)      --если ручной ввод не пересчитываем курс
             THEN 
             
                 -- если изменилась валюта документа или если значение курса = 0
                 IF (vbCurrencyDocumentId <> inCurrencyDocumentId OR vbCurrencyPartnerId <> inCurrencyPartnerId OR COALESCE (ioCurrencyValue, 0) = 0) 
                 OR (inCurrencyDocumentId <> inCurrencyPartnerId AND COALESCE (ioCurrencyValue, 0) = 0)
                 THEN
                     IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
                     THEN
                         SELECT tmp.Amount, tmp.ParValue
                         INTO ioCurrencyValue, ioParValue
                         FROM lfSelect_Movement_Currency_byDate (inOperDate       := vbOperDatePartner
                                                               , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                               , inCurrencyToId   := inCurrencyDocumentId
                                                               , inPaidKindId     := vbPaidKindId)            AS tmp;
                     ELSE
                         SELECT tmp.Amount, tmp.ParValue
                         INTO ioCurrencyValue, ioParValue
                         FROM lfSelect_Movement_Currency_byDate (inOperDate       := vbOperDatePartner
                                                               , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                               , inCurrencyToId   := inCurrencyPartnerId
                                                               , inPaidKindId     := vbPaidKindId)            AS tmp;
                     END IF;    
                 END IF;
             ELSE IF (inCurrencyDocumentId = inCurrencyPartnerId AND COALESCE (ioCurrencyValue, 0) = 0)
                  THEN
                      SELECT tmp.Amount, tmp.ParValue
                      INTO ioCurrencyValue, ioParValue
                      FROM lfSelect_Movement_Currency_byDate (inOperDate       := vbOperDatePartner
                                                            , inCurrencyFromId := zc_Enum_Currency_Basis()
                                                            , inCurrencyToId   := inCurrencyDocumentId
                                                            , inPaidKindId     := vbPaidKindId)            AS tmp;
                  END IF;
             END IF; 
             
         ELSE
             ioCurrencyValue := 1.00; ioParValue := 1.00;
         END IF;  
     END IF; 

     -- сохранили связь с <Валюта (документа)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), inId, inCurrencyDocumentId);
     -- сохранили связь с <Валюта (контрагента) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), inId, inCurrencyPartnerId);
          
     -- сохранили свойство <Курс для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), inId, ioCurrencyValue);
     -- сохранили свойство <Номинал для перевода в валюту баланса>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), inId, ioParValue); 
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_CurrencyUser(), inId, inisCurrencyUser); 

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.24         *
*/

-- тест
--