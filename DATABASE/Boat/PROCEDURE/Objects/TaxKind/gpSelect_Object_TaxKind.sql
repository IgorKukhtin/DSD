-- Function: gpSelect_Object_TaxKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TaxKind (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_TaxKind (Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TaxKind(
    IN inLanguageId1       Integer,
    IN inLanguageId2       Integer,
    IN inLanguageId3       Integer,
    IN inLanguageId4       Integer,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Code_str TVarChar, Name TVarChar
             , Enum TVarChar, NDS TFloat
             , Info TVarChar, Comment TVarChar 
             , Value1 TVarChar
             , Value2 TVarChar
             , Value3 TVarChar
             , Value4 TVarChar
             , ValueComment1 TVarChar
             , ValueComment2 TVarChar
             , ValueComment3 TVarChar
             , ValueComment4 TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_TaxKind());

   RETURN QUERY 

   WITH
   tmpTranslateObject AS (SELECT Object_TranslateObject.Id          AS Id 
                               , Object_TranslateObject.ObjectCode  AS Code
                               , Object_TranslateObject.ValueData   AS Name  
                               , ObjectString_Comment.ValueData     AS Comment
                               , ObjectLink_Language.ChildObjectId  AS LanguageId
                               , ObjectLink_Object.ChildObjectId    AS TaxKindId
                          FROM Object AS Object_TranslateObject
                             INNER JOIN ObjectLink AS ObjectLink_Language
                                                   ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                  AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                             INNER JOIN ObjectLink AS ObjectLink_Object
                                                   ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                  AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                             INNER JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId AND Object_Object.DescId = zc_Object_TaxKind()

                             LEFT JOIN ObjectString AS ObjectString_Comment
                                                    ON ObjectString_Comment.ObjectId = Object_TranslateObject.Id
                                                   AND ObjectString_Comment.DescId = zc_ObjectString_TranslateObject_Comment()

                          WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                            AND Object_TranslateObject.isErased = FALSE
                          )

   SELECT
        Object_TaxKind.Id           AS Id 
      , Object_TaxKind.ObjectCode   AS Code
      , ObjectString_TaxKind_Code.ValueData :: TVarChar AS Code_str
      , Object_TaxKind.ValueData    AS Name
      
      , ObjectString_Enum.ValueData          AS Enum
      , ObjectFloat_TaxKind_Value.ValueData  AS Value
      
      , ObjectString_TaxKind_Info.ValueData    AS Info
      , ObjectString_TaxKind_Comment.ValueData AS Comment

      , tmpTranslate1.Name ::TVarChar AS Value1
      , tmpTranslate2.Name ::TVarChar AS Value2
      , tmpTranslate3.Name ::TVarChar AS Value3
      , tmpTranslate4.Name ::TVarChar AS Value4

      , tmpTranslate1.Comment ::TVarChar AS ValueComment1
      , tmpTranslate2.Comment ::TVarChar AS ValueComment2
      , tmpTranslate3.Comment ::TVarChar AS ValueComment3
      , tmpTranslate4.Comment ::TVarChar AS ValueComment4
      
      , Object_TaxKind.isErased     AS isErased
      
   FROM OBJECT AS Object_TaxKind
        LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                              ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id 
                             AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()   
        LEFT JOIN ObjectString AS ObjectString_TaxKind_Code
                               ON ObjectString_TaxKind_Code.ObjectId = Object_TaxKind.Id 
                              AND ObjectString_TaxKind_Code.DescId = zc_ObjectString_TaxKind_Code()

        LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                               ON ObjectString_TaxKind_Info.ObjectId = Object_TaxKind.Id 
                              AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()
        LEFT JOIN ObjectString AS ObjectString_TaxKind_Comment
                               ON ObjectString_TaxKind_Comment.ObjectId = Object_TaxKind.Id 
                              AND ObjectString_TaxKind_Comment.DescId = zc_ObjectString_TaxKind_Comment()   
        
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_TaxKind.Id 
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()

        LEFT JOIN tmpTranslateObject AS tmpTranslate1 ON tmpTranslate1.TaxKindId = Object_TaxKind.Id AND tmpTranslate1.LanguageId = inLanguageId1
        LEFT JOIN tmpTranslateObject AS tmpTranslate2 ON tmpTranslate2.TaxKindId = Object_TaxKind.Id AND tmpTranslate2.LanguageId = inLanguageId2
        LEFT JOIN tmpTranslateObject AS tmpTranslate3 ON tmpTranslate3.TaxKindId = Object_TaxKind.Id AND tmpTranslate3.LanguageId = inLanguageId3
        LEFT JOIN tmpTranslateObject AS tmpTranslate4 ON tmpTranslate4.TaxKindId = Object_TaxKind.Id AND tmpTranslate4.LanguageId = inLanguageId4

   WHERE Object_TaxKind.DescId = zc_Object_TaxKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.23         *
 11.11.20         *
*/

-- тест
--  SELECT * FROM gpSelect_Object_TaxKind(0,0,0,0,'2')