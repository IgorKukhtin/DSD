-- Function: gpGet_Object_PartionCell_check()

DROP FUNCTION IF EXISTS gpGet_Object_PartionCell_check (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_PartionCell_check (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartionCell_check(
    IN inId              Integer,       -- 
 INOUT ioIsLock_record   Boolean,
    IN inPSW             TVarChar,      -- 
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     ioIsLock_record:= TRUE;

     IF NOT EXISTS (SELECT 1 FROM ObjectString AS OS WHERE OS.ObjectId = vbUserId AND OS.DescId = zc_ObjectString_User_Key() AND OS.ValueData = inPSW AND inPSW <> '')
     THEN

         RAISE EXCEPTION 'Ошибка.Введите правильный Пароль для подтвержения выбора <%>.', lfGet_Object_ValueData_sh (inId);

     END IF;
     
     ioIsLock_record:= FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.02.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_PartionCell_check (zc_PartionCell_Err(), TRUE, 'c:\key\OOO_Alan\24447183_U201210142354.ZS2', '5')
