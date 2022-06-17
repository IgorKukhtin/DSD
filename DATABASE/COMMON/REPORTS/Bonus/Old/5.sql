-- Function: lpreport_checkbonus2222(tdatetime, tdatetime, integer, integer, integer, boolean, tvarchar)

-- DROP FUNCTION lpreport_checkbonus2222(tdatetime, tdatetime, integer, integer, integer, boolean, tvarchar);

CREATE OR REPLACE FUNCTION lpreport_checkbonus2222(
    IN instartdate tdatetime,
    IN inenddate tdatetime,
    IN inpaidkindid integer,
    IN injuridicalid integer,
    IN inbranchid integer,
    IN inismovement boolean,
    IN insession tvarchar)
  RETURNS TABLE(operdate_movement tdatetime, operdatepartner tdatetime, invnumber_movement tvarchar, descname_movement tvarchar, contractid_master integer, contractid_child integer, contractid_find integer, invnumber_master tvarchar, invnumber_child tvarchar, invnumber_find tvarchar, contracttagname_child tvarchar, contractstatekindcode_child integer, infomoneyid_master integer, infomoneyid_find integer, infomoneyname_master tvarchar, infomoneyname_child tvarchar, infomoneyname_find tvarchar, juridicalid integer, juridicalname tvarchar, paidkindid integer, paidkindname tvarchar, paidkindname_child tvarchar, conditionkindid integer, conditionkindname tvarchar, bonuskindid integer, bonuskindname tvarchar, branchid integer, branchname tvarchar, branchid_inf integer, branchname_inf tvarchar, retailname tvarchar, personalcode integer, personalname tvarchar, partnerid integer, partnername tvarchar, value tfloat, percentretbonus tfloat, percentretbonus_fact tfloat, percentretbonus_diff tfloat, percentretbonus_fact_weight tfloat, percentretbonus_diff_weight tfloat, sum_checkbonus tfloat, sum_checkbonusfact tfloat, sum_bonus tfloat, sum_bonusfact tfloat, sum_salefact tfloat, sum_account tfloat, sum_accountsenddebt tfloat, sum_sale tfloat, sum_return tfloat, sum_salereturnin tfloat, sum_sale_weight tfloat, sum_returnin_weight tfloat, comment tvarchar, reportbonusid integer, issend boolean, fromname_movement tvarchar, toname_movement tvarchar, paidkindname_movement tvarchar, contractcode_movement tvarchar, contractname_movement tvarchar, contracttagname_movement tvarchar, totalcount_movement tfloat, totalcountpartner_movement tfloat, totalsumm_movement tfloat, contractconditionid integer) AS
$BODY$
--    DECLARE inisMovement  Boolean ; -- �� ����������
    DECLARE vbEndDate     TDateTime;
