-- Function: gpInsertUpdate_Object_PaidKind(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_PaidKind (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PaidKind(
 INOUT ioId             Integer,       -- Ключ объекта <Виды форм оплаты>
    IN inCode           Integer,       -- свойство <Код Вида формы оплаты>
    IN inName           TVarChar,      -- свойство <Наименование Вида формы оплаты>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_PaidKind());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_PaidKind();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование Вида формы оплаты>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_PaidKind(), inName);
   -- проверка прав уникальности для свойства <Код Вида формы оплаты>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PaidKind(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PaidKind(), Code_max, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PaidKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.13          *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PaidKind(2, 2,'ау','2')
