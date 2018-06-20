-- Function: gpGet_Object_ReplServer()

DROP FUNCTION IF EXISTS gpGet_Object_ReplServer(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReplServer(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Host TVarChar
             , UserName TVarChar
             , Password TVarChar
             , Port TVarChar
             , DataBaseName TVarChar
             ) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ReplServer());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)       AS Id
           , COALESCE (MAX (ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)     AS NAME
           
           , CAST ('' as TVarChar)     AS Host
           , CAST ('' as TVarChar)     AS UserName
           , CAST ('' as TVarChar)     AS Password
           , CAST ('' as TVarChar)     AS Port
           , CAST ('' as TVarChar)     AS DataBaseName
           
       FROM Object 
       WHERE Object.DescId = zc_Object_ReplServer();
   ELSE
     RETURN QUERY 
     SELECT Object_ReplServer.Id             AS Id 
          , Object_ReplServer.ObjectCode     AS Code
          , Object_ReplServer.ValueData      AS Name
          
          , ObjectString_Host.ValueData      AS Host
          , ObjectString_User.ValueData      AS UserName                                                                                                       
          , ObjectString_Password.ValueData  AS Password
          , ObjectString_Port.ValueData      AS Port
          , ObjectString_DataBase.ValueData  AS DataBaseName
 
     FROM Object AS Object_ReplServer
          LEFT JOIN ObjectString AS ObjectString_Host
                                 ON ObjectString_Host.ObjectId = Object_ReplServer.Id
                                AND ObjectString_Host.DescId = zc_ObjectString_ReplServer_Host()

          LEFT JOIN ObjectString AS ObjectString_User
                                 ON ObjectString_User.ObjectId = Object_ReplServer.Id
                                AND ObjectString_User.DescId = zc_ObjectString_ReplServer_User()

          LEFT JOIN ObjectString AS ObjectString_Password
                                 ON ObjectString_Password.ObjectId = Object_ReplServer.Id
                                AND ObjectString_Password.DescId = zc_ObjectString_ReplServer_Password()

          LEFT JOIN ObjectString AS ObjectString_Port
                                 ON ObjectString_Port.ObjectId = Object_ReplServer.Id
                                AND ObjectString_Port.DescId = zc_ObjectString_ReplServer_Port()

          LEFT JOIN ObjectString AS ObjectString_DataBase
                                 ON ObjectString_DataBase.ObjectId = Object_ReplServer.Id
                                AND ObjectString_DataBase.DescId = zc_ObjectString_ReplServer_DataBase()  

       WHERE Object_ReplServer.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.18         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReplServer(0, '2')