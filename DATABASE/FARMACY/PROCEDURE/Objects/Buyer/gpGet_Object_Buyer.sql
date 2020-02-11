-- Function: gpGet_Object_Buyer()

DROP FUNCTION IF EXISTS gpGet_Object_Buyer(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Buyer(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Phone TVarChar
             , Name TVarChar, Email TVarChar, Address TVarChar
             , DateBirth TDateTime, Sex TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_Buyer()) AS Code
           , CAST ('' as TVarChar)   AS Phone
           , CAST ('' as TVarChar)   AS Name
           , CAST ('' as TVarChar)   AS Email
           , CAST ('' as TVarChar)   AS Address
           , NULL::TDateTime         AS DateBirth
           , CAST ('' as TVarChar)   AS Sex
           , CAST ('' as TVarChar)   AS Comment
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_Buyer.Id                       AS Id
            , Object_Buyer.ObjectCode               AS Code
            , Object_Buyer.ValueData                AS Phone
            , ObjectString_Buyer_Name.ValueData     AS Name
            , ObjectString_Buyer_EMail.ValueData    AS Email
            , ObjectString_Buyer_Address.ValueData  AS Address
            , ObjectDate_Buyer_DateBirth.ValueData  AS DateBirth
            , ObjectString_Buyer_Sex.ValueData      AS Sex
            , ObjectString_Buyer_Comment.ValueData  AS Comment
            , Object_Buyer.isErased                 AS isErased
       FROM Object AS Object_Buyer
            LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                                   ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id 
                                  AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()
            LEFT JOIN ObjectString AS ObjectString_Buyer_EMail
                                   ON ObjectString_Buyer_EMail.ObjectId = Object_Buyer.Id 
                                  AND ObjectString_Buyer_EMail.DescId = zc_ObjectString_Buyer_EMail()
            LEFT JOIN ObjectString AS ObjectString_Buyer_Address
                                   ON ObjectString_Buyer_Address.ObjectId = Object_Buyer.Id 
                                  AND ObjectString_Buyer_Address.DescId = zc_ObjectString_Buyer_Address()
            LEFT JOIN ObjectString AS ObjectString_Buyer_Comment
                                   ON ObjectString_Buyer_Comment.ObjectId = Object_Buyer.Id 
                                  AND ObjectString_Buyer_Comment.DescId = zc_ObjectString_Buyer_Comment()

            LEFT JOIN ObjectDate AS ObjectDate_Buyer_DateBirth
                                 ON ObjectDate_Buyer_DateBirth.ObjectId = Object_Buyer.Id 
                                AND ObjectDate_Buyer_DateBirth.DescId = zc_ObjectDate_Buyer_DateBirth()
            LEFT JOIN ObjectString AS ObjectString_Buyer_Sex
                                   ON ObjectString_Buyer_Sex.ObjectId = Object_Buyer.Id 
                                  AND ObjectString_Buyer_Sex.DescId = zc_ObjectString_Buyer_Sex()
       WHERE Object_Buyer.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Buyer(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.01.20         *
 27.12.19                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_Buyer (0, '3')