-- View: Object_Contract_InvNumber_View

DROP VIEW IF EXISTS Object_Contract_InvNumber_View CASCADE;

CREATE OR REPLACE VIEW Object_Contract_InvNumber_View AS
  SELECT Object_Contract.Id                          AS ContractId
       , Object_Contract.ObjectCode                  AS ContractCode  
       , CAST (CASE WHEN Object_Contract.ValueData <> '' THEN Object_Contract.ValueData ELSE '**уп' || CAST (Object_InfoMoney.ObjectCode AS TVarChar) END AS TVarChar) AS InvNumber
       , ObjectLink_Contract_InfoMoney.ChildObjectId         AS InfoMoneyId
       , Object_Contract.isErased                    AS isErased
  FROM Object AS Object_Contract
       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id 
                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                           
       LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId
  WHERE Object_Contract.DescId = zc_Object_Contract();


ALTER TABLE Object_Contract_InvNumber_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.14                                        * 
*/

-- тест
-- SELECT * FROM Object_Contract_InvNumber_View