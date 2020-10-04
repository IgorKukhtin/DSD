-- Function: gpSelect_Object_TranslateWord_list (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TranslateWord_list (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TranslateWord_list(
    IN inSession           TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id            Integer
             , Value1        TVarChar
             , Value2        TVarChar
             , Value3        TVarChar
             , Value4        TVarChar
             , LanguageName1 TVarChar
             , LanguageName2 TVarChar
             , LanguageName3 TVarChar
             , LanguageName4 TVarChar
             , isErased      Boolean
              ) 
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE inLanguageId1       Integer;
   DECLARE inLanguageId2       Integer;
   DECLARE inLanguageId3       Integer;
   DECLARE inLanguageId4       Integer;
    DECLARE inIsShowAll         Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    inLanguageId1:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 1);
    inLanguageId2:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 2);
    inLanguageId3:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 3);
    inLanguageId4:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.isErased = FALSE) SELECT tmpList.Id FROM tmpList WHERE tmpList.Ord = 4);
    inIsShowAll:= false;

     -- Результат
     RETURN QUERY 
       SELECT tmp.Id
           -- , tmp.ParentName
            , tmp.Value1 ::TVarChar
            , tmp.Value2 ::TVarChar
            , tmp.Value3 ::TVarChar
            , tmp.Value4 ::TVarChar
            
            , Object_Language1.ValueData
            , Object_Language2.ValueData
            , Object_Language3.ValueData
            , Object_Language4.ValueData

            , CASE WHEN tmp.isErased = 1 THEN TRUE ELSE FALSE END AS isErased

       FROM (SELECT COALESCE (ObjectLink_TranslateWord_Parent.ChildObjectId, Object_TranslateWord.Id) AS Id
                  , MAX (CASE WHEN ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId1 THEN Object_TranslateWord.ValueData ELSE '' END) AS Value1
                  , MAX (CASE WHEN ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId2 THEN Object_TranslateWord.ValueData ELSE '' END) AS Value2
                  , MAX (CASE WHEN ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId3 THEN Object_TranslateWord.ValueData ELSE '' END) AS Value3
                  , MAX (CASE WHEN ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId4 THEN Object_TranslateWord.ValueData ELSE '' END) AS Value4
                  , MAX (CASE WHEN Object_TranslateWord.isErased = TRUE THEN 1 ELSE 0 END) AS isErased
             FROM Object AS Object_TranslateWord
                 LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Language
                                       ON ObjectLink_TranslateWord_Language.ObjectId = Object_TranslateWord.Id
                                      AND ObjectLink_TranslateWord_Language.DescId = zc_ObjectLink_TranslateWord_Language()

                 LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                      ON ObjectLink_TranslateWord_Parent.ObjectId = Object_TranslateWord.Id
                                     AND ObjectLink_TranslateWord_Parent.DescId = zc_ObjectLink_TranslateWord_Parent()
                -- LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_TranslateWord_Parent.ChildObjectId

             WHERE Object_TranslateWord.DescId = zc_Object_TranslateWord()
               AND (Object_TranslateWord.isErased = FALSE OR inIsShowAll = TRUE)
               AND (ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId1
                 OR ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId2
                 OR ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId3
                 OR ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId4)
               AND (inLanguageId1 <> 0
                 OR inLanguageId2 <> 0
                 OR inLanguageId3 <> 0
                 OR inLanguageId4 <> 0)
               GROUP BY COALESCE (ObjectLink_TranslateWord_Parent.ChildObjectId, Object_TranslateWord.Id)
            ) AS tmp
            LEFT JOIN Object AS Object_Language1 ON Object_Language1.Id = inLanguageId1
            LEFT JOIN Object AS Object_Language2 ON Object_Language2.Id = inLanguageId2
            LEFT JOIN Object AS Object_Language3 ON Object_Language3.Id = inLanguageId3
            LEFT JOIN Object AS Object_Language4 ON Object_Language4.Id = inLanguageId4
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.09.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_TranslateWord_list (inSession := zfCalc_UserAdmin())
