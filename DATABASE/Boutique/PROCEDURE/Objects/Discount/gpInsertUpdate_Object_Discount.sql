-- Function: gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, TFloat,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Discount(
 INOUT ioId           Integer,       -- ключ объекта <>
    IN inCode         Integer,       -- свойство <Код>
    IN inName         TVarChar,      -- главное Название
    IN inKindDiscount TFloat,        --
    IN inSession      TVarChar       -- сессия пользователя
)
  RETURNS integer
  AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;

BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());
   UserId := inSession;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Discount();
   ELSE
       Code_max := inCode;
   END IF;

   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Discount(), inName); 
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Discount(), Code_max);



   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Discount(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Discount_KindDiscount(), ioId, inKindDiscount);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
22.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Discount(0, 1000, 'testdb',)
