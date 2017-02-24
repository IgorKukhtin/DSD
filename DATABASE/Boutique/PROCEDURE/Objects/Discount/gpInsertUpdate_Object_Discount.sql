-- Function: gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, TFloat,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Discount(
 INOUT ioId           Integer,       -- Ключ объекта <Названия накопительных скидок>            
    IN inCode         Integer,       -- Код объекта <Названия накопительных скидок>             
    IN inName         TVarChar,      -- Название объекта <Названия накопительных скидок>        
    IN inKindDiscount TFloat,        -- поле объекта <Вид скидки>
    IN inSession      TVarChar       -- сессия пользователя                     
)
  RETURNS integer
  AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCode_max Integer;

BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

    -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_Discount()); 

   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Discount(), inName); 
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Discount(), vbCode_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Discount(), vbCode_max, inName);
   -- сохранили <Вид скидки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Discount_KindDiscount(), ioId, inKindDiscount);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

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
