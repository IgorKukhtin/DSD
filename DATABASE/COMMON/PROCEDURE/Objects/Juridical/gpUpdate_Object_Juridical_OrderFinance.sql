-- Function: gpUpdate_Object_Juridical_OrderFinance()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_OrderFinance (Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_OrderFinance(
    IN inId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inSummOrderFinance    TFloat    ,    --
    IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());

   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_SummOrderFinance(), inId, inSummOrderFinance);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.19         *
*/

-- тест
--