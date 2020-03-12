-- Function: gpGet_Object_CommentTR()

DROP FUNCTION IF EXISTS gpGet_Object_CommentTR(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CommentTR(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isExplanation Boolean, isResort Boolean
             , isDifferenceSum Boolean
             , DifferenceSum TFloat
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
           , lfGet_ObjectCode(0, zc_Object_CommentTR()) AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST (FALSE AS Boolean) AS isExplanation
           , CAST (FALSE AS Boolean) AS isResort
           , CAST (FALSE AS Boolean) AS isDifferenceSum
           , Null                    AS DifferenceSum
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_CommentTR.Id                                              AS Id
            , Object_CommentTR.ObjectCode                                      AS Code
            , Object_CommentTR.ValueData                                       AS Name
            , COALESCE(ObjectBoolean_CommentTR_Explanation.ValueData, FALSE)   AS isExplanation
            , COALESCE(ObjectBoolean_CommentTR_Resort.ValueData, FALSE)        AS isResort
            , COALESCE(ObjectBoolean_CommentTR_DifferenceSum.ValueData, FALSE) AS isDifferenceSum
            , ObjectFloat_DifferenceSum.ValueData                              AS DifferenceSum
            , Object_CommentTR.isErased                                        AS isErased
       FROM Object AS Object_CommentTR

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Explanation
                                ON ObjectBoolean_CommentTR_Explanation.ObjectId = Object_CommentTR.Id 
                               AND ObjectBoolean_CommentTR_Explanation.DescId = zc_ObjectBoolean_CommentTR_Explanation()
                               
        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Resort
                                ON ObjectBoolean_CommentTR_Resort.ObjectId = Object_CommentTR.Id 
                               AND ObjectBoolean_CommentTR_Resort.DescId = zc_ObjectBoolean_CommentTR_Resort()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_DifferenceSum
                                ON ObjectBoolean_CommentTR_DifferenceSum.ObjectId = Object_CommentTR.Id 
                               AND ObjectBoolean_CommentTR_DifferenceSum.DescId = zc_ObjectBoolean_CommentTR_DifferenceSum()

        LEFT JOIN ObjectFloat AS ObjectFloat_DifferenceSum
                              ON ObjectFloat_DifferenceSum.ObjectId = Object_CommentTR.Id 
                             AND ObjectFloat_DifferenceSum.DescId = zc_ObjectFloat_CommentTR_DifferenceSum()

       WHERE Object_CommentTR.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CommentTR(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.02.20                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_CommentTR (1, '3')