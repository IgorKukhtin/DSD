-- Function: gpUpdate_Movement_Check_SMS_Site() - проц которая у заказа ставит признак "отправлено смс"

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SMS_Site (Integer, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SMS_Site(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSMS               Boolean   , -- 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    IF inSMS = TRUE
    THEN
        -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), inId, zc_Enum_ConfirmedKind_SmsYes());
    ELSE
        -- сохранили связь с <Статус заказа (Состояние VIP-чека)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), inId, zc_Enum_ConfirmedKind_SmsNo());
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 25.08.16                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Check_SMS_Site (inId:= 0, inSMS:= TRUE, inSession:= zfCalc_UserAdmin());
