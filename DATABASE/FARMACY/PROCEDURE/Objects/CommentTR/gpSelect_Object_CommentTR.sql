-- Function: gpSelect_Object_CommentTR()

DROP FUNCTION IF EXISTS gpSelect_Object_CommentTR(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentTR(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isExplanation Boolean
             , isResort Boolean
             , isDifferenceSum Boolean
             , DifferenceSum TFloat
             , isBlockFormSUN Boolean
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_CommentTR.Id                             AS Id 
        , Object_CommentTR.ObjectCode                     AS Code
        , Object_CommentTR.ValueData                      AS Name
        , ObjectBoolean_CommentTR_Explanation.ValueData   AS isExplanation
        , ObjectBoolean_CommentTR_Resort.ValueData        AS isResort
        , ObjectBoolean_CommentTR_DifferenceSum.ValueData AS isDifferenceSum
        , ObjectFloat_DifferenceSum.ValueData             AS DifferenceSum
        , ObjectBoolean_CommentTR_BlockFormSUN.ValueData  AS isBlockFormSUN
        , Object_CommentTR.isErased                       AS isErased
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

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_BlockFormSUN
                                ON ObjectBoolean_CommentTR_BlockFormSUN.ObjectId = Object_CommentTR.Id 
                               AND ObjectBoolean_CommentTR_BlockFormSUN.DescId = zc_ObjectFloat_CommentTR_BlockFormSUN()

   WHERE Object_CommentTR.DescId = zc_Object_CommentTR()
     AND Object_CommentTR.ObjectCode <> 8;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CommentTR(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.02.20                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_CommentTR('3')