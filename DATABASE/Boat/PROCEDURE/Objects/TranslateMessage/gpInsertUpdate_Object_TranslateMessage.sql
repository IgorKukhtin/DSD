-- Function: gpInsertUpdate_Object_TranslateMessage

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TranslateMessage (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TranslateMessage(
 INOUT ioId                       Integer   ,    --  <>
    IN inLanguageId1              Integer   ,    --
    IN inLanguageId2              Integer   ,    -- ключ объекта <>
    IN inLanguageId3              Integer   ,    --
    IN inLanguageId4              Integer   ,    --
    IN inValue1                   TVarChar  ,
    IN inValue2                   TVarChar  ,
    IN inValue3                   TVarChar  ,
    IN inValue4                   TVarChar  ,
    IN inName                     TVarChar  ,    -- название Элемента ()
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
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TranslateMessage());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили ВСЕГДА значение Слова для inLanguageId1
   ioId := lpInsertUpdate_Object_TranslateMessage (COALESCE (ioId, 0)
                                                 , 0 -- !!! Главный !!!
                                                 , inLanguageId1
                                                 , COALESCE (TRIM (inValue1), '')
                                                 , TRIM (inName)
                                                 , vbUserId
                                                  );


   -- для inLanguageId2
   vbId := 0;
   IF inLanguageId2 <> 0
   THEN
       -- находим через "главного"
       vbId := (SELECT Object_TranslateMessage.Id
                FROM Object AS Object_TranslateMessage
                     INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                           ON ObjectLink_TranslateMessage_Language.ObjectId      = Object_TranslateMessage.Id
                                          AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                                          AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId2

                     INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                           ON ObjectLink_TranslateMessage_Parent.ObjectId      = Object_TranslateMessage.Id
                                          AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()
                                          AND ObjectLink_TranslateMessage_Parent.ChildObjectId = ioId
                WHERE Object_TranslateMessage.DescId = zc_Object_TranslateMessage()
               );

       -- сохранили перевод в inLanguageId2
       IF vbId > 0 OR TRIM (inValue2) <> ''
       THEN
           PERFORM lpInsertUpdate_Object_TranslateMessage (vbId, ioId, inLanguageId2, COALESCE (TRIM (inValue2), ''), '', vbUserId);
       END IF;

       -- переведем точно так же слово inValue2 для inValue1 - в других записях
       IF TRIM (inValue2) <> ''
       THEN
           --
           PERFORM lpInsertUpdate_Object_TranslateMessage (tmp.TranslateMessageId_child, tmp.TranslateMessageId, inLanguageId2, TRIM (inValue2), '', vbUserId)
           FROM (WITH tmpTranslateMessage AS
                      (SELECT Object_TranslateMessage.Id                               AS TranslateMessageId
                            , ObjectLink_TranslateMessage_Language_child.ObjectId      AS TranslateMessageId_child
                            , ObjectLink_TranslateMessage_Language_child.ChildObjectId AS LanguageId_child
                       FROM Object AS Object_TranslateMessage
                            INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                                  ON ObjectLink_TranslateMessage_Language.ObjectId      = Object_TranslateMessage.Id
                                                 AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                                                 AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId1

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                                 ON ObjectLink_TranslateMessage_Parent.ChildObjectId = Object_TranslateMessage.Id
                                                AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Language_child
                                                 ON ObjectLink_TranslateMessage_Language_child.ObjectId = ObjectLink_TranslateMessage_Parent.ObjectId
                                                AND ObjectLink_TranslateMessage_Language_child.DescId   = zc_ObjectLink_TranslateMessage_Language()
                       WHERE Object_TranslateMessage.DescId    = zc_Object_TranslateMessage()
                         AND Object_TranslateMessage.ValueData ILIKE TRIM (inValue1)
                         AND Object_TranslateMessage.Id        <> ioId
                      )
                 SELECT tmp.TranslateMessageId
                      , tmpTranslateMessage.TranslateMessageId_child
                 FROM (SELECT DISTINCT tmpTranslateMessage.TranslateMessageId FROM tmpTranslateMessage) AS tmp
                      LEFT JOIN tmpTranslateMessage ON tmpTranslateMessage.TranslateMessageId  = tmp.TranslateMessageId
                                                AND tmpTranslateMessage.LanguageId_child = inLanguageId2
                ) AS tmp;

       END IF;

   END IF;


   -- для inLanguageId3
   vbId := 0;
   IF inLanguageId3 <> 0
   THEN
       -- находим через "главного"
       vbId := (SELECT Object_TranslateMessage.Id
                FROM Object AS Object_TranslateMessage
                     INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                           ON ObjectLink_TranslateMessage_Language.ObjectId      = Object_TranslateMessage.Id
                                          AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                                          AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId3

                     INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                           ON ObjectLink_TranslateMessage_Parent.ObjectId      = Object_TranslateMessage.Id
                                          AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()
                                          AND ObjectLink_TranslateMessage_Parent.ChildObjectId = ioId
                WHERE Object_TranslateMessage.DescId = zc_Object_TranslateMessage()
               );

       -- сохранили перевод в inLanguageId3
       IF vbId > 0 OR TRIM (inValue3) <> ''
       THEN
           PERFORM lpInsertUpdate_Object_TranslateMessage (vbId, ioId, inLanguageId3, COALESCE (TRIM (inValue3), ''), '', vbUserId);
       END IF;

       -- переведем точно так же слово inValue3 для inValue1 - в других записях
       IF TRIM (inValue3) <> ''
       THEN
           --
           PERFORM lpInsertUpdate_Object_TranslateMessage (tmp.TranslateMessageId_child, tmp.TranslateMessageId, inLanguageId3, TRIM (inValue3), '', vbUserId)
           FROM (WITH tmpTranslateMessage AS
                      (SELECT Object_TranslateMessage.Id                               AS TranslateMessageId
                            , ObjectLink_TranslateMessage_Language_child.ObjectId      AS TranslateMessageId_child
                            , ObjectLink_TranslateMessage_Language_child.ChildObjectId AS LanguageId_child
                       FROM Object AS Object_TranslateMessage
                            INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                                  ON ObjectLink_TranslateMessage_Language.ObjectId      = Object_TranslateMessage.Id
                                                 AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                                                 AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId1

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                                 ON ObjectLink_TranslateMessage_Parent.ChildObjectId = Object_TranslateMessage.Id
                                                AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Language_child
                                                 ON ObjectLink_TranslateMessage_Language_child.ObjectId = ObjectLink_TranslateMessage_Parent.ObjectId
                                                AND ObjectLink_TranslateMessage_Language_child.DescId   = zc_ObjectLink_TranslateMessage_Language()
                       WHERE Object_TranslateMessage.DescId    = zc_Object_TranslateMessage()
                         AND Object_TranslateMessage.ValueData ILIKE TRIM (inValue1)
                         AND Object_TranslateMessage.Id        <> ioId
                      )
                 SELECT tmp.TranslateMessageId
                      , tmpTranslateMessage.TranslateMessageId_child
                 FROM (SELECT DISTINCT tmpTranslateMessage.TranslateMessageId FROM tmpTranslateMessage) AS tmp
                      LEFT JOIN tmpTranslateMessage ON tmpTranslateMessage.TranslateMessageId  = tmp.TranslateMessageId
                                                AND tmpTranslateMessage.LanguageId_child = inLanguageId3
                ) AS tmp;

       END IF;

   END IF;


   -- для inLanguageId4
   vbId := 0;
   IF inLanguageId4 <> 0
   THEN
       -- находим через "главного"
       vbId := (SELECT Object_TranslateMessage.Id
                FROM Object AS Object_TranslateMessage
                     INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                           ON ObjectLink_TranslateMessage_Language.ObjectId      = Object_TranslateMessage.Id
                                          AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                                          AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId4

                     INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                           ON ObjectLink_TranslateMessage_Parent.ObjectId      = Object_TranslateMessage.Id
                                          AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()
                                          AND ObjectLink_TranslateMessage_Parent.ChildObjectId = ioId
                WHERE Object_TranslateMessage.DescId    = zc_Object_TranslateMessage()
               );

       -- сохранили перевод в inLanguageId4
       IF vbId > 0 OR TRIM (inValue4) <> ''
       THEN
           PERFORM lpInsertUpdate_Object_TranslateMessage (vbId, ioId, inLanguageId4, COALESCE (TRIM (inValue4), ''), '', vbUserId);
       END IF;

       -- переведем точно так же слово inValue4 для inValue1 - в других записях
       IF TRIM (inValue4) <> ''
       THEN
           --
           PERFORM lpInsertUpdate_Object_TranslateMessage (tmp.TranslateMessageId_child, tmp.TranslateMessageId, inLanguageId4, TRIM (inValue4), '', vbUserId)
           FROM (WITH tmpTranslateMessage AS
                      (SELECT Object_TranslateMessage.Id                               AS TranslateMessageId
                            , ObjectLink_TranslateMessage_Language_child.ObjectId      AS TranslateMessageId_child
                            , ObjectLink_TranslateMessage_Language_child.ChildObjectId AS LanguageId_child
                       FROM Object AS Object_TranslateMessage
                            INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                                  ON ObjectLink_TranslateMessage_Language.ObjectId      = Object_TranslateMessage.Id
                                                 AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                                                 AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId1

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                                 ON ObjectLink_TranslateMessage_Parent.ChildObjectId = Object_TranslateMessage.Id
                                                AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()

                            LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Language_child
                                                 ON ObjectLink_TranslateMessage_Language_child.ObjectId = ObjectLink_TranslateMessage_Parent.ObjectId
                                                AND ObjectLink_TranslateMessage_Language_child.DescId   = zc_ObjectLink_TranslateMessage_Language()
                       WHERE Object_TranslateMessage.DescId    = zc_Object_TranslateMessage()
                         AND Object_TranslateMessage.ValueData ILIKE TRIM (inValue1)
                         AND Object_TranslateMessage.Id        <> ioId
                      )
                 SELECT tmp.TranslateMessageId
                      , tmpTranslateMessage.TranslateMessageId_child
                 FROM (SELECT DISTINCT tmpTranslateMessage.TranslateMessageId FROM tmpTranslateMessage) AS tmp
                      LEFT JOIN tmpTranslateMessage ON tmpTranslateMessage.TranslateMessageId  = tmp.TranslateMessageId
                                                   AND tmpTranslateMessage.LanguageId_child = inLanguageId4
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
 15.12.20          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_TranslateMessage(ioId := 35549 , inLanguageId1 := 35539 , inLanguageId2 := 35544 , inLanguageId3 := 0 , inLanguageId4 := 0 , inValue1 := 'Платье' , inValue2 := 'dress' , inValue3 := '' , inValue4 := '' , inFormName:= '', inName:= '', inSession := zfCalc_UserAdmin());
