-- Function: lpInsertUpdate_Object_TranslateWord  ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_TranslateWord (Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_TranslateWord(
 INOUT ioId                       Integer   ,    -- ключ объекта <> 
    IN inParentId                Integer   ,    -- 
    IN inLanguageId               Integer   ,    -- 
    IN inValue                    TVarChar  ,    -- Название объекта <>
    IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer; 
BEGIN

   -- проверка
   IF COALESCE (inLanguageId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. <Язык> не выбран.';
   END IF;

   IF ioId <> 0
   THEN
       vbCode_calc := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   ELSE
       vbCode_calc := NEXTVAL ('Object_TranslateWord_seq')
   END IF;
   
   
   -- сохранили
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TranslateWord(), vbCode_calc ::Integer, inValue);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Language(), ioId, inLanguageId);

   IF ioId <> inParentId
   THEN
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Parent(), ioId, inParentId);
   END IF;


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.09.20         *
*/

-- тест
--