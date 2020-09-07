-- Function: lpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar)

--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_MemberExternal(
 INOUT ioId	             Integer   ,    -- ключ объекта <Физические лица(сторонние)> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта
    IN inDriverCertificate   TVarChar  ,    -- Водительское удостоверение
    IN inINN                 TVarChar  ,    -- ИНН
    IN inUserId              Integer        -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer;
BEGIN
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_MemberExternal());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_MemberExternal(), TRIM (inName));
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MemberExternal(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberExternal(), vbCode_calc, TRIM (inName), inAccessKeyId:= NULL);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberExternal_DriverCertificate(), ioId, inDriverCertificate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberExternal_INN(), ioId, inINN);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.09.20         *
 27.01.20         *
 30.03.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_MemberExternal()
