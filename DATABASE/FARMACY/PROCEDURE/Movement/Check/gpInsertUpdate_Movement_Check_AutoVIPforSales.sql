-- Function: gpInsertUpdate_Movement_Check_AutoVIPforSales()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_AutoVIPforSales (Integer, Integer, TDateTime, TVarChar, TVarChar);
    
CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_AutoVIPforSales(
 INOUT ioId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inUnitId            Integer   , -- Ключ объекта <Подразделение>
    IN inDate              TDateTime , -- Дата/время документа
    IN inComment           TVarChar  , -- Комментарий клиента
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF inDate is null
    THEN
        inDate := DATE_TRUNC ('MONTH', CURRENT_DATE);
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
            Movement_Check_View.OperDate >= inDate
            AND 
            Movement_Check_View.OperDate < inDate + INTERVAL '1 DAY';
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
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

    -- Отмечаем документ как отложенный
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), ioId, TRUE);
    -- Отмечаем документ как отложенный
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_AutoVIPforSales(), ioId, TRUE);
    
      -- сохранили Комментарий клиента
    IF COALESCE (TRIM(inComment), '') <> '' THEN
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentCustomer(), ioId, TRIM(inComment));
	END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.12.21                                                       *
*/

-- тест
--