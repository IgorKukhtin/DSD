-- Function: gpGet_Object_CommentCheck()

DROP FUNCTION IF EXISTS gpGet_Object_CommentCheck(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CommentCheck(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CommentTRId Integer, CommentTRCode Integer, CommentTRName TVarChar
             , isSendPartionDate boolean, isLostPositions boolean
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)                          AS Id
           , lfGet_ObjectCode(0, zc_Object_CommentCheck()) AS Code
           , CAST ('' as TVarChar)                        AS Name
           , CAST (0 AS Integer)                          AS CommentTRId
           , CAST (0 AS Integer)                          AS CommentTRCode
           , CAST ('' AS TVarChar)                        AS CommentTRName
           , CAST (FALSE AS Boolean)                      AS isSendPartionDate 
           , CAST (FALSE AS Boolean)                      AS isLostPositions 
           , CAST (FALSE AS Boolean)                      AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_CommentCheck.Id                         AS Id 
        , Object_CommentCheck.ObjectCode                     AS Code
        , Object_CommentCheck.ValueData                      AS Name
        , Object_CommentTR.Id                               AS CommentTRId 
        , Object_CommentTR.ObjectCode                       AS CommentTRCode
        , Object_CommentTR.ValueData                        AS CommentTRName
        , COALESCE(ObjectBoolean_CommentSun_SendPartionDate.ValueData, FALSE)   AS isSendPartionDate
        , COALESCE(ObjectBoolean_CommentSun_LostPositions.ValueData, FALSE)     AS isLostPositions
        , Object_CommentCheck.isErased                       AS isErased
   FROM Object AS Object_CommentCheck

        LEFT JOIN ObjectLink AS ObjectLink_CommentCheck_CommentTR
                             ON ObjectLink_CommentCheck_CommentTR.ObjectId = Object_CommentCheck.Id
                            AND ObjectLink_CommentCheck_CommentTR.DescId = zc_ObjectLink_CommentCheck_CommentTR()
        LEFT JOIN Object AS Object_CommentTR ON Object_CommentTR.Id = ObjectLink_CommentCheck_CommentTR.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentSun_SendPartionDate
                                ON ObjectBoolean_CommentSun_SendPartionDate.ObjectId = Object_CommentCheck.Id 
                               AND ObjectBoolean_CommentSun_SendPartionDate.DescId = zc_ObjectBoolean_CommentSun_SendPartionDate()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentSun_LostPositions
                                ON ObjectBoolean_CommentSun_LostPositions.ObjectId = Object_CommentCheck.Id 
                               AND ObjectBoolean_CommentSun_LostPositions.DescId = zc_ObjectBoolean_CommentSun_LostPositions()

       WHERE Object_CommentCheck.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CommentCheck(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.04.23                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_CommentCheck (1, '3')