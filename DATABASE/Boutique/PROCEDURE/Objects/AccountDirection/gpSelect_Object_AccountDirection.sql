-- Function: gpSelect_Object_AccountDirection (TVarChar)

-- DROP FUNCTION gpSelect_Object_AccountDirection (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AccountDirection(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               AccountGroupId Integer, AccountGroupCode Integer, AccountGroupName TVarChar,
               isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_AccountDirection());

   RETURN QUERY 
   SELECT
        Object_AccountDirection.Id                   AS Id 
      , Object_AccountDirection.ObjectCode           AS Code
      , Object_AccountDirection.ValueData            AS NAME
       
   	  , lfObject_AccountDirection.AccountGroupId     AS AccountGroupId
	  , lfObject_AccountDirection.AccountGroupCode   AS AccountGroupCode
	  , lfObject_AccountDirection.AccountGroupName   AS AccountGroupName
		  
      , Object_AccountDirection.isErased   AS isErased
   FROM OBJECT AS Object_AccountDirection
   LEFT JOIN lfSelect_Object_AccountDirection() AS lfObject_AccountDirection ON lfObject_AccountDirection.AccountDirectionId = Object_AccountDirection.Id
   WHERE Object_AccountDirection.DescId = zc_Object_AccountDirection();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AccountDirection (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.06.13          * AccountGroup
 21.06.13          * zc_Enum_Process_Select_Object_AccountDirection()
 17.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AccountDirection('2')
