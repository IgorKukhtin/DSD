-- Function: gpGet_Object_MemberIncomeCheck (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MemberIncomeCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberIncomeCheck(
    IN inId          Integer,        -- 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MemberIncomeCheck());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MemberIncomeCheck()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_MemberIncomeCheck.Id          AS Id
            , Object_MemberIncomeCheck.ObjectCode  AS Code
            , Object_MemberIncomeCheck.ValueData   AS Name
            , Object_MemberIncomeCheck.isErased    AS isErased
       FROM Object AS Object_MemberIncomeCheck
       WHERE Object_MemberIncomeCheck.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberIncomeCheck(0,'2')