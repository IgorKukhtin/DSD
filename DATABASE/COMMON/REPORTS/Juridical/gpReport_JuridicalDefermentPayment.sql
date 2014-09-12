-- Function: gpReport_JuridicalSold()

DROP FUNCTION IF EXISTS gpReport_JuridicalDefermentPayment (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalDefermentPayment(
    IN inOperDate         TDateTime , -- 
    IN inEmptyParam       TDateTime , -- 
    IN inAccountId        Integer   , --
    IN inPaidKindId       Integer   , --
    IN inBranchId         Integer   , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (AccountName TVarChar, JuridicalId Integer, JuridicalName TVarChar, RetailName TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar
             , ContractTagName TVarChar, ContractStateKindCode Integer
             , PersonalName TVarChar
             , PersonalCollationName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , DebetRemains TFloat, KreditRemains TFloat
             , SaleSumm TFloat, DefermentPaymentRemains TFloat
             , SaleSumm1 TFloat, SaleSumm2 TFloat, SaleSumm3 TFloat, SaleSumm4 TFloat, SaleSumm5 TFloat
             , Condition TVarChar, StartContractDate TDateTime, Remains TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , AreaName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbLenght Integer;

   DECLARE vbObjectId_Constraint Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется уровень доступа
     vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0);
     -- !!!меняется параметр!!!
     IF vbObjectId_Constraint > 0 THEN inBranchId:= vbObjectId_Constraint; END IF;


     -- Выбираем остаток на дату по юр. лицам в разрезе договоров. 
     -- Так же выбираем продажи и возвраты за период 
      vbLenght := 7;


     -- Результат
     RETURN QUERY  
     SELECT a.AccountName, a.JuridicalId, a.JuridicalName, a.RetailName, a.OKPO, a.JuridicalGroupName
             , a.PartnerId, a.PartnerCode, a.PartnerName TVarChar
             , a.BranchId, a.BranchCode, a.BranchName
             , a.PaidKindId, a.PaidKindName
             , a.ContractId, a.ContractCode, a.ContractNumber
             , a.ContractTagName TVarChar, a.ContractStateKindCode
             , a.PersonalName
             , a.PersonalCollationName
             , a.StartDate, a.EndDate
             , a.DebetRemains, a.KreditRemains
             , a.SaleSumm, a.DefermentPaymentRemains
             , a.SaleSumm1, a.SaleSumm2, a.SaleSumm3, a.SaleSumm4, a.SaleSumm5
             , a.Condition, a.StartContractDate, a.Remains
             , a.InfoMoneyGroupName, a.InfoMoneyDestinationName, a.InfoMoneyCode, a.InfoMoneyName
             , a.AreaName
from (
  SELECT 
     Object_Account_View.AccountName_all AS AccountName
   , Object_Juridical.Id        AS JuridicalId
   , Object_Juridical.Valuedata AS JuridicalName
   , COALESCE (Object_Retail.ValueData, 'прочие') :: TVarChar AS RetailName
   , ObjectHistory_JuridicalDetails_View.OKPO
   , Object_JuridicalGroup.ValueData AS JuridicalGroupName
   , Object_Partner.Id          AS PartnerId
   , Object_Partner.ObjectCode  AS PartnerCode
   , Object_Partner.ValueData   AS PartnerName
   , Object_Branch.Id           AS BranchId
   , Object_Branch.ObjectCode   AS BranchCode
   , Object_Branch.ValueData    AS BranchName
   , Object_PaidKind.Id         AS PaidKindId
   , Object_PaidKind.ValueData  AS PaidKindName
   , View_Contract.ContractId
   , View_Contract.ContractCode
   , View_Contract.InvNumber AS ContractNumber
   , View_Contract.ContractTagName
   , View_Contract.ContractStateKindCode
   , Object_Personal_View.PersonalName      AS PersonalName
   , Object_PersonalCollation.PersonalName  AS PersonalCollationName
   , View_Contract.StartDate
   , View_Contract.EndDate

   , (CASE WHEN RESULT.Remains > 0 THEN RESULT.Remains ELSE 0 END)::TFloat AS DebetRemains
   , (CASE WHEN RESULT.Remains > 0 THEN 0 ELSE -1 * RESULT.Remains END)::TFloat AS KreditRemains
   , RESULT.SaleSumm :: TFloat AS SaleSumm

   , (CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > 0
                THEN RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm
           ELSE RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm -- 0
      END)::TFloat AS DefermentPaymentRemains

   , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > 0 AND RESULT.SaleSumm1 > 0)
                THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm) > RESULT.SaleSumm1
                          THEN RESULT.SaleSumm1
                          ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm)
                     END
           ELSE 0
      END)::TFloat AS SaleSumm1

   , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1) > 0 AND RESULT.SaleSumm2 > 0)
                THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1) > RESULT.SaleSumm2
                          THEN RESULT.SaleSumm2
                          ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1)
                     END
      ELSE 0 END)::TFloat AS SaleSumm2

   , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > 0 AND RESULT.SaleSumm3 > 0)
                THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2) > RESULT.SaleSumm3
                          THEN RESULT.SaleSumm3
                          ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2)
                     END
           ELSE 0
      END)::TFloat AS SaleSumm3

   , (CASE WHEN ((RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > 0 AND RESULT.SaleSumm4 > 0)
                THEN CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3) > RESULT.SaleSumm4
                          THEN RESULT.SaleSumm4
                          ELSE (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3)
                     END
            ELSE 0
      END)::TFloat AS SaleSumm4

   , (CASE WHEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4) > 0
                THEN (RESULT.Remains - RESULT.DelayCreditLimit - RESULT.SaleSumm - RESULT.SaleSumm1 - RESULT.SaleSumm2 - RESULT.SaleSumm3 - RESULT.SaleSumm4)
                ELSE 0
      END )::TFloat AS SaleSumm5

   , (RESULT.DayCount||' '|| CASE WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendar()
                                       THEN 'К.дн.'
                                  -- WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayCalendarSale()
                                  --      THEN 'К.Р.дн.'
                                  WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBank()
                                       THEN 'Б.дн.'
                                  -- WHEN RESULT.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayDayBankSale()
                                  --     THEN 'Б.Р.дн.'
                                  ELSE ''
                             END
                     ||' '|| CASE WHEN RESULT.DelayCreditLimit <> 0
                                       THEN '+ ' || TRIM (to_char (RESULT.DelayCreditLimit, '999 999 999 999 999D99')) || 'грн.'
                                  ELSE ''
                             END
      )::TVarChar AS Condition -- Object_ContractConditionKind.ValueData
   , RESULT.ContractDate::TDateTime AS StartContractDate
   , (-RESULT.Remains)::TFloat AS Remains

      , Object_InfoMoney_View.InfoMoneyGroupName
      , Object_InfoMoney_View.InfoMoneyDestinationName
      , Object_InfoMoney_View.InfoMoneyCode
      , Object_InfoMoney_View.InfoMoneyName

      , Object_Area.ValueData AS AreaName

  FROM (SELECT RESULT_all.AccountId
             , RESULT_all.ContractId
             , RESULT_all.JuridicalId 
             , SUM (RESULT_all.Remains)   AS Remains
             , SUM (RESULT_all.SaleSumm)  AS SaleSumm
             , SUM (RESULT_all.SaleSumm1) AS SaleSumm1
             , SUM (RESULT_all.SaleSumm2) AS SaleSumm2
             , SUM (RESULT_all.SaleSumm3) AS SaleSumm3
             , SUM (RESULT_all.SaleSumm4) AS SaleSumm4
             , RESULT_all.ContractConditionKindId
             , RESULT_all.DayCount
             , RESULT_all.DelayCreditLimit
             , RESULT_all.ContractDate
             , CLO_InfoMoney.ObjectId AS InfoMoneyId
             , CLO_PaidKind.ObjectId  AS PaidKindId
             , CLO_Partner.ObjectId   AS PartnerId
             , CLO_Branch.ObjectId    AS BranchId
        FROM
       (SELECT Container.Id
             , Container.ObjectId     AS AccountId
             , View_Contract_ContractKey.ContractId_Key AS ContractId -- CLO_Contract.ObjectId AS ContractId
             , CLO_Juridical.ObjectId AS JuridicalId 
             , Container.Amount - COALESCE(SUM (CASE WHEN MIContainer.OperDate >= inOperDate THEN MIContainer.Amount ELSE 0 END), 0) AS Remains
             , SUM (CASE WHEN (MIContainer.OperDate < inOperDate)                 AND (MIContainer.OperDate >= ContractDate)               AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut()) THEN MIContainer.Amount ELSE 0 END) AS SaleSumm
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate                AND MIContainer.OperDate >= ContractDate - vbLenght)     AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut()) THEN MIContainer.Amount ELSE 0 END) AS SaleSumm1
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - vbLenght     AND MIContainer.OperDate >= ContractDate - 2 * vbLenght) AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut()) THEN MIContainer.Amount ELSE 0 END) AS SaleSumm2
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 2 * vbLenght AND MIContainer.OperDate >= ContractDate - 3 * vbLenght) AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut()) THEN MIContainer.Amount ELSE 0 END) AS SaleSumm3
             , SUM (CASE WHEN (MIContainer.OperDate < ContractDate - 3 * vbLenght AND MIContainer.OperDate >= ContractDate - 4 * vbLenght) AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut()) THEN MIContainer.Amount ELSE 0 END) AS SaleSumm4
             , ContractCondition_DefermentPayment.ContractConditionKindId
             , COALESCE (ContractCondition_DefermentPayment.DayCount, 0) AS DayCount
             , COALESCE (ContractCondition_CreditLimit.DelayCreditLimit, 0) AS DelayCreditLimit
             , ContractCondition_DefermentPayment.ContractDate
         FROM ContainerLinkObject AS CLO_Juridical
              INNER JOIN Container ON Container.Id = CLO_Juridical.ContainerId AND Container.DescId = zc_Container_Summ()
              LEFT JOIN ContainerLinkObject AS CLO_Contract
                                            ON CLO_Contract.ContainerId = Container.Id
                                           AND CLO_Contract.DescId = zc_ContainerLinkObject_Contract()
              -- !!!Группируем Договора!!!
              LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey ON View_Contract_ContractKey.ContractId = CLO_Contract.ObjectId

              LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                              , zfCalc_DetermentPaymentDate (COALESCE (ContractConditionKindId, 0), Value::Integer, inOperDate) :: Date AS ContractDate
                              , ContractConditionKindId
                              , Value :: Integer AS DayCount
                           FROM Object_ContractCondition_View
                                INNER JOIN Object_ContractCondition_DefermentPaymentView 
                                        ON Object_ContractCondition_DefermentPaymentView.ConditionKindId = Object_ContractCondition_View.ContractConditionKindId
                           WHERE Object_ContractCondition_View.ContractConditionKindId IN (zc_Enum_ContractConditionKind_DelayDayCalendar(), zc_Enum_ContractConditionKind_DelayDayBank())
                             AND Value <> 0
                        ) AS ContractCondition_DefermentPayment
                          ON ContractCondition_DefermentPayment.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId

              LEFT JOIN (SELECT Object_ContractCondition_View.ContractId
                              , Value AS DelayCreditLimit
                         FROM Object_ContractCondition_View
                         WHERE Object_ContractCondition_View.ContractConditionKindId = zc_Enum_ContractConditionKind_DelayCreditLimit()
                        ) AS ContractCondition_CreditLimit
                          ON ContractCondition_CreditLimit.ContractId = View_Contract_ContractKey.ContractId_Key -- CLO_Contract.ObjectId
                              
              LEFT JOIN MovementItemContainer AS MIContainer 
                                              ON MIContainer.Containerid = Container.Id
                                             AND MIContainer.OperDate >= COALESCE (ContractCondition_DefermentPayment.ContractDate :: Date - 4 * vbLenght, inOperDate)
             LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
         WHERE CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
            AND (Container.ObjectId = inAccountId OR inAccountId = 0)
         GROUP BY Container.Id
                , Container.ObjectId
                , Container.Amount
                , View_Contract_ContractKey.ContractId_Key
                , CLO_Juridical.ObjectId  
                , ContractConditionKindId
                , DayCount
                , DelayCreditLimit
                , ContractDate
       ) AS RESULT_all

           LEFT JOIN ContainerLinkObject AS CLO_PaidKind
                                         ON CLO_PaidKind.ContainerId = RESULT_all.Id
                                        AND CLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
           LEFT JOIN ContainerLinkObject AS CLO_Branch
                                         ON CLO_Branch.ContainerId = RESULT_all.Id
                                        AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
           LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                         ON CLO_InfoMoney.ContainerId = RESULT_all.Id
                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
           LEFT JOIN ContainerLinkObject AS CLO_Partner
                                         ON CLO_Partner.ContainerId = RESULT_all.Id
                                        AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
         WHERE (CLO_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)
           AND (CLO_Branch.ObjectId = inBranchId OR inBranchId = 0)
         GROUP BY RESULT_all.AccountId
                , RESULT_all.ContractId
                , RESULT_all.JuridicalId 
                , RESULT_all.ContractConditionKindId
                , RESULT_all.DayCount
                , RESULT_all.DelayCreditLimit
                , RESULT_all.ContractDate
                , CLO_InfoMoney.ObjectId
                , CLO_PaidKind.ObjectId
                , CLO_Partner.ObjectId
                , CLO_Branch.ObjectId
       ) AS RESULT

       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = RESULT.JuridicalId
       LEFT JOIN Object_Account_View ON Object_Account_View.AccountId = RESULT.AccountId
       LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = RESULT.ContractId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                               ON ObjectLink_Contract_Personal.ObjectId = RESULT.ContractId
                              AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
           LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               

           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                ON ObjectLink_Contract_PersonalCollation.ObjectId = RESULT.ContractId
                               AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
           LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId        

           LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = RESULT.InfoMoneyId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                                ON ObjectLink_Contract_Area.ObjectId = RESULT.ContractId
                               AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_Area()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = RESULT.BranchId
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = RESULT.PaidKindId
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = RESULT.PartnerId

) as a
where a.DebetRemains <> 0 or a.KreditRemains <> 0
             or  a.SaleSumm <> 0 or a.DefermentPaymentRemains <> 0
             or  a.SaleSumm1 <> 0 or a.SaleSumm2 <> 0 or a.SaleSumm3 <> 0 or a.SaleSumm4 <> 0 or a.SaleSumm5 <> 0
             or  a.Remains <> 0 
    ;
    -- Конец. Добавили строковые данные. 
    -- КОНЕЦ ЗАПРОСА

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalDefermentPayment (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.09.14                                        * add Branch...
 24.08.14                                        * add Partner...
 11.07.14                                        * add RetailName
 05.07.14                                        * add zc_Movement_TransferDebtOut
 02.06.14                                        * change DefermentPaymentRemains
 20.05.14                                        * add Object_Contract_View
 12.05.14                                        * add RESULT.DelayCreditLimit
 05.05.14                                        * add inPaidKindId
 26.04.14                                        * add Object_Contract_ContractKey_View
 15.04.14                                        * add StartDate and EndDate
 10.04.14                                        * add AreaName
 09.04.14                                        * add !!!
 31.03.14                                        * add Object_Contract_View and Object_InfoMoney_View and ObjectHistory_JuridicalDetails_View and Object_PaidKind
 30.03.14                          * 
 06.02.14                          * 
*/

-- тест
-- SELECT * FROM gpReport_JuridicalDefermentPayment (inOperDate:= '01.06.2014', inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_FirstForm(),  inBranchId:= 0, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_JuridicalDefermentPayment (inOperDate:= '01.06.2014', inEmptyParam:= NULL :: TDateTime, inAccountId:= 0, inPaidKindId:= zc_Enum_PaidKind_SecondForm(), inBranchId:= 0, inSession:= zfCalc_UserAdmin());
