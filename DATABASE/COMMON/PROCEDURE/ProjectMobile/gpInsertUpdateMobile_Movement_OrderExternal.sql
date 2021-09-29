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
   DECLARE vbisInsert Boolean;
   DECLARE vbId Integer;
   DECLARE vbOperDatePartner TDateTime;
   DECLARE vbRouteId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbChangePercent TFloat;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
      vbUserId:= lpGetUserBySession (inSession);
      
      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION 'Ошибка.Нет Прав.';
      END IF;


      IF inPaidKindId <> COALESCE ((SELECT OL_Contract_PaidKind.ChildObjectId FROM ObjectLink AS OL_Contract_PaidKind WHERE OL_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind() AND OL_Contract_PaidKind.ObjectId = inContractId), 0)
      THEN
          RAISE EXCEPTION 'Ошибка.Нет Прав менять форму оплаты. Заявка № <%> от <%> должна быть с ФО = <%>'
                        , inInvNumber
                        , lfGet_Object_ValueData_sh (inPartnerId)
                        , lfGet_Object_ValueData_sh ((SELECT OL_Contract_PaidKind.ChildObjectId FROM ObjectLink AS OL_Contract_PaidKind WHERE OL_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind() AND OL_Contract_PaidKind.ObjectId = inContractId))
                         ;
      END IF;
      
      -- Замена
      IF EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.ObjectId = inPartnerId AND ObjectLink.ObjectId = zc_ObjectLink_Partner_UnitMobile() AND ObjectLink.ChildObjectId > 0)
      THEN
          inUnitId:= (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = inPartnerId AND ObjectLink.ObjectId = zc_ObjectLink_Partner_UnitMobile());
      END IF;


      -- определение идентификатора заявки по глобальному уникальному идентификатору
      SELECT MovementString_GUID.MovementId 
           , Movement_OrderExternal.StatusId
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_OrderExternal
                         ON Movement_OrderExternal.Id = MovementString_GUID.MovementId
                        AND Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbisInsert:= (COALESCE(vbId, 0) = 0);

      IF vbisInsert = TRUE
      THEN
           PERFORM lpInsert_LockUnique (inKeyData:= inGUID, inUserId:= vbUserId);
      END IF;
                                                                                       
      vbOperDatePartner:= inOperDate + (COALESCE ((SELECT ValueData FROM ObjectFloat 
                                                   WHERE ObjectId = inPartnerId 
                                                     AND DescId = zc_ObjectFloat_Partner_PrepareDayCount()
                                                  ), 0) :: TVarChar || ' DAY') :: INTERVAL;

      -- определение идентификатора маршрута для заявки
      SELECT ObjectLink_Partner_Route.ChildObjectId
      INTO vbRouteId
      FROM ObjectLink AS ObjectLink_Partner_Route
      WHERE ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
        AND ObjectLink_Partner_Route.ObjectId = inPartnerId;

      -- определение Экспедитора по дню недели или тот же самый
      SELECT ObjectLink_Partner_MemberTake.ChildObjectId
      INTO vbPersonalId
      FROM ObjectLink AS ObjectLink_Partner_MemberTake
      WHERE ObjectLink_Partner_MemberTake.ObjectId = inPartnerId
        AND ObjectLink_Partner_MemberTake.DescId = CASE EXTRACT (DOW FROM inOperDate + ((COALESCE ((SELECT ObjectFloat.ValueData 
                                                                                                     FROM ObjectFloat 
                                                                                                     WHERE ObjectFloat.ObjectId = inPartnerId
                                                                                                       AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0)
                                                                                        + COALESCE ((SELECT ObjectFloat.ValueData 
                                                                                                     FROM ObjectFloat 
                                                                                                     WHERE ObjectFloat.ObjectId = inPartnerId 
                                                                                                       AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0)
                                                                                         )::TVarChar || ' DAY'
                                                                                       )::Interval
                                                                )
                                                        WHEN 1 THEN zc_ObjectLink_Partner_MemberTake1()
                                                        WHEN 2 THEN zc_ObjectLink_Partner_MemberTake2()
                                                        WHEN 3 THEN zc_ObjectLink_Partner_MemberTake3()
                                                        WHEN 4 THEN zc_ObjectLink_Partner_MemberTake4()
                                                        WHEN 5 THEN zc_ObjectLink_Partner_MemberTake5()
                                                        WHEN 6 THEN zc_ObjectLink_Partner_MemberTake6()
                                                        WHEN 0 THEN zc_ObjectLink_Partner_MemberTake7()
                                                   END;



      -- !!! ВРЕМЕННО - 04.07.17 !!!
      IF vbStatusId = zc_Enum_Status_Complete()
      THEN
           -- !!! ВРЕМЕННО !!!
           RETURN vbId;
      END IF;
      -- !!! ВРЕМЕННО - 04.07.17 !!!

    /*SELECT CASE 
               WHEN MIN (ObjectFloat_ContractCondition_Value.ValueData) < 0.0 THEN 
                 (MIN (ABS (ObjectFloat_ContractCondition_Value.ValueData)) * -1.0)::TFloat
               ELSE MIN (ObjectFloat_ContractCondition_Value.ValueData)::TFloat
             END AS ContractConditionKindValue
      INTO vbChangePercent
      FROM ObjectLink AS ObjectLink_ContractCondition_Contract
           JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                           ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                          AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                          AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
           JOIN ObjectFloat AS ObjectFloat_ContractCondition_Value
                            ON ObjectFloat_ContractCondition_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                           AND ObjectFloat_ContractCondition_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                           AND ObjectFloat_ContractCondition_Value.ValueData <> 0.0
           JOIN Object AS Object_ContractCondition
                       ON Object_ContractCondition.Id = ObjectLink_ContractCondition_Contract.ObjectId
                      AND Object_ContractCondition.isErased = FALSE
           JOIN Object AS Object_Contract
                       ON Object_Contract.Id = ObjectLink_ContractCondition_Contract.ChildObjectId
                      AND Object_Contract.isErased = FALSE
      WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
        AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId
      GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
             , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId;*/

      vbChangePercent:= COALESCE (vbChangePercent, 0)::TFloat;

      IF (vbisInsert = FALSE) AND (vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased()))
      THEN -- если заявка проведена, то распроводим
           PERFORM lpUnComplete_Movement_OrderExternal (inMovementId:= vbId, inUserId:= vbUserId);
      END IF;

      -- создали Документ
      vbId:= (SELECT tmp.ioId
              FROM lpInsertUpdate_Movement_OrderExternal (ioId              := vbId
                                                        , inInvNumber       := (zfConvert_StringToNumber (inInvNumber) + lfGet_User_BillNumberMobile (vbUserId)) :: TVarChar
                                                        , inInvNumberPartner:= COALESCE ((SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = vbId AND MS.DescId = zc_MovementString_InvNumberPartner()), '')
                                                        , inOperDate        := inOperDate
                                                        , inOperDatePartner := vbOperDatePartner
                                                        , inOperDateMark    := inOperDate
                                                        , inPriceWithVAT    := inPriceWithVAT
                                                        , inVATPercent      := inVATPercent
                                                        , ioChangePercent   := vbChangePercent    
                                                        , inFromId          := inPartnerId
                                                        , inToId            := inUnitId
                                                        , inPaidKindId      := inPaidKindId
                                                        , inContractId      := inContractId
                                                        , inRouteId         := vbRouteId
                                                        , inRouteSortingId  := NULL
                                                        , inPersonalId      := vbPersonalId
                                                        , inPriceListId     := inPriceListId
                                                        , inPartnerId       := NULL
                                                        , inisPrintComment  := FALSE ::Boolean
                                                        , inUserId          := vbUserId
                                                         ) AS tmp);

      -- сохранили свойство <Глобальный уникальный идентификатор>                       
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);   
      -- Комментарий
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), vbId, inComment);

      -- сохранили свойство <Дата/время создания заказа на мобильном устройстве>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol (vbId, vbUserId, FALSE);

      RETURN vbId;                                                                      
