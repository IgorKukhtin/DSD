-- Function: gpUpdate_Object_Instructions_FileName()

DROP FUNCTION IF EXISTS gpUpdate_Object_Instructions_FileName (Integer, TVarChar, Tvarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Instructions_FileName(
    IN inId                      Integer   ,   	-- ключ объекта <>
    IN inFileName                TVarChar  ,    -- Имя файла
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   vbUserId := lpGetUserBySession (inSession); 
  
   IF COALESCE (inId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка. Инструкция не сохранена...';
   END IF;

   -- сохранили <Имя файла>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Instructions_FileName(), inId, inFileName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Instructions_FileName (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.02.21                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Instructions_FileName ()                            