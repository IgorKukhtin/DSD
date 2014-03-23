-- FunctiON: gpReport_CheckBonus ()

DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckBonus (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    --IN inDocumentTaxKindID   Integer ,
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE ( ContractId Integer, Contract_InvNumber TVarChar
              , ContractConditionKindName TVarChar
              , Value TFloat
              , BonusKindName TVarChar
              , InfoMoneyName TVarChar
              , PaidKindName TVarChar
              , JuridicalName TVarChar
              , Sum_Sale TFloat--, Sum_SaleBonus TFloat
              , Sum_SaleReturnIn TFloat--, Sum_SaleReturnInBonus TFloat
              , Sum_Account TFloat--, Sum_AccountBonus TFloat
              , Sum_Bonus TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY

     WITH tmpContract AS (SELECT Object_Contract_View.JuridicalId
                               , Object_Contract_View.ContractId
                               , Object_Contract_View.invnumber
                               , Object_Contract_View.InfoMoneyId
                               , Object_Contract_View.PaidKindId
                               , Object_ContractConditionKind.Id AS ContractConditionKindID
                               , Object_ContractConditionKind.ValueData AS ContractConditionKindName 
                               , ObjectLink_ContractCondition_BonusKind.ChildObjectId AS BonusKindId
                               , ObjectFloat_Value.ValueData AS Value
    
                          FROM Object AS Object_ContractConditionKind
                               LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind 
                                                    ON ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = Object_ContractConditionKind.Id
                                                   AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                               --LEFT JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                    ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                   AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                               LEFT JOIN Object_Contract_View AS Object_Contract_View ON Object_Contract_View.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                    ON ObjectLink_ContractCondition_BonusKind.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                   AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
                               --LEFT JOIN Object AS Object_Bonus ON Object_Bonus.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId

                               LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                                     ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                 
                          WHERE Object_ContractConditionKind.Id in (zc_Enum_ContractConditionKind_BonusPercentAccount(), zc_Enum_ContractConditionKind_BonusPercentSaleReturn(), zc_Enum_ContractConditionKind_BonusPercentSale())
                          ORDER BY Object_Contract_View.invnumber
                          )
       , tmpContractGroup AS (SELECT tmpContract.JuridicalId
                                   , tmpContract.ContractId
                                   , tmpContract.InfoMoneyId
                                   , tmpContract.ContractConditionKindID
                                   , tmpContract.PaidKindId
                              FROM tmpContract
                              GROUP BY tmpContract.JuridicalId
                                     , tmpContract.ContractId
                                     , tmpContract.InfoMoneyId
                                     , tmpContract.ContractConditionKindID
                                     , tmpContract.PaidKindId
                              )
       , tmpContainer AS (SELECT Container.Id AS ContainerId
                               , tmpContractGroup.JuridicalId 
                               , tmpContractGroup.ContractId
                               , tmpContractGroup.InfoMoneyId
                               , tmpContractGroup.PaidKindId
                          FROM Container--tmpContractGroup
                               JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = Container.Id --ObjectId = tmpContractGroup.JuridicalId
                                                                                AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                                JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = Container.Id --ObjectId = tmpContractGroup.ContractId
                                                                                AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract() 
                                                                                AND ContainerLO_Contract.ContainerId = ContainerLO_Juridical.ContainerId 
                                JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = Container.Id --ObjectId = tmpContractGroup.InfoMoneyId
                                                                                 AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()                               
                                                                                 AND ContainerLO_InfoMoney.ContainerId = ContainerLO_Juridical.ContainerId 
                                JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = Container.Id --ObjectId = tmpContractGroup.PaidKindId
                                                                                AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()                               
                                                                                AND ContainerLO_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId 
                                JOIN tmpContractGroup ON tmpContractGroup.JuridicalId = ContainerLO_Juridical.ObjectId
                                                     AND tmpContractGroup.ContractId = ContainerLO_Contract.ObjectId
                                                     AND tmpContractGroup.InfoMoneyId = ContainerLO_InfoMoney.ObjectId
                                                     AND tmpContractGroup.PaidKindId = ContainerLO_PaidKind.ObjectId
                            WHERE Container.ObjectId <> zc_Enum_Account_50401()
                             -- AND Container.ObjectId <> zc_Enum_AccountDirection_70300() нужно убрать проводки по оплате маркетинга
                            )
                            
        , tmpMovement AS (SELECT tmpGroup.JuridicalId
                               , tmpGroup.ContractId
                               , tmpGroup.InfoMoneyId
                               , tmpGroup.PaidKindId
                               --, tmpGroup.invnumber
                               , SUM(tmpGroup.Sum_Sale) AS Sum_Sale
                               , SUM(tmpGroup.Sum_SaleReturnIn) AS Sum_SaleReturnIn
                               , SUM(tmpGroup.Sum_Account) AS Sum_Account
                          FROM (SELECT tmpContainer.JuridicalId
                                     , tmpContainer.ContractId
                                     , tmpContainer.InfoMoneyId
                                     , tmpContainer.PaidKindId
                                     , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN SUM(MIContainer.Amount) ELSE 0 END AS Sum_Sale
                                     , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN SUM(MIContainer.Amount) WHEN Movement.DescId = zc_Movement_ReturnIn() THEN SUM(MIContainer.Amount) ELSE 0 END AS Sum_SaleReturnIn
                                     , CASE WHEN ((Movement.DescId = zc_Movement_BankAccount() OR Movement.DescId = zc_Movement_Cash()) AND tmpContainer.InfoMoneyId = zc_Enum_InfoMoney_30101()) THEN SUM(MIContainer.Amount*(-1)) ELSE 0 END AS Sum_Account
                                     , Movement.DescId as MovementDescId
                               --      , Movement.invnumber
                                   FROM tmpContainer
                                        JOIN MovementItemContainer AS MIContainer 
                                                                   ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                  AND MIContainer.DescId = zc_MIContainer_Summ()
                                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                        JOIN Movement ON Movement.Id = MIContainer.MovementId
                                                     AND Movement.DescId in (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(),zc_Movement_Cash()) 
                                   GROUP BY tmpContainer.JuridicalId
                                          , tmpContainer.ContractId
                                          , tmpContainer.InfoMoneyId
                                          , tmpContainer.PaidKindId
                                          , Movement.DescId
                                          , Movement.invnumber) AS tmpGroup
                            GROUP BY tmpGroup.JuridicalId
                                   , tmpGroup.ContractId
                                   , tmpGroup.InfoMoneyId
                                   , tmpGroup.PaidKindId
                                 --  , tmpGroup.invnumber
                            )

         SELECT tmpContract.ContractId
              , tmpContract.invnumber
              , tmpContract.ContractConditionKindName
              , tmpContract.Value
              , Object_BonusKind.ValueData AS BonusKindName
              , Object_InfoMoney.ValueData AS InfoMoneyName
              , Object_PaidKind.ValueData AS PaidKindName
              , Object_Juridical.ValueData AS JuridicalName
              , CAST (tmpMovement.Sum_Sale AS Tfloat) AS Sum_Sale
              , CAST (tmpMovement.Sum_SaleReturnIn AS Tfloat) AS Sum_SaleReturnIn
              , CAST (tmpMovement.Sum_Account AS Tfloat) AS Sum_Account

              , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN tmpMovement.Sum_Sale/100 * tmpContract.Value 
                           WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN (tmpMovement.Sum_SaleReturnIn/100 * tmpContract.Value) 
                           WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN (tmpMovement.Sum_Account/100 * tmpContract.Value)
                      ELSE 0 END  AS Tfloat) AS Sum_Bonus
         FROM tmpContract
               JOIN tmpMovement ON tmpContract.JuridicalId = tmpMovement.JuridicalId
                                   AND tmpContract.ContractId = tmpMovement.ContractId
                                   AND tmpContract.InfoMoneyId = tmpMovement.InfoMoneyId
                                   AND tmpContract.PaidKindId = tmpMovement.PaidKindId
               LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpContract.InfoMoneyId 
               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpContract.JuridicalId 
               LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpContract.PaidKindId
               LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpContract.BonusKindId
         --WHERE Object_Juridical.Id=15594
         ORDER BY Object_Juridical.ValueData, tmpContract.invnumber


 ;
            
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckBonus (TDateTime, TDateTime, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.14         *

                
*/

-- тест
--SELECT * FROM gpReport_CheckBonus (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013', inSessiON:= zfCalc_UserAdmin());