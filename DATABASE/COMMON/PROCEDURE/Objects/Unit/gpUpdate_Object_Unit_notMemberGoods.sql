-- Function: gpUpdate_Object_Unit_notMemberGoods

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_notMemberGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_notMemberGoods(
    IN inId                    Integer   , -- ключ объекта <Подразделение>
    IN inisnotMemberGoods        Boolean   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());       --lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_notMemberGoods());

   IF inId = 0
   THEN
       Return;
   END IF;
   
   -- меняется признак
   inisnotMemberGoods:= NOT inisnotMemberGoods;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_notMemberGoods(), inId, inisnotMemberGoods);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.05.26         *            
*/

-- тест
-- 