BEGIN

     --inisMovement:= FALSE;
     vbEndDate := inEndDate + INTERVAL '1 Day';

    RETURN QUERY
      WITH 
           tmpContract_full AS (SELECT View_Contract.*
                                FROM Object_Contract_View AS View_Contract
                                WHERE (View_Contract.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                )
         , tmpContract_all AS (SELECT *
                               FROM tmpContract_full
                               WHERE tmpContract_full.PaidKindId = inPaidKindId OR COALESCE (inPaidKindId, 0)  = 0
                              )
           -- ��� �������� - �� �������� ��� ��� ����
         , tmpContract_find AS (SELECT View_Contract.*
                                FROM tmpContract_full AS View_Contract
                                WHERE View_Contract.isErased = FALSE
                                  AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                    OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                   , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                    )
                                      )
                               )
           -- ��������� zc_Object_ContractPartner - �.�. ���� ����� ������ �� ���� ������ - ���� ��� �����������, ����� �� ����
         , tmpContractPartner_only AS 
                        (SELECT tmpContract_full.ContractId AS ContractId
                              , tmpContract_full.JuridicalId
                              , COALESCE (ObjectLink_ContractPartner_Partner.ChildObjectId,ObjectLink_Partner_Juridical.ObjectId)   AS PartnerId

                              , CASE WHEN COALESCE (ObjectLink_ContractCondition_PaidKind.ChildObjectId,0) <> 0
                                     THEN ObjectLink_ContractCondition_PaidKind.ChildObjectId
                                     ELSE tmpContract_full.PaidKindId
                                END AS PaidKindId_byBase
                             , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN ObjectLink_ContractCondition_Contract.ObjectId ELSE 0 END AS ContractConditionId
                         FROM tmpContract_full
                                     
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                       ON ObjectLink_ContractCondition_Contract.ChildObjectId = tmpContract_full.ContractId
                                                      AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                                       ON ObjectLink_ContractCondition_PaidKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                      AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()
                        
                                  INNER JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                        ON ObjectLink_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                       AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                                      AND ObjectLink_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                                           , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                                           , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                                           , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                                            )
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                       ON ObjectLink_ContractPartner_Contract.ChildObjectId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                      AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                              
                                  LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                       ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                      AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                        
                                   -- ���� ��� ObjectLink_ContractPartner_Partner.ChildObjectId ����� ���� ������������ �� �� ����
                                  LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                       ON ObjectLink_Contract_Juridical.ObjectId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId      --  AS JuridicalId-- ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId 
                                                      AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                      AND COALESCE (ObjectLink_ContractPartner_Partner.ChildObjectId,0) = 0
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                         WHERE tmpContract_full.PaidKindId = inPaidKindId
                         )
           -- ��� ��� ��� �������� ������������ �� ������� ��������, ���� �������. �� ������ ������ �� ��� �������
         , tmpCCPartner AS (SELECT tmp.ContractConditionId
                                 , ObjectLink_ContractConditionPartner_Partner.ChildObjectId AS PartnerId
                            FROM (SELECT DISTINCT tmpContractPartner_only.ContractConditionId FROM tmpContractPartner_only) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                                      ON ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId = tmp.ContractConditionId
                                                     AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()
            
                                 INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                                       ON ObjectLink_ContractConditionPartner_Partner.ObjectId = ObjectLink_ContractConditionPartner_ContractCondition.ObjectId
                                                      AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
                           )

         -- ����������� 2 ��������
         , tmpContractPartner AS (--����������� ������������� �� ������� ��������
                                  SELECT tmpContractPartner_only.*
                                  FROM tmpContractPartner_only
                                       INNER JOIN tmpCCPartner ON tmpCCPartner.ContractConditionId = tmpContractPartner_only.ContractConditionId
                                                              AND tmpCCPartner.PartnerId = tmpContractPartner_only.PartnerId
                               -- WHERE COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) <> 0
                                UNION
                                 -- ���� ��� ������������ � ���. �������� ����� ���� ���� ���������
                                 SELECT tmpContractPartner_only.*
                                 FROM tmpContractPartner_only
                                       LEFT JOIN tmpCCPartner ON tmpCCPartner.ContractConditionId = tmpContractPartner_only.ContractConditionId
                                                             AND tmpCCPartner.PartnerId = tmpContractPartner_only.PartnerId
                               -- WHERE COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) = 0
                                 WHERE tmpCCPartner.PartnerId IS NULL
                                UNION
                                 -- ���� ����� � ������� �������� ���� �����������, ������� ��� � ��������
                                 SELECT tmpContract_full.ContractId AS ContractId
                                      , tmpContract_full.JuridicalId
                                      , tmpCCPartner.PartnerId
                                      , CASE WHEN COALESCE (ObjectLink_ContractCondition_PaidKind.ChildObjectId,0) <> 0
                                             THEN ObjectLink_ContractCondition_PaidKind.ChildObjectId
                                             ELSE tmpContract_full.PaidKindId
                                        END AS PaidKindId_byBase
                                     , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN ObjectLink_ContractCondition_Contract.ObjectId ELSE 0 END AS ContractConditionId
                                 FROM tmpCCPartner
                                       LEFT JOIN tmpContractPartner_only ON tmpContractPartner_only.ContractConditionId = tmpCCPartner.ContractConditionId
                                                                        AND tmpContractPartner_only.PartnerId = tmpCCPartner.PartnerId
                                       LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                                            ON ObjectLink_ContractCondition_PaidKind.ObjectId = tmpCCPartner.ContractConditionId
                                                           AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()                                  
                                       LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                            ON ObjectLink_ContractCondition_Contract.ObjectId = tmpCCPartner.ContractConditionId
                                                           AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                       INNER JOIN tmpContract_full ON tmpContract_full.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                 WHERE tmpContractPartner_only.PartnerId IS NULL
                                --  AND COALESCE ((SELECT COUNT(*) FROM tmpCCPartner),0) <> 0
                                 )

         -- ����������� ������ ���������, � ������� ���� ������� �� "�������" ����������� ������
       , tmpCCK_BonusMonthlyPayment AS (SELECT -- ������� ��������
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
                                           , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN Object_ContractCondition.Id ELSE 0 END AS ContractConditionId
                                      FROM ObjectLink AS ObjectLink_ContractConditionKind
                                           INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionKind.ObjectId
                                                                                        AND Object_ContractCondition.isErased = FALSE
                                           INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                                ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                           INNER JOIN tmpContract_find AS View_Contract 
                                                                       ON View_Contract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                                      --AND View_Contract.PaidKindId = inPaidKindId

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

                                      WHERE ObjectLink_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_BonusMonthlyPayment()
                                        AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                     )


         -- ����������� ������ ���������, � ������� ���� ������� �� "�������"
       , tmpContractConditionKind AS (SELECT -- ������� ��������
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
                                           , 0 AS ContractId_send
                                           , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN Object_ContractCondition.Id ELSE 0 END AS ContractConditionId
                                      FROM ObjectLink AS ObjectLink_ContractConditionKind
                                           INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionKind.ObjectId
                                                                                        AND Object_ContractCondition.isErased = FALSE
                                           INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                                ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                                      --AND View_Contract.PaidKindId = inPaidKindId

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
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                              )
                                        AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                     )
      -- ��� ��������� (���� !!!��������� ��-������ ��� �������!!!) ���� ����� �������� ������� (�� 4-� ������ + ����� � "���� ������� ���������")
      -- �.�. ������� ���� � �������, �� ���� ���������� "������-�������" � ���������� �������� �� ����
    , tmpContractBonus AS (SELECT tmpContract_find.ContractId_master
                                , tmpContract_find.ContractId_find
                                , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
                                , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
                                , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmpContract_find.ContractConditionId ELSE 0 END ContractConditionId
                           FROM (-- ������� �������� � ������� "��������" ������� + ��������� ����� ���������� "������-�������"
                                 SELECT DISTINCT
                                        CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                                                     , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                                                      )
                                               AND tmpContractConditionKind.InfoMoneyId_master IN (zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                                                                                 , zc_Enum_InfoMoney_21502() -- ��������� + ������ �� ������ �����
                                                                                                  )
                                                  

                                             THEN -- ������ �������
                                                  tmpContractConditionKind.ContractId_send
                                             ELSE -- �������� ��� ����
                                                  tmpContractConditionKind.ContractId_master
                                        END AS ContractId_master
                                        --
                                      , CASE WHEN ObjectLink_Contract_InfoMoney_send.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                                                     , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                                                      )
                                               AND tmpContractConditionKind.InfoMoneyId_master IN (zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                                                                                 , zc_Enum_InfoMoney_21502() -- ��������� + ������ �� ������ �����
                                                                                                  )
                                                  
                                             THEN -- ������ �������
                                                  tmpContractConditionKind.ContractId_master
                                             ELSE -- �������� ��� ����
                                                  tmpContractConditionKind.ContractId_send
                                        END AS ContractId_find
                                        --
                                      , tmpContractConditionKind.ContractConditionId
                                 FROM tmpContractConditionKind
                                      LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney_send
                                                           ON ObjectLink_Contract_InfoMoney_send.ObjectId = tmpContractConditionKind.ContractId_send
                                                          AND ObjectLink_Contract_InfoMoney_send.DescId   = zc_ObjectLink_Contract_InfoMoney()
                                 WHERE tmpContractConditionKind.ContractId_send > 0
                                UNION
                                 -- ��������� ������� �������� ��� ������� ������� "������-�������"
                                 SELECT tmpContractConditionKind.ContractId_master
                                      , MAX (COALESCE (View_Contract_find_tag.ContractId, View_Contract_find.ContractId)) AS ContractId_find
                                      , tmpContractConditionKind.ContractConditionId
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

                                 GROUP BY tmpContractConditionKind.ContractId_master, tmpContractConditionKind.ContractConditionId
                                ) AS tmpContract_find
                                LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = tmpContract_find.ContractId_find
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
                           , tmpContractConditionKind.PaidKindId        AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                           , tmpContractConditionKind.ContractConditionId
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
                           , tmpContractConditionKind.ContractConditionId
                      FROM tmpContractConditionKind
                           INNER JOIN tmpContract_full AS View_Contract_child
                                                       ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                      AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child -- ��� ����� �������� ��������
                     )
        
      -- ���������� ��������, �.�. "����" ����� ����������� �� 4-� ������
    , tmpContractGroup AS (SELECT tmpContract.JuridicalId
                               , tmpContract.ContractId_master
                               , tmpContract.ContractId_child
                               , tmpContract.InfoMoneyId_child
                               , tmpContract.PaidKindId_byBase
                               , tmpContract.ContractConditionId
                           FROM tmpContract
                           -- WHERE (tmpContract.PaidKindId = inPaidKindId OR inPaidKindId = 0)
                           --  AND (tmpContract.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                           GROUP BY tmpContract.JuridicalId
                                  , tmpContract.ContractId_master
                                  , tmpContract.ContractId_child
                                  , tmpContract.InfoMoneyId_child
                                  , tmpContract.PaidKindId_byBase
                                  , tmpContract.ContractConditionId
                          )

      -- ������ ContractId �� ������� ����� ������ "����"
    , tmpAccount AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId <> zc_Enum_AccountGroup_110000()) -- �������

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

    , tmpContainer1 AS (SELECT DISTINCT
                               tmpContainerAll.Id  AS ContainerId
                             , tmpContractGroup.JuridicalId
                             , tmpContractGroup.ContractId_master
                             , tmpContractGroup.ContractId_child
                             , tmpContractGroup.InfoMoneyId_child
                             , tmpContractGroup.PaidKindId_byBase
                             , tmpContractGroup.ContractConditionId
                             , ContainerLO_Branch.ObjectId      AS BranchId
                        FROM tmpContainerAll 
                            -- ����������� �� 4-� ������
                            JOIN tmpContractGroup ON tmpContractGroup.JuridicalId       = tmpContainerAll.JuridicalId 
                                                 AND tmpContractGroup.ContractId_child  = tmpContainerAll.ContractId
                                                 AND tmpContractGroup.InfoMoneyId_child = tmpContainerAll.InfoMoneyId
                                                 AND tmpContractGroup.PaidKindId_byBase = tmpContainerAll.PaidKindId
                            LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                          ON ContainerLO_Branch.ContainerId = tmpContainerAll.Id
                                                         AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                       -- WHERE COALESCE (ContainerLO_Branch.ObjectId,0) = inBranchId OR inBranchId = 0
                       )

     , tmpContainer AS (SELECT tmpContainer1.*
                             , 0 AS PartnerId    
                       FROM tmpContainer1
                       )

      , tmpMovementContALL AS (SELECT tmp.JuridicalId
                                    , tmp.ContractId_child
                                    , tmp.ContractId_master
                                    , tmp.InfoMoneyId_child
                                    , tmp.PaidKindId_byBase
                                    , tmp.ContractConditionId
                                    , tmp.BranchId
                                    , tmp.PartnerId
                                    , SUM (tmp.Sum_Sale)            AS Sum_Sale
                                    , SUM (tmp.Sum_SaleReturnIn)    AS Sum_SaleReturnIn
                                    , SUM (tmp.Sum_Account)         AS Sum_Account
                                    , SUM (tmp.Sum_AccountSendDebt) AS Sum_AccountSendDebt
                                    , SUM (tmp.Sum_Return)          AS Sum_Return -- �������
                                    , tmp.MovementDescId
                                    , tmp.MovementId
                                    , SUM (CASE WHEN tmp.Ord = 1 THEN tmp.Sale_AmountPartner_Weight ELSE 0 END)   AS Sale_AmountPartner_Weight
                                    , SUM (CASE WHEN tmp.Ord = 1 THEN tmp.Return_AmountPartner_Weight ELSE 0 END) AS Return_AmountPartner_Weight
                               FROM (SELECT tmpContainer.JuridicalId
                                          , tmpContainer.ContractId_child
                                          , tmpContainer.ContractId_master
                                          , tmpContainer.InfoMoneyId_child
                                          , tmpContainer.PaidKindId_byBase
                                          , tmpContainer.ContractConditionId

                                          , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) AS BranchId
                                          , CASE WHEN Object.DescId = zc_Object_Partner() THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
                                                 ELSE 0
                                            END    AS PartnerId
                                            -- ������ �������
                                          ,  (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN COALESCE(MIContainer.Amount,0) ELSE 0 END) AS Sum_Sale
                                            -- ������� - ��������
                                          ,  (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN COALESCE(MIContainer.Amount,0) ELSE 0 END) AS Sum_SaleReturnIn
                                            -- ������
                                          ,  (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())
                                                           THEN -1 * COALESCE (MIContainer.Amount, 0)
                                                      ELSE 0
                                                 END) AS Sum_Account
                                            -- ������ + �����������
                                          ,  (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                                           THEN -1 * COALESCE (MIContainer.Amount, 0)
                                                      ELSE 0
                                                 END) AS Sum_AccountSendDebt

                                          ,  (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN (-1)*COALESCE(MIContainer.Amount,0) ELSE 0 END) AS Sum_Return  -- �������
                                          , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementDescId ELSE 0 END  AS MovementDescId
                                          , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END      AS MovementId

                                          ,  (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN COALESCE(MIFloat_AmountPartner.ValueData,0) ELSE 0 END
                                               * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                                ) AS Sale_AmountPartner_Weight
                                               
                                          ,  (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE(MIFloat_AmountPartner.ValueData,0) ELSE 0 END
                                               * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                                                ) AS Return_AmountPartner_Weight
                                          
                                          , ROW_Number() OVER (PARTITION BY MIContainer.MovementItemId)  AS Ord --�������������� �� ���� ����� �� �������� ���-��
                                     FROM MovementItemContainer AS MIContainer
                                          JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId

                                          LEFT JOIN MovementItem ON MovementItem.Id = MIContainer.MovementItemId 
                                                                AND MovementItem.DescId = zc_MI_Master()
         
                                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                      ON MIFloat_AmountPartner.MovementItemId = MIContainer.MovementItemId
                                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
         
                                          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                               ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
         
                                          LEFT JOIN Object ON Object.Id = CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END
         
                                          -- ��� ���� �� �������� ������ �� ���������� �� ��������, �� ��������� 
                                          LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                               ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpContainer.ContractId_master
                                                              AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                                              AND tmpContainer.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()
                                          
                                          -- ��� ���� ��� ����� ������ �� ���������� �� �����������, �� ���������
                                          LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                               ON ObjectLink_Partner_PersonalTrade.ObjectId = CASE WHEN Object.DescId = zc_Object_Partner() THEN CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(),zc_Movement_Cash()) THEN MIContainer.ObjectId_Analyzer ELSE MIContainer.ObjectExtId_Analyzer END ELSE 0 END
                                                              AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                                              AND (tmpContainer.PaidKindId_byBase = zc_Enum_PaidKind_SecondForm()
                                                                  OR COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId,0) = 0 
                                                                  )
         
                                          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                               ON ObjectLink_Personal_PersonalServiceList.ObjectId = COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId, ObjectLink_Partner_PersonalTrade.ChildObjectId)
                                                              AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                                               ON ObjectLink_PersonalServiceList_Branch.ObjectId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                                              AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()
                                                              
                                     WHERE MIContainer.DescId = zc_MIContainer_Summ()
                                       AND (MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < vbEndDate)
                                       AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())  -- ����������� �������, ���� �� �� ����� �� ������
                                       AND (COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) = inBranchId OR inBranchId = 0)
                                     ) AS tmp
                               GROUP BY tmp.JuridicalId
                                      , tmp.ContractId_child
                                      , tmp.InfoMoneyId_child
                                      , tmp.PaidKindId_byBase
                                      , tmp.MovementDescId
                                      , tmp.MovementId
                                      , tmp.BranchId
                                      , tmp.PartnerId
                                      , tmp.ContractConditionId
                                      , tmp.ContractId_master
                              )

      , tmpMovementCont AS (SELECT tmpMovementContALL.* 
                            FROM tmpMovementContALL
                             INNER JOIN tmpContractPartner ON tmpContractPartner.ContractConditionId = tmpMovementContALL.ContractConditionId
                                                          AND tmpContractPartner.PaidKindId_byBase = tmpMovementContALL.PaidKindId_byBase
                                                          AND tmpContractPartner.PartnerId = tmpMovementContALL.PartnerId
                                                          AND tmpContractPartner.ContractId = tmpMovementContALL.ContractId_master
                            UNION 
                            SELECT tmpMovementContALL.*
                            FROM tmpMovementContALL
                            WHERE tmpMovementContALL.PartnerId = 0
                            )

      , tmpMovement AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.PartnerId
                             , tmpGroup.ContractId_child
                             , tmpGroup.ContractId_master
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId_byBase
                             , tmpGroup.ContractConditionId
                             , tmpGroup.BranchId
                             , tmpGroup.MovementId
                             , tmpGroup.MovementDescId
                             , tmpGroup.Sum_Sale
                             , tmpGroup.Sum_Return
                             , tmpGroup.Sum_SaleReturnIn
                             , tmpGroup.Sum_Account
                             , tmpGroup.Sum_AccountSendDebt
                             , tmpGroup.Sum_Sale_weight
                             , tmpGroup.Sum_ReturnIn_weight
                             --���������� % �������� ���� = ���� �������� / ���� �������� * 100
                             , CASE WHEN COALESCE (tmpGroup.Sum_Sale,0) <> 0 THEN tmpGroup.Sum_Return / tmpGroup.Sum_Sale * 100 ELSE 0 END AS PercentRetBonus_fact
                             , CASE WHEN COALESCE (tmpGroup.Sum_Sale_weight,0) <> 0 THEN tmpGroup.Sum_ReturnIn_weight / tmpGroup.Sum_Sale_weight * 100 ELSE 0 END AS PercentRetBonus_fact_weight
                        FROM 
                            (SELECT tmpGroup.JuridicalId
                                  , tmpGroup.PartnerId
                                  , tmpGroup.ContractId_master
                                  , tmpGroup.ContractId_child 
                                  , tmpGroup.InfoMoneyId_child
                                  , tmpGroup.PaidKindId_byBase
                                  , tmpGroup.ContractConditionId
                                  , tmpGroup.BranchId
                                  , tmpGroup.MovementId
                                  , tmpGroup.MovementDescId
                                  , SUM (tmpGroup.Sum_Sale)            AS Sum_Sale
                                  , SUM (tmpGroup.Sum_SaleReturnIn)    AS Sum_SaleReturnIn
                                  , SUM (tmpGroup.Sum_Account)         AS Sum_Account
                                  , SUM (tmpGroup.Sum_AccountSendDebt) AS Sum_AccountSendDebt
                                  , SUM (tmpGroup.Sum_Return)          AS Sum_Return
                                  , SUM (tmpGroup.Sale_AmountPartner_Weight)   AS Sum_Sale_weight
                                  , SUM (tmpGroup.Return_AmountPartner_Weight) AS Sum_ReturnIn_weight
                             FROM tmpMovementCont AS tmpGroup
                             WHERE tmpGroup.BranchId = inBranchId OR inBranchId = 0
                             GROUP BY tmpGroup.JuridicalId
                                    , tmpGroup.PartnerId
                                    , tmpGroup.ContractId_child
                                    , tmpGroup.InfoMoneyId_child
                                    , tmpGroup.PaidKindId_byBase
                                    , tmpGroup.ContractConditionId
                                    , tmpGroup.MovementId
                                    , tmpGroup.MovementDescId
                                    , tmpGroup.BranchId
                                    , tmpGroup.ContractId_master
                             ) AS tmpGroup
                       )
                       

           , tmpAll as(SELECT tmp.*
                       FROM (SELECT tmpContract.InvNumber_master
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
                                  , CASE WHEN tmpContract.ContractConditionKindID IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                    , zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt())
                                          AND tmpContract.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()
                                              THEN 0
                                         ELSE tmpMovement.PartnerId
                                    END AS PartnerId
                                  -- ��������� ������� �� b� ���.�������� �� �� �� ��������
                                  , tmpContract.PaidKindId                                 --tmpMovement.PaidKindId AS PaidKindId
                                  , tmpContract.PaidKindId_byBase  AS PaidKindId_child     -- �� �������� ����
                                  , tmpContract.ContractConditionKindId
                                  , tmpContract.BonusKindId
                                  , COALESCE (tmpContract.Value,0) AS Value
                                  , COALESCE (tmpContract.PercentRetBonus,0)            ::TFloat AS PercentRetBonus
                                  , COALESCE (tmpMovement.PercentRetBonus_fact,0)       ::TFloat AS PercentRetBonus_fact
                                  , COALESCE (tmpMovement.PercentRetBonus_fact_weight,0)::TFloat AS PercentRetBonus_fact_weight
      
                                  , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale()            THEN tmpMovement.Sum_Sale 
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn()      THEN tmpMovement.Sum_SaleReturnIn
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount()         THEN tmpMovement.Sum_Account
                                               WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt() THEN tmpMovement.Sum_AccountSendDebt
                                          ELSE 0 END  AS TFloat) AS Sum_CheckBonus
      
                                    -- ����� % �������� ���� ��������� % �������� ����, ����� �� ����������� 
                                  , CAST (CASE WHEN (COALESCE (tmpContract.PercentRetBonus,0) <> 0 AND tmpMovement.PercentRetBonus_fact_weight > tmpContract.PercentRetBonus) THEN 0 
                                               ELSE 
                                                  CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale()            THEN (tmpMovement.Sum_Sale            / 100 * tmpContract.Value)
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn()      THEN (tmpMovement.Sum_SaleReturnIn    / 100 * tmpContract.Value) 
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount()         THEN (tmpMovement.Sum_Account         / 100 * tmpContract.Value)
                                                       WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccountSendDebt() THEN (tmpMovement.Sum_AccountSendDebt / 100 * tmpContract.Value)
                                                  ELSE 0 END
                                          END  AS NUMERIC (16, 2)) AS Sum_Bonus
                                  , 0 :: TFloat                    AS Sum_BonusFact
                                  , 0 :: TFloat                    AS Sum_CheckBonusFact
                                  , 0 :: TFloat                    AS Sum_SaleFact
                                  , COALESCE (tmpMovement.Sum_Account,0)         AS Sum_Account
                                  , COALESCE (tmpMovement.Sum_AccountSendDebt,0) AS Sum_AccountSendDebt
                                  , COALESCE (tmpMovement.Sum_Sale,0)            AS Sum_Sale
                                  , COALESCE (tmpMovement.Sum_Return,0)          AS Sum_Return
                                  , COALESCE (tmpMovement.Sum_SaleReturnIn,0)    AS Sum_SaleReturnIn
                                  , COALESCE (tmpMovement.Sum_Sale_weight,0)     AS Sum_Sale_weight    
                                  , COALESCE (tmpMovement.Sum_ReturnIn_weight,0) AS Sum_ReturnIn_weight
                             
                                  , COALESCE (tmpContract.Comment, '')  AS Comment
                        
                                  , COALESCE (tmpMovement.MovementId,0) AS MovementId
                                  , tmpMovement.MovementDescId
                                  , COALESCE (tmpMovement.BranchId,0)   AS BranchId
                                  , CASE WHEN inSessiON = '5' THEN tmpContract.ContractConditionId ELSE 0 END AS ContractConditionId
                             FROM tmpContract
                                  INNER JOIN tmpMovement ON tmpMovement.JuridicalId       = tmpContract.JuridicalId
                                                        AND tmpMovement.ContractId_child  = tmpContract.ContractId_child
                                                        AND tmpMovement.InfoMoneyId_child = tmpContract.InfoMoneyId_child
                                                        AND tmpMovement.PaidKindId_byBase = tmpContract.PaidKindId_byBase
                                                        AND tmpMovement.ContractConditionId = tmpContract.ContractConditionId
                                                        AND tmpMovement.ContractId_master = tmpContract.ContractId_master
                                  LEFT JOIN tmpContractBonus ON tmpContractBonus.ContractId_master = tmpContract.ContractId_master
                                                            AND tmpContractBonus.ContractConditionId = tmpContract.ContractConditionId
      
                             ) AS tmp
                     UNION ALL 
                       SELECT View_Contract_InvNumber_master.InvNumber AS InvNumber_master
                            , View_Contract_InvNumber_child.InvNumber  AS InvNumber_child
                            , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find

                            , View_Contract_InvNumber_child.ContractTagName  AS ContractTagName_child
                            , View_Contract_InvNumber_child.ContractStateKindCode AS ContractStateKindCode_child

                            , MILinkObject_ContractMaster.ObjectId           AS ContractId_master  
                            , MILinkObject_ContractChild.ObjectId            AS ContractId_child            
                            , MILinkObject_Contract.ObjectId                 AS ContractId_find

                            , View_Contract_InvNumber_master.InfoMoneyId     AS InfoMoneyId_master
                            , View_Contract_InvNumber_child.InfoMoneyId      AS InfoMoneyId_child
                            , MILinkObject_InfoMoney.ObjectId                AS InfoMoneyId_find

                            , Object_Juridical.Id                            AS JuridicalId
                            --, CASE WHEN View_Contract_InvNumber_child.PaidKindId = zc_Enum_PaidKind_FirstForm() THEN 0 ELSE COALESCE (ObjectLink_Partner_Juridical.ObjectId,0) END AS PartnerId
                            , COALESCE (ObjectLink_Partner_Juridical.ObjectId,0) AS PartnerId
                            , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                            , View_Contract_InvNumber_child.PaidKindId       AS PaidKindId_child
                            , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                            , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                            , COALESCE (MIFloat_BonusValue.ValueData,0)      AS Value
                            , 0 ::TFloat                                     AS PercentRetBonus
                            , 0 ::TFloat                                     AS PercentRetBonus_fact
                            , 0 ::TFloat                                     AS PercentRetBonus_fact_weight

                            , 0 :: TFloat                                    AS Sum_CheckBonus
                            , 0 :: TFloat                                    AS Sum_Bonus
                            , MovementItem.Amount                            AS Sum_BonusFact
                            , MIFloat_Summ.ValueData                         AS Sum_CheckBonusFact
                            , MIFloat_AmountPartner.ValueData                AS Sum_SaleFact
                            , 0 :: TFloat                                    AS Sum_Account
                            , 0 :: TFloat                                    AS Sum_AccountSendDebt
                            , 0 :: TFloat                                    AS Sum_Sale
                            , 0 :: TFloat                                    AS Sum_Return
                            , 0 :: TFloat                                    AS Sum_SaleReturnIn

                            , 0 :: TFloat                                    AS Sum_Sale_weight    
                            , 0 :: TFloat                                    AS Sum_ReturnIn_weight
                            , COALESCE (MIString_Comment.ValueData,'')       AS Comment

                            , CASE WHEN inisMovement = TRUE THEN Movement.Id ELSE 0 END      AS MovementId
                            , CASE WHEN inisMovement = TRUE THEN Movement.DescId ELSE 0 END  AS MovementDescId
                            , COALESCE (MILinkObject_Branch.ObjectId,0)      AS BranchId
                            , 0 AS ContractConditionId
                     FROM Movement 
                            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            
                            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)

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

                            LEFT JOIN tmpContract_all  AS View_Contract_InvNumber_find   ON View_Contract_InvNumber_find.ContractId   = MILinkObject_Contract.ObjectId
                            LEFT JOIN tmpContract_all  AS View_Contract_InvNumber_master ON View_Contract_InvNumber_master.ContractId = MILinkObject_ContractMaster.ObjectId
                            LEFT JOIN tmpContract_full AS View_Contract_InvNumber_child  ON View_Contract_InvNumber_child.ContractId  = MILinkObject_ContractChild.ObjectId
           
                            --LEFT JOIN (SELECT tmpMovement.JuridicalId, MAX (tmpMovement.PartnerId) AS PartnerId FROM tmpMovement GROUP BY tmpMovement.JuridicalId) tmpInf ON tmpInf.JuridicalId = MovementItem.ObjectId 
                       WHERE Movement.DescId = zc_Movement_ProfitLossService()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND (Movement.OperDate >= inStartDate AND Movement.OperDate < vbEndDate)
                         AND MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501() -- ��������� + ������ �� ���������
                                                               , zc_Enum_InfoMoney_21502()) -- ��������� + ������ �� ������ �����
                         AND (Object_Juridical.Id = inJuridicalId OR inJuridicalId = 0)
                         AND (COALESCE (MILinkObject_Branch.ObjectId,0) = inBranchId OR inBranchId = 0)
                         -- AND MILinkObject_ContractConditionKind.ObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount(), zc_Enum_ContractConditionKind_BonusPercentSaleReturn(), zc_Enum_ContractConditionKind_BonusPercentSale())
                         

                     UNION ALL
                       SELECT tmpData.InvNumber_master   AS InvNumber_master
                            , tmpData.InvNumber_master   AS InvNumber_child
                            , tmpData.InvNumber_master   AS InvNumber_find

                            , '' ::TVarChar              AS ContractTagName_child
                            , 0                          AS ContractStateKindCode_child

                            , tmpData.ContractId_master  AS ContractId_master  
                            , tmpData.ContractId_master  AS ContractId_child            
                            , tmpData.ContractId_master  AS ContractId_find

                            , tmpData.InfoMoneyId_master AS InfoMoneyId_master
                            , tmpData.InfoMoneyId_child  AS InfoMoneyId_child
                            , 0                          AS InfoMoneyId_find

                            , tmpData.JuridicalId               AS JuridicalId
                            , 0                                 AS PartnerId
                            , tmpData.PaidKindId                AS PaidKindId
                            , tmpData.PaidKindId_ContractCondition AS PaidKindId_child
                            , tmpData.ContractConditionKindId   AS ContractConditionKindId
                            , tmpData.BonusKindId               AS BonusKindId
                            , COALESCE (tmpData.Value,0)        AS Value
                            , 0 ::TFloat                        AS PercentRetBonus
                            , 0 ::TFloat                        AS PercentRetBonus_fact
                            , 0 ::TFloat                        AS PercentRetBonus_fact_weight

                            , 0 :: TFloat                       AS Sum_CheckBonus
                            , COALESCE (tmpData.Value,0)        AS Sum_Bonus
                            , 0 :: TFloat                       AS Sum_BonusFact
                            , 0 :: TFloat                       AS Sum_CheckBonusFact
                            , 0 :: TFloat                       AS Sum_SaleFact
                            , 0 :: TFloat                       AS Sum_Account
                            , 0 :: TFloat                       AS Sum_AccountSendDebt
                            , 0 :: TFloat                       AS Sum_Sale
                            , 0 :: TFloat                       AS Sum_Return
                            , 0 :: TFloat                       AS Sum_SaleReturnIn

                            , 0 :: TFloat                       AS Sum_Sale_weight    
                            , 0 :: TFloat                       AS Sum_ReturnIn_weight
                            , COALESCE (tmpData.Comment,'')     AS Comment
                            , 0                                 AS MovementId
                            , 0                                 AS MovementDescId
                            , COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) AS BranchId

                            , 0 AS ContractConditionId

                       FROM tmpCCK_BonusMonthlyPayment AS tmpData
                            -- ��� ���� �� �������� ������ �� ���������� �� ��������, �� ��������� 
                            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                                 ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpData.ContractId_master
                                                AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                                --AND tmpContainer.PaidKindId_byBase = zc_Enum_PaidKind_FirstForm()
                            
                            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                 ON ObjectLink_Personal_PersonalServiceList.ObjectId = COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId, 0)
                                                AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                            LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                                 ON ObjectLink_PersonalServiceList_Branch.ObjectId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                                AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()
                       WHERE (COALESCE (ObjectLink_PersonalServiceList_Branch.ChildObjectId,0) = inBranchId OR inBranchId = 0)
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

                         , CASE WHEN COALESCE (tmpAll.PercentRetBonus,0) = 0 THEN tmpContract.PercentRetBonus ELSE tmpAll.PercentRetBonus END AS PercentRetBonus
                         , tmpAll.PercentRetBonus_fact
                         , tmpAll.PercentRetBonus_fact_weight
                         , tmpAll.Sum_CheckBonus
                         , tmpAll.Sum_CheckBonusFact
                         , tmpAll.Sum_Bonus
                         , tmpAll.Sum_BonusFact
                         , tmpAll.Sum_SaleFact
                         , tmpAll.Sum_Account
                         , tmpAll.Sum_AccountSendDebt
                         , tmpAll.Sum_Sale
                         , tmpAll.Sum_Return
                         , tmpAll.Sum_SaleReturnIn
                         , tmpAll.Sum_Sale_weight    
                         , tmpAll.Sum_ReturnIn_weight
                         , tmpAll.Comment 
                         , tmpAll.ContractConditionId
                    FROM (SELECT tmpAll.ContractId_master
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
                         , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmpAll.PartnerId ELSE 0 END AS PartnerId
                         , tmpAll.PaidKindId
                         , tmpAll.PaidKindId_child
                         , tmpAll.ContractConditionKindId
                         , tmpAll.BonusKindId
                         , tmpAll.MovementId
                         , tmpAll.MovementDescId
                         , tmpAll.BranchId
                         , tmpAll.Value

                         , MAX (tmpAll.PercentRetBonus)    AS PercentRetBonus
                         , MAX (tmpAll.PercentRetBonus_fact)        AS PercentRetBonus_fact
                         , MAX (tmpAll.PercentRetBonus_fact_weight) AS PercentRetBonus_fact_weight
                         , SUM (tmpAll.Sum_CheckBonus)      AS Sum_CheckBonus
                         , SUM (tmpAll.Sum_CheckBonusFact)  AS Sum_CheckBonusFact
                         , SUM (tmpAll.Sum_Bonus)           AS Sum_Bonus
                         , SUM (tmpAll.Sum_BonusFact)*(-1)  AS Sum_BonusFact
                         , SUM (tmpAll.Sum_SaleFact)        AS Sum_SaleFact
                         , SUM (tmpAll.Sum_Account)         AS Sum_Account
                         , SUM (tmpAll.Sum_AccountSendDebt) AS Sum_AccountSendDebt
                         , SUM (tmpAll.Sum_Sale)            AS Sum_Sale
                         , SUM (tmpAll.Sum_Return)          AS Sum_Return
                         , SUM (tmpAll.Sum_SaleReturnIn)    AS Sum_SaleReturnIn

                         , SUM (COALESCE (tmpAll.Sum_Sale_weight,0))     AS Sum_Sale_weight    
                         , SUM (COALESCE (tmpAll.Sum_ReturnIn_weight,0)) AS Sum_ReturnIn_weight

                         , MAX (tmpAll.Comment) :: TVarChar AS Comment
                         , tmpAll.ContractConditionId
                    FROM tmpAll
                    WHERE/* (tmpAll.Sum_CheckBonus <> 0
                       OR tmpAll.Sum_Bonus <> 0
                       OR tmpAll.Sum_BonusFact <> 0)
                      AND */(tmpAll.PaidKindId = inPaidKindId OR inPaidKindId = 0)
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
                            , CASE WHEN inPaidKindId = zc_Enum_PaidKind_SecondForm() THEN tmpAll.PartnerId ELSE 0 END
                            , tmpAll.PaidKindId
                            , tmpAll.ContractConditionKindId
                            , tmpAll.BonusKindId
                            , tmpAll.Value
                            , tmpAll.MovementId
                            , tmpAll.MovementDescId
                            , tmpAll.BranchId
                            , tmpAll.PaidKindId_child
                            , tmpAll.ContractConditionId
                    ) AS tmpAll
                         --���� ���� ������ ���� ���������� ������� ��������� ��-�� �� ��������
                         LEFT JOIN (SELECT tmpContract.JuridicalId
                                         , tmpContract.ContractId_child
                                         , tmpContract.InfoMoneyId_child
                                         , tmpContract.PaidKindId_byBase
                                         , MAX (COALESCE (tmpContract.PercentRetBonus,0)) AS PercentRetBonus
                                       FROM tmpContract 
                                       GROUP BY tmpContract.JuridicalId
                                              , tmpContract.ContractId_child
                                              , tmpContract.InfoMoneyId_child
                                              , tmpContract.PaidKindId_byBase
                                       ) AS tmpContract ON tmpContract.JuridicalId = tmpAll.JuridicalId
                                                       AND tmpContract.ContractId_child = tmpAll.ContractId_child
                                                       AND tmpContract.InfoMoneyId_child = tmpAll.InfoMoneyId_child
                                                       AND tmpContract.PaidKindId_byBase = tmpAll.PaidKindId_child
                                                       AND COALESCE (tmpAll.PercentRetBonus,0) = 0
                    WHERE (tmpAll.Sum_CheckBonus <> 0
                       OR tmpAll.Sum_Bonus <> 0
                       OR tmpAll.Sum_BonusFact <> 0)
                    )

      , tmpMovementParams AS (SELECT tmpMov.MovementId
                                   , MovementDesc.ItemName
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                                   , COALESCE (Object_From.Id, Object_MoneyPlace.Id)                AS FromId
                                   , COALESCE (Object_From.ValueData, Object_MoneyPlace.ValueData)  AS FromName
                                   , Object_To.Id                               AS ToId
                                   , Object_To.ValueData                        AS ToName
                                   , Object_PaidKind.Id                         AS PaidKindId
                                   , Object_PaidKind.ValueData                  AS PaidKindName

                                   , View_Contract_InvNumber.ContractId         AS ContractId
                                   , View_Contract_InvNumber.ContractCode       AS ContractCode
                                   , View_Contract_InvNumber.InvNumber          AS ContractName
                                   , View_Contract_InvNumber.ContractTagName    AS ContractTagName

                                   , MovementFloat_TotalCount.ValueData         AS TotalCount
                                   , MovementFloat_TotalCountPartner.ValueData  AS TotalCountPartner
                                   , CASE WHEN tmpMov.MovementDescId = zc_Movement_ReturnIn() THEN (-1) * MovementFloat_TotalSumm.ValueData 
                                          WHEN tmpMov.MovementDescId = zc_Movement_Sale() THEN MovementFloat_TotalSumm.ValueData
                                          WHEN tmpMov.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()) THEN MovementItem.Amount --MovementFloat_TotalSumm
                                     END AS TotalSumm
                              FROM (SELECT DISTINCT tmpData.MovementId, tmpData.MovementDescId FROM tmpData) AS tmpMov
                                  LEFT JOIN Movement ON Movement.Id = tmpMov.MovementId
                                  LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMov.MovementDescId
                                  LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                         ON MovementDate_OperDatePartner.MovementId = tmpMov.MovementId
                                                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END
                                  LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
                                  LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
 
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                               ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                              AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                  LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                  LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
                      
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                          ON MovementFloat_TotalCount.MovementId = Movement.Id
                                                         AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                                          ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                                         AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
                      
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                          ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                                  LEFT JOIN MovementFloat AS MovementFloat_AmountSumm
                                                          ON MovementFloat_AmountSumm.MovementId = Movement.Id
                                                         AND MovementFloat_AmountSumm.DescId = zc_MovementFloat_Amount()
                                                         AND tmpMov.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())

                                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND tmpMov.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash())

                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                   ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                  LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

                              WHERE inisMovement = TRUE
                              )

    , tmpObjectBonus AS (SELECT ObjectLink_Juridical.ChildObjectId             AS JuridicalId
                              , COALESCE (ObjectLink_Partner.ChildObjectId, 0) AS PartnerId
                              , Object_ReportBonus.Id                          AS Id
                              , Object_ReportBonus.isErased
                         FROM Object AS Object_ReportBonus
                              INNER JOIN ObjectDate AS ObjectDate_Month
                                                   ON ObjectDate_Month.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectDate_Month.DescId = zc_Object_ReportBonus_Month()
                                                  AND ObjectDate_Month.ValueData =  DATE_TRUNC ('MONTH', inEndDate)
                              LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                   ON ObjectLink_Juridical.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_Juridical.DescId = zc_ObjectLink_ReportBonus_Juridical()
                              LEFT JOIN ObjectLink AS ObjectLink_Partner
                                                   ON ObjectLink_Partner.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_Partner.DescId = zc_ObjectLink_ReportBonus_Partner()
                         WHERE Object_ReportBonus.DescId   = zc_Object_ReportBonus()
                           AND inPaidKindID                = zc_Enum_PaidKind_SecondForm()
                         --AND Object_ReportBonus.isErased = TRUE
                         )
      -- ���������
      SELECT  tmpMovementParams.OperDate        :: TDateTime AS OperDate_Movement
            , tmpMovementParams.OperDatePartner :: TDateTime AS OperDatePartner
            , tmpMovementParams.InvNumber                    AS InvNumber_Movement
            , tmpMovementParams.ItemName                     AS DescName_Movement
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
            , Object_Branch_inf.Id                          AS BranchId_inf
            , Object_Branch_inf.ValueData                   AS BranchName_inf

            , Object_Retail.ValueData                       AS RetailName
            , Object_Personal_View.PersonalCode             AS PersonalCode
            , Object_Personal_View.PersonalName             AS PersonalName
            , Object_Partner.Id                             AS PartnerId
            , Object_Partner.ValueData  ::TVarChar          AS PartnerName

            , CAST (tmpData.Value AS TFloat)                AS Value
            , CAST (tmpData.PercentRetBonus AS TFloat)      AS PercentRetBonus
            , CAST (tmpData.PercentRetBonus_fact AS TFloat) AS PercentRetBonus_fact
            , CAST (COALESCE (tmpData.PercentRetBonus_fact,0) - COALESCE (tmpData.PercentRetBonus, 0) AS TFloat) :: TFloat AS PercentRetBonus_diff

            , CAST (tmpData.PercentRetBonus_fact_weight AS TFloat) AS PercentRetBonus_fact_weight
            , CAST (COALESCE (tmpData.PercentRetBonus_fact_weight,0) - COALESCE (tmpData.PercentRetBonus, 0) AS TFloat) :: TFloat AS PercentRetBonus_diff_weight

            , CAST (tmpData.Sum_CheckBonus      AS TFloat) AS Sum_CheckBonus
            , CAST (tmpData.Sum_CheckBonusFact  AS TFloat) AS Sum_CheckBonusFact
            , CAST (tmpData.Sum_Bonus           AS TFloat) AS Sum_Bonus
            , CAST (tmpData.Sum_BonusFact       AS TFloat) AS Sum_BonusFact
            , CAST (tmpData.Sum_SaleFact        AS TFloat) AS Sum_SaleFact
            , CAST (tmpData.Sum_Account         AS TFloat) AS Sum_Account
            , CAST (tmpData.Sum_AccountSendDebt AS TFloat) AS Sum_AccountSendDebt
            , CAST (tmpData.Sum_Sale            AS TFloat) AS Sum_Sale
            , CAST (tmpData.Sum_Return          AS TFloat) AS Sum_Return
            , CAST (tmpData.Sum_SaleReturnIn    AS TFloat) AS Sum_SaleReturnIn

            , CAST (tmpData.Sum_Sale_weight     AS TFloat) AS Sum_Sale_weight
            , CAST (tmpData.Sum_ReturnIn_weight AS TFloat) AS Sum_ReturnIn_weight
            
            , tmpData.Comment :: TVarChar                 AS Comment
            
            , tmpObjectBonus.Id :: Integer AS ReportBonusId
            , CASE WHEN tmpObjectBonus.Id IS NULL OR tmpObjectBonus.isErased = True THEN TRUE ELSE FALSE END :: Boolean AS isSend

            , tmpMovementParams.FromName         :: TVarChar AS FromName_Movement
            , tmpMovementParams.ToName           :: TVarChar AS ToName_Movement
            , tmpMovementParams.PaidKindName     :: TVarChar AS PaidKindName_Movement
            , tmpMovementParams.ContractCode     :: TVarChar AS ContractCode_Movement
            , tmpMovementParams.ContractName     :: TVarChar AS ContractName_Movement
            , tmpMovementParams.ContractTagName  :: TVarChar AS ContractTagName_Movement
            , tmpMovementParams.TotalCount       :: TFloat   AS TotalCount_Movement
            , tmpMovementParams.TotalCountPartner:: TFloat   AS TotalCountPartner_Movement
            , tmpMovementParams.TotalSumm        :: TFloat   AS TotalSumm_Movement
            , tmpData.ContractConditionId        :: Integer  AS ContractConditionId
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

            LEFT JOIN tmpMovementParams ON tmpMovementParams.MovementId = tmpData.MovementId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpData.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            --��� �� ����� �� ��������
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                 ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpData.ContractId_master
                                AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                                AND tmpData.PaidKindId_child = zc_Enum_PaidKind_FirstForm()
            --LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId 
            --��� ��� ����� �� �����������          
            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = tmpData.PartnerId
                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                AND (tmpData.PaidKindId_child = zc_Enum_PaidKind_SecondForm()
                                   OR COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId,0) = 0
                                     )
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = COALESCE (ObjectLink_Partner_PersonalTrade.ChildObjectId, ObjectLink_Contract_PersonalTrade.ChildObjectId) 

            --���������� ������������ ������ �� ������������� ���������� ��
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Personal_View.UnitId
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch_inf ON Object_Branch_inf.Id = ObjectLink_Unit_Branch.ChildObjectId

            LEFT JOIN tmpObjectBonus ON tmpObjectBonus.JuridicalId = Object_Juridical.Id
                                    AND tmpObjectBonus.PartnerId   = COALESCE (Object_Partner.Id, 0)
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION lpreport_checkbonus2222(tdatetime, tdatetime, integer, integer, integer, boolean, tvarchar)
  OWNER TO admin;
