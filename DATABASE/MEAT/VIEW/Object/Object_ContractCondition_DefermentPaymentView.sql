-- View: Object_ContractCondition_DefermentPaymentView

CREATE OR REPLACE VIEW Object_ContractCondition_DefermentPaymentView AS
        SELECT zc_Enum_ContractConditionKind_DelayDayCalendar()  AS ConditionKindId
  UNION SELECT zc_Enum_ContractConditionKind_DelayDayBank()      AS ConditionKindId;


ALTER TABLE Object_ContractCondition_DefermentPaymentView  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.11.13                                        *
*/

-- тест
-- SELECT * FROM Object_ContractCondition_DefermentPaymentView