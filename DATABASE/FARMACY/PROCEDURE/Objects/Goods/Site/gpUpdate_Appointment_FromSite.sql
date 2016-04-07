-- Function: gpUpdate_Appointment_FromSite()

DROP FUNCTION IF EXISTS gpUpdate_Appointment_FromSite (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Appointment_FromSite(
    IN inAppointmentCode     Integer   ,    -- назначение препарата
    IN inAppointmentName     TVarChar  ,    -- назначение препарата
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbApoitmentId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- для адекватного кода
    IF inAppointmentCode <> 0
    THEN
        -- поиск по коду
        vbApoitmentId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Appointment() AND ObjectCode = inAppointmentCode);
        -- добавили/изменили - ВСЕГДА
        vbApoitmentId:= lpInsertUpdate_Object (vbApoitmentId, zc_Object_Appointment(), inAppointmentCode, inAppointmentName);

        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (vbApoitmentId, vbUserId);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 07.04.16                                        *
*/
