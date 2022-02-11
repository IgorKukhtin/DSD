-- Function: gpInsertUpdate_Object_Unit_Position (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit_Position (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit_Position(
    IN inId                  Integer   ,    -- Ключ объекта <Подразделения> 
    IN inLeft                Integer   ,    -- ключ объекта <Група> 
    IN inTop                 Integer   ,    -- ключ объекта <Група> 
    IN inWidth               Integer   ,    -- ключ объекта <Група> 
    IN inHeight              Integer   ,    -- ключ объекта <Група> 
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
   

   -- сохранили 	Положение зафиксирована
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PositionFixed(), inId, True);
   -- сохранили Положение относительно левого края
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_Left(), inId, inLeft);
   -- сохранили Положение относительно верхнего края
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_Top(), inId, inTop);
   -- сохранили Ширина
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_Width(), inId, inWidth);
   -- сохранили Высота
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_Height(), inId, inHeight);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.22                                                       *
*/

-- тест
--