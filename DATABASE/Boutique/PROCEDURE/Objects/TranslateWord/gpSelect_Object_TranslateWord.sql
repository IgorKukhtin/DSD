-- Function: gpSelect_Object_TranslateWord (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TranslateWord (Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TranslateWord(
    IN inLanguageId1       Integer,
    IN inLanguageId2       Integer,
    IN inLanguageId3       Integer,
    IN inLanguageId4       Integer,
    IN inIsShowAll         Boolean,       --  признак показать удаленные да/нет
    IN inSession           TVarChar       --  сессия пользователя
)
RETURNS TABLE (Id     Integer
            -- , ParentName   TVarChar
             , Value1       TVarChar
             , Value2       TVarChar
             , Value3       TVarChar
             , Value4       TVarChar
             , isErased     Boolean
              ) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT tmp.Id
           -- , tmp.ParentName
            , tmp.Value1 ::TVarChar
            , tmp.Value2 ::TVarChar
            , tmp.Value3 ::TVarChar
            , tmp.Value4 ::TVarChar
            , CASE WHEN tmp.isErased = 1 THEN TRUE ELSE FALSE END AS isErased

       FROM (SELECT COALESCE (ObjectLink_TranslateWord_Parent.ChildObjectId, Object_TranslateWord.Id) AS Id
                  --, Object_Parent.ValueData                AS ParentName
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
                 OR inLanguageId2<> 0
                 OR inLanguageId3<> 0
                 OR inLanguageId4<> 0)
               GROUP BY COALESCE (ObjectLink_TranslateWord_Parent.ChildObjectId, Object_TranslateWord.Id)
                    --  , Object_Parent.ValueData
            ) AS tmp
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
--select * from gpSelect_Object_TranslateWord(inLanguageId1 := 35539 , inLanguageId2 := 35544 , inLanguageId3 := 35546 , inLanguageId4 := 0 , inIsShowAll := 'False'::Boolean ,  inSession := '2'::TVarchar);
