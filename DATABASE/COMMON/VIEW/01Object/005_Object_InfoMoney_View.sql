-- View: Object_InfoMoney_View
--DROP VIEW IF EXISTS Object_InfoMoney_View CASCADE;

CREATE OR REPLACE VIEW Object_InfoMoney_View AS
  SELECT ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId               AS InfoMoneyGroupId
       , Object_InfoMoneyGroup.ObjectCode       AS InfoMoneyGroupCode
       , Object_InfoMoneyGroup.ValueData        AS InfoMoneyGroupName
       , ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId         AS InfoMoneyDestinationId
       , Object_InfoMoneyDestination.ObjectCode AS InfoMoneyDestinationCode
       , Object_InfoMoneyDestination.ValueData  AS InfoMoneyDestinationName
       , Object_InfoMoney.Id                    AS InfoMoneyId
       , Object_InfoMoney.ObjectCode            AS InfoMoneyCode
       , Object_InfoMoney.ValueData             AS InfoMoneyName
       
       , CAST ('(' || CAST (Object_InfoMoney.ObjectCode AS TVarChar)
           || ') '|| Object_InfoMoneyGroup.ValueData
           || ' ' || Object_InfoMoneyDestination.ValueData
           || CASE WHEN Object_InfoMoneyDestination.ValueData <> Object_InfoMoney.ValueData THEN ' ' || Object_InfoMoney.ValueData ELSE '' END
              AS TVarChar)  AS InfoMoneyName_all

       , Object_InfoMoney.isErased              AS isErased

       , Object_CashFlow_in.Id                  AS CashFlowId_in
       , Object_CashFlow_in.ObjectCode          AS CashFlowCode_in
       , Object_CashFlow_in.ValueData           AS CashFlowName_in
       
       , Object_CashFlow_out.Id                 AS CashFlowId_out
       , Object_CashFlow_out.ObjectCode         AS CashFlowCode_out
       , Object_CashFlow_out.ValueData          AS CashFlowName_out
  FROM Object AS Object_InfoMoney
       LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                            ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = Object_InfoMoney.Id
                           AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
       LEFT JOIN Object AS Object_InfoMoneyDestination ON Object_InfoMoneyDestination.Id = ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId
 
       LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyGroup
                            ON ObjectLink_InfoMoney_InfoMoneyGroup.ObjectId = Object_InfoMoney.Id
                           AND ObjectLink_InfoMoney_InfoMoneyGroup.DescId = zc_ObjectLink_InfoMoney_InfoMoneyGroup()
       LEFT JOIN Object AS Object_InfoMoneyGroup ON Object_InfoMoneyGroup.Id = ObjectLink_InfoMoney_InfoMoneyGroup.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_CashFlow_in
                            ON ObjectLink_InfoMoney_CashFlow_in.ObjectId = Object_InfoMoney.Id
                           AND ObjectLink_InfoMoney_CashFlow_in.DescId = zc_ObjectLink_InfoMoney_CashFlow_in()
       LEFT JOIN Object AS Object_CashFlow_in ON Object_CashFlow_in.Id = ObjectLink_InfoMoney_CashFlow_in.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_CashFlow_out
                            ON ObjectLink_InfoMoney_CashFlow_out.ObjectId = Object_InfoMoney.Id
                           AND ObjectLink_InfoMoney_CashFlow_out.DescId = zc_ObjectLink_InfoMoney_CashFlow_out()
       LEFT JOIN Object AS Object_CashFlow_out ON Object_CashFlow_out.Id = ObjectLink_InfoMoney_CashFlow_out.ChildObjectId

 WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney();


ALTER TABLE Object_InfoMoney_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 22.06.20         * CashFlow
 26.09.13                                        * add InfoMoneyName_all
 30.09.13                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_InfoMoney_View