-- Function: lpInsertUpdate_Object_TranslateWord  ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_TranslateWord (Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_TranslateWord(
 INOUT ioId                       Integer   ,    -- ключ объекта <>
    IN inParentId                 Integer   ,    --
    IN inLanguageId               Integer   ,    -- Язык перевода
    IN inValue                    TVarChar  ,    -- Перевод
    IN inFormName                 TVarChar  ,    -- Форма приложения
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
       --RAISE EXCEPTION 'Ошибка. <Язык> не выбран.';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка. <Язык> не выбран.' :: TVarChar
                                             , inProcedureName := 'lpInsertUpdate_Object_TranslateWord' :: TVarChar
                                             , inUserId        := inUserId
                                             );
   END IF;

   -- проверка - "главный" язык перевода - должен быть №1
   IF COALESCE (inParentId, 0) = 0 AND inLanguageId <> COALESCE ((SELECT MIN (Id) FROM Object WHERE Object.DescId = zc_Object_Language()), 0)
   THEN
       /*RAISE EXCEPTION 'Ошибка.Должен быть выбран главный язык Перевода = <%>.Но был выбран <%>.'
                      , lfGet_Object_ValueData_sh ((SELECT MIN (Id) FROM Object WHERE Object.DescId = zc_Object_Language()))
                      , lfGet_Object_ValueData_sh (inLanguageId);
       */
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть выбран главный язык Перевода = <%>.Но был выбран <%>.' :: TVarChar
                                             , inProcedureName := 'lpInsertUpdate_Object_TranslateWord'    :: TVarChar
                                             , inUserId        := inUserId
                                             , inParam1        := lfGet_Object_ValueData_sh ((SELECT MIN (Id) FROM Object WHERE Object.DescId = zc_Object_Language())) :: TVarChar
                                             , inParam2        := lfGet_Object_ValueData_sh (inLanguageId) :: TVarChar
                                             );
   END IF;
   -- проверка
   IF ioId > 0 AND COALESCE (inParentId, 0) = 0
      AND EXISTS (SELECT 
                  FROM ObjectLink AS ObjectLink_TranslateWord_Language
                       INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                             ON ObjectLink_TranslateWord_Parent.ObjectId      = ObjectLink_TranslateWord_Language.ObjectId
                                            AND ObjectLink_TranslateWord_Parent.ChildObjectId > 0
                                            AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()
                  WHERE ObjectLink_TranslateWord_Language.ObjectId      = ioId
                    AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                    AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId
                 )
   THEN
       --RAISE EXCEPTION 'Ошибка.Язык Перевода <%> не может стать главным.', lfGet_Object_ValueData_sh (inLanguageId);
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Язык Перевода <%> не может стать главным.' :: TVarChar
                                             , inProcedureName := 'lpInsertUpdate_Object_TranslateWord'    :: TVarChar
                                             , inUserId        := inUserId
                                             , inParam1        := lfGet_Object_ValueData_sh (inLanguageId) :: TVarChar
                                             );
   END IF;
   -- проверка
   IF ioId > 0 AND inParentId > 0
      AND NOT EXISTS (SELECT 
                      FROM ObjectLink AS ObjectLink_TranslateWord_Language
                           INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                                 ON ObjectLink_TranslateWord_Parent.ObjectId      = ObjectLink_TranslateWord_Language.ObjectId
                                                AND ObjectLink_TranslateWord_Parent.ChildObjectId > 0
                                                AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()
                      WHERE ObjectLink_TranslateWord_Language.ObjectId      = ioId
                        AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                        AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId
                     )
   THEN
       --RAISE EXCEPTION 'Ошибка.Язык Перевода <%> не может стать НЕ главным.', lfGet_Object_ValueData_sh (inLanguageId);
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Язык Перевода <%> не может стать НЕ главным.' :: TVarChar
                                             , inProcedureName := 'lpInsertUpdate_Object_TranslateWord'    :: TVarChar
                                             , inUserId        := inUserId
                                             , inParam1        := lfGet_Object_ValueData_sh (inLanguageId) :: TVarChar
                                             );
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
       --RAISE EXCEPTION 'Ошибка.Перевода слова <%> пустой для <%>.', inValue, lfGet_Object_ValueData_sh (inLanguageId);
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Перевода слова <%> пустой для <%>.' :: TVarChar
                                             , inProcedureName := 'lpInsertUpdate_Object_TranslateWord'    :: TVarChar
                                             , inUserId        := inUserId
                                             , inParam1        := inValue :: TVarChar
                                             , inParam2        := lfGet_Object_ValueData_sh (inLanguageId) :: TVarChar
                                             );
   END IF;


   IF ioId <> 0
   THEN
       vbCode_calc := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   ELSE
       vbCode_calc := NEXTVAL ('Object_TranslateWord_seq');
   END IF;


   -- сохранили
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TranslateWord(), vbCode_calc, inValue);

   -- сохранили связь с <Язык перевода>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Language(), ioId, inLanguageId);


   -- если это  "главный" язык перевода
   IF COALESCE (inParentId, 0) = 0
   THEN
       -- проверка - 0.1.
       IF COALESCE (TRIM (inFormName), '') = ''
       THEN
           --RAISE EXCEPTION 'Ошибка.Форма приложения <%> пустая для <%> + <%>.', inFormName, inValue, lfGet_Object_ValueData_sh (inLanguageId);
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Форма приложения <%> пустая для <%> + <%>.' :: TVarChar
                                                 , inProcedureName := 'lpInsertUpdate_Object_TranslateWord'    :: TVarChar
                                                 , inUserId        := inUserId
                                                 , inParam1        := inFormName :: TVarChar
                                                 , inParam2        := inValue    :: TVarChar
                                                 , inParam3        := lfGet_Object_ValueData_sh (inLanguageId) :: TVarChar
                                                 );
       END IF;
       -- проверка - 0.2.
       IF COALESCE (TRIM (inName), '') = ''
       THEN
           --RAISE EXCEPTION 'Ошибка.Контрол в программе <%> пустой для <%> + <%>.', inName, inValue, lfGet_Object_ValueData_sh (inLanguageId);
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Контрол в программе <%> пустой для <%> + <%>.' :: TVarChar
                                                 , inProcedureName := 'lpInsertUpdate_Object_TranslateWord'    :: TVarChar
                                                 , inUserId        := inUserId
                                                 , inParam1        := inName  :: TVarChar
                                                 , inParam2        := inValue :: TVarChar
                                                 , inParam3        := lfGet_Object_ValueData_sh (inLanguageId) :: TVarChar
                                                 );
       END IF;

       -- Проверка
       IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ValueData ILIKE inFormName AND Object.DescId = zc_Object_Form())
       THEN
           --RAISE EXCEPTION 'Ошибка.В списке zc_Object_Form найдено больше одной формы <%>', inFormName;
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.В списке zc_Object_Form найдено больше одной формы <%>' :: TVarChar
                                                 , inProcedureName := 'lpInsertUpdate_Object_TranslateWord'    :: TVarChar
                                                 , inUserId        := inUserId
                                                 , inParam1        := inFormName :: TVarChar
                                                 );
       END IF;
       -- нашли форму
       vbFormId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFormName AND Object.DescId = zc_Object_Form());
       -- Проверка
       IF COALESCE (vbFormId, 0) = 0 AND inFormName NOT ILIKE 'MainForm'
       THEN
           --RAISE EXCEPTION 'Ошибка.В списке zc_Object_Form НЕ найдена форма <%>', inFormName;
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.В списке zc_Object_Form НЕ найдена форма <%>' :: TVarChar
                                                 , inProcedureName := 'lpInsertUpdate_Object_TranslateWord'    :: TVarChar
                                                 , inUserId        := inUserId
                                                 , inParam1        := inFormName :: TVarChar
                                                 );
       END IF;

       -- сохранили связь с <Форма приложения>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Form(), ioId, vbFormId);

       -- сохранили <название Элемента>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_TranslateWord_Name(), ioId, inName);
   ELSE
       -- сохранили связь с <"главный" язык перевода>
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