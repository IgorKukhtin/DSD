-- Function: gpInsert_Object_TranslateWord_fill (TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_TranslateWord_fill (TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_TranslateWord_fill(
    IN inValue                    TVarChar  ,
    IN inName                     TVarChar  ,
    IN inFormName                 TVarChar  ,
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbLanguageId1 Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TranslateWord());
   vbUserId:= lpGetUserBySession (inSession);


   -- Нашли Язык, он первый
   vbLanguageId1:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language()) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 1);

   -- нашли, ключ - vbLanguageId1 + inName + inFormName
   vbId := (SELECT ObjectString_Name.ObjectId
            FROM ObjectString AS ObjectString_Name
                 INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                       ON ObjectLink_TranslateWord_Language.ObjectId      = ObjectString_Name.ObjectId
                                      AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                      AND ObjectLink_TranslateWord_Language.ChildObjectId = vbLanguageId1

                 LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Form
                                      ON ObjectLink_TranslateWord_Form.ObjectId = ObjectString_Name.ObjectId
                                     AND ObjectLink_TranslateWord_Form.DescId   = zc_ObjectLink_TranslateWord_Form()
                 LEFT JOIN Object AS Object_Form ON Object_Form.Id        = ObjectLink_TranslateWord_Form.ChildObjectId

            WHERE ObjectString_Name.DescId    = zc_ObjectString_TranslateWord_Name()
              AND ObjectString_Name.ValueData ILIKE inName
              AND (Object_Form.ValueData ILIKE inFormName
                OR (inFormName ILIKE 'MainForm' AND ObjectLink_TranslateWord_Form.ChildObjectId IS NULL)
                  )
           );

   -- сохранили <Объект>
   vbId := (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language())
                 -- если в этой записи уже есть перевод
               , tmpTranslateWord AS (SELECT tmpList.Ord, Object.ValueData AS TranslateWordName
                                      FROM ObjectLink AS ObjectLink_TranslateWord_Parent
                                           INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                                                 ON ObjectLink_TranslateWord_Language.ObjectId = ObjectLink_TranslateWord_Parent.ChildObjectId
                                                                AND ObjectLink_TranslateWord_Language.DescId   = zc_ObjectLink_TranslateWord_Language()
                                           INNER JOIN Object ON Object.Id = ObjectLink_TranslateWord_Parent.ChildObjectId
                                                            AND TRIM (Object.ValueData) <> ''
                                           INNER JOIN tmpList ON tmpList.Id = ObjectLink_TranslateWord_Language.ChildObjectId
                                      WHERE ObjectLink_TranslateWord_Parent.ObjectId = vbId
                                        AND ObjectLink_TranslateWord_Parent.DescId   = zc_ObjectLink_TranslateWord_Parent()
                                     )
                 -- если перевод надо найти в других записях
               , tmpTranslateWord_oth AS (SELECT tmpList.Ord, Object_child.ValueData AS TranslateWordName, Object_child.Id AS TranslateWordId
                                          FROM Object AS Object_TranslateWord
                                               INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                                                     ON ObjectLink_TranslateWord_Language.ObjectId      = Object_TranslateWord.Id
                                                                    AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                                                    AND ObjectLink_TranslateWord_Language.ChildObjectId = vbLanguageId1

                                               INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                                                     ON ObjectLink_TranslateWord_Parent.ChildObjectId = Object_TranslateWord.Id
                                                                    AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()

                                               INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language_child
                                                                     ON ObjectLink_TranslateWord_Language_child.ObjectId = ObjectLink_TranslateWord_Parent.ObjectId
                                                                    AND ObjectLink_TranslateWord_Language_child.DescId   = zc_ObjectLink_TranslateWord_Language()

                                               INNER JOIN Object AS Object_child ON Object_child.Id = ObjectLink_TranslateWord_Language_child.ObjectId
                                                                                AND TRIM (Object_child.ValueData) <> ''
                                               INNER JOIN tmpList ON tmpList.Id = ObjectLink_TranslateWord_Language_child.ChildObjectId

                                          WHERE Object_TranslateWord.DescId    = zc_Object_TranslateWord()
                                            AND Object_TranslateWord.ValueData ILIKE inValue
                                         )
            SELECT gpInsertUpdate.ioId
            FROM gpInsertUpdate_Object_TranslateWord (vbId
                                                    , inLanguageId1:= vbLanguageId1
                                                    , inLanguageId2:= (SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 2)
                                                    , inLanguageId3:= (SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 3)
                                                    , inLanguageId4:= (SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 4)
                                                    , inValue1     := inValue
                                                    , inValue2     := COALESCE ((SELECT tmpTranslateWord.TranslateWordName FROM tmpTranslateWord WHERE tmpTranslateWord.Ord = 2)
                                                                              , (SELECT tmpTranslateWord_oth.TranslateWordName FROM tmpTranslateWord_oth WHERE tmpTranslateWord_oth.Ord = 2 ORDER BY tmpTranslateWord_oth.TranslateWordId DESC LIMIT 1)
                                                                               )
                                                    , inValue3     := COALESCE ((SELECT tmpTranslateWord.TranslateWordName FROM tmpTranslateWord WHERE tmpTranslateWord.Ord = 3)
                                                                              , (SELECT tmpTranslateWord_oth.TranslateWordName FROM tmpTranslateWord_oth WHERE tmpTranslateWord_oth.Ord = 3 ORDER BY tmpTranslateWord_oth.TranslateWordId DESC LIMIT 1)
                                                                               )
                                                    , inValue4     := COALESCE ((SELECT tmpTranslateWord.TranslateWordName FROM tmpTranslateWord WHERE tmpTranslateWord.Ord = 4)
                                                                              , (SELECT tmpTranslateWord_oth.TranslateWordName FROM tmpTranslateWord_oth WHERE tmpTranslateWord_oth.Ord = 4 ORDER BY tmpTranslateWord_oth.TranslateWordId DESC LIMIT 1)
                                                                               )
                                                    , inFormName   := inFormName
                                                    , inName       := inName
                                                    , inSession    := inSession
                                                     ) AS gpInsertUpdate
           );


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
-- select * from gpInsert_Object_TranslateWord_fill (inValue:= 'Платье', inName:= '', inFormName:= 'TAccountDirectionForm', inSession := zfCalc_UserAdmin());
