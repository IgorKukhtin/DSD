-- Function: gpInsertUpdateMobile_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_ReturnIn (
    IN inGUID             TVarChar  , -- Глобальный уникальный идентификатор для синхронизации с Главной БД
    IN inInvNumber        TVarChar  , -- Номер документа
    IN inInvNumberPartner TVarChar  , -- Номер документа у контрагента
    IN inOperDate         TDateTime , -- Дата документа
    IN inOperDatePartner  TDateTime , -- Дата документа у контрагента
    IN inStatusId         Integer   , -- Виды статусов
    IN inChecked          Boolean   , -- Проверен
    IN inPriceWithVAT     Boolean   , -- Цена с НДС (да/нет)
    IN inInsertDate       TDateTime , -- Дата/время создания документа
    IN inVATPercent       TFloat    , -- % НДС
    IN inChangePercent    TFloat    , -- (-)% Скидки (+)% Наценки
    IN inPaidKindId       Integer   , -- Вид формы оплаты
    IN inPartnerId        Integer   , -- Контрагент
    IN inUnitId           Integer   , -- Подразделение
    IN inContractId       Integer   , -- Договор
    IN inComment          TVarChar  , -- Примечание
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- получаем Id документа по GUID
      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_StoreReal
                         ON Movement_StoreReal.Id = MovementString_GUID.MovementId
                        AND Movement_StoreReal.DescId = zc_Movement_ReturnIn()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbIsInsert:= (COALESCE (vbId, 0) = 0);

      SELECT ObjectLink_Contract_Currency.ChildObjectId
      INTO vbCurrencyId
      FROM ObjectLink AS ObjectLink_Contract_Currency
      WHERE ObjectLink_Contract_Currency.ObjectId = inContractId
        AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency();

      vbCurrencyId:= COALESCE (vbCurrencyId, zc_Enum_Currency_Basis());

      vbId:= lpInsertUpdate_Movement_ReturnIn (ioId                 := vbId            -- Ключ объекта <Документ Возврат покупателя>
                                             , inInvNumber          := inInvNumber     -- Номер документа
                                             , inInvNumberPartner   := inInvNumberPartner -- Номер накладной у контрагента
                                             , inInvNumberMark      := ''              -- Номер "перекресленої зеленої марки зi складу"
                                             , inParentId           := NULL
                                             , inOperDate           := inOperDate      -- Дата(склад)
                                             , inOperDatePartner    := inOperDatePartner -- Дата документа у покупателя
                                             , inChecked            := inChecked       -- Проверен
                                             , inIsPartner          := false           -- основание - Акт недовоза
                                             , inPriceWithVAT       := inPriceWithVAT  -- Цена с НДС (да/нет)
                                             , inisList             := false           -- Только для списка
                                             , inVATPercent         := inVATPercent    -- % НДС
                                             , inChangePercent      := inChangePercent -- (-)% Скидки (+)% Наценки
                                             , inFromId             := inPartnerId     -- От кого (в документе)
                                             , inToId               := inUnitId        -- Кому (в документе)
                                             , inPaidKindId         := inPaidKindId    -- Виды форм оплаты
                                             , inContractId         := inContractId    -- Договора
                                             , inCurrencyDocumentId := vbCurrencyId    -- Валюта (документа)
                                             , inCurrencyPartnerId  := vbCurrencyId    -- Валюта (контрагента)
                                             , inCurrencyValue      := 1.0             -- курс валюты
                                             , inComment            := inComment       -- примечание
                                             , inUserId             := vbUserId        -- Пользователь
                                              );

      -- сохранили свойство <Глобальный уникальный идентификатор>                       
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);   
                                                                                        
      -- сохранили свойство <Дата/время создания на мобильном устройстве>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      IF vbIsInsert 
      THEN
           -- сохранили связь с <Пользователь>
           PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), vbId, vbUserId);
           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), vbId, CURRENT_TIMESTAMP);
      END IF;

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 21.03.17                                                        *
*/

-- тест
/* SELECT * FROM gpInsertUpdateMobile_Movement_ReturnIn (inGUID          := '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}'
                                                    , inInvNumber        := '-10'
                                                    , inInvNumberPartner := '34523'                   -- Номер накладной у контрагента
                                                    , inOperDate         := CURRENT_DATE
                                                    , inOperDatePartner  := CURRENT_DATE - 1          -- Дата документа у покупателя
                                                    , inStatusId      := zc_Enum_Status_UnComplete()  -- Виды статусов
                                                    , inChecked       := false                        -- Проверен
                                                    , inPriceWithVAT  := false                        -- Цена с НДС (да/нет)
                                                    , inInsertDate    := CURRENT_TIMESTAMP            -- Дата/время создания документа
                                                    , inVATPercent    := 20.0                         -- % НДС
                                                    , inChangePercent := -5.0                         -- (-)% Скидки (+)% Наценки
                                                    , inPaidKindId    := zc_Enum_PaidKind_FirstForm() -- Вид формы оплаты
                                                    , inPartnerId     := 0                            -- Контрагент
                                                    , inUnitId        := 0                            -- Подразделение
                                                    , inContractId    := 0                            -- Договор
                                                    , inComment       := 'Test'                       -- Примечание
                                                    , inSession       := zfCalc_UserAdmin()
                                                     );

*/
