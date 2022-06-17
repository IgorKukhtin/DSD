-- Function: gpInsertUpdate_Movement_Check_Site()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Boolean, TVarChar, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Boolean, TVarChar, Boolean, Integer, Boolean, TDateTime, TVarChar);
      
CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_Site(
 INOUT ioId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUnitId            Integer   , -- Ключ объекта <Подразделение>
    IN inDate              TDateTime , -- Дата/время документа
    IN inBayerId           Integer   , -- ID покупателя с сайта
    IN inBayer             TVarChar  , -- Покупатель ВИП 
    IN inBayerPhone        TVarChar  , -- Контактный телефон (Покупателя)
    IN inInvNumberOrder    TVarChar  , -- Номер заказа (с сайта)
    IN inManagerName       TVarChar  , -- Менеджер – Вип
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
   DECLARE vbSiteDiscount TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);

    IF inDate is null
    THEN
        inDate := CURRENT_TIMESTAMP::TDateTime;
    END IF;
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

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

    inBayer := translate(inBayer, chr('8296')||chr('8297')||chr('8203'), '');

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
    IF COALESCE(vbSiteDiscount, 0) <> 0 THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Site(), ioId, True);
	END IF;

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
    inComment := translate(inComment, chr('8296')||chr('8297')||chr('8203'), '');
    IF COALESCE (TRIM(inComment), '') <> '' THEN
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentCustomer(), ioId, TRIM(inComment));
	END IF;
    
    -- Заказ с мобильного приложения
    
    IF COALESCE(inisMobileApp, FALSE) = True
    THEN

      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_MobileApplication(), ioId, True);
    
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
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Coming(), ioId, inDateComing);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 29.01.19                                                                                      *
 17.12.15                                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Check_Site (0, 1, '2022-05-09 13:26:27'::TDateTime, 68870, 'Oleksii', '+38(050) 043-4130', '394725', '', False, 0 , False, '', TRUE, 123, TRUE, CURRENT_DATE::tdatetime, '3'); 
