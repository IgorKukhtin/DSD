-- Function: gpGet_Object_SignInternalItem (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_SignInternalItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SignInternalItem(
    IN inId             Integer,       -- ключ объекта <Маршрут>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , SignInternalId Integer, SignInternalCode Integer, SignInternalName TVarChar
             , UserId Integer, UserName TVarChar
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_SignInternalItem());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_SignInternalItem()) AS Code
           , CAST ('' as TVarChar)  AS Name
                   
           , CAST (0 as Integer)   AS SignInternalId 
           , CAST (0 as Integer)   AS SignInternalCode
           , CAST ('' as TVarChar) AS SignInternalName

           , CAST (0 as Integer)   AS UserId 
           , CAST ('' as TVarChar) AS UserName
            
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT
             Object_SignInternalItem.Id         AS Id
           , Object_SignInternalItem.ObjectCode AS Code
           , Object_SignInternalItem.ValueData  AS Name

           , Object_SignInternal.Id         AS SignInternalId 
           , Object_SignInternal.ObjectCode AS SignInternalCode
           , Object_SignInternal.ValueData  AS SignInternalName

           , Object_User.Id         AS UserId
           , Object_User.ValueData  AS UserName

           , Object_SignInternalItem.isErased   AS isErased
           
       FROM Object AS Object_SignInternalItem
            LEFT JOIN ObjectLink AS ObjectLink_SignInternalItem_SignInternal 
                                 ON ObjectLink_SignInternalItem_SignInternal.ObjectId = Object_SignInternalItem.Id
                                AND ObjectLink_SignInternalItem_SignInternal.DescId = zc_ObjectLink_SignInternalItem_SignInternal()
            LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = ObjectLink_SignInternalItem_SignInternal.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_SignInternalItem_User 
                                 ON ObjectLink_SignInternalItem_User.ObjectId = Object_SignInternalItem.Id
                                AND ObjectLink_SignInternalItem_User.DescId = zc_ObjectLink_SignInternalItem_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_SignInternalItem_User.ChildObjectId
         
       WHERE Object_SignInternalItem.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.16         *
 
*/

-- тест
-- SELECT * FROM gpGet_Object_SignInternalItem (2, '')
