-- Function: gpInsertUpdate_Object_TranslateWord (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TranslateWord (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TranslateWord(
 INOUT ioId                       Integer   ,    --  <> 
    IN inLanguageId1              Integer   ,    -- 
    IN inLanguageId2              Integer   ,    -- ключ объекта <> 
    IN inLanguageId3              Integer   ,    --
    IN inLanguageId4              Integer   ,    --
    IN inValue1                   TVarChar  ,
    IN inValue2                   TVarChar  ,
    IN inValue3                   TVarChar  ,
    IN inValue4                   TVarChar  ,
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TranslateWord());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inLanguageId1, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. <Язык 1> не выбран.';
   END IF;

   -- по идее vbId = ioId , но на всякий случай поищем
   vbId := (SELECT Object_TranslateWord.Id
            FROM Object AS Object_TranslateWord
                 INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                       ON ObjectLink_TranslateWord_Language.ObjectId = Object_TranslateWord.Id
                                      AND ObjectLink_TranslateWord_Language.DescId = zc_ObjectLink_TranslateWord_Language()
                                      AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId1
     
                 LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                       ON ObjectLink_TranslateWord_Parent.ObjectId = Object_TranslateWord.Id
                                      AND ObjectLink_TranslateWord_Parent.DescId = zc_ObjectLink_TranslateWord_Parent()
                                      
            WHERE Object_TranslateWord.DescId = zc_Object_TranslateWord()
              AND (ObjectLink_TranslateWord_Parent.ChildObjectId = ioId OR ObjectLink_TranslateWord_Parent.ChildObjectId IS NULL)
            LIMIT 1 --
             );

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object_TranslateWord (vbId, ioId, inLanguageId1, inValue1, vbUserId);


   vbId := 0;
   IF inLanguageId2 <> 0
   THEN
       vbId := (SELECT Object_TranslateWord.Id
                FROM Object AS Object_TranslateWord
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                           ON ObjectLink_TranslateWord_Language.ObjectId = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Language.DescId = zc_ObjectLink_TranslateWord_Language()
                                          AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId2
         
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                           ON ObjectLink_TranslateWord_Parent.ObjectId = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Parent.DescId = zc_ObjectLink_TranslateWord_Parent()
                                          AND ObjectLink_TranslateWord_Parent.ChildObjectId = ioId
                WHERE Object_TranslateWord.DescId = zc_Object_TranslateWord()
                LIMIT 1 --
                 );

       -- сохранили
       PERFORM lpInsertUpdate_Object_TranslateWord (vbId, ioId, inLanguageId2, inValue2, vbUserId);
   END IF;

   vbId := 0;
   IF inLanguageId3 <> 0
   THEN
       vbId := (SELECT Object_TranslateWord.Id
                FROM Object AS Object_TranslateWord
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                           ON ObjectLink_TranslateWord_Language.ObjectId = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Language.DescId = zc_ObjectLink_TranslateWord_Language()
                                          AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId3
         
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                           ON ObjectLink_TranslateWord_Parent.ObjectId = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Parent.DescId = zc_ObjectLink_TranslateWord_Parent()
                                          AND ObjectLink_TranslateWord_Parent.ChildObjectId = ioId
                WHERE Object_TranslateWord.DescId = zc_Object_TranslateWord()
                LIMIT 1 --
                 );
       -- сохранили
       PERFORM lpInsertUpdate_Object_TranslateWord (vbId, ioId, inLanguageId3, inValue3, vbUserId);
   END IF;

   vbId := 0;
   IF inLanguageId4 <> 0
   THEN
       vbId := (SELECT Object_TranslateWord.Id
                FROM Object AS Object_TranslateWord
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                           ON ObjectLink_TranslateWord_Language.ObjectId = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Language.DescId = zc_ObjectLink_TranslateWord_Language()
                                          AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId4
         
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                           ON ObjectLink_TranslateWord_Parent.ObjectId = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Parent.DescId = zc_ObjectLink_TranslateWord_Parent()
                                          AND ObjectLink_TranslateWord_Parent.ChildObjectId = ioId
                WHERE Object_TranslateWord.DescId = zc_Object_TranslateWord()
                LIMIT 1 --
                );

       -- сохранили
       PERFORM lpInsertUpdate_Object_TranslateWord (vbId, ioId, inLanguageId4, inValue4, vbUserId);
   END IF;

   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.09.20          *
*/

-- тест
--select * from gpInsertUpdate_Object_TranslateWord(ioId := 35549 , inLanguageId1 := 35539 , inLanguageId2 := 35544 , inLanguageId3 := 0 , inLanguageId4 := 0 , inValue1 := 'Платье' , inValue2 := 'dress' , inValue3 := '' , inValue4 := '' ,  inSession := '2');