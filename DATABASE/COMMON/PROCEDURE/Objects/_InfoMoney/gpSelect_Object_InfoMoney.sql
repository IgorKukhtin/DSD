-- Function: gpSelect_Object_InfoMoney()

--DROP FUNCTION gpSelect_Object_InfoMoney();

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney(
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean,
               InfoMoneyDestinationName TVarChar, InfoMoneyGroupName TVarChar
) AS
$BODY$BEGIN
      
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
      RETURN QUERY 
      SELECT 
           Object_InfoMoney.Id
         , Object_InfoMoney.ObjectCode           AS Code
         , Object_InfoMoney.ValueData            AS Name
         , Object_InfoMoney.isErased
         , Object_InfoMoneyDestination.ValueData AS InfoMoneyDestinationName
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
     WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_InfoMoney(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_InfoMoney('2')