﻿-- Function: gpGet_Object_Member (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,        -- Физические лица 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
            , INN TVarChar, DriverCertificate TVarChar, Comment TVarChar
            , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Member());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Member()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS INN
           , CAST ('' as TVarChar)  AS DriverCertificate
           , CAST ('' as TVarChar)  AS Comment
           
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Member.Id         AS Id
         , Object_Member.ObjectCode AS Code
         , Object_Member.ValueData  AS Name
         
         , ObjectString_INN.ValueData               AS INN
         , ObjectString_DriverCertificate.ValueData AS DriverCertificate
         , ObjectString_Comment.ValueData           AS Comment
         
         , Object_Member.isErased  AS isErased
         
     FROM OBJECT AS Object_Member
          LEFT JOIN ObjectString AS ObjectString_INN ON ObjectString_INN.ObjectId = Object_Member.Id 
                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
 
          LEFT JOIN ObjectString AS ObjectString_DriverCertificate ON ObjectString_DriverCertificate.ObjectId = Object_Member.Id 
                AND ObjectString_DriverCertificate.DescId = zc_ObjectString_Member_DriverCertificate()

          LEFT JOIN ObjectString AS ObjectString_Comment ON ObjectString_Comment.ObjectId = Object_Member.Id 
                AND ObjectString_Comment.DescId = zc_ObjectString_Member_Comment()

     WHERE Object_Member.Id = inId;
     
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Member(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.13         *  add DriverCertificate, Comment                            
 01.07.13         *
 19.07.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Member('2')