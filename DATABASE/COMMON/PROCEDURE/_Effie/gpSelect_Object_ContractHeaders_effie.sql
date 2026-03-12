-- Function: gpSelect_Object_Warehouse_effie

DROP FUNCTION IF EXISTS gpSelect_Object_ContractHeaders_effie ( TVarChar);
                  
CREATE OR REPLACE FUNCTION gpSelect_Object_ContractHeaders_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId            TVarChar   -- Уникальный идентификатор договора
             , Name             TVarChar   -- Название Договора  
             , code             TVarChar   -- Код договора
             , contractDate     TVarChar   -- Дата оформления контракта
             , validFrom        TVarChar   -- Дата начала контракта (минимальное значение )
             , validTo          TVarChar   -- Дата окончания контракта
             , form             Integer    -- 1 или 2 форма
             , paymentDelay     Integer    -- Отсрочка оплаты в днях
             , creditLimit      TFloat     -- Кредитный лимит 
             , isDeleted        Boolean    -- Признак активности: false = активен / true = не активен
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH
     tmpDelayCreditLimit AS (SELECT -- Договор
                                      ObjectLink_ContractCondition_Contract.ChildObjectId  AS ContractId
                                      -- кредитный лимит
                                    , MAX (COALESCE (ObjectFloat_Value.ValueData,0)) :: TFloat AS Value
                                    
                             FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                               -- Условие договора НЕ удалено
                                    INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                                 AND Object_ContractCondition.isErased = FALSE
                                    -- Значение для условия
                                    INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                           ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                          AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                          AND ObjectFloat_Value.ValueData <> 0
                                    -- Договор
                                    INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                          ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                         AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                              -- Период для условия с ....
                                    LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                         ON ObjectDate_StartDate.ObjectId = Object_ContractCondition.Id
                                                        AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractCondition_StartDate()
                                    -- Период для условия по ....
                                    LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                         ON ObjectDate_EndDate.ObjectId = Object_ContractCondition.Id
                                                        AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractCondition_EndDate()
                             WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_DelayCreditLimit()
                                                         AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                             AND (COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())) :: TDateTime <= CURRENT_DATE
                             AND (COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())) >= CURRENT_DATE
                             
                             GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId
                             )
              
     --
     SELECT Object_Contract_View.ContractId                                ::TVarChar AS extId
          , TRIM (Object_Contract_View.InvNumber)                          ::TVarChar AS Name
          , Object_Contract_View.ContractCode                              ::TVarChar AS code
          , zfConvert_DateToString (ObjectDate_Signing.ValueData)          ::TVarChar AS contractDate
          , zfConvert_DateToString (Object_Contract_View.StartDate)        ::TVarChar AS validFrom
          , zfConvert_DateToString (Object_Contract_View.EndDate)          ::TVarChar AS validTo
          , CASE WHEN Object_Contract_View.PaidKindId = zc_Enum_PaidKind_FirstForm() THEN 1
                 WHEN Object_Contract_View.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN 2
            END                                                            ::Integer  AS form
          , (COALESCE (Object_Contract_View.DayCalendar,0) + COALESCE (Object_Contract_View.DayBank,0)) ::Integer AS paymentDelay
          , tmpDelayCreditLimit.Value                                      ::TFloat   AS creditLimit
          , Object_Contract_View.isErased                                  ::Boolean  AS isDeleted
     FROM Object_Contract_View
        LEFT JOIN ObjectDate AS ObjectDate_Signing
                             ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

        LEFT JOIN tmpDelayCreditLimit ON tmpDelayCreditLimit.ContractId = Object_Contract_View.ContractId
        
     WHERE Object_Contract_View.isErased = FALSE 
       AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() 
       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractHeaders_effie (zfCalc_UserAdmin()::TVarChar);


/*
  возвращает только договора ObjectLink_Contract_InfoMoney = zc_Enum_InfoMoney_30101() +  не закрытые zc_Enum_ContractStateKind_Close + не удаленные
*/