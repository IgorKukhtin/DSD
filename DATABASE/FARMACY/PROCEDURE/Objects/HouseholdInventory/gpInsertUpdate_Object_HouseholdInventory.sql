-- Function: gpInsertUpdate_Object_HouseholdInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_HouseholdInventory (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_HouseholdInventory(
 INOUT ioId                     Integer   ,     -- ключ объекта <Город>
    IN inCode                   Integer   ,     -- Код объекта
    IN inName                   TVarChar  ,     -- Название объекта
    IN inCountForPrice          TFloat    ,     -- Себестоимость
    IN inSession                TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_HouseholdInventory());

   IF COALESCE (inName, '') = ''
   THEN
      RAISE EXCEPTION 'Ошибка. Не заполнено <Наименование>...';
   END IF;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_HouseholdInventory());

   -- проверка уникальности для свойства <Наименование> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_HouseholdInventory(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_HouseholdInventory(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_HouseholdInventory(), vbCode_calc, inName);

   -- сохранили свойство <Себестоимость>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_HouseholdInventory_CountForPrice(), ioId, inCountForPrice);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_HouseholdInventory (Integer, Integer, TVarChar, TFloat, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_HouseholdInventory(ioId:=null, inCode:=null, inName:='Щетка', inSession:='3')