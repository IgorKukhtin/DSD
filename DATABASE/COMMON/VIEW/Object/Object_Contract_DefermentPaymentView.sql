-- View: Object_Contract_PercentView

DROP VIEW IF EXISTS Object_Contract_DefermentPaymentView;

CREATE OR REPLACE VIEW Object_Contract_DefermentPaymentView AS
        SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
               --     , zfCalc_DetermentPaymentDate(COALESCE(ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId, 0), ObjectFloat_Value.ValueData::Integer, CURRENT_DATE)::Date AS ContractDate
                    , ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                    , ObjectFloat_Value.ValueData::Integer AS DayCount
                 FROM ObjectLink AS ObjectLink_ContractCondition_Contract
                 JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                   ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                  AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  AND ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId IN (SELECT ConditionKindId FROM Object_ContractCondition_DefermentPaymentView)
                 JOIN ObjectFloat AS ObjectFloat_Value 
                   ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                  AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                 JOIN Object AS ContractCondition ON 
                      ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.objectid 
                WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                  AND ContractCondition.iserased = false;


ALTER TABLE Object_Contract_DefermentPaymentView  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 10.04.14                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Object_ContractCondition_PercentView