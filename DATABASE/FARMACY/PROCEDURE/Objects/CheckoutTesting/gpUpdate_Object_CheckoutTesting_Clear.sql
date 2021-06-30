-- Function: gpUpdate_Object_CheckoutTesting_Clear()

DROP FUNCTION IF EXISTS gpUpdate_Object_CheckoutTesting_Clear (Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CheckoutTesting_Clear(
    IN inId                      Integer   ,   	-- ключ объекта <>
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 

   
   IF COALESCE(inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Запись не сохранена.';
   END IF;

   -- сохранили связь с <Тип расчета заработной платы>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CheckoutTesting_Updates(), inId, False);

   -- сохранили свойство <Дата начала действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CheckoutTesting_DateUpdate(), inId, Null);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.06.21                                                       *
*/

-- тест
-- 

select * from gpUpdate_Object_CheckoutTesting_Clear(inId := 0, inSession := '3');