﻿--Function: gpSelect_Object_InfoMoneyKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, EnumName TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InfoMoneyKind());

   RETURN QUERY 
       SELECT 
             Object.Id         AS Id 
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , ObjectString_Enum.ValueData AS EnumName
           , Object.isErased   AS isErased
       FROM Object
            LEFT JOIN ObjectString AS ObjectString_Enum
                                   ON ObjectString_Enum.ObjectId = Object.Id
                                  AND ObjectString_Enum.DescId = zc_ObjectString_Enum()
       WHERE Object.DescId = zc_Object_InfoMoneyKind()
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name
            , '' :: TVarChar AS EnumName
            , FALSE AS isErased
     ;
  
END;$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.22          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoneyKind('2')