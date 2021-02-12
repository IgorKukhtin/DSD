-- View: Object_ContractCondition_View

DROP VIEW IF EXISTS Object_ContractCondition_View;

CREATE OR REPLACE VIEW Object_ContractCondition_View
AS
        SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
             , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
             , ObjectLink_Contract_PaidKind.ChildObjectId AS PaidKindId
             , ObjectFloat_Value.ValueData AS Value
         FROM ObjectLink AS ObjectLink_ContractCondition_Contract
              INNER JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                    ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
              INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                     ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                    AND ObjectFloat_Value.ValueData <> 0
              LEFT JOIN Object AS ContractCondition ON  ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.objectid 
              LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                   ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                  AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
         WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
           AND ContractCondition.isErased = FALSE;

ALTER TABLE Object_ContractCondition_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 11.05.14                         * parse
 24.04.14                         *
 10.04.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_ContractCondition_View