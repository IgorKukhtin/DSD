-- Function: gpInsertUpdateMobile_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_OrderExternal (TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_OrderExternal(
    IN inGUID                TVarChar  , -- Глобальный уникальный идентификатор
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPartnerId           Integer   , -- Контрагент
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inPriceListId         Integer   , -- Прайс лист
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbId          Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert    Boolean;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

      -- определяем ключ доступа
      vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

      SELECT MovementId INTO vbId FROM MovementString WHERE DescId = zc_MovementString_GUID() AND ValueData = inGUID;

      -- определяем признак Создание/Корректировка
      vbIsInsert:= COALESCE (vbId, 0) = 0;

      -- сохранили <Документ>
      vbId:= lpInsertUpdate_Movement (vbId, zc_Movement_OrderExternal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

      IF vbIsInsert
      THEN
           -- сохранили свойство <Дата создания>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbId, CURRENT_TIMESTAMP);
           -- сохранили свойство <Пользователь (создание)>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), vbId, vbUserId);
      END IF;

      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

      -- сохранили связь с <Контрагент>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbId, inPartnerId);    

      -- сохранили связь с <Виды форм оплаты >
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), vbId, inPaidKindId);

      -- сохранили связь с <Договора>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), vbId, inContractId);

      -- сохранили связь с <Прайс лист>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), vbId, inPriceListId);

      -- сохранили свойство <Цена с НДС (да/нет)>
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), vbId, inPriceWithVAT);
      -- сохранили свойство <% НДС>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), vbId, inVATPercent);
      -- сохранили свойство <(-)% Скидки (+)% Наценки >
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbId, inChangePercent);

      -- пересчитали Итоговые суммы по накладной
      PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbId);

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol (vbId, vbUserId, vbIsInsert);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 28.02.17                                                         *
*/

-- тест
/* SELECT * FROM gpInsertUpdateMobile_Movement_OrderExternal (inGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}'
                                                            , inInvNumber:= '-1'
                                                            , inOperDate:= CURRENT_DATE
                                                            , inPartnerId:= NULL
                                                            , inPaidKindId:= NULL
                                                            , inContractId:= NULL
                                                            , inPriceListId:= NULL
                                                            , inPriceWithVAT:= true
                                                            , inVATPercent:= 20
                                                            , inChangePercent:= 5
                                                            , inSession:= zfCalc_UserAdmin()
                                                             )
*/
