-- Function: gpSelect_Object_StickerFile (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StickerFile (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerFile(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_70_70 TVarChar
             , LanguageId Integer, LanguageName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar, ItemName TVarChar
             , Comment TVarChar
             , Width1 TFloat, Width2 TFloat, Width3 TFloat, Width4 TFloat, Width5 TFloat
             , Width6 TFloat, Width7 TFloat, Width8 TFloat, Width9 TFloat, Width10 TFloat
             , Level1 TFloat, Level2 TFloat
             , Left1 TFloat, Left2 TFloat
             , Width1_70_70 TFloat, Width2_70_70 TFloat, Width3_70_70 TFloat, Width4_70_70 TFloat, Width5_70_70 TFloat
             , Width6_70_70 TFloat, Width7_70_70 TFloat, Width8_70_70 TFloat, Width9_70_70 TFloat, Width10_70_70 TFloat
             , Level1_70_70 TFloat, Level2_70_70 TFloat
             , Left1_70_70 TFloat, Left2_70_70 TFloat
             , isDefault Boolean
             , isSize70 Boolean
             , isErased Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_StickerFile());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT
             Object_StickerFile.Id           AS Id
           , CASE WHEN vbUserId = 5 THEN Object_StickerFile.Id ELSE Object_StickerFile.ObjectCode END :: Integer AS Code
           , CASE WHEN ObjectForm.ValueData       <> '' THEN Object_StickerFile.ValueData              ELSE '' END :: TVarChar AS Name
           , CASE WHEN ObjectForm_70_70.ValueData <> '' THEN Object_StickerFile.ValueData || '_70_70'  ELSE '' END :: TVarChar AS Name_70_70

           , Object_Language.Id              AS LanguageId
           , Object_Language.ValueData       AS LanguageName

           , Object_TradeMark.Id             AS TradeMarkId
           , Object_TradeMark.ValueData      AS TradeMarkName

           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName
           , ObjectDesc.ItemName             AS ItemName

           , ObjectString_Comment.ValueData  AS Comment

           , ObjectFloat_Width1.ValueData    AS Width1
           , ObjectFloat_Width2.ValueData    AS Width2
           , ObjectFloat_Width3.ValueData    AS Width3
           , ObjectFloat_Width4.ValueData    AS Width4
           , ObjectFloat_Width5.ValueData    AS Width5
           , ObjectFloat_Width6.ValueData    AS Width6
           , ObjectFloat_Width7.ValueData    AS Width7
           , ObjectFloat_Width8.ValueData    AS Width8
           , ObjectFloat_Width9.ValueData    AS Width9
           , ObjectFloat_Width10.ValueData   AS Width10

           , ObjectFloat_Level1.ValueData      AS Level1
           , ObjectFloat_Level2.ValueData      AS Level2
           , ObjectFloat_Left1.ValueData       AS Left1
           , ObjectFloat_Left2.ValueData       AS Left2

           , ObjectFloat_Width1_70_70.ValueData      AS Width1_70_70
           , ObjectFloat_Width2_70_70.ValueData      AS Width2_70_70
           , ObjectFloat_Width3_70_70.ValueData      AS Width3_70_70
           , ObjectFloat_Width4_70_70.ValueData      AS Width4_70_70
           , ObjectFloat_Width5_70_70.ValueData      AS Width5_70_70
           , ObjectFloat_Width6_70_70.ValueData      AS Width6_70_70
           , ObjectFloat_Width7_70_70.ValueData      AS Width7_70_70
           , ObjectFloat_Width8_70_70.ValueData      AS Width8_70_70
           , ObjectFloat_Width9_70_70.ValueData      AS Width9_70_70
           , ObjectFloat_Width10_70_70.ValueData     AS Width10_70_70

           , ObjectFloat_Level1_70_70.ValueData      AS Level1_70_70
           , ObjectFloat_Level2_70_70.ValueData      AS Level2_70_70
           , ObjectFloat_Left1_70_70.ValueData       AS Left1_70_70
           , ObjectFloat_Left2_70_70.ValueData       AS Left2_70_70

           , ObjectBoolean_Default.ValueData AS isDefault
           , COALESCE (ObjectBoolean_70.ValueData, FALSE) ::Boolean AS isSize70
           , Object_StickerFile.isErased     AS isErased

       FROM tmpIsErased
            INNER JOIN Object AS Object_StickerFile
                              ON Object_StickerFile.isErased = tmpIsErased.isErased
                             AND Object_StickerFile.DescId = zc_Object_StickerFile()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerFile.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerFile_Comment()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                    ON ObjectBoolean_Default.ObjectId = Object_StickerFile.Id
                                   AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_StickerFile_Default()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_70
                                    ON ObjectBoolean_70.ObjectId = Object_StickerFile.Id
                                   AND ObjectBoolean_70.DescId = zc_ObjectBoolean_StickerFile_70()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width1
                                  ON ObjectFloat_Width1.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width1.DescId = zc_ObjectFloat_StickerFile_Width1()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width2
                                  ON ObjectFloat_Width2.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width2.DescId = zc_ObjectFloat_StickerFile_Width2()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width3
                                  ON ObjectFloat_Width3.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width3.DescId = zc_ObjectFloat_StickerFile_Width3()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width4
                                  ON ObjectFloat_Width4.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width4.DescId = zc_ObjectFloat_StickerFile_Width4()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width5
                                  ON ObjectFloat_Width5.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width5.DescId = zc_ObjectFloat_StickerFile_Width5()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width6
                                  ON ObjectFloat_Width6.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width6.DescId = zc_ObjectFloat_StickerFile_Width6()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width7
                                  ON ObjectFloat_Width7.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width7.DescId = zc_ObjectFloat_StickerFile_Width7()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width8
                                  ON ObjectFloat_Width8.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width8.DescId = zc_ObjectFloat_StickerFile_Width8()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width9
                                  ON ObjectFloat_Width9.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width9.DescId = zc_ObjectFloat_StickerFile_Width9()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width10
                                  ON ObjectFloat_Width10.ObjectId = Object_StickerFile.Id
                                 AND ObjectFloat_Width10.DescId = zc_ObjectFloat_StickerFile_Width10()

            LEFT JOIN ObjectFloat AS ObjectFloat_Level1
                                  ON ObjectFloat_Level1.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Level1.DescId = zc_ObjectFloat_StickerFile_Level1()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Level2
                                  ON ObjectFloat_Level2.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Level2.DescId = zc_ObjectFloat_StickerFile_Level2()

            LEFT JOIN ObjectFloat AS ObjectFloat_Left1
                                  ON ObjectFloat_Left1.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Left1.DescId = zc_ObjectFloat_StickerFile_Left1()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Left2
                                  ON ObjectFloat_Left2.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Left2.DescId = zc_ObjectFloat_StickerFile_Left2()

       ---
            LEFT JOIN ObjectFloat AS ObjectFloat_Width1_70_70
                                  ON ObjectFloat_Width1_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width1_70_70.DescId = zc_ObjectFloat_StickerFile_Width1_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width2_70_70
                                  ON ObjectFloat_Width2_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width2_70_70.DescId = zc_ObjectFloat_StickerFile_Width2_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width3_70_70
                                  ON ObjectFloat_Width3_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width3_70_70.DescId = zc_ObjectFloat_StickerFile_Width3_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width4_70_70
                                  ON ObjectFloat_Width4_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width4_70_70.DescId = zc_ObjectFloat_StickerFile_Width4_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width5_70_70
                                  ON ObjectFloat_Width5_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width5_70_70.DescId = zc_ObjectFloat_StickerFile_Width5_70_70()

            LEFT JOIN ObjectFloat AS ObjectFloat_Width6_70_70
                                  ON ObjectFloat_Width6_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width6_70_70.DescId = zc_ObjectFloat_StickerFile_Width6_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width7_70_70
                                  ON ObjectFloat_Width7_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width7_70_70.DescId = zc_ObjectFloat_StickerFile_Width7_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width8_70_70
                                  ON ObjectFloat_Width8_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width8_70_70.DescId = zc_ObjectFloat_StickerFile_Width8_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width9_70_70
                                  ON ObjectFloat_Width9_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width9_70_70.DescId = zc_ObjectFloat_StickerFile_Width9_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Width10_70_70
                                  ON ObjectFloat_Width10_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Width10_70_70.DescId = zc_ObjectFloat_StickerFile_Width10_70_70()

            LEFT JOIN ObjectFloat AS ObjectFloat_Level1_70_70
                                  ON ObjectFloat_Level1_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Level1_70_70.DescId = zc_ObjectFloat_StickerFile_Level1_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Level2_70_70
                                  ON ObjectFloat_Level2_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Level2_70_70.DescId = zc_ObjectFloat_StickerFile_Level2_70_70()

            LEFT JOIN ObjectFloat AS ObjectFloat_Left1_70_70
                                  ON ObjectFloat_Left1_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Left1_70_70.DescId = zc_ObjectFloat_StickerFile_Left1_70_70()
 
            LEFT JOIN ObjectFloat AS ObjectFloat_Left2_70_70
                                  ON ObjectFloat_Left2_70_70.ObjectId = Object_StickerFile.Id 
                                 AND ObjectFloat_Left2_70_70.DescId = zc_ObjectFloat_StickerFile_Left2_70_70()

            LEFT JOIN ObjectLink AS ObjectLink_StickerFile_Language
                                 ON ObjectLink_StickerFile_Language.ObjectId = Object_StickerFile.Id
                                AND ObjectLink_StickerFile_Language.DescId = zc_ObjectLink_StickerFile_Language()
            LEFT JOIN Object AS Object_Language ON Object_Language.Id = ObjectLink_StickerFile_Language.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_StickerFile_TradeMark
                                 ON ObjectLink_StickerFile_TradeMark.ObjectId = Object_StickerFile.Id
                                AND ObjectLink_StickerFile_TradeMark.DescId = zc_ObjectLink_StickerFile_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_StickerFile_TradeMark.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_StickerFile_Juridical
                                 ON ObjectLink_StickerFile_Juridical.ObjectId = Object_StickerFile.Id
                                AND ObjectLink_StickerFile_Juridical.DescId = zc_ObjectLink_StickerFile_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_StickerFile_Juridical.ChildObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId

            LEFT JOIN Object AS ObjectForm
                             ON ObjectForm.ValueData = (Object_StickerFile.ValueData || '.Sticker') :: TVarChar
                            AND ObjectForm.DescId    = zc_Object_Form()
            --
            LEFT JOIN Object AS ObjectForm_70_70
                             ON ObjectForm_70_70.ValueData = (Object_StickerFile.ValueData || '_70_70.Sticker') :: TVarChar
                            AND ObjectForm_70_70.DescId    = zc_Object_Form()

      UNION ALL
       SELECT
             0    :: Integer  AS Id
           , 0    :: Integer  AS Code
           , 'УДАЛИТЬ Значение' :: TVarChar AS Name
           , ''                 :: TVarChar AS Name_70_70

           , 0    :: Integer  AS LanguageId
           , ''   :: TVarChar AS LanguageName

           , 0    :: Integer  AS TradeMarkId
           , ''   :: TVarChar AS TradeMarkName

           , 0    :: Integer  AS JuridicalId
           , ''   :: TVarChar AS JuridicalName
           , ''   :: TVarChar AS ItemName

           , ''   :: TVarChar AS Comment

           , CAST (0 as TFloat)  AS Width1
           , CAST (0 as TFloat)  AS Width2
           , CAST (0 as TFloat)  AS Width3
           , CAST (0 as TFloat)  AS Width4
           , CAST (0 as TFloat)  AS Width5
           , CAST (0 as TFloat)  AS Width6
           , CAST (0 as TFloat)  AS Width7
           , CAST (0 as TFloat)  AS Width8
           , CAST (0 as TFloat)  AS Width9
           , CAST (0 as TFloat)  AS Width10

           , CAST (0 as TFloat)  AS Level1
           , CAST (0 as TFloat)  AS Level2
           , CAST (0 as TFloat)  AS Left1
           , CAST (0 as TFloat)  AS Left2

           , CAST (0 as TFloat)  AS Width1_70_70
           , CAST (0 as TFloat)  AS Width2_70_70
           , CAST (0 as TFloat)  AS Width3_70_70
           , CAST (0 as TFloat)  AS Width4_70_70
           , CAST (0 as TFloat)  AS Width5_70_70
           , CAST (0 as TFloat)  AS Width6_70_70
           , CAST (0 as TFloat)  AS Width7_70_70
           , CAST (0 as TFloat)  AS Width8_70_70
           , CAST (0 as TFloat)  AS Width9_70_70
           , CAST (0 as TFloat)  AS Width10_70_70

           , CAST (0 as TFloat)  AS Level1_70_70
           , CAST (0 as TFloat)  AS Level2_70_70
           , CAST (0 as TFloat)  AS Left1_70_70
           , CAST (0 as TFloat)  AS Left2_70_70

           , TRUE  :: Boolean AS isDefault
           , FALSE :: Boolean AS isSize70
           , FALSE :: Boolean AS isErased
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.09.23         *
 19.12.17         *
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StickerFile (FALSE, zfCalc_UserAdmin())
