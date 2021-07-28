-- Function: gpInsertUpdate_Object_DiffKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TFloat, TFloat, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiffKind(
 INOUT ioId	                  Integer   ,    -- ключ объекта <> 
    IN inCode                 Integer   ,    -- код объекта 
    IN inName                 TVarChar  ,    -- Название объекта <>
    IN inIsClose              Boolean   ,    -- закрыт для заказа
    IN inMaxOrderAmount       TFloat    ,    -- Максимальная сумма заказа 
    IN inMaxOrderAmountSecond TFloat    ,    -- Максимальная сумма заказа вторая шкала
    IN inDaysForSale          Integer   ,    -- Дней для продажы
    IN inIsLessYear           Boolean   ,    -- Разрешен заказ товара с сроком менее года
    IN inIsFormOrder          Boolean   ,    -- Сразу формировать заказ
    IN inisFindLeftovers      Boolean   ,    -- Поиск остатков по аптекам
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
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiffKind());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_DiffKind(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiffKind(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_DiffKind(), vbCode_calc, inName);

   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_Close(), ioId, inIsClose);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_LessYear(), ioId, inIsLessYear);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_FormOrder(), ioId, inIsFormOrder);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_FindLeftovers(), ioId, inisFindLeftovers);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MaxOrderAmount(), ioId, inMaxOrderAmount);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MaxOrderAmountSecond(), ioId, inMaxOrderAmountSecond);
   -- сохранили
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DiffKind_DaysForSale(), ioId, inDaysForSale);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.12.19                                                       * 
 05.06.19                                                       * 
 11.12.18         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_DiffKind()