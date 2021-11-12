-- View: Object_ContractCondition_ValueView

-- DROP VIEW IF EXISTS Object_ContractCondition_ValueView;

CREATE OR REPLACE VIEW Object_ContractCondition_ValueView AS
  SELECT ObjectLink_ContractCondition_Contract.ChildObjectId  AS ContractId

       , MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_ChangePercent()        THEN ObjectFloat_Value.ValueData ELSE NULL END) :: TFloat AS ChangePercent
       , MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_ChangePercentPartner() THEN ObjectFloat_Value.ValueData ELSE NULL END) :: TFloat AS ChangePercentPartner
       , MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_ChangePrice()          THEN ObjectFloat_Value.ValueData ELSE NULL END) :: TFloat AS ChangePrice
       
       , MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_DelayDayCalendar() THEN ObjectFloat_Value.ValueData ELSE NULL END) :: TFloat AS DayCalendar
       , MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_DelayDayBank()     THEN ObjectFloat_Value.ValueData ELSE NULL END) :: TFloat AS DayBank
       , CASE WHEN 0 <> MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_DelayDayCalendar() THEN ObjectFloat_Value.ValueData ELSE NULL END)
                  THEN (MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_DelayDayCalendar() THEN ObjectFloat_Value.ValueData ELSE NULL END) :: Integer) :: TVarChar || ' К.дн.'
              WHEN 0 <> MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_DelayDayBank()     THEN ObjectFloat_Value.ValueData ELSE NULL END)
                  THEN (MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_DelayDayBank()     THEN ObjectFloat_Value.ValueData ELSE NULL END) :: Integer) :: TVarChar || ' Б.дн.'
              ELSE '0 дн.'
         END :: TVarChar  AS DelayDay

       , (COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())) :: TDateTime AS StartDate
       , (COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd()))     :: TDateTime AS EndDate

  FROM (SELECT zc_Enum_ContractConditionKind_ChangePercent()        AS Id -- (-)% Скидки (+)% Наценки
       UNION ALL
        SELECT zc_Enum_ContractConditionKind_ChangePercentPartner() AS Id -- % Наценки Павильоны (Приход покупателю)
       UNION ALL
        SELECT zc_Enum_ContractConditionKind_ChangePrice()          AS Id -- Скидка в цене ГСМ

       UNION ALL
        SELECT zc_Enum_ContractConditionKind_DelayDayCalendar() AS Id -- Отсрочка в календарных днях 
       UNION ALL
        SELECT zc_Enum_ContractConditionKind_DelayDayBank()     AS Id --  Отсрочка в банковских днях 

       ) AS tmpContractConditionKind
       INNER JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                             ON ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = tmpContractConditionKind.Id
                            AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
       INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                    AND Object_ContractCondition.isErased = FALSE
       INNER JOIN ObjectFloat AS ObjectFloat_Value
                              ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                             AND ObjectFloat_Value.ValueData <> 0
       INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                             ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                            AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()

       LEFT JOIN ObjectDate AS ObjectDate_StartDate
                            ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                           AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
       LEFT JOIN ObjectDate AS ObjectDate_EndDate
                            ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                           AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()

  GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
       , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())
       , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())
          ;

ALTER TABLE Object_ContractCondition_ValueView  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.11.13                                        *
*/

-- тест
-- SELECT * FROM Object_ContractCondition_ValueView
