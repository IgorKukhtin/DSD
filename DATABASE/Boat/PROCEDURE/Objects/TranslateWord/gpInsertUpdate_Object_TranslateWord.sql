-- Function: gpInsertUpdate_Object_TranslateWord

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TranslateWord (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

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
    IN inFormName                 TVarChar  ,    -- Форма приложения
    IN inName                     TVarChar  ,    -- название Элемента (Контрол в программе)
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



   -- сохранили ВСЕГДА значение Слова для inLanguageId1
   ioId := lpInsertUpdate_Object_TranslateWord (COALESCE (ioId, 0)
                                              , 0 -- !!! Главный !!!
                                              , inLanguageId1
                                              , COALESCE (TRIM (inValue1), '')
                                              , CASE WHEN COALESCE (TRIM (inFormName), '') = '' AND ioId > 0
                                                          THEN
                                                              -- попробуем найти
                                                              COALESCE ((SELECT Object.ValueData FROM ObjectLink AS OL JOIN Object ON Object.Id = OL.ChildObjectId WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_TranslateWord_Form())
                                                                      , 'MainForm'
                                                                       )
                                                     -- оставляем то что есть
                                                     ELSE inFormName
                                                END
                                              , CASE WHEN COALESCE (TRIM (inName), '') = '' AND ioId > 0
                                                          THEN
                                                              -- попробуем найти
                                                              (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = ioId AND OS.DescId = zc_ObjectString_TranslateWord_Name())
                                                     -- оставляем то что есть
                                                     ELSE inName
                                                END
                                              , vbUserId
                                               );


   -- для inLanguageId2
   vbId := 0;
   IF inLanguageId2 <> 0
   THEN
       -- находим через "главного"
       vbId := (SELECT Object_TranslateWord.Id
                FROM Object AS Object_TranslateWord
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                           ON ObjectLink_TranslateWord_Language.ObjectId      = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                          AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId2

                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                           ON ObjectLink_TranslateWord_Parent.ObjectId      = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()
                                          AND ObjectLink_TranslateWord_Parent.ChildObjectId = ioId
                WHERE Object_TranslateWord.DescId = zc_Object_TranslateWord()
               );

       -- сохранили перевод в inLanguageId2
       IF vbId > 0 OR TRIM (inValue2) <> ''
       THEN
           PERFORM lpInsertUpdate_Object_TranslateWord (vbId, ioId, inLanguageId2, COALESCE (TRIM (inValue2), ''), '', '', vbUserId);
       END IF;

       -- переведем точно так же слово inValue2 для inValue1 - в других записях
       IF TRIM (inValue2) <> ''
       THEN
           --
           PERFORM lpInsertUpdate_Object_TranslateWord (tmp.TranslateWordId_child, tmp.TranslateWordId, inLanguageId2, TRIM (inValue2), '', '', vbUserId)
           FROM (WITH tmpTranslateWord AS
                      (SELECT Object_TranslateWord.Id                               AS TranslateWordId
                            , ObjectLink_TranslateWord_Language_child.ObjectId      AS TranslateWordId_child
                            , ObjectLink_TranslateWord_Language_child.ChildObjectId AS LanguageId_child
                       FROM Object AS Object_TranslateWord
                            INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                                  ON ObjectLink_TranslateWord_Language.ObjectId      = Object_TranslateWord.Id
                                                 AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                                 AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId1

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                                 ON ObjectLink_TranslateWord_Parent.ChildObjectId = Object_TranslateWord.Id
                                                AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Language_child
                                                 ON ObjectLink_TranslateWord_Language_child.ObjectId = ObjectLink_TranslateWord_Parent.ObjectId
                                                AND ObjectLink_TranslateWord_Language_child.DescId   = zc_ObjectLink_TranslateWord_Language()
                       WHERE Object_TranslateWord.DescId    = zc_Object_TranslateWord()
                         AND Object_TranslateWord.ValueData ILIKE TRIM (inValue1)
                         AND Object_TranslateWord.Id        <> ioId
                      )
                 SELECT tmp.TranslateWordId
                      , tmpTranslateWord.TranslateWordId_child
                 FROM (SELECT DISTINCT tmpTranslateWord.TranslateWordId FROM tmpTranslateWord) AS tmp
                      LEFT JOIN tmpTranslateWord ON tmpTranslateWord.TranslateWordId  = tmp.TranslateWordId
                                                AND tmpTranslateWord.LanguageId_child = inLanguageId2
                ) AS tmp;

       END IF;

   END IF;


   -- для inLanguageId3
   vbId := 0;
   IF inLanguageId3 <> 0
   THEN
       -- находим через "главного"
       vbId := (SELECT Object_TranslateWord.Id
                FROM Object AS Object_TranslateWord
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                           ON ObjectLink_TranslateWord_Language.ObjectId      = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                          AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId3

                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                           ON ObjectLink_TranslateWord_Parent.ObjectId      = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()
                                          AND ObjectLink_TranslateWord_Parent.ChildObjectId = ioId
                WHERE Object_TranslateWord.DescId = zc_Object_TranslateWord()
               );

       -- сохранили перевод в inLanguageId3
       IF vbId > 0 OR TRIM (inValue3) <> ''
       THEN
           PERFORM lpInsertUpdate_Object_TranslateWord (vbId, ioId, inLanguageId3, COALESCE (TRIM (inValue3), ''), '', '', vbUserId);
       END IF;

       -- переведем точно так же слово inValue3 для inValue1 - в других записях
       IF TRIM (inValue3) <> ''
       THEN
           --
           PERFORM lpInsertUpdate_Object_TranslateWord (tmp.TranslateWordId_child, tmp.TranslateWordId, inLanguageId3, TRIM (inValue3), '', '', vbUserId)
           FROM (WITH tmpTranslateWord AS
                      (SELECT Object_TranslateWord.Id                               AS TranslateWordId
                            , ObjectLink_TranslateWord_Language_child.ObjectId      AS TranslateWordId_child
                            , ObjectLink_TranslateWord_Language_child.ChildObjectId AS LanguageId_child
                       FROM Object AS Object_TranslateWord
                            INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                                  ON ObjectLink_TranslateWord_Language.ObjectId      = Object_TranslateWord.Id
                                                 AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                                 AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId1

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                                 ON ObjectLink_TranslateWord_Parent.ChildObjectId = Object_TranslateWord.Id
                                                AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Language_child
                                                 ON ObjectLink_TranslateWord_Language_child.ObjectId = ObjectLink_TranslateWord_Parent.ObjectId
                                                AND ObjectLink_TranslateWord_Language_child.DescId   = zc_ObjectLink_TranslateWord_Language()
                       WHERE Object_TranslateWord.DescId    = zc_Object_TranslateWord()
                         AND Object_TranslateWord.ValueData ILIKE TRIM (inValue1)
                         AND Object_TranslateWord.Id        <> ioId
                      )
                 SELECT tmp.TranslateWordId
                      , tmpTranslateWord.TranslateWordId_child
                 FROM (SELECT DISTINCT tmpTranslateWord.TranslateWordId FROM tmpTranslateWord) AS tmp
                      LEFT JOIN tmpTranslateWord ON tmpTranslateWord.TranslateWordId  = tmp.TranslateWordId
                                                AND tmpTranslateWord.LanguageId_child = inLanguageId3
                ) AS tmp;

       END IF;

   END IF;


   -- для inLanguageId4
   vbId := 0;
   IF inLanguageId4 <> 0
   THEN
       -- находим через "главного"
       vbId := (SELECT Object_TranslateWord.Id
                FROM Object AS Object_TranslateWord
                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                           ON ObjectLink_TranslateWord_Language.ObjectId      = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                          AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId4

                     INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                           ON ObjectLink_TranslateWord_Parent.ObjectId      = Object_TranslateWord.Id
                                          AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()
                                          AND ObjectLink_TranslateWord_Parent.ChildObjectId = ioId
                WHERE Object_TranslateWord.DescId    = zc_Object_TranslateWord()
               );

       -- сохранили перевод в inLanguageId4
       IF vbId > 0 OR TRIM (inValue4) <> ''
       THEN
           PERFORM lpInsertUpdate_Object_TranslateWord (vbId, ioId, inLanguageId4, COALESCE (TRIM (inValue4), ''), '', '', vbUserId);
       END IF;

       -- переведем точно так же слово inValue4 для inValue1 - в других записях
       IF TRIM (inValue4) <> ''
       THEN
           --
           PERFORM lpInsertUpdate_Object_TranslateWord (tmp.TranslateWordId_child, tmp.TranslateWordId, inLanguageId4, TRIM (inValue4), '', '', vbUserId)
           FROM (WITH tmpTranslateWord AS
                      (SELECT Object_TranslateWord.Id                               AS TranslateWordId
                            , ObjectLink_TranslateWord_Language_child.ObjectId      AS TranslateWordId_child
                            , ObjectLink_TranslateWord_Language_child.ChildObjectId AS LanguageId_child
                       FROM Object AS Object_TranslateWord
                            INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                                  ON ObjectLink_TranslateWord_Language.ObjectId      = Object_TranslateWord.Id
                                                 AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                                 AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId1

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                                 ON ObjectLink_TranslateWord_Parent.ChildObjectId = Object_TranslateWord.Id
                                                AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Language_child
                                                 ON ObjectLink_TranslateWord_Language_child.ObjectId = ObjectLink_TranslateWord_Parent.ObjectId
                                                AND ObjectLink_TranslateWord_Language_child.DescId   = zc_ObjectLink_TranslateWord_Language()
                       WHERE Object_TranslateWord.DescId    = zc_Object_TranslateWord()
                         AND Object_TranslateWord.ValueData ILIKE TRIM (inValue1)
                         AND Object_TranslateWord.Id        <> ioId
                      )
                 SELECT tmp.TranslateWordId
                      , tmpTranslateWord.TranslateWordId_child
                 FROM (SELECT DISTINCT tmpTranslateWord.TranslateWordId FROM tmpTranslateWord) AS tmp
                      LEFT JOIN tmpTranslateWord ON tmpTranslateWord.TranslateWordId  = tmp.TranslateWordId
                                                AND tmpTranslateWord.LanguageId_child = inLanguageId4
                ) AS tmp;

       END IF;

   END IF;

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
-- SELECT * FROM gpInsertUpdate_Object_TranslateWord(ioId := 35549 , inLanguageId1 := 35539 , inLanguageId2 := 35544 , inLanguageId3 := 0 , inLanguageId4 := 0 , inValue1 := 'Платье' , inValue2 := 'dress' , inValue3 := '' , inValue4 := '' , inFormName:= '', inName:= '', inSession := zfCalc_UserAdmin());
