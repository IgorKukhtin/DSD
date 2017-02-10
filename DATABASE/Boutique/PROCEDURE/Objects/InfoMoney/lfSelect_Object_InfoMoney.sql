-- Function: lfSelect_Object_InfoMoney ()

-- DROP FUNCTION lfSelect_Object_InfoMoney ();

CREATE OR REPLACE FUNCTION lfSelect_Object_InfoMoney()

RETURNS TABLE (InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar) AS
   
$BODY$BEGIN

     -- Выбираем данные для справочника уп-назначения (на самом деле это три справочника)
     RETURN QUERY 
     SELECT 
           Object_InfoMoneyGroup.Id            AS InfoMoneyGroupId
          ,Object_InfoMoneyGroup.ObjectCode    AS InfoMoneyGroupCode
          ,Object_InfoMoneyGroup.ValueData     AS InfoMoneyGroupName
          
          ,Object_InfoMoneyDestination.Id           AS InfoMoneyDestinationId
          ,Object_InfoMoneyDestination.ObjectCode   AS InfoMoneyDestinationCode
          ,Object_InfoMoneyDestination.ValueData    AS InfoMoneyDestinationName
          
          ,Object_InfoMoney.Id           AS InfoMoneyId
          ,Object_InfoMoney.ObjectCode   AS InfoMoneyCode
          ,Object_InfoMoney.ValueData    AS InfoMoneyName
          
     FROM Object AS Object_InfoMoney
       
     LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
            ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id 
           AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
     LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId

     LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
            ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id 
           AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
     LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId

     WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney();
          
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_InfoMoney () OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.13          *                            

*/

-- тест
-- SELECT * FROM lfSelect_Object_InfoMoney()
