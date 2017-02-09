-- Function: gpGet_Object_InfoMoneyGroup(Integer, TVarChar)

--DROP FUNCTION gpGet_Object_InfoMoneyGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InfoMoneyGroup(
    IN inId          Integer,       -- Группы управленческих аналитик 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_InfoMoneyGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_InfoMoneyGroup.ObjectCode), 0) + 1  AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object AS Object_InfoMoneyGroup
       WHERE Object_InfoMoneyGroup.DescId = zc_Object_InfoMoneyGroup();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_InfoMoneyGroup.Id         AS Id 
           , Object_InfoMoneyGroup.ObjectCode AS Code
           , Object_InfoMoneyGroup.ValueData  AS Name
           , Object_InfoMoneyGroup.isErased   AS isErased
       FROM OBJECT AS Object_InfoMoneyGroup
       WHERE Object_InfoMoneyGroup.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_InfoMoneyGroup (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             

*/

-- тест
-- SELECT * FROM gpGet_Object_InfoMoneyGroup('2')