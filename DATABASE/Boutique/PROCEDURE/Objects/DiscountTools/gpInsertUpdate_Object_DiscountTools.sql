-- Function: gpInsertUpdate_Object_DiscountTools (Integer,  TFloat, TFloat, TTFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountTools (Integer,  TFloat, TFloat, TTFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountTools(
 INOUT ioId           Integer,       -- ключ объекта 
    IN inStartSumm    TFloat,        -- Начальная сумма скидки
    IN inEndSumm      TFloat,        -- Конечная сумма скидки
    IN inDiscountTax  TFloat,        -- Процент скидки
    IN inDiscountId   Integer,       -- Связь Названия накопительных скидок
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;

BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountTools());
   UserId := inSession;



   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiscountTools(), Code_max);



   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_DiscountTools(), 0, '');
   
   -- сохранили связь с <Названия накопительных скидок>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_DiscountTools_Discount(), ioId, inDiscountId);

   -- сохранили свойства
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiscountTools_StartSumm(), ioId, inStartSumm);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiscountTools_EndSumm(), ioId, inEndSumm);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiscountTools_DiscountTax(), ioId, inDiscountTax);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
23.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiscountTools()
