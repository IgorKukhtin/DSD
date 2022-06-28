-- Function: gpUpdate_Movement_Check_DateComing_Site()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_DateComing_Site (Integer, TDateTime, TVarChar);
      
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_DateComing_Site(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inDateComing        TDateTime , -- Дата прихода в аптеку
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    -- Дата прихода в аптеку
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Coming(), inId, inDateComing);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inSession, inDateComing;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 27.06.22                                                                    *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Check_DateComing_Site (28372118 , CURRENT_DATE::tdatetime, '3'); 
