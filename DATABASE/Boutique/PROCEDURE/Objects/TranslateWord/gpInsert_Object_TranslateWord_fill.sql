-- Function: gpInsert_Object_TranslateWord_fill (TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_TranslateWord_fill (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_TranslateWord_fill(
    IN inValue                    TVarChar  ,
    IN inFormName                 TVarChar  ,
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TranslateWord());
   vbUserId:= lpGetUserBySession (inSession);


   -- по идее vbId = ioId , но на всякий случай поищем
   vbId := (SELECT Object_TranslateWord.Id
            FROM Object AS Object_TranslateWord
                 /*INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                       ON ObjectLink_TranslateWord_Language.ObjectId      = Object_TranslateWord.Id
                                      AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                                      AND ObjectLink_TranslateWord_Language.ChildObjectId = */

                 INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                       ON ObjectLink_TranslateWord_Parent.ObjectId = Object_TranslateWord.Id
                                      AND ObjectLink_TranslateWord_Parent.DescId   = zc_ObjectLink_TranslateWord_Parent()

                 INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Form
                                       ON ObjectLink_TranslateWord_Form.ObjectId = Object_TranslateWord.Id
                                      AND ObjectLink_TranslateWord_Form.DescId   = zc_ObjectLink_TranslateWord_Form()

                 INNER JOIN Object AS Object_Form ON Object_Form.Id        = ObjectLink_TranslateWord_Form.ChildObjectId
                                                 AND Object_Form.ValueData ILIKE inFormName

            WHERE Object_TranslateWord.DescId = zc_Object_TranslateWord()
              AND ObjectLink_TranslateWord_Parent.ChildObjectId IS NULL
            LIMIT 1
           );

   -- сохранили <Объект>
   vbId := gpInsertUpdate_Object_TranslateWord (vbId
                                              , inLanguageId1:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 1)
                                              , inLanguageId2:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 2)
                                              , inLanguageId3:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 3)
                                              , inLanguageId4:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 4)
                                              , inValue1     := inValue
                                              , inValue2     := ''
                                              , inValue3     := ''
                                              , inValue4     := ''
                                              , inSession    := inSession
                                               );

   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ValueData ILIKE inFormName AND Object.DescId = zc_Object_Form())
   THEN
       RAISE EXCEPTION 'Ошибка.В списке zc_Object_Form найдено больше одной формы <%>', inFormName;
   END IF;

   IF 1 <> (SELECT COUNT(*) FROM Object WHERE Object.ValueData ILIKE inFormName AND Object.DescId = zc_Object_Form())
   THEN
       RAISE EXCEPTION 'Ошибка.В списке zc_Object_Form НЕ найдена форма <%>', inFormName;
   END IF;
  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Form(), vbId, (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFormName AND Object.DescId = zc_Object_Form()));


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
-- select * from gpInsert_Object_TranslateWord_fill(inValue := 'Платье' , inFormName:= 'TAccountDirectionForm', inSession := '2');
