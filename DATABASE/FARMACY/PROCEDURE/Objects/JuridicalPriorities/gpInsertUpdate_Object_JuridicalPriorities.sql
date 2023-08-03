-- Function: gpInsertUpdate_Object_JuridicalPriorities()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalPriorities(Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalPriorities(
 INOUT ioId             Integer   ,     -- ключ объекта <> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inJuridicalId    Integer   ,     -- Поставщик
    IN inGoodsId        Integer   ,     -- Главный товар
    IN inPriorities     TFloat    ,     -- % Приоритета 
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalPriorities());
   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE(inJuridicalId, 0) = 0 OR COALESCE(inGoodsId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Не заполнен поставщик или товар!';
   END IF;
 
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;
   
   IF EXISTS(SELECT * FROM gpSelect_Object_JuridicalPriorities ('3') AS JuridicalPriorities
             WHERE JuridicalPriorities.ID <> COALESCE (ioId, 0)
               AND JuridicalPriorities.JuridicalId = inJuridicalId
               AND JuridicalPriorities.GoodsId = inGoodsId)
   THEN
     RAISE EXCEPTION 'Ошибка. По товару и поставщику уже есть приоритет!';   
   END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_JuridicalPriorities());
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalPriorities(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalPriorities(), vbCode_calc, '');

   -- сохранили связь с <Поставщик>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalPriorities_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <Главный товар>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalPriorities_Goods(), ioId, inGoodsId);
   
   -- сохранили % Приоритета 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_JuridicalPriorities_Priorities(), ioId, inPriorities);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.08.20                                                       *
*/

-- тест
-- 
