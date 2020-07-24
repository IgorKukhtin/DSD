-- FunctiON: gpReport_CheckBonus_Income ()

DROP FUNCTION IF EXISTS gpReport_CheckBonus_Income (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckBonus_Income (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inPaidKindID          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   , 
    IN inSessiON             TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate_Movement TDateTime, InvNumber_Movement TVarChar, DescName_Movement TVarChar
             , ContractId_master Integer, ContractId_child Integer, ContractId_find Integer, InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , ContractTagName_child TVarChar, ContractStateKindCode_child Integer
             , InfoMoneyId_master Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PaidKindName_Child TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , RetailName TVarChar
             , PersonalCode Integer, PersonalName TVarChar
             , PartnerName TVarChar
             , Value TFloat
             , PercentRetBonus TFloat
             , PercentRetBonus_fact TFloat
             , Sum_CheckBonus TFloat
             , Sum_CheckBonusFact TFloat 
             , Sum_Bonus TFloat
             , Sum_BonusFact TFloat
             , Sum_IncomeFact TFloat
             , Sum_Account TFloat
             , Sum_IncomeReturnIn TFloat
             , Comment TVarChar
              )  
AS
$BODY$
   DECLARE inisMovement  Boolean ; -- �� ����������
BEGIN

   inisMovement:= FALSE;

   -- ��������� �������
   --����������
   CREATE TEMP TABLE tmpJuridical ON COMMIT DROP AS (SELECT ObjectLink_Juridical_JuridicalGroup.ObjectId AS JuridicalId
                                                     FROM ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                     WHERE ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                                                         AND ObjectLink_Juridical_JuridicalGroup.ChildObjectId = 8357
                                                     );

   CREATE TEMP TABLE tmpContract_full ON COMMIT DROP AS (SELECT View_Contract.*
                                                         FROM Object_Contract_View AS View_Contract
                                                            --������ ����������
                                                            INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = View_Contract.JuridicalId
                                                         WHERE (View_Contract.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                                         );
   CREATE TEMP TABLE tmpContract_all ON COMMIT DROP AS (SELECT *
                                                        FROM tmpContract_full
                                                        WHERE tmpContract_full.PaidKindId = inPaidKindId OR COALESCE (inPaidKindId, 0)  = 0
                                                       );
   -- ��� �������� - �� �������� ��� ��� ����
   CREATE TEMP TABLE tmpContract_find ON COMMIT DROP AS (SELECT View_Contract.*
                                                         FROM tmpContract_full AS View_Contract
                                                         WHERE View_Contract.isErased = FALSE
                                                           AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                             OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                                            , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                                             )
                                                               )
                                                        );

   CREATE TEMP TABLE tmpContractPartner ON COMMIT DROP AS (
           WITH
           -- ����������� ContractPartner
           tmp1 AS (SELECT ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
                         , ObjectLink_ContractPartner_Partner.ChildObjectId  AS PartnerId
                    FROM ObjectLink AS ObjectLink_ContractPartner_Contract
                         INNER JOIN tmpContract_full ON tmpContract_full.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId
                                                    AND tmpContract_full.PaidKindId <> zc_Enum_PaidKind_FirstForm()

                         LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                              ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                             AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                    WHERE ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                    )
           --  Partner ��� ���������, ��� ������� ��� ContractPartner
         , tmp2 AS (SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId
                         , ObjectLink_Partner_Juridical.ObjectId  AS PartnerId
                    FROM tmpContract_full
                         LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                              ON ObjectLink_Contract_Juridical.ObjectId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId      --  AS JuridicalId-- ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId 
                                             AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                              ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                         LEFT JOIN (SELECT DISTINCT tmp1.ContractId FROM tmp1) AS tmpContract ON tmpContract.ContractId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ObjectId -- ContractId
                     WHERE tmpContract.ContractId IS NULL
                     )

           SELECT tmp1.ContractId
                , tmp1.PartnerId
           FROM tmp1
         UNION
           SELECT tmp2.ContractId
                , tmp2.PartnerId
           FROM tmp2
           );

   CREATE TEMP TABLE tmpContractConditionKind ON COMMIT DROP AS (
         -- ����������� ������ ���������, � ������� ���� ������� �� "�������"
                SELECT -- ������� ��������
                       ObjectLink_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                     , View_Contract.JuridicalId
                     , View_Contract.InvNumber             AS InvNumber_master
                     , View_Contract.ContractTagId         AS ContractTagId_master
                     , View_Contract.ContractTagName       AS ContractTagName_master
                     , View_Contract.ContractStateKindCode AS ContractStateKindCode_master
                     , View_Contract.ContractId            AS ContractId_master
                       -- ������ �� ��������
                     , View_InfoMoney.InfoMoneyId AS InfoMoneyId_master
                       -- ������ �� ������� ����� ����� ����
                     , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                 THEN zc_Enum_InfoMoney_30101() -- ������� ���������
                            WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- ��������� + ������ �� ������ �����
                                 THEN zc_Enum_InfoMoney_30201() -- ������ �����
                            -- !!!��� ������ ������ - ����� ����!!!
                            WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ���������
                                 THEN 0
                            -- !!!���� ��� ���� - ����� � ������ ���� ��������!!!
                            WHEN View_InfoMoney.InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- ������
                                 THEN 0
                            ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                       END AS InfoMoneyId_child
   
                       -- ������ �� ������� - ����������� ��� ������ ����
                     , COALESCE (ObjectLink_ContractCondition_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_Condition
                       -- ����� ������
                     , View_Contract.PaidKindId AS PaidKindId
                       -- ����� ������ �� ���.�������� ��� ������� ���� 
                     , ObjectLink_ContractCondition_PaidKind.ChildObjectId AS PaidKindId_ContractCondition
                       -- ��� ������
                     , ObjectLink_ContractCondition_BonusKind.ChildObjectId    AS BonusKindId
                     , COALESCE (ObjectFloat_Value.ValueData, 0)               AS Value
                     , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0)      AS PercentRetBonus
                     , COALESCE (Object_Comment.ValueData, '')                 AS Comment
   
                       -- !!!��������� - ��� ����� "����"!!!
                     , ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send
   
                FROM ObjectLink AS ObjectLink_ContractConditionKind
                     INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionKind.ObjectId
                                                                  AND Object_ContractCondition.isErased = FALSE
                     INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                          ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                         AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                     INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                            --  AND (View_Contract.JuridicalId = inJuridicalId OR inJuridicalId = 0)
   
                     INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                            ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id
                                           AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                           AND ObjectFloat_Value.ValueData <> 0  
   
                     LEFT JOIN ObjectFloat AS ObjectFloat_PercentRetBonus
                                           ON ObjectFloat_PercentRetBonus.ObjectId = Object_ContractCondition.Id
                                          AND ObjectFloat_PercentRetBonus.DescId = zc_ObjectFloat_ContractCondition_PercentRetBonus()
   
                     LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                          ON ObjectLink_ContractCondition_ContractSend.ObjectId = Object_ContractCondition.Id
                                         AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
   
                     LEFT JOIN Object AS Object_Comment ON Object_Comment.Id = Object_ContractCondition.Id
                     LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                          ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                                         AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                     LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                                          ON ObjectLink_ContractCondition_InfoMoney.ObjectId = Object_ContractCondition.Id
                                         AND ObjectLink_ContractCondition_InfoMoney.DescId   = zc_ObjectLink_ContractCondition_InfoMoney()
                     LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId
   
                     LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                          ON ObjectLink_ContractCondition_PaidKind.ObjectId = Object_ContractCondition.Id
                                         AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()
                     LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ContractCondition_PaidKind.ChildObjectId
   
                WHERE ObjectLink_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                       , zc_Enum_ContractConditionKind_BonusPercentIncome()
                                                                       , zc_Enum_ContractConditionKind_BonusPercentIncomeReturn()
                                                                        )
                  AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                );

   CREATE TEMP TABLE tmpContractBonus ON COMMIT DROP AS (
      -- ��� ��������� (���� !!!��������� ��-������ ��� �������!!!) ���� ����� �������� ������� (�� 4-� ������ + ����� � "���� ������� ���������")
      -- �.�. ������� ���� � �������, �� ���� ���������� "������-�������" � ���������� �������� �� ����
      SELECT tmpContract_find.ContractId_master
           , tmpContract_find.ContractId_find
           , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
           , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
      FROM (-- ������� �������� � ������� "��������" ������� + ��������� ����� ���������� "������-�������"
            SELECT DISTINCT
                   tmpContractConditionKind.ContractId_master
                 , tmpContractConditionKind.ContractId_send AS ContractId_find
            FROM tmpContractConditionKind
            WHERE tmpContractConditionKind.ContractId_send > 0
           UNION
            -- ��������� ������� �������� ��� ������� ������� "������-�������"
            SELECT tmpContractConditionKind.ContractId_master
                 , MAX (COALESCE (View_Contract_find_tag.ContractId, View_Contract_find.ContractId)) AS ContractId_find
            FROM tmpContractConditionKind
                 -- ��� ������ ContractCondition � ���� ����� ������
                 INNER JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                       ON ObjectLink_ContractCondition_BonusKind.ChildObjectId = tmpContractConditionKind.BonusKindId
                                      AND ObjectLink_ContractCondition_BonusKind.DescId        = zc_ObjectLink_ContractCondition_BonusKind()
                 -- ��� ������ �� ������
                 INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                              AND Object_ContractCondition.isErased = FALSE
                 -- � ���� ���������
                 INNER JOIN ObjectFloat AS ObjectFloat_Value
                                        ON ObjectFloat_Value.ObjectId  = ObjectLink_ContractCondition_BonusKind.ObjectId
                                       AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ContractCondition_Value()
                                       AND ObjectFloat_Value.ValueData = tmpContractConditionKind.Value

                 -- �������� ��� �������
                 INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                       ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_BonusKind.ObjectId
                                      AND ObjectLink_ContractCondition_Contract.DescId   = zc_ObjectLink_ContractCondition_Contract()

                 -- ����� 1 - �� 3 - � ��������, ������� - ContractTagId_master
                 LEFT JOIN tmpContract_all AS View_Contract_find_tag
                                           ON View_Contract_find_tag.JuridicalId   = tmpContractConditionKind.JuridicalId
                                          AND View_Contract_find_tag.InfoMoneyId   = tmpContractConditionKind.InfoMoneyId_Condition
                                          AND View_Contract_find_tag.ContractTagId = tmpContractConditionKind.ContractTagId_master
                                          AND tmpContractConditionKind.ContractId_send IS NULL
                                          -- ���-�� �������� � ��� ����� �������
                                          AND View_Contract_find_tag.ContractId    = ObjectLink_ContractCondition_Contract.ChildObjectId

                 -- ����� 2 - �� 3 - � �������� - �����, �.�. � ��� ����� ������ ContractTagId_master
                 LEFT JOIN tmpContract_all AS View_Contract_find
                                           ON View_Contract_find.JuridicalId = tmpContractConditionKind.JuridicalId
                                          AND View_Contract_find.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_Condition
                                          AND View_Contract_find.ContractId  = ObjectLink_ContractCondition_Contract.ChildObjectId
                                          AND View_Contract_find_tag.ContractId        IS NULL
                                          AND tmpContractConditionKind.ContractId_send IS NULL
                 LEFT JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                      ON ObjectLink_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                     AND ObjectLink_ContractConditionKind.DescId   = zc_ObjectLink_ContractCondition_ContractConditionKind()
            WHERE -- ���� ������ � ������� ��������
                  tmpContractConditionKind.InfoMoneyId_Condition <> 0
                  -- !!!��� ������ ������� ��������!!!
              AND COALESCE (ObjectLink_ContractConditionKind.ChildObjectId, 0) = 0
                  -- !!!�� ��������� - ��� ����� "����"!!!
              AND tmpContractConditionKind.ContractId_send IS NULL

            GROUP BY tmpContractConditionKind.ContractId_master
           ) AS tmpContract_find
           LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = tmpContract_find.ContractId_find
      WHERE tmpContract_find.ContractId_find <> 0
     );
   
     CREATE TEMP TABLE tmpContract ON COMMIT DROP AS (
         -- ��� ���� �� ���, � ���� ���� "������" ����������� ������ ���� ������ ��������� (�� ��� ����� ������ ������ "����")
         SELECT tmpContractConditionKind.JuridicalId
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
              , tmpContractConditionKind.PaidKindId        AS PaidKindId_byBase
              , tmpContractConditionKind.ContractConditionKindId
              , tmpContractConditionKind.BonusKindId
              , tmpContractConditionKind.Value
              , tmpContractConditionKind.PercentRetBonus
              , tmpContractConditionKind.Comment
         FROM tmpContractConditionKind
         WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child -- ��� ����� �� �������� �������� (�� � ��� ���� ������)
       UNION ALL
         SELECT tmpContractConditionKind.JuridicalId
              , tmpContractConditionKind.InvNumber_master
              , View_Contract_child.InvNumber             AS InvNumber_child
              , tmpContractConditionKind.ContractId_master
              , View_Contract_child.ContractId            AS ContractId_child
              , View_Contract_child.ContractTagName       AS ContractTagName_child
              , View_Contract_child.ContractStateKindCode AS ContractStateKindCode_child
              , tmpContractConditionKind.InfoMoneyId_master
              , tmpContractConditionKind.InfoMoneyId_child
              , tmpContractConditionKind.InfoMoneyId_Condition
              , tmpContractConditionKind.PaidKindId
              -- ����� �� �� ���.�������� ��� ���. ���� ���� �� ����� , ���� �� �� ������� ����� �� �������� 
              --(�.�. ������� �� ����� ���, ����� �� ����� ���, � ���� ���� ����� �������� �� ����� ��)
              , CASE WHEN COALESCE (tmpContractConditionKind.PaidKindId_ContractCondition, 0) <> 0 THEN tmpContractConditionKind.PaidKindId_ContractCondition ELSE tmpContractConditionKind.PaidKindId END AS PaidKindId_byBase
              , tmpContractConditionKind.ContractConditionKindId
              , tmpContractConditionKind.BonusKindId
              , tmpContractConditionKind.Value
              , tmpContractConditionKind.PercentRetBonus
              , tmpContractConditionKind.Comment
         FROM tmpContractConditionKind
              INNER JOIN tmpContract_full AS View_Contract_child
                                          ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                         AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
         WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child -- ��� ����� �������� ��������
         );
   
   --- ����
   CREATE TEMP TABLE tmpBase ON COMMIT DROP AS (
      WITH 
      -- ���������� ��������, �.�. "����" ����� ����������� �� 4-� ������
      tmpContractGroup AS (SELECT tmpContract.JuridicalId
                               , tmpContract.ContractId_child
                               , tmpContract.InfoMoneyId_child
                               , tmpContract.PaidKindId_byBase
                           FROM tmpContract
                           -- WHERE (tmpContract.PaidKindId = inPaidKindId OR inPaidKindId = 0)
                           --  AND (tmpContract.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                           GROUP BY tmpContract.JuridicalId
                                  , tmpContract.ContractId_child
                                  , tmpContract.InfoMoneyId_child
                                  , tmpContract.PaidKindId_byBase
                          )
                          
      -- ������ ContractId �� ������� ����� ������ "����"
    , tmpAccount AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId <> zc_Enum_AccountGroup_110000()) -- �������

/*    , tmpContainer1 AS (SELECT DISTINCT
                              Container.Id  AS ContainerId
                            , tmpContractGroup.JuridicalId
                            , tmpContractGroup.ContractId_child
                            , tmpContractGroup.InfoMoneyId_child
                            , tmpContractGroup.PaidKindId_byBase
                            , COALESCE (ContainerLO_Branch.ObjectId,0) AS BranchId
                       FROM tmpAccount
                            JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                                          AND Container.DescId = zc_Container_Summ()

                            JOIN ContainerLinkObject AS ContainerLO_Juridical 
                                                     ON ContainerLO_Juridical.ContainerId = Container.Id
                                                    AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                            JOIN ContainerLinkObject AS ContainerLO_Contract
                                                     ON ContainerLO_Contract.ContainerId = Container.Id
                                                    AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract() 
                            JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                                             AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()                               
                            JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = Container.Id
                                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind() 

                            -- ����������� �� 4-� ������
                            JOIN tmpContractGroup ON tmpContractGroup.JuridicalId       = ContainerLO_Juridical.ObjectId 
                                                 AND tmpContractGroup.ContractId_child  = ContainerLO_Contract.ObjectId
                                                 AND tmpContractGroup.InfoMoneyId_child = ContainerLO_InfoMoney.ObjectId
                                                 AND tmpContractGroup.PaidKindId_byBase = ContainerLO_PaidKind.ObjectId

                            /*LEFT JOIN ContainerLinkObject AS CLO_Partner
                                                     ON CLO_Partner.ContainerId = Container.Id
                                                    AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                                    AND inPaidKindId <> zc_Enum_PaidKind_FirstForm()*/
                            -- ������������ ������������� --
                            --INNER JOIN tmpContractPartner ON (tmpContractPartner.PartnerId = CLO_Partner.ObjectId
                              --                               ) OR ContainerLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
                                                 
                            LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                          ON ContainerLO_Branch.ContainerId = Container.Id
                                                         AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                       WHERE COALESCE (ContainerLO_Branch.ObjectId,0) = inBranchId OR inBranchId = 0
                       -- WHERE Container.ObjectId <> zc_Enum_Account_50401() -- "���������"
                       --   AND Container.ObjectId <> zc_Enum_AccountDirection_70300() ����� ������ �������� �� ������ ����������
                       --  AND (inPaidKindId <> zc_Enum_PaidKind_FirstForm() AND CLO_Partner.ObjectId IN (SELECT DISTINCT tmpContractPartner.PartnerId FROM tmpContractPartner) )
                       )
 */

    , tmpContainerAll AS (SELECT Container.*
                             , ContainerLO_Juridical.ObjectId  AS JuridicalId
                             , ContainerLO_Contract.ObjectId   AS ContractId
                             , ContainerLO_InfoMoney.ObjectId  AS InfoMoneyId
                             , ContainerLO_PaidKind.ObjectId   AS PaidKindId

                        FROM Container
                            JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = Container.Id
                                                                             AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                            JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = Container.Id
                                                                            AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract() 
                            JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                                             AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()                               
                            JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = Container.Id
                                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind() 
                        WHERE Container.ObjectId IN (SELECT DISTINCT tmpAccount.AccountId FROM tmpAccount)
                          AND Container.DescId = zc_Container_Summ()
                        )

    , tmpContainer1 AS (SELECT  DISTINCT
                              tmpContainerAll.Id  AS ContainerId
                            , tmpContractGroup.JuridicalId
                            , tmpContractGroup.ContractId_child
                            , tmpContractGroup.InfoMoneyId_child
                            , tmpContractGroup.PaidKindId_byBase
                            , COALESCE (ContainerLO_Branch.ObjectId,0) AS BranchId
                        FROM tmpContainerAll 
                            -- ����������� �� 4-� ������
                            JOIN tmpContractGroup ON tmpContractGroup.JuridicalId       = tmpContainerAll.JuridicalId 
                                                 AND tmpContractGroup.ContractId_child  = tmpContainerAll.ContractId
                                                 AND tmpContractGroup.InfoMoneyId_child = tmpContainerAll.InfoMoneyId
                                                 AND tmpContractGroup.PaidKindId_byBase = tmpContainerAll.PaidKindId
                            LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                          ON ContainerLO_Branch.ContainerId = tmpContainerAll.Id
                                                         AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                        WHERE COALESCE (ContainerLO_Branch.ObjectId,0) = inBranchId OR inBranchId = 0 
                       )
 
     , tmpCLO_Partner AS (SELECT ContainerLinkObject.*
                          FROM ContainerLinkObject
                          WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpContainer1.ContainerId
                                                                    FROM tmpContainer1
                                                                    WHERE tmpContainer1.PaidKindId_byBase = zc_Enum_PaidKind_SecondForm())
                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Partner()
                            AND ContainerLinkObject.ObjectId IN (SELECT DISTINCT tmpContractPartner.PartnerId FROM tmpContractPartner)
                          )
     , tmpContainer AS (SELECT tmpContainer1.*
                             , 0 AS PartnerId    
                       FROM tmpContainer1
                       WHERE tmpContainer1.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()
                       UNION
                       -- ��� ��� ������������ ������������
                       SELECT tmpContainer.*
                            , CLO_Partner.ObjectId AS PartnerId  --, 0 AS PartnerId    --,
                       FROM tmpContainer1 As tmpContainer
                           INNER JOIN tmpCLO_Partner AS CLO_Partner
                                                          ON CLO_Partner.ContainerId = tmpContainer.ContainerId
                                                         AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                                         AND CLO_Partner.ObjectId IN (SELECT DISTINCT tmpContractPartner.PartnerId FROM tmpContractPartner)
                       WHERE tmpContainer.PaidKindId_byBase <> zc_Enum_PaidKind_FirstForm()
                       )

      SELECT tmpContainer.JuridicalId
           , tmpContainer.ContractId_child
           , tmpContainer.InfoMoneyId_child
           , tmpContainer.PaidKindId_byBase
           , tmpContainer.BranchId
           , tmpContainer.PartnerId
           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.Amount ELSE 0 END) AS Sum_Income -- ������ �������
           , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()) THEN MIContainer.Amount ELSE 0 END) AS Sum_IncomeReturnOut -- ������ - ��������
           , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                            THEN -1 * MIContainer.Amount
                       ELSE 0
                  END) AS Sum_Account -- ������
           
           , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnOut() THEN MIContainer.Amount ELSE 0 END) AS Sum_Return  -- �������
           , MIContainer.MovementDescId   AS MovementDescId
           , MIContainer.MovementId       AS MovementId

      FROM MovementItemContainer AS MIContainer
           JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId
      WHERE MIContainer.DescId = zc_MIContainer_Summ()
        AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
        AND MIContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_BankAccount(),zc_Movement_Cash(), zc_Movement_SendDebt())
      GROUP BY tmpContainer.JuridicalId
             , tmpContainer.ContractId_child
             , tmpContainer.InfoMoneyId_child
             , tmpContainer.PaidKindId_byBase
             , MIContainer.MovementDescId
             , MIContainer.MovementId
             , tmpContainer.BranchId
             , tmpContainer.PartnerId
      );


    RETURN QUERY
      WITH 
        tmpMovement AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.PartnerId
                             , tmpGroup.ContractId_child 
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId_byBase
                             , tmpGroup.BranchId
                             , tmpGroup.MovementId
                             , tmpGroup.MovementDescId
                             , tmpGroup.Sum_Income
                             , tmpGroup.Sum_IncomeReturnOut
                             , tmpGroup.Sum_Account
                             --���������� % �������� ���� = ���� �������� / ���� �������� * 100
                             , CASE WHEN COALESCE (tmpGroup.Sum_Income,0) <> 0 THEN tmpGroup.Sum_Return / tmpGroup.Sum_Income * 100 ELSE 0 END AS PercentRetBonus_fact
                        FROM 
                            (SELECT tmpGroup.JuridicalId
                                  , tmpGroup.PartnerId
                                  , tmpGroup.ContractId_child 
                                  , tmpGroup.InfoMoneyId_child
                                  , tmpGroup.PaidKindId_byBase
                                  , tmpGroup.BranchId
                                  , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementId ELSE 0 END     AS MovementId
                                  , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementDescId ELSE 0 END AS MovementDescId
                                  , SUM (tmpGroup.Sum_Income)    AS Sum_Income
                                  , SUM (tmpGroup.Sum_IncomeReturnOut) AS Sum_IncomeReturnOut
                                  , SUM (tmpGroup.Sum_Account) AS Sum_Account
                                  , SUM (tmpGroup.Sum_Return)  AS Sum_Return
                             FROM tmpBase AS tmpGroup
                             GROUP BY tmpGroup.JuridicalId
                                    , tmpGroup.PartnerId
                                    , tmpGroup.ContractId_child
                                    , tmpGroup.InfoMoneyId_child
                                    , tmpGroup.PaidKindId_byBase
                                    , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementId ELSE 0 END
                                    , CASE WHEN inisMovement = TRUE THEN tmpGroup.MovementDescId ELSE 0 END
                                    , tmpGroup.BranchId
                             ) AS tmpGroup
                       )

      , tmpAll as(SELECT tmpContract.InvNumber_master
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
                       , tmpMovement.PartnerId
                       -- ��������� ������� �� b� ���.�������� �� �� �� ��������
                       , tmpContract.PaidKindId                                 --tmpMovement.PaidKindId AS PaidKindId
                       , tmpContract.PaidKindId_byBase  AS PaidKindId_child     -- �� �������� ����
                       , tmpContract.ContractConditionKindId
                       , tmpContract.BonusKindId
                       , COALESCE (tmpContract.Value,0) AS Value
                       , COALESCE (tmpContract.PercentRetBonus,0)     ::TFloat AS PercentRetBonus
                       , COALESCE (tmpMovement.PercentRetBonus_fact,0)::TFloat AS PercentRetBonus_fact

                       , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncome() THEN tmpMovement.Sum_Income 
                                    WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncomeReturn() THEN tmpMovement.Sum_IncomeReturnOut
                                    WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN tmpMovement.Sum_Account
                               ELSE 0 END  AS TFloat) AS Sum_CheckBonus

                       --����� % �������� ���� ��������� % �������� ����, ����� �� ����������� 
                       , CAST (CASE WHEN (COALESCE (tmpContract.PercentRetBonus,0) <> 0 AND tmpMovement.PercentRetBonus_fact > tmpContract.PercentRetBonus) THEN 0 
                                    ELSE 
                                       CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncome() THEN (tmpMovement.Sum_Income/100 * tmpContract.Value)
                                            WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentIncomeReturn() THEN (tmpMovement.Sum_IncomeReturnOut/100 * tmpContract.Value) 
                                            WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN (tmpMovement.Sum_Account/100 * tmpContract.Value)
                                       ELSE 0 END
                               END  AS NUMERIC (16, 2)) AS Sum_Bonus

                       , 0 :: TFloat                  AS Sum_BonusFact
                       , 0 :: TFloat                  AS Sum_CheckBonusFact
                       , 0 :: TFloat                  AS Sum_IncomeFact
                       , COALESCE (tmpMovement.Sum_Account) AS Sum_Account
                       , COALESCE (tmpMovement.Sum_IncomeReturnOut) AS Sum_IncomeReturnOut

                       , COALESCE (tmpContract.Comment, '')  AS Comment
             
                       , COALESCE (tmpMovement.MovementId,0) AS MovementId
                       , tmpMovement.MovementDescId
                       , COALESCE (tmpMovement.BranchId,0)   AS BranchId
                  FROM tmpContract
                       INNER JOIN tmpMovement ON tmpMovement.JuridicalId       = tmpContract.JuridicalId
                                             AND tmpMovement.ContractId_child  = tmpContract.ContractId_child
                                             AND tmpMovement.InfoMoneyId_child = tmpContract.InfoMoneyId_child
                                             AND tmpMovement.PaidKindId_byBase = tmpContract.PaidKindId_byBase
                       LEFT JOIN tmpContractBonus ON tmpContractBonus.ContractId_master = tmpContract.ContractId_master

                UNION ALL 
                  SELECT View_Contract_InvNumber_master.InvNumber AS InvNumber_master
                       , View_Contract_InvNumber_child.InvNumber AS InvNumber_child
                       , View_Contract_InvNumber_find.InvNumber AS InvNumber_find

                       , View_Contract_InvNumber_child.ContractTagName  AS ContractTagName_child
                       , View_Contract_InvNumber_child.ContractStateKindCode AS ContractStateKindCode_child

                       , MILinkObject_ContractMaster.ObjectId           AS ContractId_master  
                       , MILinkObject_ContractChild.ObjectId            AS ContractId_child            
                       , MILinkObject_Contract.ObjectId                 AS ContractId_find

                       , View_Contract_InvNumber_master.InfoMoneyId     AS InfoMoneyId_master
                       , View_Contract_InvNumber_child.InfoMoneyId      AS InfoMoneyId_child
                       , MILinkObject_InfoMoney.ObjectId                AS InfoMoneyId_find

                       , MovementItem.ObjectId                          AS JuridicalId
                       , 0                 AS PartnerId
                       , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                       , View_Contract_InvNumber_child.PaidKindId       AS PaidKindId_child
                       , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                       , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                       , COALESCE (MIFloat_BonusValue.ValueData,0)      AS Value
                       , 0 ::TFloat                                     AS PercentRetBonus
                       , 0 ::TFloat                                     AS PercentRetBonus_fact

                       , 0 :: TFloat                                    AS Sum_CheckBonus
                       , 0 :: TFloat                                    AS Sum_Bonus
                       , MovementItem.Amount                            AS Sum_BonusFact
                       , MIFloat_Summ.ValueData                         AS Sum_CheckBonusFact
                       , MIFloat_AmountPartner.ValueData                AS Sum_IncomeFact
                       , 0 :: TFloat                                    AS Sum_Account
                       , 0 :: TFloat                                    AS Sum_IncomeReturnOut

                       , COALESCE (MIString_Comment.ValueData,'')       AS Comment

                       , CASE WHEN inisMovement = TRUE THEN Movement.Id ELSE 0 END      AS MovementId
                       , CASE WHEN inisMovement = TRUE THEN Movement.DescId ELSE 0 END  AS MovementDescId
                       , COALESCE (MILinkObject_Branch.ObjectId,0)      AS BranchId
                FROM Movement 
                       LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                       INNER JOIN tmpJuridical ON tmpJuridical.JuridicalId = MovementItem.ObjectId

                       LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                                   ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                                  AND MIFloat_BonusValue.DescId = zc_MIFloat_BonusValue()
                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                   ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                       LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                   ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                       LEFT JOIN MovementItemString AS MIString_Comment
                                                    ON MIString_Comment.MovementItemId = MovementItem.Id
                                                   AND MIString_Comment.DescId = zc_MIString_Comment()

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                        ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                        ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractMaster
                                                        ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                        ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                        ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                        ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                        ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                        ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                       LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = MILinkObject_Contract.ObjectId
                       LEFT JOIN tmpContract_all AS View_Contract_InvNumber_master ON View_Contract_InvNumber_master.ContractId = MILinkObject_ContractMaster.ObjectId
                       LEFT JOIN tmpContract_full AS View_Contract_InvNumber_child ON View_Contract_InvNumber_child.ContractId = MILinkObject_ContractChild.ObjectId
      
                       --LEFT JOIN (SELECT tmpMovement.JuridicalId, MAX (tmpMovement.PartnerId) AS PartnerId FROM tmpMovement GROUP BY tmpMovement.JuridicalId) tmpInf ON tmpInf.JuridicalId = MovementItem.ObjectId 
                  WHERE Movement.DescId = zc_Movement_ProfitLossService()
                    AND Movement.StatusId = zc_Enum_Status_Complete()
                    AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                    AND MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                                          , zc_Enum_InfoMoney_21502()) -- ��������� + ������ �� ������ �����
                    AND (MovementItem.ObjectId = inJuridicalId OR inJuridicalId = 0)
                    -- AND MILinkObject_ContractConditionKind.ObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount(), zc_Enum_ContractConditionKind_BonusPercentIncomeReturn(), zc_Enum_ContractConditionKind_BonusPercentIncome())
                 )
      , tmpData AS (SELECT tmpAll.ContractId_master
                         , tmpAll.ContractId_child
                         , tmpAll.ContractId_find
                         , tmpAll.InvNumber_master
                         , tmpAll.InvNumber_child
                         , tmpAll.InvNumber_find
                         , tmpAll.ContractTagName_child
                         , tmpAll.ContractStateKindCode_child
                         , tmpAll.InfoMoneyId_master
                         , tmpAll.InfoMoneyId_child
                         , tmpAll.InfoMoneyId_find
                         , tmpAll.JuridicalId
                         , tmpAll.PartnerId
                         , tmpAll.PaidKindId
                         , tmpAll.PaidKindId_child
                         , tmpAll.ContractConditionKindId
                         , tmpAll.BonusKindId
                         , tmpAll.MovementId
                         , tmpAll.MovementDescId
                         , tmpAll.BranchId
                         , tmpAll.Value

                         , MAX (tmpAll.PercentRetBonus)    AS PercentRetBonus
                         , MAX (tmpAll.PercentRetBonus_fact)*(-1) AS PercentRetBonus_fact
                         , SUM (tmpAll.Sum_CheckBonus)     AS Sum_CheckBonus
                         , SUM (tmpAll.Sum_CheckBonusFact) AS Sum_CheckBonusFact
                         , SUM (tmpAll.Sum_Bonus)          AS Sum_Bonus
                         , SUM (tmpAll.Sum_BonusFact)*(-1) AS Sum_BonusFact
                         , SUM (tmpAll.Sum_IncomeFact)     AS Sum_IncomeFact
                         , SUM (tmpAll.Sum_Account)        AS Sum_Account
                         , SUM (tmpAll.Sum_IncomeReturnOut)   AS Sum_IncomeReturnOut
                         , MAX (tmpAll.Comment) :: TVarChar AS Comment
                    FROM tmpAll
                    WHERE (tmpAll.Sum_CheckBonus > 0
                       OR tmpAll.Sum_Bonus > 0
                       OR tmpAll.Sum_BonusFact <> 0)
                      AND (tmpAll.PaidKindId = inPaidKindId OR inPaidKindId = 0)
                      AND (tmpAll.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                    GROUP BY  tmpAll.ContractId_master
                            , tmpAll.ContractId_child
                            , tmpAll.ContractId_find
                            , tmpAll.InvNumber_master
                            , tmpAll.InvNumber_child
                            , tmpAll.InvNumber_find
                            , tmpAll.ContractTagName_child
                            , tmpAll.ContractStateKindCode_child
                            , tmpAll.InfoMoneyId_master
                            , tmpAll.InfoMoneyId_child
                            , tmpAll.InfoMoneyId_find
                            , tmpAll.JuridicalId
                            , tmpAll.PartnerId
                            , tmpAll.PaidKindId
                            , tmpAll.ContractConditionKindId
                            , tmpAll.BonusKindId
                            , tmpAll.Value
                            , tmpAll.MovementId
                            , tmpAll.MovementDescId
                            , tmpAll.BranchId
                            , tmpAll.PaidKindId_child
                    )


      SELECT  Movement.OperDate                             AS OperDate_Movement
            , Movement.InvNumber                            AS InvNumber_Movement
            , MovementDesc.ItemName                         AS DescName_Movement
            , tmpData.ContractId_master
            , tmpData.ContractId_child
            , tmpData.ContractId_find
            , tmpData.InvNumber_master ::TVarChar
            , tmpData.InvNumber_child  ::TVarChar
            , tmpData.InvNumber_find   ::TVarChar

            , tmpData.ContractTagName_child        ::TVarChar
            , tmpData.ContractStateKindCode_child  

            , Object_InfoMoney_master.Id                    AS InfoMoneyId_master
            , Object_InfoMoney_find.Id                      AS InfoMoneyId_find

            , Object_InfoMoney_master.ValueData             AS InfoMoneyName_master
            , Object_InfoMoney_child.ValueData              AS InfoMoneyName_child
            , Object_InfoMoney_find.ValueData               AS InfoMoneyName_find

            , Object_Juridical.Id                           AS JuridicalId
            , Object_Juridical.ValueData                    AS JuridicalName

            , Object_PaidKind.Id                            AS PaidKindId
            , Object_PaidKind.ValueData                     AS PaidKindName
            , Object_PaidKind_Child.ValueData               AS PaidKindName_Child

            , Object_ContractConditionKind.Id               AS ConditionKindId
            , Object_ContractConditionKind.ValueData        AS ConditionKindName

            , Object_BonusKind.Id                           AS BonusKindId
            , Object_BonusKind.ValueData                    AS BonusKindName
            
            , Object_Branch.Id                              AS BranchId
            , Object_Branch.ValueData                       AS BranchName

            , Object_Retail.ValueData                       AS RetailName
            , Object_Personal_View.PersonalCode             AS PersonalCode
            , Object_Personal_View.PersonalName             AS PersonalName
            , Object_Partner.ValueData  ::TVarChar          AS PartnerName

            , CAST (tmpData.Value AS TFloat)                AS Value
            , CAST (tmpData.PercentRetBonus AS TFloat)      AS PercentRetBonus
            , CAST (tmpData.PercentRetBonus_fact AS TFloat) AS PercentRetBonus_fact

            , CAST (tmpData.Sum_CheckBonus AS TFloat)       AS Sum_CheckBonus
            , CAST (tmpData.Sum_CheckBonusFact AS TFloat)   AS Sum_CheckBonusFact
            , CAST (tmpData.Sum_Bonus      AS TFloat)       AS Sum_Bonus
            , CAST (tmpData.Sum_BonusFact  AS TFloat)       AS Sum_BonusFact
            , CAST (tmpData.Sum_IncomeFact   AS TFloat)     AS Sum_IncomeFact
            , CAST (tmpData.Sum_Account    AS TFloat)       AS Sum_Account
            , CAST (tmpData.Sum_IncomeReturnOut AS TFloat)  AS Sum_IncomeReturnOut
            , tmpData.Comment :: TVarChar                   AS Comment
      FROM tmpData
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
            LEFT JOIN Object AS Object_PaidKind_Child ON Object_PaidKind_Child.Id = tmpData.PaidKindId_child
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpData.BonusKindId
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpData.ContractConditionKindId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpData.BranchId

            LEFT JOIN Object AS Object_InfoMoney_master ON Object_InfoMoney_master.Id = tmpData.InfoMoneyId_master
            LEFT JOIN Object AS Object_InfoMoney_child ON Object_InfoMoney_child.Id = tmpData.InfoMoneyId_child
            LEFT JOIN Object AS Object_InfoMoney_find ON Object_InfoMoney_find.Id = tmpData.InfoMoneyId_find

            LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpData.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                                 ON ObjectLink_Contract_Personal.ObjectId = tmpData.ContractId_child
                                AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.07.20         * gpReport_CheckBonus_Income
*/

-- ����
-- select * from gpReport_CheckBonus_Income (inStartDate:= '15.03.2016', inEndDate:= '15.03.2016', inPaidKindID:= zc_Enum_PaidKind_FirstForm(), inJuridicalId:= 0, inBranchId:= 0, inSession:= zfCalc_UserAdmin());
-- select * from gpReport_CheckBonus_Income(inStartDate := ('28.05.2020')::TDateTime , inEndDate := ('28.05.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 344240 , inBranchId := 0 ,  inSession := '5');--
-- select * from gpReport_CheckBonus_Income(inStartDate := ('01.05.2020')::TDateTime , inEndDate := ('30.06.2020')::TDateTime , inPaidKindId := 4 , inJuridicalId := 3834632 , inBranchId := 0 ,  inSession := '5');