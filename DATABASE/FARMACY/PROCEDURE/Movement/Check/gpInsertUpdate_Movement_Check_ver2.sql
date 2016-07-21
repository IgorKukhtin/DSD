-- Function: gpInsertUpdate_Movement_Check()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar);
  
CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_ver2(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inDate                TDateTime , --Дата/время документа
    IN inCashRegister        TVarChar  , --Серийник кассового аппарата
    IN inPaidType            Integer   , --тип оплаты
    IN inManagerId           Integer   , --Менеджер
    IN inBayer               TVarChar  , --Покупатель ВИП 
    IN inFiscalCheckNumber   TVarChar  , --Номер фискального чека
    IN inNotMCS              Boolean  ,  --Не участвует в расчете НТЗ
    IN inDiscountExternalId  Integer  DEFAULT 0,  -- Проект дисконтных карт
    IN inDiscountCardNumber  TVarChar DEFAULT '', -- № Дисконтной карты
    IN inSession             TVarChar DEFAULT ''  -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbInvNumber Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbPaidTypeId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
    vbUserId := inSession;

    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;   
    vbUnitId := vbUnitKey::Integer;

    IF COALESCE(vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION 'Для пользователя не установлено значение параметра Подразделение';
    END IF;

    IF inDate is null
    THEN
        inDate := CURRENT_TIMESTAMP::TDateTime;
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
            Movement_Check_View.UnitId = vbUnitId 
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

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, vbUnitId);
	
    --сохранили связь с кассовым аппаратом
    IF COALESCE(inCashRegister,'') <> ''
    THEN
        vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister,
                                                                inSession := inSession);
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),ioId,vbCashRegisterId);
    END IF;
    
    -- сохранили отметку <Не участвует в расчете НТЗ>
    PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_NotMCS(),ioId,inNotMCS);
    
    -- сохранили Номер чека в кассовом аппарате
    PERFORM lpInsertUpdate_MovementString(zc_MovementString_FiscalCheckNumber(),ioId,inFiscalCheckNumber);
    
    -- сохранили связь с <Тип полаты>
    IF inPaidType <> -1
    THEN
        if inPaidType = 0 then
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),ioId,zc_Enum_PaidType_Cash());
        ELSEIF inPaidType = 1 THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),ioId,zc_Enum_PaidType_Card());
        ELSE
            RAISE EXCEPTION 'Ошибка.Не определен тип оплаты';
        END IF;
    END IF;
    
    -- сохранили связь с менеджером и покупателем
    IF COALESCE (inManagerId,0) <> 0 THEN
        -- Приписываем менеджера
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, inManagerId);
        -- прописываем ФИО покупателя
        PERFORM lpInsertUpdate_MovementString(zc_MovementString_Bayer(), ioId, inBayer);
        -- Отмечаем документ как отложенный
        PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), ioId, True);      
    END IF;
 
    -- сохранили связь с <Дисконтная карта> + здесь же и сформировали <Дисконтная карта>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DiscountCard(), ioId, lpInsertFind_Object_DiscountCard (inObjectId:= inDiscountExternalId, inValue:= inDiscountCardNumber, inUserId:= vbUserId));

    -- сохранили протокол
    -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 20.07.16                                        *
 03.11.15                                                                       *
*/
