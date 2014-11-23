-- Function: gpGet_Object_Member (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberContact (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberContact(
    IN inId          Integer,        -- Физические лица 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (EMail TVarChar) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Member());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
           CAST ('' as TVarChar)  AS Email;
   ELSE
       RETURN QUERY 
     SELECT 
         ObjectString_Email.ValueData           AS Email

     FROM ObjectString AS ObjectString_Email 
          WHERE ObjectString_Email.ObjectId = inId 
            AND ObjectString_Email.DescId = zc_ObjectString_Member_Email();
     
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_MemberContact (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.11.14                         * add 
*/

-- тест
-- SELECT * FROM gpSelect_Member('2')