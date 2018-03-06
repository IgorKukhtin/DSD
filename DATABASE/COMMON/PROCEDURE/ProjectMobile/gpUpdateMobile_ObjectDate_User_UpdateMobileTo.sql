-- Function: gpUpdateMobile_ObjectDate_User_UpdateMobileTo

DROP FUNCTION IF EXISTS gpUpdateMobile_ObjectDate_User_UpdateMobileTo (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_ObjectDate_User_UpdateMobileTo (
    IN inUpdateMobileTo TDateTime , -- протокол - дата/время успешной ИСХОДЯЩЕЙ синхронизации на Мобильное устройство
    IN inSession        TVarChar    -- сессия пользователя
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
           -- сохранили свойство <дата/время успешной ИСХОДЯЩЕЙ синхронизации на Мобильное устройство>
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_UpdateMobileTo(), vbUserId, CURRENT_TIMESTAMP /*inUpdateMobileTo*/);
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
-- SELECT * FROM gpUpdateMobile_ObjectDate_User_UpdateMobileTo (inUpdateMobileTo:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