END;                                                                                    
$BODY$                                                                                  
  LANGUAGE plpgsql VOLATILE;                                                            

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 25.05.21         * add inisPrintComment
 28.02.17                                                         *
*/

-- тест
/* SELECT * FROM gpInsertUpdateMobile_Movement_OrderExternal (inGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}'
                                                            , inInvNumber:= '-1'
                                                            , inOperDate:= CURRENT_DATE
                                                            , inComment:= 'Тестовая заявка' 
                                                            , inPartnerId:= 17819
                                                            , inUnitId:= 8459 
                                                            , inPaidKindId:= zc_Enum_PaidKind_SecondForm()
                                                            , inContractId:= 16687
                                                            , inPriceListId:= 18840
                                                            , inPriceWithVAT:= false
                                                            , inVATPercent:= 20
                                                            , inChangePercent:= 5
                                                            , inInsertDate:= CURRENT_TIMESTAMP 
                                                            , inSession:= zfCalc_UserAdmin()
                                                             )
*/

/* SELECT * FROM gpInsertUpdateMobile_Movement_OrderExternal (inGUID:= '{14F4EEA5-E10B-44D2-B6F6-DE71F0DED47E}'
                                                            , inInvNumber:= '-2'
                                                            , inOperDate:= CURRENT_DATE
                                                            , inComment:= 'Тестовая заявка 2' 
                                                            , inPartnerId:= 17819
                                                            , inUnitId:= 8459 
                                                            , inPaidKindId:= zc_Enum_PaidKind_SecondForm()
                                                            , inContractId:= 16687
                                                            , inPriceListId:= 18840
                                                            , inPriceWithVAT:= false
                                                            , inVATPercent:= 20
                                                            , inChangePercent:= 10
                                                            , inInsertDate:= CURRENT_TIMESTAMP 
                                                            , inSession:= zfCalc_UserAdmin()
                                                             )
*/
