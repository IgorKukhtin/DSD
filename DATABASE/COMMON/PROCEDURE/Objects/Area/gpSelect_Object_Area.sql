-- Function: gpSelect_Object_Area()

DROP FUNCTION IF EXISTS gpSelect_Object_Area(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Area(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , TelegramGroupId Integer, TelegramGroupName TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT 
          Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name  
        , Object_TelegramGroup.Id        ::Integer  AS TelegramGroupId
        , Object_TelegramGroup.ValueData ::TVarChar AS TelegramGroupName
        , Object.isErased   AS isErased
   FROM Object
        LEFT JOIN ObjectLink AS ObjectLink_Area_TelegramGroup
                             ON ObjectLink_Area_TelegramGroup.ObjectId = Object.Id
                            AND ObjectLink_Area_TelegramGroup.DescId = zc_ObjectLink_Area_TelegramGroup()
        LEFT JOIN Object AS Object_TelegramGroup ON Object_TelegramGroup.Id = ObjectLink_Area_TelegramGroup.ChildObjectId
   WHERE Object.DescId = zc_Object_Area();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.22         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Area('2')