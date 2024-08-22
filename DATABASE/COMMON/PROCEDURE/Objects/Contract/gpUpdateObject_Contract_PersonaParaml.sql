-- Function: gpUpdate_Object_Contract_PersonalParam()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract_PersonalParam (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract_PersonalParam(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inPersonalId          Integer   ,    -- 
    IN inParam               Integer   ,    -- 1 - Сотрудники (ответственное лицо)
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract_Personal());

   
   IF inParam = 1
   THEN
       -- сохранили связь с <Сотрудники (ответственное лицо)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Contract_Personal(), inId, inPersonalId);
   END IF;    

 
   IF vbUserId = 9457
   THEN
       RAISE EXCEPTION 'Test. Ok!';
   END IF;     
     
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.24         *
*/
