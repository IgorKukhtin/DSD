-- Function: gpUpdateObject_Goods_isPLM()

DROP FUNCTION IF EXISTS gpUpdateObject_Goods_isPLM (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Goods_isPLM(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inisPLM               Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Goods_isPLM());
    

     -- меняется признак
     inisPLM:= NOT inisPLM;

     -- сохранили свойство
    -- PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_PLM(), inId, inisPLM);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.26         *
*/


-- тест
-- 