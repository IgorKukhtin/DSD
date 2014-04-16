-- FunctiON: gpReport_CheckBonus ()

DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_CheckBonus (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE ( ContractId Integer, InvNumber TVarChar , InvNumber_child TVarChar
              , ConditionKindName TVarChar
              , Value TFloat
              , BonusKindName TVarChar
              , InfoMoneyName TVarChar
              , PaidKindName TVarChar
              , JuridicalName TVarChar
              , Sum_CheckBonus TFloat
              , Sum_Bonus TFloat
              , Sum_BonusFact TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY
    -- формируется список договоров, у которых есть условие по "Бонусам"
    WITH tmpContractConditionKind AS (SELECT Object_Contract_View.JuridicalId
                                           , Object_Contract_View.ContractId AS ContractId_master
                                           , Object_Contract_View.InvNumber
                                           , Object_Contract_View.InfoMoneyId
                                           , CASE WHEN Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                       THEN zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                  WHEN Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                       THEN zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                  WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- Маркетинг
                                                       THEN 0
                                                  WHEN View_InfoMoney.InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- Доходы
                                                       THEN 0
                                                  ELSE COALESCE (Object_Contract_View.InfoMoneyId, 0)
                                             END AS InfoMoneyId_child
                                           , Object_Contract_View.PaidKindId
                                           , Object_ContractConditionKind.Id AS ContractConditionKindID
                                           , Object_ContractConditionKind.ValueData AS ContractConditionKindName
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId AS BonusKindId
                                           , COALESCE (ObjectFloat_Value.ValueData, 0) AS Value
                                      FROM Object AS Object_ContractConditionKind
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind 
                                                                ON ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = Object_ContractConditionKind.Id
                                                               AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                           LEFT JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId

                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                                ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                               AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                           LEFT JOIN Object_Contract_View AS Object_Contract_View ON Object_Contract_View.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = Object_Contract_View.InfoMoneyId

                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
                                           JOIN ObjectFloat AS ObjectFloat_Value 
                                                            ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                           AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                           AND ObjectFloat_Value.ValueData <> 0  
                                               
                                      WHERE Object_ContractConditionKind.Id IN (zc_Enum_ContractConditionKind_BonusPercentAccount(), zc_Enum_ContractConditionKind_BonusPercentSaleReturn(), zc_Enum_ContractConditionKind_BonusPercentSale())
                                        AND Object_ContractCondition.isErased = FALSE
                                        AND Object_Contract_View.isErased = FALSE
                                        AND (Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                          OR Object_Contract_View.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                 )
                                            )
                                    )
      -- для всех юр лиц, у кого есть "Бонусы" формируется список всех других договоров (по ним будем делать расчет "базы")
    , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.InvNumber AS InvNumber_master
                           , tmpContractConditionKind.ContractId_master AS ContractId_child
                           , tmpContractConditionKind.InvNumber AS InvNumber_child
                           , tmpContractConditionKind.InfoMoneyId
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.PaidKindId
                           , tmpContractConditionKind.ContractConditionKindID
                           , tmpContractConditionKind.ContractConditionKindName 
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                      FROM tmpContractConditionKind
                      WHERE tmpContractConditionKind.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child -- это будут не бонусные договора (но в них есть бонусы)
                    UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.InvNumber AS InvNumber_master
                           , Object_Contract_View.ContractId AS ContractId_child
                           , Object_Contract_View.InvNumber AS InvNumber_child
                           , tmpContractConditionKind.InfoMoneyId
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.PaidKindId
                           , tmpContractConditionKind.ContractConditionKindID
                           , tmpContractConditionKind.ContractConditionKindName 
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                      FROM tmpContractConditionKind
                           JOIN Object_Contract_View AS Object_Contract_View 
                                                     ON Object_Contract_View.JuridicalId = tmpContractConditionKind.JuridicalId
                                                    AND Object_Contract_View.InfoMoneyId =  tmpContractConditionKind.InfoMoneyId_child
                      WHERE tmpContractConditionKind.InfoMoneyId <> tmpContractConditionKind.InfoMoneyId_child -- это будут бонусные договора
                     )
        
      -- группируем договора, т.к. "базу" будем формировать по 4-м ключам
    ,tmpContractGroup AS (SELECT JuridicalId
                               , ContractId_child
                               , InfoMoneyId_child
                               , PaidKindId
                           FROM tmpContract
                           GROUP BY JuridicalId
                                  , ContractId_child
                                  , InfoMoneyId_child
                                  , PaidKindId
                          )
                          
      -- список ContractId по которым будет расчет "базы"
    , tmpContainer AS (SELECT Container.Id AS ContainerId
                            , tmpContractGroup.JuridicalId 
                            , tmpContractGroup.ContractId_child
                            , tmpContractGroup.InfoMoneyId_child
                            , tmpContractGroup.PaidKindId
                       FROM Container
                            JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = Container.Id
                                                                             AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                            JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = Container.Id
                                                                            AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract() 
                            JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                                             AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()                               
                            JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = Container.Id
                                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()                               
                            -- ограничение по 4-м ключам
                            JOIN tmpContractGroup ON tmpContractGroup.JuridicalId       = ContainerLO_Juridical.ObjectId
                                                 AND tmpContractGroup.ContractId_child  = ContainerLO_Contract.ObjectId
                                                 AND tmpContractGroup.InfoMoneyId_child = ContainerLO_InfoMoney.ObjectId
                                                 AND tmpContractGroup.PaidKindId        = ContainerLO_PaidKind.ObjectId
                       -- WHERE Container.ObjectId <> zc_Enum_Account_50401() -- "Маркетинг"
                       --   AND Container.ObjectId <> zc_Enum_AccountDirection_70300() нужно убрать проводки по оплате маркетинга
                       )

      , tmpMovement AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.ContractId_child 
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId
                             , SUM (tmpGroup.Sum_Sale) AS Sum_Sale
                             , SUM (tmpGroup.Sum_SaleReturnIn) AS Sum_SaleReturnIn
                             , SUM (tmpGroup.Sum_Account) AS Sum_Account
                        FROM (SELECT tmpContainer.JuridicalId
                                   , tmpContainer.ContractId_child
                                   , tmpContainer.InfoMoneyId_child
                                   , tmpContainer.PaidKindId
                                   , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS Sum_Sale -- Только продажи
                                   , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIContainer.Amount ELSE 0 END) AS Sum_SaleReturnIn -- продажи - возвраты
                                   , SUM (CASE WHEN Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                                    THEN -1 * MIContainer.Amount
                                               ELSE 0
                                          END) AS Sum_Account -- оплаты
                              FROM tmpContainer
                                   JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                             AND MIContainer.DescId = zc_MIContainer_Summ()
                                                             AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                   JOIN Movement ON Movement.Id = MIContainer.MovementId
                                                AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(),zc_Movement_Cash(), zc_Movement_SendDebt()) 
                              GROUP BY tmpContainer.JuridicalId
                                     , tmpContainer.ContractId_child
                                     , tmpContainer.InfoMoneyId_child
                                     , tmpContainer.PaidKindId
                             ) AS tmpGroup
                        GROUP BY tmpGroup.JuridicalId
                               , tmpGroup.ContractId_child
                               , tmpGroup.InfoMoneyId_child
                               , tmpGroup.PaidKindId
                       )


      SELECT  View_Contract_InvNumber.ContractId               AS ContractId            
            , View_Contract_InvNumber.InvNumber                AS InvNumber
            , View_Contract_2.InvNumber                        AS InvNumber_child
            , Object_ContractConditionKind.ValueData           AS ConditionKindName
            --, CAST (max(tmpAll.value) AS Tfloat)               AS Value
            , CAST (tmpAll.value AS Tfloat)                    AS Value
            , Object_BonusKind.ValueData                       AS BonusKindName
            , Object_InfoMoney_View.InfoMoneyName              AS InfoMoneyName
            , Object_PaidKind.ValueData                        AS PaidKindName
            , Object_Juridical.ValueData                       AS JuridicalName
            , CAST ( (tmpAll.Sum_CheckBonus) AS Tfloat)     AS Sum_CheckBonus
            , CAST ( (tmpAll.Sum_Bonus) AS Tfloat)          AS Sum_Bonus
            , CAST ( (tmpAll.Sum_BonusFact)*(-1) AS Tfloat) AS Sum_BonusFact
      FROM  
          (SELECT tmpContract.ContractId_master
                , tmpContract.ContractId_child 
                , tmpContract.JuridicalId AS JuridicalId
                , tmpContract.ContractConditionKindId
                , tmpContract.Value
                , tmpContract.BonusKindId
                , tmpContract.InfoMoneyId
                , tmpMovement.PaidKindId AS PaidKindId
                , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale() THEN tmpMovement.Sum_Sale 
                             WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN tmpMovement.Sum_SaleReturnIn
                             WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN tmpMovement.Sum_Account
                        ELSE 0 END  AS Tfloat) AS Sum_CheckBonus
                , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale() THEN (tmpMovement.Sum_Sale/100 * tmpContract.Value)
                             WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN (tmpMovement.Sum_SaleReturnIn/100 * tmpContract.Value) 
                             WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN (tmpMovement.Sum_Account/100 * tmpContract.Value)
                        ELSE 0 END  AS Tfloat) AS Sum_Bonus
                , 0::TFloat AS Sum_BonusFact
              
           FROM tmpContract
                JOIN tmpMovement ON tmpMovement.JuridicalId       = tmpContract.JuridicalId
                                AND tmpMovement.ContractId_child  = tmpContract.ContractId_child
                                AND tmpMovement.InfoMoneyId_child = tmpContract.InfoMoneyId_child
                                AND tmpMovement.PaidKindId        = tmpContract.PaidKindId
         UNION  ALL 

           SELECT MILinkObject_Contract.ObjectId                 AS ContractId_master  
                , MILinkObject_Contract.ObjectId                 AS ContractId_child            
                , MovementItem.ObjectId                          AS JuridicalId
                , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                , 0                                              AS Value
                , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                , MILinkObject_InfoMoney.ObjectId                AS InfoMoneyId
                , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                , 0::Tfloat                                      AS Sum_CheckBonus
                , 0::Tfloat                                      AS Sum_Bonus
                , MovementItem.Amount                            AS Sum_BonusFact
           FROM Movement 
                LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                 ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                 ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                 ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()
           
           WHERE Movement.DescId = zc_Movement_ProfitLossService()
             AND Movement.StatusId = zc_Enum_Status_Complete()
             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
             AND MILinkObject_ContractConditionKind.ObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount(), zc_Enum_ContractConditionKind_BonusPercentSaleReturn(), zc_Enum_ContractConditionKind_BonusPercentSale())
          ) AS tmpAll
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpAll.InfoMoneyId 
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpAll.JuridicalId 
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpAll.PaidKindId
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpAll.BonusKindId
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpAll.ContractConditionKindId
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = tmpAll.ContractId_master  
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_2 ON View_Contract_2.ContractId = tmpAll.ContractId_child    
      /*GROUP BY  View_Contract_InvNumber.ContractId                    
              , View_Contract_InvNumber.InvNumber   
              , View_Contract_2.InvNumber           
              , tmpAll.JuridicalId                        
              , Object_Juridical.ValueData                     
              , tmpAll.ContractConditionKindId                
              , Object_ContractConditionKind.ValueData      
              , tmpAll.BonusKindId                           
              , Object_BonusKind.ValueData                    
              , Object_InfoMoney_View.InfoMoneyId                
              , Object_InfoMoney_View.InfoMoneyName          
              , Object_PaidKind.ValueData 
              , tmpAll.value*/                 ---
      ORDER BY 9                    
 ;

            
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckBonus (TDateTime, TDateTime, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.14                                        * all
 10.04.14         *
*/

-- тест
-- select * from gpReport_CheckBonus (inStartDate:= '03.01.2014', inEndDate:= '31.03.2014', inSession:= '5');
-- select * from gpReport_CheckBonus (inStartDate:= '01.01.2014', inEndDate:= '31.01.2014', inSession:= '5');

