-- Function: gpInsertUpdateMobile_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_OrderExternal (TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_OrderExternal (TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_OrderExternal(
    IN inGUID                TVarChar  , -- Глобальный уникальный идентификатор
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inComment             TVarChar  , -- Примечание
    IN inPartnerId           Integer   , -- Контрагент
    IN inUnitId              Integer   , -- Подразделение
    IN inPaidKindId          Integer   , -- Виды форм оплаты
    IN inContractId          Integer   , -- Договора
    IN inPriceListId         Integer   , -- Прайс лист
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inInsertDate          TDateTime , -- Дата/время создания заказа по этой дате будет фильтр в журнале + подсветка записи если дата заявки позже
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbRouteId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_OrderExternal
                         ON Movement_OrderExternal.Id = MovementString_GUID.MovementId
                        AND Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;
                                                                                       
      vbOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat 
                                                   WHERE ObjectId = inPartnerId 
                                                     AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()
                                                  ), 0) :: TVarChar || ' DAY') :: INTERVAL;

      SELECT ObjectLink_Partner_Route.ChildObjectId
      INTO vbRouteId
      FROM ObjectLink AS ObjectLink_Partner_Route
      WHERE ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
        AND ObjectLink_Partner_Route.ObjectId = inPartnerId;

      vbId:= lpInsertUpdate_Movement_OrderExternal (ioId:= vbId
                                                  , inInvNumber:= inInvNumber
                                                  , inInvNumberPartner:= inInvNumber
                                                  , inOperDate:= inOperDate
                                                  , inOperDatePartner:= vbOperDatePartner
                                                  , inOperDateMark:= inOperDate
                                                  , inPriceWithVAT:= inPriceWithVAT
                                                  , inVATPercent:= inVATPercent
                                                  , inChangePercent:= inChangePercent    
                                                  , inFromId:= inPartnerId
                                                  , inToId:= inUnitId
                                                  , inPaidKindId:= inPaidKindId
                                                  , inContractId:= inContractId
                                                  , inRouteId:= vbRouteId
                                                  , inRouteSortingId:= NULL
                                                  , inPersonalId:= NULL
                                                  , inPriceListId:= inPriceListId
                                                  , inPartnerId:= inPartnerId
                                                  , inUserId:= vbUserId
                                                   );

      -- сохранили свойство <Глобальный уникальный идентификатор>                       
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);   
      -- Комментарий
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), vbId, inComment);
      -- сохранили связь с <Пользователь>
      PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), vbId, vbUserId);
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), vbId, inInsertDate);

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
                                                            , inComment:= 'Тестовая заявка' 
                                                            , inPartnerId:= NULL
                                                            , inUnitId:= NULL 
                                                            , inPaidKindId:= NULL
                                                            , inContractId:= NULL
                                                            , inPriceListId:= NULL
                                                            , inPriceWithVAT:= true
                                                            , inVATPercent:= 20
                                                            , inChangePercent:= 5
                                                            , inInsertDate:= CURRENT_TIMESTAMP 
                                                            , inSession:= zfCalc_UserAdmin()
                                                             )
*/
