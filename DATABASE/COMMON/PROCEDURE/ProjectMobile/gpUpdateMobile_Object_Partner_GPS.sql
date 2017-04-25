-- Function: gpUpdateMobile_Object_Partner_GPS

DROP FUNCTION IF EXISTS gpUpdateMobile_Object_Partner_GPS (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_Object_Partner_GPS (
    IN inId      Integer  , -- Идентификатор контрагента
    IN inGPSN    TFloat   , -- GPS координаты точки доставки (широта)
    IN inGPSE    TFloat   , -- GPS координаты точки доставки (долгота)
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- перед сохранением координат проверяем наличие контрагента
      IF EXISTS (SELECT 1 FROM Object AS Object_Partner WHERE Object_Partner.Id = inId AND Object_Partner.DescId = zc_Object_Partner())
      THEN
           -- сохранили свойство <GPS координаты точки доставки (широта)>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_GPSN(), inId, inGPSN);
           -- сохранили свойство <GPS координаты точки доставки (долгота)>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_GPSE(), inId, inGPSE);
           -- сохранили протокол
           PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 04.04.17                                                         *
*/

-- тест
-- SELECT * FROM gpUpdateMobile_Object_Partner_GPS (inId:= 261129, inGPSN:= 56, inGPSE:= 58, inSession:= zfCalc_UserAdmin())
