-- Function: gpGet_Object_SignInternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_SignInternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SignInternal(
    IN inId             Integer,       -- ключ объекта <Маршрут>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MovementDescId Integer, MovementDescName TVarChar
             , ObjectDescId  Integer, ObjectDescName TVarChar
             , Comment TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , isMain Boolean
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_SignInternal());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_SignInternal()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)     AS MovementDescId
           , CAST (Null as TVarChar)  AS MovementDescName
           , CAST (0 as Integer)     AS ObjectDescId
           , CAST (Null as TVarChar)  AS ObjectDescName

           , CAST ('' as TVarChar)   AS Comment
                      
           , CAST (0 as Integer)   AS ObjectId 
           , CAST (0 as Integer)   AS ObjectCode
           , CAST ('' as TVarChar) AS ObjectName
          
           , CAST (FALSE AS Boolean) AS isMain
           , CAST (FALSE AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT
             Object_SignInternal.Id         AS Id
           , Object_SignInternal.ObjectCode AS Code
           , Object_SignInternal.ValueData  AS Name

           , ObjectFloat_MovementDesc.ValueData :: integer AS MovementDescId
           , Object_MovementDesc.ItemName       AS MovementDescName

           , ObjectFloat_ObjectDesc.ValueData :: integer   AS ObjectDescId
           , Object_ObjectDesc.ItemName         AS ObjectDescName

           , ObjectString_Comment.ValueData     AS Comment
                      
           , Object_Object.Id         AS ObjectId 
           , Object_Object.ObjectCode AS ObjectCode
           , Object_Object.ValueData  AS ObjectName

           , COALESCE (ObjectBoolean_Main.ValueData, FALSE) :: Boolean AS isMain
           , Object_SignInternal.isErased   AS isErased
           
       FROM Object AS Object_SignInternal
            LEFT JOIN ObjectFloat AS ObjectFloat_MovementDesc
                                  ON ObjectFloat_MovementDesc.ObjectId = Object_SignInternal.Id
                                 AND ObjectFloat_MovementDesc.DescId = zc_ObjectFloat_SignInternal_MovementDesc()
            LEFT JOIN MovementDesc AS Object_MovementDesc ON Object_MovementDesc.Id = ObjectFloat_MovementDesc.ValueData :: integer
            
            LEFT JOIN ObjectFloat AS ObjectFloat_ObjectDesc
                                  ON ObjectFloat_ObjectDesc.ObjectId = Object_SignInternal.Id
                                 AND ObjectFloat_ObjectDesc.DescId = zc_ObjectFloat_SignInternal_ObjectDesc()
            LEFT JOIN ObjectDesc AS Object_ObjectDesc ON Object_ObjectDesc.Id = ObjectFloat_ObjectDesc.ValueData :: integer


            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_SignInternal.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_SignInternal_Comment()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                    ON ObjectBoolean_Main.ObjectId = Object_SignInternal.Id 
                                   AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_SignInternal_Main()

            LEFT JOIN ObjectLink AS ObjectLink_SignInternal_Object 
                                 ON ObjectLink_SignInternal_Object.ObjectId = Object_SignInternal.Id
                                AND ObjectLink_SignInternal_Object.DescId = zc_ObjectLink_SignInternal_Object()
            LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_SignInternal_Object.ChildObjectId
         
       WHERE Object_SignInternal.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.20         *
 22.08.16         *
 
*/

-- тест
-- SELECT * FROM gpGet_Object_SignInternal (0, '3')
