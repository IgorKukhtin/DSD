-- View: Object_ContractCondition_View

DROP VIEW IF EXISTS Object_ContractCondition_View;

CREATE OR REPLACE VIEW Object_ContractCondition_View
AS
        SELECT ObjectLink_ContractCondition_Contract.ChildObjectId                            AS ContractId
             , ObjectLink_ContractCondition_Contract.ObjectId                                 AS ContractConditionId
             , COALESCE (ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId, 0) AS ContractConditionKindId
             , ObjectLink_Contract_InfoMoney.ChildObjectId                                    AS InfoMoneyId
               -- форма оплаты из договора
             , ObjectLink_Contract_PaidKind.ChildObjectId                                     AS PaidKindId
               -- форма оплаты из усл.договора для расчета базы                  
             , ObjectLink_ContractCondition_PaidKind.ChildObjectId                            AS PaidKindId_Condition
               --                                                                
             , ObjectFloat_Value.ValueData                                                    AS Value
               --
             , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())         :: TDateTime AS StartDate
             , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())             :: TDateTime AS EndDate

             , Object_ContractCondition.isErased                                              AS isErased

         FROM ObjectLink AS ObjectLink_ContractCondition_Contract
              LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                   ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                  AND ObjectLink_ContractCondition_ContractConditionKind.DescId   = zc_ObjectLink_ContractCondition_ContractConditionKind()
              INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                     ON ObjectFloat_Value.ObjectId  = ObjectLink_ContractCondition_Contract.ObjectId
                                    AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ContractCondition_Value()
                                    AND ObjectFloat_Value.ValueData <> 0
              LEFT JOIN Object AS Object_ContractCondition ON  Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.objectid 
              -- 
              LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                   ON ObjectLink_Contract_InfoMoney.ObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                  AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
              LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                   ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                  AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
              LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                   ON ObjectLink_ContractCondition_PaidKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                  AND ObjectLink_ContractCondition_PaidKind.DescId   = zc_ObjectLink_ContractCondition_PaidKind()
              --
              LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                   ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                  AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
              LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                   ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                  AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()
         WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
           -- условие договора, не удалено
           AND Object_ContractCondition.isErased = FALSE
        ;

ALTER TABLE Object_ContractCondition_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.05.14                         * parse
 24.04.14                         *
 10.04.14                         *
*/

-- тест
-- SELECT * FROM Object_ContractCondition_View
