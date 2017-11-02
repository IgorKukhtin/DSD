-- View: Object_Contract_InvNumber_Sale_View

-- LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
-- LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

CREATE OR REPLACE VIEW Object_Contract_InvNumber_Sale_View
AS
  SELECT Object_Contract.Id                            AS ContractId
       , Object_Contract.ObjectCode                    AS ContractCode  
       , Object_Contract.ValueData                     AS InvNumber
       , Object_ContractTag.Id                         AS ContractTagId
       , Object_ContractTag.ObjectCode                 AS ContractTagCode
       , Object_ContractTag.ValueData                  AS ContractTagName

       , ObjectLink_Contract_InfoMoney.ChildObjectId   AS InfoMoneyId
       , Object_InfoMoney.ObjectCode                   AS InfoMoneyCode
       , Object_InfoMoney.ValueData                    AS InfoMoneyName

       , ObjectLink_InfoMoneyDestination.ChildObjectId AS InfoMoneyDestinationId
       , Object_InfoMoneyDestination.ObjectCode        AS InfoMoneyDestinationCode
       , Object_InfoMoneyDestination.ValueData         AS InfoMoneyDestinationName

       , ObjectLink_InfoMoneyGroup.ChildObjectId       AS InfoMoneyGroupId
       , Object_InfoMoneyGroup.ObjectCode              AS InfoMoneyGroupCode
       , Object_InfoMoneyGroup.ValueData               AS InfoMoneyGroupName

       , ('(' || Object_InfoMoney.ObjectCode :: TVarChar
       || ') '|| Object_InfoMoneyGroup.ValueData
       || ' ' || Object_InfoMoneyDestination.ValueData
       || CASE WHEN Object_InfoMoneyDestination.ValueData <> Object_InfoMoney.ValueData THEN ' ' || Object_InfoMoney.ValueData ELSE '' END
         ) :: TVarChar AS InfoMoneyName_all


       , Object_Contract.isErased                      AS isErased
  FROM Object AS Object_Contract
       LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                            ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
       LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                            ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
       LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyDestination
                            ON ObjectLink_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id
                           AND ObjectLink_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
       LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoneyDestination.ChildObjectId
 
       LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyGroup
                            ON ObjectLink_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id
                           AND ObjectLink_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
       LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoneyGroup.ChildObjectId

  WHERE Object_Contract.DescId = zc_Object_Contract()
    AND ObjectLink_InfoMoneyGroup.ChildObjectId IN (zc_Enum_InfoMoneyGroup_30000() -- Доходы
                                                  -- , zc_Enum_InfoMoneyGroup_21000() -- Общефирменные
                                                   )
  ;

ALTER TABLE Object_Contract_InvNumber_Sale_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.11.17                                        *
*/

-- тест
-- SELECT * FROM Object_Contract_InvNumber_Sale_View
