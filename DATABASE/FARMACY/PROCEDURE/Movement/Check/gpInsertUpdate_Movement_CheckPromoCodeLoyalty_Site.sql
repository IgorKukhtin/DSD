-- Function: gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Boolean, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Boolean, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Boolean, TFloat, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Boolean, TFloat, Boolean, TVarChar, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Boolean, TFloat, Boolean, TVarChar, Boolean, Integer, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site(
 INOUT ioId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUnitId            Integer   , -- Ключ объекта <Подразделение>
    IN inDate              TDateTime , -- Дата/время документа
    IN inBayerId           Integer   , -- ID покупателя с сайта
    IN inBayer             TVarChar  , -- Покупатель ВИП
    IN inBayerPhone        TVarChar  , -- Контактный телефон (Покупателя)
    IN inInvNumberOrder    TVarChar  , -- Номер заказа (с сайта)
    IN inManagerName       TVarChar  , -- Менеджер – Вип
    IN inPromoCodeId       Integer   , -- ID Промокода
    IN inisDelivery        Boolean   , -- Hаша доставка
    IN inDeliveryPrice     TFloat    , -- Цена доставки
    IN inisCallOrder       Boolean   , -- Заказ по звонку покупателя
    IN inComment           TVarChar  , -- Комментарий клиента
    IN inisMobileApp       Boolean   , -- Заказ с мобильного приложения
    IN inUserReferals      Integer   , -- По рекомендации сотрудника
    IN inisConfirmByPhone  Boolean   , -- Подтвердить телефонным звонком
    IN inDateComing        TDateTime , -- Дата прихода в аптеку
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbPaidTypeId Integer;
   DECLARE vbManagerId Integer;

   DECLARE vbGUID TVarChar;
   DECLARE vbMovementId Integer;
   DECLARE vbDiscountAmount TFloat;
   DECLARE vbisErased Boolean;
   DECLARE vbParentId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbStatusId Integer;
   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale TDateTime;
   DECLARE vbMonthCount Integer;
   DECLARE vbisElectron Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF inDate is null
    THEN
        inDate := CURRENT_TIMESTAMP::TDateTime;
    END IF;

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Контроль акции
    IF NOT EXISTS(SELECT 1 FROM MovementItem
                  INNER JOIN Movement  ON Movement.Id = MovementItem.MovementId
                                      AND Movement.DescId = zc_Movement_Loyalty()
                  WHERE MovementItem.Id = inPromoCodeId
                    AND MovementItem.DescId = zc_MI_Sign())
    THEN
      RAISE EXCEPTION 'Ошибка. Промокод не найден.';
    END IF;

    SELECT MovementItem.MovementID, MovementItem.Amount, MovementItem.isErased, MovementItem.ParentId, MIDate_OperDate.ValueData, MIString_GUID.ValueData,
           Movement.InvNumber::Integer, Movement.StatusId, MovementDate_StartSale.ValueData, MovementDate_EndSale.ValueData,
           MovementFloat_MonthCount.ValueData::Integer, COALESCE(MovementBoolean_Electron.ValueData, FALSE) ::Boolean
    INTO vbMovementId, vbDiscountAmount, vbisErased, vbParentId, vbOperDate, vbGUID,
         vbInvNumber, vbStatusId, vbStartSale, vbEndSale, vbMonthCount, vbisElectron
    FROM MovementItem

         LEFT JOIN MovementItemString AS MIString_GUID
                                      ON MIString_GUID.MovementItemId = MovementItem.Id
                                     AND MIString_GUID.DescId = zc_MIString_GUID()

         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                    ON MIDate_OperDate.MovementItemId = MovementItem.ID
                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

         LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

         LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
         LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
         LEFT JOIN MovementFloat AS MovementFloat_MonthCount
                                 ON MovementFloat_MonthCount.MovementId =  Movement.Id
                                AND MovementFloat_MonthCount.DescId = zc_MovementFloat_MonthCount()

         LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                   ON MovementBoolean_Electron.MovementId =  Movement.Id
                                  AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

    WHERE MovementItem.Id = inPromoCodeId;

    IF EXISTS(SELECT 1 FROM MovementFloat AS MovementFloat_MovementItemId
              WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                AND MovementFloat_MovementItemId.ValueData = inPromoCodeId)
    THEN
      IF vbDiscountAmount < (SELECT SUM(MovementFloat_TotalSummChangePercent.ValueData)
                             FROM MovementFloat AS MovementFloat_MovementItemId
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                          ON MovementFloat_TotalSummChangePercent.MovementId =  MovementFloat_MovementItemId.MovementId
                                                         AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
                                   WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                     AND MovementFloat_MovementItemId.ValueData = inPromoCodeId)
      THEN
        RAISE EXCEPTION 'Ошибка. Продажа по промокоду <%> уже произведена.', vbGUID;
      END IF;
    END IF;

    IF vbisErased = TRUE
    THEN
      RAISE EXCEPTION 'Ошибка. Промокод <%> удален.', vbGUID;
    END IF;

    IF COALESCE(vbParentId, 0) = 0 AND vbisElectron = FALSE
    THEN
      RAISE EXCEPTION 'Ошибка. По промокоду <%> нет подтверждения продажи.', vbGUID;
    END IF;

    -- Если неподходят даты
    IF vbStartSale > CURRENT_DATE OR vbEndSale < CURRENT_DATE
    THEN
      RAISE EXCEPTION 'Ошибка. Срок действия "Программы лояльности" по промокоду <%> закончен.', vbGUID;
    END IF;

    -- Если аптека невходит
    IF COALESCE(inUnitID, 0) <> 0 AND
       NOT EXISTS(SELECT 1 FROM MovementItem AS MI_Loyalty
                  WHERE MI_Loyalty.MovementId = vbMovementId
                    AND MI_Loyalty.DescId = zc_MI_Child()
                    AND MI_Loyalty.isErased = FALSE
                    AND MI_Loyalty.ObjectId = inUnitID)
    THEN
      RAISE EXCEPTION 'Ошибка. "Программы лояльности" по промокоду <%> на аптеку не распространяеться.', vbGUID;
    END IF;

    -- Если просрочен даты
    IF (vbOperDate + (vbMonthCount||' MONTH')::INTERVAL) < CURRENT_DATE
    THEN
      RAISE EXCEPTION 'Ошибка. Срок действия промокода <%> закончен.', vbGUID;
    END IF;

	IF COALESCE(ioId,0) = 0
    THEN
        SELECT
            COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1
        INTO
            vbInvNumber
        FROM
            Movement_Check_View
        WHERE
            Movement_Check_View.UnitId = inUnitId
            AND
            Movement_Check_View.OperDate > CURRENT_DATE;
    ELSE
        SELECT
            InvNumber
        INTO
            vbInvNumber
        FROM
            Movement_Check_View
        WHERE
            Movement_Check_View.Id = ioId;
    END IF;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Check(), vbInvNumber::TVarChar, inDate, NULL);


    -- поиск менеджера
    IF TRIM (inManagerName) <> ''
    THEN
        vbManagerId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = zfConvert_StringToNumber (TRIM (inManagerName)) AND Object.DescId = zc_Object_Member() AND zfConvert_StringToNumber (inManagerName) <> 0);
        -- vbManagerId:= (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inManagerName) AND Object.DescId = zc_Object_Member());
    END IF;
    -- сохранили связь с менеджером
    IF COALESCE (vbManagerId,0) <> 0
    THEN
        -- сохранили менеджера
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, vbManagerId);
    END IF;

    IF vbIsInsert = TRUE
    THEN
        -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), ioId, zc_Enum_ConfirmedKind_SmsNo());
    END IF;

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), ioId, zc_Enum_ConfirmedKind_UnComplete());

    inBayer := translate(inBayer, chr('8296')||chr('8297'), '');

    IF COALESCE (inBayerId, 0) <> 0
    THEN
      -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BuyerForSite(), ioId, gpInsertUpdate_Object_BuyerForSite(inBayerID, inBayer, inBayerPhone, inSession));    
    ELSE
      -- сохранили ФИО покупателя
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_Bayer(), ioId, inBayer);
      -- сохранили Контактный телефон (Покупателя)
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_BayerPhone(), ioId, inBayerPhone);
    END IF;

    -- сохранили Номер заказа (с сайта)
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);
    -- Отмечаем документ как отложенный
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), ioId, TRUE);
	-- сохранили Id промокода
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), ioId, inPromoCodeId);

    IF COALESCE(inisDelivery, False) = TRUE
    THEN
      -- сохранили <Наша доставка с сайта>
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DeliverySite(), ioId, inisDelivery);
      -- сохранили <Сумма доставки>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummaDelivery(), ioId, inDeliveryPrice);
    END IF;

    IF COALESCE (inisCallOrder, False) = TRUE THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_CallOrder(), ioId, True);
	END IF;

      -- сохранили Комментарий клиента
    inComment := translate(inComment, chr('8296')||chr('8297'), '');
    IF COALESCE (TRIM(inComment), '') <> '' THEN
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentCustomer(), ioId, TRIM(inComment));
	END IF;

    -- Заказ с мобильного приложения
    
    IF COALESCE(inisMobileApp, FALSE) = True
    THEN

      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_MobileApplication(), ioId, True);
    
      -- Автопростановка ОС   
      IF EXISTS(SELECT 1
                FROM ObjectBoolean
                WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Unit_AutospaceOS()
                  AND ObjectBoolean.ObjectId = inUnitId
                  AND ObjectBoolean.ValueData = TRUE) 
      THEN
        PERFORM lpInsertUpdate_MovementBoolean (zc_ObjectBoolean_Unit_AutospaceOS(), ioId, True);
      END IF;

      -- По рекомендации сотрудника   
      IF COALESCE(inUserReferals, 0) <> 0 AND
         EXISTS(SELECT Object_User.Id
                FROM Object AS Object_User
                WHERE Object_User.DescId = zc_Object_User()
                  AND Object_User.ObjectCode = inUserReferals) 
      THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserReferals(), ioId, (SELECT Object_User.Id
                                                                                                FROM Object AS Object_User
                                                                                                WHERE Object_User.DescId = zc_Object_User()
                                                                                                  AND Object_User.ObjectCode = inUserReferals));
      END IF;
    END IF;

    -- Подтвердить телефонным звонком
    IF COALESCE(inisConfirmByPhone, FALSE) = True
    THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ConfirmByPhone(), ioId, True);
    END IF;

    -- Дата прихода в аптеку
    IF inDateComing IS NOT NULL
    THEN
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Coming(), ioId, date_trunc('day',inDateComing));
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 30.01.19        *
 17.17.18        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_CheckPromoCodeLoyalty_Site (ioId := 0, inUnitId := 183292, inDate := NULL::TDateTime, inBayer := 'Test Bayer'::TVarChar, inBayerPhone:= '11-22-33', inInvNumberOrder:= '12345', inManagerName:= '5', inPromoCodeId := 297504593, inSession := '3'); -- Аптека_1 пр_Правды_6

