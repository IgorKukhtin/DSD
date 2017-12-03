-- Function: gpSelect_Object_StickerFile (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StickerFile (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerFile(
    IN inShowAll     Boolean,  
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , LanguageId Integer, LanguageName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar, ItemName TVarChar
             , Comment TVarChar
             , isDefault Boolean
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
           , Object_StickerFile.ObjectCode   AS Code
           , Object_StickerFile.ValueData    AS Name

           , Object_Language.Id              AS LanguageId
           , Object_Language.ValueData       AS LanguageName
 
           , Object_TradeMark.Id             AS TradeMarkId
           , Object_TradeMark.ValueData      AS TradeMarkName

           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName
           , ObjectDesc.ItemName             AS ItemName
                     
           , ObjectString_Comment.ValueData  AS Comment

           , ObjectBoolean_Default.ValueData AS isDefault
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
      UNION ALL
       SELECT 
             0    :: Integer  AS Id
           , 0    :: Integer  AS Code
           , 'УДАЛИТЬ Значение' :: TVarChar AS Name

           , 0    :: Integer  AS LanguageId
           , ''   :: TVarChar AS LanguageName
 
           , 0    :: Integer  AS TradeMarkId
           , ''   :: TVarChar AS TradeMarkName

           , 0    :: Integer  AS JuridicalId
           , ''   :: TVarChar AS JuridicalName
           , ''   :: TVarChar AS ItemName
                     
           , ''   :: TVarChar AS Comment

           , TRUE  :: Boolean AS isDefault
           , FALSE :: Boolean AS isErased
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StickerFile (FALSE, zfCalc_UserAdmin())
