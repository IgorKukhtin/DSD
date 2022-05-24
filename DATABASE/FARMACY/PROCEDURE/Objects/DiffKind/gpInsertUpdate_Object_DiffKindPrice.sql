-- Function: gpInsertUpdate_Object_DiffKindPrice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKindPrice (Integer, Integer, TVarChar, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiffKindPrice(
 INOUT ioId	                  Integer   ,    -- ключ объекта <> 
    IN inCode                 Integer   ,    -- код объекта 
    IN inName                 TVarChar  ,    -- Название объекта <>
    IN inDiffKindId           Integer   ,    -- Вид отказа
    IN inPrice                TFloat    ,    -- Минимальная цена
    IN inAmount               TFloat    ,    -- Количество упаковок
    IN inSumma                TFloat    ,    -- Максимальная сумма заказа
    IN inSession              TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession;
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiffKindPrice());
   
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiffKindPrice(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_DiffKindPrice(), vbCode_calc, COALESCE(inName, ''));

   -- сохранили
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiffKindPrice_DiffKind(), ioId, inDiffKindId);

   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiffKindPrice_MinPrice(), ioId, inPrice);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiffKindPrice_Amount(), ioId, inAmount);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiffKindPrice_Summa(), ioId, inSumma);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.05.22                                                       * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiffKindPrice()