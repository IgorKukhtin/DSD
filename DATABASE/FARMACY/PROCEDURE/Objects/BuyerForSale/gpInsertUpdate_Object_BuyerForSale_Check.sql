-- Function: gpInsertUpdate_Object_BuyerForSale()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BuyerForSale(Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BuyerForSale(Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BuyerForSale(
 INOUT ioId             Integer   ,     -- ключ объекта <Покупатель> 
    IN inName           TVarChar  ,     -- Фамилия Имя Отчество
    IN inPhone          TVarChar  ,     -- Телефон
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_BuyerForSale());

   -- Ищем покупателя по имени
   IF EXISTS (SELECT ValueData FROM Object WHERE DescId = zc_Object_BuyerForSale() AND TRIM(UPPER(ValueData)) = TRIM(UPPER(inName))) 
   THEN
      SELECT ID INTO ioId FROM Object WHERE DescId = zc_Object_BuyerForSale() AND TRIM(UPPER(ValueData)) = TRIM(UPPER(inName));
      RETURN;
   ELSE
     ioId := 0;
   END IF; 


   -- пытаемся найти код
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_BuyerForSale());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BuyerForSale(), vbCode_calc, inName);
      
   -- сохранили Телефон
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_BuyerForSale_Phone(), ioId, inPhone);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.12.19                                                       *
*/

-- тест select gpInsertUpdate_Object_BuyerForSale(0, 'Сидоров О.О.', '3');


