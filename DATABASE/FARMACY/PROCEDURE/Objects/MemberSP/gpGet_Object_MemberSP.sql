-- Function: gpGet_Object_MemberSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberSP(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MemberSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MemberSP()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_MemberSP.Id          AS Id
            , Object_MemberSP.ObjectCode  AS Code
            , Object_MemberSP.ValueData   AS Name
            , Object_MemberSP.isErased    AS isErased
       FROM Object AS Object_MemberSP
       WHERE Object_MemberSP.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.02.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberSP(0,'2')