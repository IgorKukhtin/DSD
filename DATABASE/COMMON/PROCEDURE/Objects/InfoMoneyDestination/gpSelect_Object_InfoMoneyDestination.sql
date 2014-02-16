﻿-- Function: gpSelect_Object_InfoMoneyDestination(TVarChar)

--DROP FUNCTION gpSelect_Object_InfoMoneyDestination(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyDestination(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_InfoMoneyDestination());

   RETURN QUERY 
   SELECT
         Object_InfoMoneyDestination.Id         AS Id
       , Object_InfoMoneyDestination.ObjectCode AS Code
       , Object_InfoMoneyDestination.ValueData  AS NAME
	   
	   , lfObject_InfoMoneyDestination.InfoMoneyGroupId   AS InfoMoneyGroupId
	   , lfObject_InfoMoneyDestination.InfoMoneyGroupCode AS InfoMoneyGroupCode
	   , lfObject_InfoMoneyDestination.InfoMoneyGroupName AS InfoMoneyGroupName
	   
	   , Object_InfoMoneyDestination.isErased   AS isErased
    FROM Object AS Object_InfoMoneyDestination
    LEFT JOIN lfSelect_Object_InfoMoneyDestination() AS lfObject_InfoMoneyDestination ON lfObject_InfoMoneyDestination.InfoMoneyDestinationId = Object_InfoMoneyDestination.Id
    WHERE Object_InfoMoneyDestination.DescId = zc_Object_InfoMoneyDestination();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoneyDestination (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.06.13          * InfoMoneyGroup               
 21.06.13          * zc_Enum_Process_Select_Object_InfoMoneyDestination()
 17.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoneyDestination('2')