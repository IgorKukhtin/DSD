  -- Function: gpUpdateObject_Contract_isReExch()

DROP FUNCTION IF EXISTS gpUpdateObject_Contract_isReExch (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Contract_isReExch(
    IN inId                  Integer   , -- Ключ объекта
    IN inisReExch            Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_ReExch(), inId, inisReExch);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);   
     
     IF vbUserId = 9457 THEN 
        RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.05.26         *
*/


-- тест
--