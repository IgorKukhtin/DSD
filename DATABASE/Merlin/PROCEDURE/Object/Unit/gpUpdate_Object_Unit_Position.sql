-- Function: gpUpdate_Object_Unit_Position (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_Position (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_Position(
    IN inId                  Integer   ,    -- Ключ объекта <Подразделения> 
    IN inPosition            Integer   ,    -- 
    IN inDescCode            TVarChar  ,    -- 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGroupNameFull TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE (inId, 0) = 0
   THEN
     RETURN;
   END IF;
   

   -- сохранили Положение 
   PERFORM lpInsertUpdate_ObjectFloat ((SELECT tmp.Id FROM ObjectFloatDesc AS tmp WHERE tmp.Code = inDescCode), inId, inPosition);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.08.22         *
*/

-- тест
--