-- Function: gpSelect_Object_TranslateMessage (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TranslateMessage (Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TranslateMessage(
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
             , ProcedureName  TVarChar
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

            , ObjectString_TranslateMessage_Name.ValueData AS ProcedureName

            , CASE WHEN tmp.isErased = 1 THEN TRUE ELSE FALSE END AS isErased

       FROM (SELECT COALESCE (ObjectLink_TranslateMessage_Parent.ChildObjectId, Object_TranslateMessage.Id) AS Id
                  , MAX (CASE WHEN ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId1 THEN Object_TranslateMessage.ValueData ELSE '' END) AS Value1
                  , MAX (CASE WHEN ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId2 THEN Object_TranslateMessage.ValueData ELSE '' END) AS Value2
                  , MAX (CASE WHEN ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId3 THEN Object_TranslateMessage.ValueData ELSE '' END) AS Value3
                  , MAX (CASE WHEN ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId4 THEN Object_TranslateMessage.ValueData ELSE '' END) AS Value4
                  , MAX (CASE WHEN Object_TranslateMessage.isErased = TRUE THEN 1 ELSE 0 END) AS isErased
             FROM Object AS Object_TranslateMessage
                 LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Language
                                      ON ObjectLink_TranslateMessage_Language.ObjectId = Object_TranslateMessage.Id
                                     AND ObjectLink_TranslateMessage_Language.DescId = zc_ObjectLink_TranslateMessage_Language()

                 LEFT JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                      ON ObjectLink_TranslateMessage_Parent.ObjectId = Object_TranslateMessage.Id
                                     AND ObjectLink_TranslateMessage_Parent.DescId = zc_ObjectLink_TranslateMessage_Parent()

             WHERE Object_TranslateMessage.DescId = zc_Object_TranslateMessage()
               AND (Object_TranslateMessage.isErased = FALSE OR inIsShowAll = TRUE)
               AND (ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId1
                 OR ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId2
                 OR ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId3
                 OR ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId4)
               AND (inLanguageId1 <> 0
                 OR inLanguageId2 <> 0
                 OR inLanguageId3 <> 0
                 OR inLanguageId4 <> 0)
               GROUP BY COALESCE (ObjectLink_TranslateMessage_Parent.ChildObjectId, Object_TranslateMessage.Id)
            ) AS tmp
            LEFT JOIN ObjectString AS ObjectString_TranslateMessage_Name
                                   ON ObjectString_TranslateMessage_Name.ObjectId = tmp.Id
                                  AND ObjectString_TranslateMessage_Name.DescId = zc_ObjectString_TranslateMessage_Name()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.12.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_TranslateMessage (inLanguageId1:= 0, inLanguageId2:= 0, inLanguageId3:= 0, inLanguageId4:= 0, inIsShowAll:= FALSE, inSession:= zfCalc_UserAdmin());
