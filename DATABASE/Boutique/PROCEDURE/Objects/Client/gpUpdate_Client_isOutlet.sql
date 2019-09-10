-- Function: gpUpdate_Client_isOutlet()

DROP FUNCTION IF EXISTS gpUpdate_Client_isOutlet(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Client_isOutlet(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisOutlet            Boolean   ,    -- Показывать покуп. в маг. Outlet Да/Нет
   OUT outisOutlet           Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Client_isOutlet());

   -- определили признак
   outisOutlet:= NOT inisOutlet;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Client_Outlet(), inId, outisOutlet);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.09.19         *

*/