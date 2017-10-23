-- Function: gpGet_Object_StickerFile (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_StickerFile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StickerFile(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , LanguageId Integer, LanguageName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , Comment TVarChar
             , isDefault Boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StickerFile());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_StickerFile()) AS Code
           , CAST ('' as TVarChar)     AS NAME
           
           , CAST (0 as Integer)       AS LanguageId
           , CAST ('' as TVarChar)     AS LanguageName
 
           , CAST (0 as Integer)       AS TradeMarkId
           , CAST ('' as TVarChar)     AS TradeMarkName

           , CAST (0 as Integer)       AS JuridicalId
           , CAST ('' as TVarChar)     AS JuridicalName
           
           , CAST ('' as TVarChar)     AS Comment

           , CAST (NULL AS Boolean)    AS isDefault
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_StickerFile.Id          AS Id
           , Object_StickerFile.ObjectCode  AS Code
           , Object_StickerFile.ValueData   AS Name

           , Object_Language.Id             AS LanguageId
           , Object_Language.ValueData      AS LanguageName
 
           , Object_TradeMark.Id            AS TradeMarkId
           , Object_TradeMark.ValueData     AS TradeMarkName

           , Object_Juridical.Id            AS JuridicalId
           , Object_Juridical.ValueData     AS JuridicalName
           
           , ObjectString_Comment.ValueData AS Comment
           
           , ObjectBoolean_Default.isErased AS isDefault
           
       FROM Object AS Object_StickerFile
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

       WHERE Object_StickerFile.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_StickerFile (2, '')
