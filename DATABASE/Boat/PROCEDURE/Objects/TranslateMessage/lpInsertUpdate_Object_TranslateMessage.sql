-- Function: lpInsertUpdate_Object_TranslateMessage  ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_TranslateMessage (Integer, Integer, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_TranslateMessage(
 INOUT ioId                       Integer   ,    -- ключ объекта <>
    IN inParentId                 Integer   ,    --
    IN inLanguageId               Integer   ,    -- Язык перевода
    IN inValue                    TVarChar  ,    -- Перевод
    IN inName                     TVarChar  ,    -- название Элемента (Контрол в программе)
    IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer;
   DECLARE vbFormId    Integer;
BEGIN

   -- проверка
   IF COALESCE (inLanguageId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. <Язык> не выбран.';
   END IF;

   -- проверка - "главный" язык перевода - должен быть №1
   IF COALESCE (inParentId, 0) = 0 AND inLanguageId <> COALESCE ((SELECT MIN (Id) FROM Object WHERE Object.DescId = zc_Object_Language()), 0)
   THEN
       RAISE EXCEPTION 'Ошибка.Должен быть выбран главный язык Перевода = <%>.Но был выбран <%>.'
                      , lfGet_Object_ValueData_sh ((SELECT MIN (Id) FROM Object WHERE Object.DescId = zc_Object_Language()))
                      , lfGet_Object_ValueData_sh (inLanguageId);
   END IF;
   -- проверка
   IF ioId > 0 AND COALESCE (inParentId, 0) = 0
      AND EXISTS (SELECT 
                  FROM ObjectLink AS ObjectLink_TranslateMessage_Language
                       INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                             ON ObjectLink_TranslateMessage_Parent.ObjectId      = ObjectLink_TranslateMessage_Language.ObjectId
                                            AND ObjectLink_TranslateMessage_Parent.ChildObjectId > 0
                                            AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()
                  WHERE ObjectLink_TranslateMessage_Language.ObjectId      = ioId
                    AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                    AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId
                 )
   THEN
       RAISE EXCEPTION 'Ошибка.Язык Перевода <%> не может стать главным.', lfGet_Object_ValueData_sh (inLanguageId);
   END IF;
   -- проверка
   IF ioId > 0 AND inParentId > 0
      AND NOT EXISTS (SELECT 
                      FROM ObjectLink AS ObjectLink_TranslateMessage_Language
                           INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                                 ON ObjectLink_TranslateMessage_Parent.ObjectId      = ObjectLink_TranslateMessage_Language.ObjectId
                                                AND ObjectLink_TranslateMessage_Parent.ChildObjectId > 0
                                                AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()
                      WHERE ObjectLink_TranslateMessage_Language.ObjectId      = ioId
                        AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                        AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId
                     )
   THEN
       RAISE EXCEPTION 'Ошибка.Язык Перевода <%> не может стать НЕ главным.', lfGet_Object_ValueData_sh (inLanguageId);
   END IF;


   -- !!! ВЫХОД !!! - если это НЕ "главный" язык перевода и "нечего" переводить
   IF inParentId > 0 AND COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inValue), '') = ''
   THEN
       ioId:= 0;
       RETURN;
   END IF;


   -- проверка - для "главного" языка перевода - должно быть слово
   IF COALESCE (inParentId, 0) = 0 AND COALESCE (TRIM (inValue), '') = ''
   THEN
       RAISE EXCEPTION 'Ошибка.Перевода слова <%> пустой для <%>.', inValue, lfGet_Object_ValueData_sh (inLanguageId);
   END IF;


   IF ioId <> 0
   THEN
       vbCode_calc := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   ELSE
       vbCode_calc := NEXTVAL ('Object_TranslateMessage_seq');
   END IF;


   -- сохранили
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TranslateMessage(), vbCode_calc, inValue);

   -- сохранили связь с <Язык перевода>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateMessage_Language(), ioId, inLanguageId);


   -- если это  "главный" язык перевода
   IF COALESCE (inParentId, 0) = 0
   THEN
       -- проверка
       IF COALESCE (TRIM (inName), '') = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Контрол в программе <%> пустой для <%> + <%>.', inName, inValue, lfGet_Object_ValueData_sh (inLanguageId);
       END IF;

       -- сохранили <название Элемента>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_TranslateMessage_Name(), ioId, inName);
   ELSE
       -- сохранили связь с <"главный" язык перевода>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateMessage_Parent(), ioId, inParentId);
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
 15.12.20         *
*/

-- тест
--