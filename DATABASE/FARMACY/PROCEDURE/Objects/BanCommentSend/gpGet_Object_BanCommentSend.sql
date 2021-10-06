-- Function: gpGet_Object_BanCommentSend()

DROP FUNCTION IF EXISTS gpGet_Object_BanCommentSend (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BanCommentSend(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , CommentSendId Integer, CommentSendName TVarChar
             , UnitId Integer, UnitName TVarChar
              )
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BanCommentSend());

      IF COALESCE (inId, 0) = 0
      THEN
           RETURN QUERY
             SELECT CAST (0 AS Integer)    AS Id
                  , lfGet_ObjectCode(0, zc_Object_BanCommentSend()) AS Code
                 
                  , NULL :: Integer        AS CommentSendId
                  , CAST ('' AS TVarChar)  AS CommentSendName
                  , NULL :: Integer        AS UnitId
                  , CAST ('' AS TVarChar)  AS UnitName;
      ELSE
           RETURN QUERY
             SELECT Object_BanCommentSend.Id         AS Id
                  , Object_BanCommentSend.ObjectCode AS Code
                  , Object_CommentSend.Id              AS CommentSendId
                  , Object_CommentSend.ValueData       AS CommentSendName
                  , Object_Unit.Id                          AS UnitId
                  , Object_Unit.ValueData                   AS UnitName

             FROM Object AS Object_BanCommentSend
                  LEFT JOIN ObjectLink AS ObjectLink_CommentSend
                                       ON ObjectLink_CommentSend.ObjectId = Object_BanCommentSend.Id
                                      AND ObjectLink_CommentSend.DescId = zc_ObjectLink_BanCommentSend_CommentSend()
                  LEFT JOIN Object AS Object_CommentSend ON Object_CommentSend.Id = ObjectLink_CommentSend.ChildObjectId
                  LEFT JOIN ObjectLink AS ObjectLink_Unit
                                       ON ObjectLink_Unit.ObjectId = Object_BanCommentSend.Id
                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_BanCommentSend_Unit()
                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

             WHERE Object_BanCommentSend.Id = inId;
      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_BanCommentSend (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.10.21                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_BanCommentSend (2915395, zfCalc_UserAdmin())
