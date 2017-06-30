-- Function: gpGet_Object_SPKind_def (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_SPKind_def (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SPKind_def(
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, /*Code Integer,*/ Name TVarChar
             , Tax      TFloat
             /*, isErased Boolean*/
              )
AS
$BODY$
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_SPKind());

    RETURN QUERY 
       SELECT Object_SPKind.Id          AS Id
--            , Object_SPKind.ObjectCode  AS Code
            , Object_SPKind.ValueData   AS Name
            , COALESCE (ObjectFloat_Tax.ValueData, 0) :: TFloat AS Tax 
--            , Object_SPKind.isErased    AS isErased
       FROM Object AS Object_SPKind
            LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                                  ON ObjectFloat_Tax.ObjectId = Object_SPKind.Id
                                 AND ObjectFloat_Tax.DescId   = zc_ObjectFloat_SPKind_Tax()
       WHERE Object_SPKind.DescId   = zc_Object_SPKind()
         AND Object_SPKind.isErased = FALSE
       ORDER BY Object_SPKind.Id
       LIMIT 1;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.06.17                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_SPKind_def ('2')
