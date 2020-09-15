-- Function: gpGet_Object_CommentSend()

DROP FUNCTION IF EXISTS gpGet_Object_CommentSend(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CommentSend(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CommentTRId Integer, CommentTRCode Integer, CommentTRName TVarChar
             , isPromo boolean, isSendPartionDate boolean, isLostPositions boolean
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
           , lfGet_ObjectCode(0, zc_Object_CommentSend()) AS Code
           , CAST ('' as TVarChar)                        AS Name
           , CAST (0 AS Integer)                          AS CommentTRId
           , CAST (0 AS Integer)                          AS CommentTRCode
           , CAST ('' AS TVarChar)                        AS CommentTRName
           , CAST (FALSE AS Boolean)                      AS isPromo
           , CAST (FALSE AS Boolean)                      AS isSendPartionDate 
           , CAST (FALSE AS Boolean)                      AS isLostPositions 
           , CAST (FALSE AS Boolean)                      AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_CommentSend.Id                         AS Id 
        , Object_CommentSend.ObjectCode                     AS Code
        , Object_CommentSend.ValueData                      AS Name
        , Object_CommentTR.Id                               AS CommentTRId 
        , Object_CommentTR.ObjectCode                       AS CommentTRCode
        , Object_CommentTR.ValueData                        AS CommentTRName
        , COALESCE(ObjectBoolean_CommentSun_Promo.ValueData, FALSE)             AS isPromo
        , COALESCE(ObjectBoolean_CommentSun_SendPartionDate.ValueData, FALSE)   AS isSendPartionDate
        , COALESCE(ObjectBoolean_CommentSun_LostPositions.ValueData, FALSE)     AS isLostPositions
        , Object_CommentSend.isErased                       AS isErased
   FROM Object AS Object_CommentSend

        LEFT JOIN ObjectLink AS ObjectLink_CommentSend_CommentTR
                             ON ObjectLink_CommentSend_CommentTR.ObjectId = Object_CommentSend.Id
                            AND ObjectLink_CommentSend_CommentTR.DescId = zc_ObjectLink_CommentSend_CommentTR()
        LEFT JOIN Object AS Object_CommentTR ON Object_CommentTR.Id = ObjectLink_CommentSend_CommentTR.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentSun_Promo
                                ON ObjectBoolean_CommentSun_Promo.ObjectId = Object_CommentSend.Id 
                               AND ObjectBoolean_CommentSun_Promo.DescId = zc_ObjectBoolean_CommentSun_Promo()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentSun_SendPartionDate
                                ON ObjectBoolean_CommentSun_SendPartionDate.ObjectId = Object_CommentSend.Id 
                               AND ObjectBoolean_CommentSun_SendPartionDate.DescId = zc_ObjectBoolean_CommentSun_SendPartionDate()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentSun_LostPositions
                                ON ObjectBoolean_CommentSun_LostPositions.ObjectId = Object_CommentSend.Id 
                               AND ObjectBoolean_CommentSun_LostPositions.DescId = zc_ObjectBoolean_CommentSun_LostPositions()

       WHERE Object_CommentSend.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CommentSend(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.08.20                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_CommentSend (1, '3')