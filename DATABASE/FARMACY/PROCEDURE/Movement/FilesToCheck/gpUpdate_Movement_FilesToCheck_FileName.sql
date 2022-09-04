-- Function: gpUpdate_Movement_FilesToCheck_FileName()

DROP FUNCTION IF EXISTS gpUpdate_Movement_FilesToCheck_FileName (Integer, TVarChar, Tvarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_FilesToCheck_FileName(
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
      RAISE EXCEPTION 'Ошибка. Документ не сохранен...';
   END IF;

   -- сохранили <Имя файла>
   PERFORM lpInsertUpdate_MovementString(zc_MovementString_FileName(), inId, inFileName);
   
   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Movement_FilesToCheck_FileName (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.09.22                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_FilesToCheck_FileName ()                            