-- Названия накопительных скидок

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Discount (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Discount(
 INOUT ioId             Integer,       -- Ключ объекта <Названия накопительных скидок>            
 INOUT ioCode           Integer,       -- Код объекта <Названия накопительных скидок>             
    IN inName           TVarChar,      -- Название объекта <Названия накопительных скидок>        
    IN inDiscountKindId Integer,       -- Ключ объекта <Вид скидки>
    IN inSession        TVarChar       -- сессия пользователя                     
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Discount_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_Discount_seq'); 
   END IF; 

   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Discount(), inName); 
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Discount(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Discount(), ioCode, inName);
  
   -- сохранили связь с <Вид скидки>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Discount_DiscountKind(), ioId, inDiscountKindId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                          *
22.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Discount(0, 1000, 'testdb',)
