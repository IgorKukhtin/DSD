-- Function: gpSelect_Object_ProdColor()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColor (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColor (Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColor(
    IN inLanguageId1       Integer,
    IN inLanguageId2       Integer,
    IN inLanguageId3       Integer,
    IN inLanguageId4       Integer,
    IN inIsShowAll         Boolean,            -- признак показать удаленные да / нет
    IN inSession           TVarChar            -- сессия пользователя

)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , Value TVarChar, Color_Value Integer  
             , Value1 TVarChar
             , Value2 TVarChar
             , Value3 TVarChar
             , Value4 TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_ProdColor());
   vbUserId:= lpGetUserBySession (inSession);


   -- результат
   RETURN QUERY 
   WITH
   tmpTranslateObject AS (SELECT Object_TranslateObject.Id          AS Id 
                               , Object_TranslateObject.ObjectCode  AS Code
                               , Object_TranslateObject.ValueData   AS Name
                               , ObjectLink_Language.ChildObjectId  AS LanguageId
                               , ObjectLink_Object.ChildObjectId    AS ProdColorId
                          FROM Object AS Object_TranslateObject
                             INNER JOIN ObjectLink AS ObjectLink_Language
                                                   ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                  AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                             INNER JOIN ObjectLink AS ObjectLink_Object
                                                   ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                  AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                             INNER JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId AND Object_Object.DescId = zc_Object_ProdColor()

                          WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                            AND Object_TranslateObject.isErased = FALSE
                          )

       -- результат
       SELECT
             Object_ProdColor.Id             AS Id
           , Object_ProdColor.ObjectCode     AS Code
           , Object_ProdColor.ValueData      AS Name
           , ObjectString_Comment.ValueData  AS Comment
           , ObjectString_Value.ValueData    AS Value
           , COALESCE(ObjectFloat_Value.ValueData, zc_Color_White())::Integer  AS Color_Value

           , tmpTranslate1.Name ::TVarChar AS Value1
           , tmpTranslate2.Name ::TVarChar AS Value2
           , tmpTranslate3.Name ::TVarChar AS Value3
           , tmpTranslate4.Name ::TVarChar AS Value4

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_ProdColor.isErased       AS isErased
       FROM Object AS Object_ProdColor
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColor.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColor_Comment()

          LEFT JOIN ObjectString AS ObjectString_Value
                                 ON ObjectString_Value.ObjectId = Object_ProdColor.Id
                                AND ObjectString_Value.DescId = zc_ObjectString_ProdColor_Value()
          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ProdColor.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ProdColor_Value()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdColor.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdColor.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN tmpTranslateObject AS tmpTranslate1 ON tmpTranslate1.ProdColorId = Object_ProdColor.Id AND tmpTranslate1.LanguageId = inLanguageId1
          LEFT JOIN tmpTranslateObject AS tmpTranslate2 ON tmpTranslate2.ProdColorId = Object_ProdColor.Id AND tmpTranslate2.LanguageId = inLanguageId2
          LEFT JOIN tmpTranslateObject AS tmpTranslate3 ON tmpTranslate3.ProdColorId = Object_ProdColor.Id AND tmpTranslate3.LanguageId = inLanguageId3
          LEFT JOIN tmpTranslateObject AS tmpTranslate4 ON tmpTranslate4.ProdColorId = Object_ProdColor.Id AND tmpTranslate4.LanguageId = inLanguageId4
       WHERE Object_ProdColor.DescId = zc_Object_ProdColor()
         AND (Object_ProdColor.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
08.10.20          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdColor (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
