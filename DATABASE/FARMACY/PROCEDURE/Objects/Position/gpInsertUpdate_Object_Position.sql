-- Function: gpInsertUpdate_Object_Position()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position(Integer, Integer, TFloat, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Position(
 INOUT ioId	             Integer   ,    -- ключ объекта <Должности> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта <
    IN inTaxService          TFloat    ,    -- % от выручки
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Position());
   vbUserId := inSession;
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Position());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Position(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Position(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Position(), vbCode_calc, inName);

   -- % бонусирования
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Position_TaxService(), ioId, inTaxService);
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.02.16         * add inTaxService
 21.01.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Position()
