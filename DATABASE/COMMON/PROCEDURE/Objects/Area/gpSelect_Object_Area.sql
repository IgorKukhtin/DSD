-- Function: gpSelect_Object_Area()

DROP FUNCTION IF EXISTS gpSelect_Object_Area(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Area(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , TelegramId TVarChar, TelegramBotToken TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT 
          Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name  
        , ObjectString_TelegramId.ValueData       ::TVarChar AS TelegramId
        , ObjectString_TelegramBotToken.ValueData ::TVarChar AS TelegramBotToken
        , Object.isErased   AS isErased
   FROM Object
        LEFT JOIN ObjectString AS ObjectString_TelegramId
                               ON ObjectString_TelegramId.ObjectId = Object_Car.Id
                              AND ObjectString_TelegramId.DescId = zc_ObjectString_Area_TelegramId()
        LEFT JOIN ObjectString AS ObjectString_TelegramBotToken
                               ON ObjectString_TelegramBotToken.ObjectId = Object_Car.Id
                              AND ObjectString_TelegramBotToken.DescId = zc_ObjectString_Area_TelegramBotToken()
   WHERE Object.DescId = zc_Object_Area();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Area(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Area('2')