-- Function: gpUpdate_Unit_ColdOutSUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ColdOutSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_ColdOutSUN(
    IN inId                     Integer   ,    -- ключ объекта <Подразделение>
    IN inisColdOutSUN Boolean   ,    -- Отправлять ошибки отправки чеков в телеграм бот
    IN inSession                TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 OR 
      COALESCE((SELECT ObjectBoolean_ColdOutSUN.ValueData 
                FROM ObjectBoolean AS ObjectBoolean_ColdOutSUN
                WHERE ObjectBoolean_ColdOutSUN.ObjectId = COALESCE(inId, 0)
                  AND ObjectBoolean_ColdOutSUN.DescId = zc_ObjectBoolean_Unit_ColdOutSUN()), False) <>
      inisColdOutSUN
   THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ColdOutSUN(), inId, not inisColdOutSUN);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.06.22                                                       *
*/

-- select * from gpUpdate_Unit_ColdOutSUN(inId := 13338606 , inisColdOutSUN := 'False' ,  inSession := '3');