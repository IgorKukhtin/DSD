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
RETURNS TABLE (Id           Integer
             , Value1       TVarChar
             , Value2       TVarChar
             , Value3       TVarChar
             , Value4       TVarChar
             , FormId       Integer
             , FormName     TVarChar
             , ControlName  TVarChar
             , isErased     Boolean
              ) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- замена 
     IF COALESCE (inLanguageId4, 0) = 0 THEN inLanguageId4:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.Id NOT IN (inLanguageId1, inLanguageId2, inLanguageId3))
                                                              SELECT tmpList.Id FROM tmpList
                                                              WHERE tmpList.Ord = 4 - CASE WHEN inLanguageId1 > 0 THEN 1 ELSE 0 END
                                                                                    - CASE WHEN inLanguageId2 > 0 THEN 1 ELSE 0 END
                                                                                    - CASE WHEN inLanguageId3 > 0 THEN 1 ELSE 0 END
                                                             );
     END IF;
     -- замена 
     IF COALESCE (inLanguageId3, 0) = 0 THEN inLanguageId3:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.Id NOT IN (inLanguageId1, inLanguageId2, inLanguageId4))
                                                              SELECT tmpList.Id FROM tmpList
                                                              WHERE tmpList.Ord = 3 - CASE WHEN inLanguageId1 > 0 THEN 1 ELSE 0 END
                                                                                    - CASE WHEN inLanguageId2 > 0 THEN 1 ELSE 0 END
                                                             );
     END IF;
     -- замена 
     IF COALESCE (inLanguageId2, 0) = 0 THEN inLanguageId2:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.Id NOT IN (inLanguageId1, inLanguageId3, inLanguageId4))
                                                              SELECT tmpList.Id FROM tmpList
                                                              WHERE tmpList.Ord = 2 - CASE WHEN inLanguageId1 > 0 THEN 1 ELSE 0 END
                                                             );
     END IF;
     -- замена 
     IF COALESCE (inLanguageId1, 0) = 0 THEN inLanguageId1:= (WITH tmpList AS (SELECT Object.Id, ROW_NUMBER() OVER (ORDER BY Object.Id ASC) AS Ord FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.Id NOT IN (inLanguageId2, inLanguageId3, inLanguageId4))
                                                              SELECT tmpList.Id FROM tmpList
                                                              WHERE tmpList.Ord = 1
                                                             );
     END IF;


     -- Результат
     RETURN QUERY 
       SELECT tmp.Id
           -- , tmp.ParentName
            , tmp.Value1 ::TVarChar
            , tmp.Value2 ::TVarChar
            , tmp.Value3 ::TVarChar
            , tmp.Value4 ::TVarChar
            
            , Object_Form.Id          AS FormId
            , COALESCE (Object_Form.ValueData, 'MainForm') :: TVarChar AS FormName

            , ObjectString_TranslateWord_Name.ValueData AS ControlName

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
            LEFT JOIN ObjectString AS ObjectString_TranslateWord_Name
                                   ON ObjectString_TranslateWord_Name.ObjectId = tmp.Id
                                  AND ObjectString_TranslateWord_Name.DescId = zc_ObjectString_TranslateWord_Name()
            LEFT JOIN ObjectLink AS ObjectLink_TranslateWord_Form
                                 ON ObjectLink_TranslateWord_Form.ObjectId = tmp.Id
                                AND ObjectLink_TranslateWord_Form.DescId = zc_ObjectLink_TranslateWord_Form()
            LEFT JOIN Object AS Object_Form ON Object_Form.Id = ObjectLink_TranslateWord_Form.ChildObjectId
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
-- SELECT * FROM gpSelect_Object_TranslateWord (inLanguageId1:= 0, inLanguageId2:= 0, inLanguageId3:= 0, inLanguageId4:= 0, inIsShowAll:= FALSE, inSession:= zfCalc_UserAdmin());
