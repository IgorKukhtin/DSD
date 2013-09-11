-- Function: gpSelect_Object_InfoMoney(TVarChar)

--DROP FUNCTION gpSelect_Object_InfoMoney (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               isErased boolean) AS
$BODY$BEGIN
     
     -- проверка прав пользователя на вызов процедуры 
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_InfoMoney());
     RETURN QUERY 
     SELECT 
           Object_InfoMoney.Id                   AS Id
         , Object_InfoMoney.ObjectCode           AS Code
         , Object_InfoMoney.ValueData            AS Name
    
         , Object_InfoMoneyGroup.Id              AS InfoMoneyGroupId
         , Object_InfoMoneyGroup.ObjectCode      AS InfoMoneyGroupCode
         , Object_InfoMoneyGroup.ValueData       AS InfoMoneyGroupName
        
         , Object_InfoMoneyDestination.Id         AS InfoMoneyDestinationId
         , Object_InfoMoneyDestination.ObjectCode AS InfoMoneyDestinationCode
         , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
         
         , Object_InfoMoney.isErased             AS isErased
      FROM Object AS Object_InfoMoney
 LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
        ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id
       AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
 LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
 
 LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
        ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id
       AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
 LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId

     WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoney (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *    + все поля          
 00.05.13                                        

*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoney('2')