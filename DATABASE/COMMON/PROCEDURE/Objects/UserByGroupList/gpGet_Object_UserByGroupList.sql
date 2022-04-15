-- Function: gpGet_Object_UserByGroupList (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_UserByGroupList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_UserByGroupList(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UserId Integer, UserName TVarChar
             , UserByGroupId Integer, UserByGroupName TVarChar
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_UserByGroupList());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
          
           , CAST (0 as Integer)    AS UserId
           , CAST ('' as TVarChar)  AS UserName  

           , CAST (0 as Integer)    AS UserByGroupId
           , CAST ('' as TVarChar)  AS UserByGroupName
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_UserByGroupList.Id      AS Id

           , Object_User.Id                 AS UserId
           , Object_User.ValueData          AS UserName

           , Object_UserByGroup.Id          AS UserByGroupId
           , Object_UserByGroup.ValueData   AS UserByGroupName

           
       FROM Object AS Object_UserByGroupList
       
            LEFT JOIN ObjectLink AS UserByGroupList_User
                                 ON UserByGroupList_User.ObjectId = Object_UserByGroupList.Id
                                AND UserByGroupList_User.DescId = zc_ObjectLink_UserByGroupList_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = UserByGroupList_User.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_UserByGroupList_UserByGroup
                                 ON ObjectLink_UserByGroupList_UserByGroup.ObjectId = Object_UserByGroupList.Id
                                AND ObjectLink_UserByGroupList_UserByGroup.DescId = zc_ObjectLink_UserByGroupList_UserByGroup()
            LEFT JOIN Object AS Object_UserByGroup ON Object_UserByGroup.Id = ObjectLink_UserByGroupList_UserByGroup.ChildObjectId
                                           
       WHERE Object_UserByGroupList.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.22         *         
*/

-- тест
--select * from gpGet_Object_UserByGroupList(inId := 7976106 ,  inSession := '9457');
