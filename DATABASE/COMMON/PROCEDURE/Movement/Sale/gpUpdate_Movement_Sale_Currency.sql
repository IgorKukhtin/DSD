-- Function: gpUpdate_Movement_Sale_Currency()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Currency (Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Currency(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inCurrencyDocumentId  Integer   , -- Валюта (документа)
    IN inCurrencyPartnerId   Integer   , -- Валюта (контрагента)
 INOUT ioCurrencyValue       TFloat    , -- курс валюты
IF vbUserId = 9457 INOUT ioParValue            TFloat    , -- номинал 
    IN inisCurrencyUser      Boolean   ,
    IN inSession             TVarChar     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert           Boolean;
   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyPartnerId  Integer;
   DECLARE vbPaidKindId         Integer;
   DECLARE vbUserId             Integer;
   DECLARE vbOperDatePartner    TDateTime; 
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_Currency());


     -- проверка
     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен';
     END IF;
     -- проверка
     IF inCurrencyDocumentId <> zc_Enum_Currency_Basis() AND inCurrencyDocumentId <> inCurrencyPartnerId
     THEN
         RAISE EXCEPTION 'Ошибка.Неверное значение <Валюта (цена)> или <Валюта (покупатель)>';
     END IF;


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

         -- рассчет курса для баланса
         IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
         THEN SELECT Amount, ParValue 
            INTO ioCurrencyValue, ioParValue
              FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyDocumentId, inPaidKindId:= vbPaidKindId);
         ELSE IF inCurrencyPartnerId <> zc_Enum_Currency_Basis()
              THEN SELECT Amount, ParValue
            INTO ioCurrencyValue, ioParValue
                   FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= vbCurrencyPartnerId, inPaidKindId:= vbPaidKindId);
              ELSE ioCurrencyValue:= 0;
                   ioParValue:=0;
              END IF;
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


 if vbUserId = 9457
 then
    RAISE EXCEPTION 'ok.Test %,   %,   %,   %',  lfGet_Object_ValueData (inCurrencyDocumentId), lfGet_Object_ValueData (inCurrencyPartnerId), ioCurrencyValue, ioParValue;
 end if;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.07.24         *
*/

-- тест
--