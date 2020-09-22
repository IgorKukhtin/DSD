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

   IF COALESCE (ioId,0) <> 0
   THEN
       vbCode_calc := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   END IF;
   
   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С vbCode_calc -> vbCode_calc
   IF COALESCE (ioId, 0) = 0 AND COALESCE (vbCode_calc, 0) <> 0 THEN vbCode_calc := NEXTVAL ('Object_TranslateWord_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (vbCode_calc, 0) = 0  THEN vbCode_calc := NEXTVAL ('Object_TranslateWord_seq'); 
   ELSEIF vbCode_calc = 0
         THEN vbCode_calc := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 
   
      -- проверка
   IF COALESCE (inLanguageId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. <Язык> не выбран.';
   END IF;
   
   -- сохранили
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TranslateWord(), vbCode_calc ::Integer, inValue);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Language(), ioId, inLanguageId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Parent(), ioId, inParentId);


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