-- Function: gpInsertUpdate_Object_ReceiptCost(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_ReceiptCost (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptCost(
 INOUT ioId             Integer,       -- Ключ объекта <Затраты в рецептурах>
    IN inCode           Integer,       -- свойство <Код>
    IN inName           TVarChar,      -- свойство <Наименование>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptCost());
   vbUserId:= lpGetUserBySession (inSession);


   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ReceiptCost()); 
   
   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReceiptCost(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReceiptCost(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptCost(), vbCode_calc, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ReceiptCost (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.07.13          * 
*/
-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptCost()