-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPayment (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPayment(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inAccountId        Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, ContractNumber TVarChar, KreditRemains TFloat, DebetRemains TFloat
             , SaleSumm TFloat, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat)
AS
$BODY$
   DECLARE vbLenght Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

     -- Выбираем остаток на дату по юр. лицам в разрезе договоров. 
     -- Так же выбираем продажи и возвраты за период 
  vbLenght := 7;

  RETURN QUERY  
  SELECT 
     Object_Account.Valuedata AS AccountName
   , Object_Juridical.Id        AS JuridicalId
   , Object_Juridical.Valuedata AS JuridicalName
   , Object_Contract_View.InvNumber
   , (CASE WHEN RESULT.Remains > 0 THEN RESULT.Remains ELSE 0 END)::TFloat AS KreditRemains
   , (CASE WHEN RESULT.Remains > 0 THEN 0 ELSE - RESULT.Remains END)::TFloat AS DebetRemains
   , RESULT.SaleSumm::TFloat
   , (CASE WHEN (RESULT.Remains - RESULT.SaleSumm) > 0 THEN RESULT.Remains - RESULT.SaleSumm ELSE 0 END)::TFloat AS DefermentPaymentRemains
   , (CASE WHEN ((RESULT.Remains - RESULT.SaleSumm) > 0 AND RESULT.SaleSumm1 > 0) THEN 
   	  CASE WHEN (RESULT.Remains - RESULT.SaleSumm) > RESULT.SaleSumm1 THEN RESULT.SaleSumm1 ELSE (RESULT.Remains - RESULT.SaleSumm) END
      ELSE 0 END)::TFloat AS SaleSumm1
   , (CASE WHEN ((RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1) > 0 AND RESULT.SaleSumm2 > 0) THEN 
   	  CASE WHEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1) > RESULT.SaleSumm2 THEN RESULT.SaleSumm2 ELSE (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1) END
      ELSE 0 END)::TFloat AS SaleSumm2
   , (CASE WHEN ((RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > 0 AND RESULT.SaleSumm3 > 0) THEN 
   	  CASE WHEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > RESULT.SaleSumm3 THEN RESULT.SaleSumm3 ELSE (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) END
      ELSE 0 END)::TFloat AS SaleSumm3
   , (CASE WHEN ((RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > 0 AND RESULT.SaleSumm4 > 0) THEN 
   	  CASE WHEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > RESULT.SaleSumm4 THEN RESULT.SaleSumm4 ELSE (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) END
      ELSE 0 END)::TFloat AS SaleSumm4
   , (CASE WHEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4) > 0 THEN (RESULT.Remains - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4) ELSE 0 END )::TFloat
   , (RESULT.DayCount||' '||Object_ContractConditionKind.ValueData)::TVarChar AS Condition
   , RESULT.ContractDate::TDateTime AS ContractDate
   , (-RESULT.Remains)::TFloat

  FROM (SELECT Container.Id
             , Container.ObjectId     AS AccountId
             , CLO_Contract.ObjectId  AS ContractId
             , CLO_Juridical.ObjectId AS JuridicalId 
             , Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate >= inOperDate THEN MIContainer.Amount ELSE 0 END), 0) AS Remains
             , SUM (CASE WHEN (MIContainer.OperDate < inOperDate) AND (MIContainer.OperDate >= ContractDate) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate AND MIContainer.OperDate >= ContractDate - vbLenght) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm1
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - vbLenght AND MIContainer.OperDate >= ContractDate - 2 * vbLenght) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm2
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 2 * vbLenght AND MIContainer.OperDate >= ContractDate - 3 * vbLenght) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm3
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 3 * vbLenght AND MIContainer.OperDate >= ContractDate - 4 * vbLenght) AND Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS SaleSumm4
             , ContractKind.ContractConditionKindId
             , ContractKind.DayCount
             , ContractDate
         FROM ContainerLinkObject AS CLO_Juridical 
         JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
    LEFT JOIN ContainerLinkObject AS CLO_Contract
           ON CLO_Contract.ContainerId = Container.Id AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                
    LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                    , zfCalc_DetermentPaymentDate(COALESCE(ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId, 0), ObjectFloat_Value.ValueData::Integer, inOperDate)::Date AS ContractDate
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
                  AND ContractCondition.iserased = false
                       ) AS ContractKind
            ON ContractKind.contractid = CLO_Contract.objectid
                              
     LEFT JOIN MovementItemContainer AS MIContainer 
            ON MIContainer.Containerid = Container.Id
           AND MIContainer.OperDate >= COALESCE(ContractKind.ContractDate::Date - 4 * vbLenght, inOperDate)
     LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
         WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
           AND (Container.ObjectId = inAccountId OR inAccountId = 0)
      GROUP BY Container.amount
             , CLO_Contract.ObjectId
             , CLO_Juridical.ObjectId  
             , Container.ObjectId
             , Container.Id
             , ContractConditionKindId
             , DayCount
             , ContractDate) AS RESULT
  JOIN Object AS Object_Juridical ON Object_Juridical.Id = RESULT.JuridicalId
  JOIN Object AS Object_Account ON Object_Account.Id = RESULT.AccountId
  JOIN Object_Contract_View ON Object_Contract_View.ContractId = RESULT.ContractId
  LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = RESULT.ContractConditionKindId;
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentPayment (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.14                          * 
 06.02.14                          * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPayment ('01.01.2014'::TDateTime, '01.02.2013'::TDateTime, 0, inSession:= '2'::TVarChar); 
