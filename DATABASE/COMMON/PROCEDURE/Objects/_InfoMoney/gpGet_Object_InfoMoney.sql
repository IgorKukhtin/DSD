-- Function: gpGet_Object_InfoMoney()

--DROP FUNCTION gpGet_Object_InfoMoney();

CREATE OR REPLACE FUNCTION gpGet_Object_InfoMoney(
IN inId          Integer,       /* Группы управленческих аналитик */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, InfoMoneyDestinationId Integer,
               InfoMoneyDestinationName TVarChar, InfoMoneyGroupId Integer, InfoMoneyGroupName TVarChar
) AS
$BODY$BEGIN
      
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
      RETURN QUERY 
      SELECT 
           Object_InfoMoney.Id
         , Object_InfoMoney.ObjectCode           AS Code
         , Object_InfoMoney.ValueData            AS Name
         , Object_InfoMoney.isErased
         , Object_InfoMoneyDestination.Id        AS InfoMoneyDestinationId
         , Object_InfoMoneyDestination.ValueData AS InfoMoneyDestinationName
         , Object_InfoMoneyGroup.Id              AS InfoMoneyGroupId
         , Object_InfoMoneyGroup.ValueData       AS InfoMoneyGroupName
      FROM Object AS Object_InfoMoney
 LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
        ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id
       AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
 LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
        ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id
       AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
 LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
 LEFT JOIN Object AS ObjectLink_InfoMoney_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId
     WHERE Object_InfoMoney.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_InfoMoney(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')