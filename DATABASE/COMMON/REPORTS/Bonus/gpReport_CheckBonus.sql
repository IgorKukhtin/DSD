-- FunctiON: gpReport_CheckBonus ()

DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckBonus (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inSessiON             TVarChar    -- ������ ������������
)
RETURNS TABLE (ContractId_master Integer, ContractId_find Integer, InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , ContractTagName_child TVarChar, ContractStateKindCode_child Integer
             , InfoMoneyId_master Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , Value TFloat
             , Sum_CheckBonus TFloat
             , Sum_Bonus TFloat
             , Sum_BonusFact TFloat
              )  
AS
$BODY$
BEGIN

    RETURN QUERY
    -- ����������� ������ ���������, � ������� ���� ������� �� "�������"
    WITH tmpContractConditionKind AS (SELECT ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId AS ContractConditionKindID
                                           , View_Contract.JuridicalId
                                           , View_Contract.InvNumber   AS InvNumber_master
                                           , View_Contract.ContractTagId         AS ContractTagId_master
                                           , View_Contract.ContractTagName       AS ContractTagName_master
                                           , View_Contract.ContractStateKindCode AS ContractStateKindCode_master
                                           , View_Contract.ContractId  AS ContractId_master
                                           , View_Contract.InfoMoneyId AS InfoMoneyId_master
                                           , CASE WHEN View_Contract.InfoMoneyId = zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                                       THEN zc_Enum_InfoMoney_30101() -- ������� ���������
                                                  WHEN View_Contract.InfoMoneyId = zc_Enum_InfoMoney_21502() -- ��������� + ������ �� ������ �����
                                                       THEN zc_Enum_InfoMoney_30201() -- ������ �����
                                                  WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ���������
                                                       THEN 0
                                                  WHEN View_InfoMoney.InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- ������
                                                       THEN 0
                                                  ELSE COALESCE (View_Contract.InfoMoneyId, 0)
                                             END AS InfoMoneyId_child
                                           , COALESCE (ObjectLink_ContractCondition_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_Condition
                                           , View_Contract.PaidKindId
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId AS BonusKindId
                                           , COALESCE (ObjecTFloat_Value.ValueData, 0) AS Value
                                      FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                           INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                                        AND Object_ContractCondition.isErased = FALSE
                                           INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                                ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                           INNER JOIN Object_Contract_View AS View_Contract
                                                                           ON View_Contract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                                          AND View_Contract.isErased = FALSE
                                                                          AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                                            OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                                                           , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                                                            )
                                                                              )
                                           INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                                                  ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id
                                                                 AND ObjectFloat_Value.DescId = zc_ObjecTFloat_ContractCondition_Value()
                                                                 AND ObjectFloat_Value.ValueData <> 0  
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                                                                ON ObjectLink_ContractCondition_InfoMoney.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_InfoMoney.DescId = zc_ObjectLink_ContractCondition_InfoMoney()
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId
                                      WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                               , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                               , zc_Enum_ContractConditionKind_BonusPercentSale())
                                        AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                     )
      -- ��� ��������� (���� !!!��������� ��-������ ��� �������!!!) ���� ����� �������� ������� (�� 4-� ������ + ����� � "���� ������� ���������")
    , tmpContractBonus AS (SELECT tmpContract_find.ContractId_master
                                , tmpContract_find.ContractId_find
                                , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
                                , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
                           FROM (SELECT tmpContractConditionKind.ContractId_master
                                      , MAX (COALESCE (View_Contract_find_tag.ContractId, View_Contract_find.ContractId)) AS ContractId_find
                                 FROM tmpContractConditionKind
                                      INNER JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                            ON ObjectLink_ContractCondition_BonusKind.ChildObjectId = tmpContractConditionKind.BonusKindId
                                                           AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
                                      INNER JOIN ObjecTFloat AS ObjecTFloat_Value 
                                                             ON ObjecTFloat_Value.ObjectId = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                            AND ObjecTFloat_Value.DescId = zc_ObjecTFloat_ContractCondition_Value()
                                                            AND ObjecTFloat_Value.ValueData = tmpContractConditionKind.Value
                                      INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                            ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                           AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                      LEFT JOIN Object_Contract_View AS View_Contract_find_tag
                                                                     ON View_Contract_find_tag.JuridicalId = tmpContractConditionKind.JuridicalId
                                                                    AND View_Contract_find_tag.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_Condition
                                                                    AND View_Contract_find_tag.ContractTagId = tmpContractConditionKind.ContractTagId_master
                                      LEFT JOIN Object_Contract_View AS View_Contract_find
                                                                     ON View_Contract_find.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                                    AND View_Contract_find.JuridicalId = tmpContractConditionKind.JuridicalId
                                                                    AND View_Contract_find.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_Condition
                                                                    AND View_Contract_find_tag.ContractId IS NULL
                                      LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                                           ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                          AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                 WHERE tmpContractConditionKind.InfoMoneyId_Condition <> 0
                                   AND COALESCE (ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId, 0) = 0
                                 GROUP BY tmpContractConditionKind.ContractId_master
                                ) AS tmpContract_find
                                LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = tmpContract_find.ContractId_find
                           WHERE tmpContract_find.ContractId_find <> 0
                          )
      -- ��� ���� �� ���, � ���� ���� "������" ����������� ������ ���� ������ ��������� (�� ��� ����� ������ ������ "����")
    , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , tmpContractConditionKind.InvNumber_master  AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.ContractId_master AS ContractId_child
                           , tmpContractConditionKind.ContractTagName_master       AS ContractTagName_child
                           , tmpContractConditionKind.ContractStateKindCode_master AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                           , tmpContractConditionKind.PaidKindId
                           , tmpContractConditionKind.ContractConditionKindID
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                      FROM tmpContractConditionKind
                      WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child -- ��� ����� �� �������� �������� (�� � ��� ���� ������)
                    UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , View_Contract_child.InvNumber  AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , View_Contract_child.ContractId AS ContractId_child
                           , View_Contract_child.ContractTagName       AS ContractTagName_child
                           , View_Contract_child.ContractStateKindCode AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                           , tmpContractConditionKind.PaidKindId
                           , tmpContractConditionKind.ContractConditionKindID
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                      FROM tmpContractConditionKind
                           JOIN Object_Contract_View AS View_Contract_child
                                                     ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                    AND View_Contract_child.InfoMoneyId =  tmpContractConditionKind.InfoMoneyId_child
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child -- ��� ����� �������� ��������
                     )
        
      -- ���������� ��������, �.�. "����" ����� ����������� �� 4-� ������
    ,tmpContractGroup AS (SELECT tmpContract.JuridicalId
                               , tmpContract.ContractId_child
                               , tmpContract.InfoMoneyId_child
                               , tmpContract.PaidKindId
                           FROM tmpContract
                           GROUP BY tmpContract.JuridicalId
                                  , tmpContract.ContractId_child
                                  , tmpContract.InfoMoneyId_child
                                  , tmpContract.PaidKindId
                          )
                          
      -- ������ ContractId �� ������� ����� ������ "����"
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
                            -- ����������� �� 4-� ������
                            JOIN tmpContractGroup ON tmpContractGroup.JuridicalId       = ContainerLO_Juridical.ObjectId
                                                 AND tmpContractGroup.ContractId_child  = ContainerLO_Contract.ObjectId
                                                 AND tmpContractGroup.InfoMoneyId_child = ContainerLO_InfoMoney.ObjectId
                                                 AND tmpContractGroup.PaidKindId        = ContainerLO_PaidKind.ObjectId
                       WHERE Container.ObjectId NOT IN (SELECT AccountId FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_110000()) -- �������
                       -- WHERE Container.ObjectId <> zc_Enum_Account_50401() -- "���������"
                       --   AND Container.ObjectId <> zc_Enum_AccountDirection_70300() ����� ������ �������� �� ������ ����������
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
                                   , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS Sum_Sale -- ������ �������
                                   , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIContainer.Amount ELSE 0 END) AS Sum_SaleReturnIn -- ������� - ��������
                                   , SUM (CASE WHEN Movement.DescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                                    THEN -1 * MIContainer.Amount
                                               ELSE 0
                                          END) AS Sum_Account -- ������
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


      SELECT  tmpAll.ContractId_master
            , tmpAll.ContractId_find
            , tmpAll.InvNumber_master
            , tmpAll.InvNumber_child
            , tmpAll.InvNumber_find

            , tmpAll.ContractTagName_child
            , tmpAll.ContractStateKindCode_child

            , Object_InfoMoney_master.Id                    AS InfoMoneyId_master
            , Object_InfoMoney_find.Id                      AS InfoMoneyId_find

            , Object_InfoMoney_master.ValueData             AS InfoMoneyName_master
            , Object_InfoMoney_child.ValueData              AS InfoMoneyName_child
            , Object_InfoMoney_find.ValueData               AS InfoMoneyName_find

            , Object_Juridical.Id                           AS JuridicalId
            , Object_Juridical.ValueData                    AS JuridicalName

            , Object_PaidKind.Id                            AS PaidKindId
            , Object_PaidKind.ValueData                     AS PaidKindName

            , Object_ContractConditionKind.Id               AS ConditionKindId
            , Object_ContractConditionKind.ValueData        AS ConditionKindName

            , Object_BonusKind.Id                           AS BonusKindId
            , Object_BonusKind.ValueData                    AS BonusKindName

            , CAST (tmpAll.Value AS TFloat)                 AS Value

            , CAST ( (tmpAll.Sum_CheckBonus) AS TFloat)     AS Sum_CheckBonus
            , CAST ( (tmpAll.Sum_Bonus) AS TFloat)          AS Sum_Bonus
            , CAST ( (tmpAll.Sum_BonusFact)*(-1) AS TFloat) AS Sum_BonusFact
      FROM  
          (SELECT tmpContract.InvNumber_master
                , tmpContract.InvNumber_child
                , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                            THEN tmpContractBonus.InvNumber_find
                       ELSE tmpContract.InvNumber_master
                  END AS InvNumber_find

                , tmpContract.ContractTagName_child
                , tmpContract.ContractStateKindCode_child

                , tmpContract.ContractId_master
                , tmpContract.ContractId_child 
                , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                            THEN tmpContractBonus.ContractId_find
                       ELSE tmpContract.ContractId_master
                  END AS ContractId_find

                , tmpContract.InfoMoneyId_master
                , tmpContract.InfoMoneyId_child 
                , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                            THEN tmpContractBonus.InfoMoneyId_find
                       WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30101() -- ������� ���������
                            THEN zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                       WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30201() -- ������ �����
                            THEN zc_Enum_InfoMoney_21502() -- ��������� + ������ �� ������ �����
                       ELSE tmpContract.InfoMoneyId_master
                  END AS InfoMoneyId_find

                , tmpContract.JuridicalId AS JuridicalId
                , tmpMovement.PaidKindId AS PaidKindId
                , tmpContract.ContractConditionKindId
                , tmpContract.BonusKindId
                , tmpContract.Value

                , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale() THEN tmpMovement.Sum_Sale 
                             WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN tmpMovement.Sum_SaleReturnIn
                             WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN tmpMovement.Sum_Account
                        ELSE 0 END  AS TFloat) AS Sum_CheckBonus
                , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale() THEN (tmpMovement.Sum_Sale/100 * tmpContract.Value)
                             WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN (tmpMovement.Sum_SaleReturnIn/100 * tmpContract.Value) 
                             WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN (tmpMovement.Sum_Account/100 * tmpContract.Value)
                        ELSE 0 END  AS TFloat) AS Sum_Bonus
                , 0 :: TFloat                  AS Sum_BonusFact
              
           FROM tmpContract
                INNER JOIN tmpMovement ON tmpMovement.JuridicalId       = tmpContract.JuridicalId
                                      AND tmpMovement.ContractId_child  = tmpContract.ContractId_child
                                      AND tmpMovement.InfoMoneyId_child = tmpContract.InfoMoneyId_child
                                      AND tmpMovement.PaidKindId        = tmpContract.PaidKindId
                LEFT JOIN tmpContractBonus ON tmpContractBonus.ContractId_master = tmpContract.ContractId_master

         UNION ALL 
           SELECT '' :: TVarChar AS InvNumber_master
                , '' :: TVarChar AS InvNumber_child
                , View_Contract_InvNumber_find.InvNumber AS InvNumber_find

                , '' :: TVarChar                                 AS ContractTagName_child
                , 0                                              AS ContractStateKindCode_child

                , 0                                              AS ContractId_master  
                , 0                                              AS ContractId_child            
                , MILinkObject_Contract.ObjectId                 AS ContractId_find

                , 0                                              AS InfoMoneyId_master  
                , 0                                              AS InfoMoneyId_child            
                , MILinkObject_InfoMoney.ObjectId                AS InfoMoneyId_find

                , MovementItem.ObjectId                          AS JuridicalId
                , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                , 0                                              AS Value

                , 0 :: TFloat                                    AS Sum_CheckBonus
                , 0 :: TFloat                                    AS Sum_Bonus
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
                LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = MILinkObject_Contract.ObjectId
           
           WHERE Movement.DescId = zc_Movement_ProfitLossService()
             AND Movement.StatusId = zc_Enum_Status_Complete()
             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
             AND MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                                   , zc_Enum_InfoMoney_21502()) -- ��������� + ������ �� ������ �����
             -- AND MILinkObject_ContractConditionKind.ObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount(), zc_Enum_ContractConditionKind_BonusPercentSaleReturn(), zc_Enum_ContractConditionKind_BonusPercentSale())
          ) AS tmpAll

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpAll.JuridicalId 
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpAll.PaidKindId
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpAll.BonusKindId
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpAll.ContractConditionKindId

            LEFT JOIN Object AS Object_InfoMoney_master ON Object_InfoMoney_master.Id = tmpAll.InfoMoneyId_master
            LEFT JOIN Object AS Object_InfoMoney_child ON Object_InfoMoney_child.Id = tmpAll.InfoMoneyId_child
            LEFT JOIN Object AS Object_InfoMoney_find ON Object_InfoMoney_find.Id = tmpAll.InfoMoneyId_find

      WHERE tmpAll.Sum_CheckBonus > 0
         OR tmpAll.Sum_Bonus > 0
         OR tmpAll.Sum_BonusFact <> 0
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
              , tmpAll.value*/
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_CheckBonus (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.14                                        * add View_Contract_find_tag
 08.05.14                                        * add <> 0
 01.05.14         * 
 26.04.14                                        * add ContractTagName_child and ContractStateKindCode_child
 17.04.14                                        * all
 10.04.14         *
*/
/*
     -- ������� - !!!��� �����������!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;
     -- 5.1. ������� - ��������
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- 5.2. ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat
                               , MovementItemId Integer, ContainerId Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer, JuridicalId_Basis Integer
                               , UnitId Integer, BranchId Integer, ContractId Integer, PaidKindId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
   select lpInsertUpdate_Movement_ProfitLossService (ioId              := 0
                                                    , inInvNumber       := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                    , inOperDate        := '30.04.2014'
                                                    , inAmountIn        := 0
                                                    , inAmountOut       := Sum_Bonus
                                                    , inComment         := ''
                                                    , inContractId      := ContractId_find
                                                    , inInfoMoneyId     := InfoMoneyId_find
                                                    , inJuridicalId     := JuridicalId
                                                    , inPaidKindId      := zc_Enum_PaidKind_FirstForm()
                                                    , inUnitId          := 0
                                                    , inContractConditionKindId   := ConditionKindId
                                                    , inBonusKindId     := BonusKindId
                                                    , inisLoad          := TRUE
                                                    , inUserId          := zfCalc_UserAdmin() :: Integer
                                                     )
   from gpReport_CheckBonus (inStartDate:= '01.04.2014', inEndDate:= '30.04.2014', inSession:= '5') as a
   where Sum_Bonus > 0 and Sum_Bonus =30
*/
-- ����
-- select * from gpReport_CheckBonus (inStartDate:= '03.01.2014', inEndDate:= '31.03.2014', inSession:= zfCalc_UserAdmin());
