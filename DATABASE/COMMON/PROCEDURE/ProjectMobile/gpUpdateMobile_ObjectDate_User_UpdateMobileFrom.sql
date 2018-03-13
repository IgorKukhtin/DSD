-- Function: gpUpdateMobile_ObjectDate_User_UpdateMobileFrom

DROP FUNCTION IF EXISTS gpUpdateMobile_ObjectDate_User_UpdateMobileFrom (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_ObjectDate_User_UpdateMobileFrom (
    IN inUpdateMobileFrom TDateTime , -- протокол - дата/время успешной ВХОДЯЩЕЙ синхронизации с Мобильного устройства
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- перед сохранением проверяем наличие пользователя
      IF EXISTS (SELECT 1 FROM Object AS Object_User WHERE Object_User.Id = vbUserId AND Object_User.DescId = zc_Object_User())
      THEN
           -- сохранили свойство <дата/время успешной ВХОДЯЩЕЙ синхронизации с Мобильного устройства>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_UpdateMobileFrom(), vbUserId, CURRENT_TIMESTAMP /*inUpdateMobileFrom*/);
           -- сохранили протокол
           PERFORM lpInsert_ObjectProtocol (vbUserId, vbUserId);
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 02.05.17                                                         *
*/

-- тест
-- SELECT * FROM gpUpdateMobile_ObjectDate_User_UpdateMobileFrom (inUpdateMobileFrom:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
