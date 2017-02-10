-- Function: gpGet_Object_InfoMoneyDestination(integer, TVarChar)

--DROP FUNCTION gpGet_Object_InfoMoneyDestination(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_InfoMoneyDestination(
    IN inId          Integer,       -- ключ объекта  Группы управленческих аналитик 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN
    
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_InfoMoneyDestination());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_InfoMoneyDestination.ObjectCode), 0) + 1  AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object AS Object_InfoMoneyDestination
       WHERE Object_InfoMoneyDestination.DescId = zc_Object_InfoMoneyDestination();
   ELSE
       RETURN QUERY 
       SELECT
             Object_InfoMoneyDestination.Id         AS Id
           , Object_InfoMoneyDestination.ObjectCode AS Code
           , Object_InfoMoneyDestination.ValueData  AS Name
           , Object_InfoMoneyDestination.isErased   AS isErased
       FROM Object AS Object_InfoMoneyDestination
       WHERE Object_InfoMoneyDestination.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_InfoMoneyDestination (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *  zc_Enum_Process_Get_Object_InfoMoneyDestination() ; IF COALESCE (inId, 0) = 0 ...    
 00.06.13          

*/

-- тест
-- SELECT * FROM gpGet_Object_InfoMoneyDestination('2')