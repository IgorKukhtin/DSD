-- Function: gpSelect_Object_ReplServer()

DROP FUNCTION IF EXISTS gpSelect_Object_ReplServer(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReplServer(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , StartTo TDateTime, StartFrom TDateTime
             , EndTo TDateTime, EndFrom TDateTime
             , Host TVarChar, UserName TVarChar, Password TVarChar, Port TVarChar, DataBaseName TVarChar
             , CountTo TFloat, CountFrom TFloat
             , isErrTo Boolean, isErrFrom Boolean
             , OID_last Integer -- BigInt
             , isErased Boolean
              ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReplServer());

     RETURN QUERY 
     SELECT Object_ReplServer.Id            AS Id 
          , Object_ReplServer.ObjectCode    AS Code
          , Object_ReplServer.ValueData     AS Name
          
          , COALESCE (ObjectDate_StartTo.ValueData, NULL)    ::TDateTime AS StartTo
          , COALESCE (ObjectDate_StartFrom.ValueData, NULL ) ::TDateTime AS StartFrom
          , COALESCE (ObjectDate_EndTo.ValueData, NULL)      ::TDateTime AS EndTo
          , COALESCE (ObjectDate_EndFrom.ValueData, NULL )   ::TDateTime AS EndFrom
          
          , ObjectString_Host.ValueData           AS Host
          , ObjectString_User.ValueData           AS UserName                                                                                                       
          , ObjectString_Password.ValueData       AS Password
          , ObjectString_Port.ValueData           AS Port
          , ObjectString_DataBase.ValueData       AS DataBaseName
 
          , ObjectFloat_CountTo.ValueData         AS CountTo
          , ObjectFloat_CountFrom.ValueData       AS CountFrom
 
          , COALESCE (ObjectBoolean_ErrTo.ValueData, FALSE)   ::Boolean  AS isErrTo
          , COALESCE (ObjectBoolean_ErrFrom.ValueData, FALSE) ::Boolean  AS isErrFrom
          
--        , (863668436)                :: BigInt  AS OID_last
--          , (863668436)              :: Integer AS OID_last
          , (1102263)                  :: Integer AS OID_last
 
          , Object_ReplServer.isErased            AS isErased
         
     FROM Object AS Object_ReplServer
                    
          LEFT JOIN ObjectDate AS ObjectDate_StartTo
                               ON ObjectDate_StartTo.ObjectId = Object_ReplServer.Id
                              AND ObjectDate_StartTo.DescId = zc_ObjectDate_ReplServer_StartTo()
          LEFT JOIN ObjectDate AS ObjectDate_StartFrom
                               ON ObjectDate_StartFrom.ObjectId = Object_ReplServer.Id
                              AND ObjectDate_StartFrom.DescId = zc_ObjectDate_ReplServer_StartFrom()
          
          LEFT JOIN ObjectDate AS ObjectDate_EndTo
                               ON ObjectDate_EndTo.ObjectId = Object_ReplServer.Id
                              AND ObjectDate_EndTo.DescId = zc_ObjectDate_ReplServer_EndTo()
          LEFT JOIN ObjectDate AS ObjectDate_EndFrom
                               ON ObjectDate_EndFrom.ObjectId = Object_ReplServer.Id
                              AND ObjectDate_EndFrom.DescId = zc_ObjectDate_ReplServer_EndFrom()

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

          LEFT JOIN ObjectFloat AS ObjectFloat_CountTo
                                ON ObjectFloat_CountTo.ObjectId = Object_ReplServer.Id
                               AND ObjectFloat_CountTo.DescId = zc_ObjectFloat_ReplServer_CountTo()

          LEFT JOIN ObjectFloat AS ObjectFloat_CountFrom
                                ON ObjectFloat_CountFrom.ObjectId = Object_ReplServer.Id
                               AND ObjectFloat_CountFrom.DescId = zc_ObjectFloat_ReplServer_CountFrom()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_ErrTo
                                  ON ObjectBoolean_ErrTo.ObjectId = Object_ReplServer.Id
                                 AND ObjectBoolean_ErrTo.DescId = zc_ObjectBoolean_ReplServer_ErrTo()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_ErrFrom
                                  ON ObjectBoolean_ErrFrom.ObjectId = Object_ReplServer.Id
                                 AND ObjectBoolean_ErrFrom.DescId = zc_ObjectBoolean_ReplServer_ErrFrom()

     WHERE Object_ReplServer.DescId = zc_Object_ReplServer()
     ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReplServer (zfCalc_UserAdmin())
