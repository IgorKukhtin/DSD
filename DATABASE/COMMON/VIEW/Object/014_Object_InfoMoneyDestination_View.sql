-- View: Object_InfoMoneyDestination_View

CREATE OR REPLACE VIEW Object_InfoMoneyDestination_View AS
  SELECT Object_InfoMoney_View.InfoMoneyGroupId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationId
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , TRUE AS isErased
  FROM Object_InfoMoney_View
  GROUP BY Object_InfoMoney_View.InfoMoneyGroupId
         , Object_InfoMoney_View.InfoMoneyGroupCode
         , Object_InfoMoney_View.InfoMoneyGroupName
         , Object_InfoMoney_View.InfoMoneyDestinationId
         , Object_InfoMoney_View.InfoMoneyDestinationCode
         , Object_InfoMoney_View.InfoMoneyDestinationName
 ;


ALTER TABLE Object_InfoMoneyDestination_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.13                                        *
*/

-- тест
-- SELECT * FROM Object_InfoMoneyDestination_View ORDER BY 5