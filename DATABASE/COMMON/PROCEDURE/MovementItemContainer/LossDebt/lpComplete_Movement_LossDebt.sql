 -- Function: lpComplete_Movement_LossDebt (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LossDebt (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LossDebt(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbIsLossOnly Boolean;
BEGIN
     -- ��������
     IF inMovementId = 123096 -- � 15 �� 31.12.2013
     THEN
         RAISE EXCEPTION '������.�������� �� ����� ���� ��������.';
     END IF;

     -- ��������
     vbIsLossOnly:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) >= '01.01.2015';
     IF vbIsLossOnly = TRUE
        AND EXISTS (SELECT MovementItem.MovementId
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                     ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                         LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                       ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                      AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                      AND (MIFloat_Summ.ValueData <> 0 OR MIBoolean_Calculated.ValueData = TRUE)
                   )
     THEN
         RAISE EXCEPTION '������.� ��������� �������� <���� �����> ���������.';
     END IF;


     -- !!!�����������!!! �������� "������"
     UPDATE MovementItem SET isErased = TRUE
     FROM (SELECT MovementItem.Id
           FROM MovementItem
                INNER JOIN MovementItemBoolean AS MIBoolean_Calculated
                                               ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                              AND MIBoolean_Calculated.ValueData = TRUE
                LEFT JOIN MovementItemFloat AS MIFloat_Summ ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.isErased = FALSE 
             AND COALESCE (MIFloat_Summ.ValueData, 0) = 0
             AND vbIsLossOnly = FALSE -- !!!������ ���� �� ��������!!!
          ) AS tmp
     WHERE MovementItem.Id = tmp.Id;


     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- !!!�� ������ ��������������� ��������!!!
     UPDATE MovementItemLinkObject SET ObjectId = tmpUpdate.InfoMoneyId
     FROM (SELECT MovementItem.Id, View_Contract_InvNumber.InfoMoneyId
           FROM MovementItem
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
                LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
           WHERE MovementItem.MovementId = inMovementId 
             AND COALESCE (View_Contract_InvNumber.InfoMoneyId, 0) <> COALESCE (MILinkObject_InfoMoney.ObjectId, 0)
          ) AS tmpUpdate
     WHERE MovementItemLinkObject.MovementItemId = tmpUpdate.Id
       AND MovementItemLinkObject.DescId = zc_MILinkObject_InfoMoney()
       AND tmpUpdate.InfoMoneyId > 0;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     WITH tmpMovement AS (SELECT Movement.Id AS MovementId, Movement.OperDate, COALESCE (MovementLinkObject_Account.ObjectId, 0) AS AccountId, COALESCE (MovementLinkObject_PaidKind.ObjectId, zc_Enum_PaidKind_FirstForm()) AS PaidKindId
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Account
                                                            ON MovementLinkObject_Account.MovementId = Movement.Id
                                                           AND MovementLinkObject_Account.DescId = zc_MovementLinkObject_Account()
                                                           -- AND MovementLinkObject_Account.ObjectId = zc_Enum_Account_50401() -- ������� ������� �������� - ���������
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                          WHERE Movement.Id = inMovementId
                            AND Movement.DescId = zc_Movement_LossDebt()
                            AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                         )
        , tmpMovementItem AS (SELECT tmpMovement.OperDate
                                   , COALESCE (MovementItem.ObjectId, 0) AS ObjectId
                                     -- ��� ���� ��������� ��� 2-�� ����� � �� ���� ��������
                                   , CASE WHEN MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                                           AND View_Constant_isCorporate.InfoMoneyId IS NULL
                                           AND COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = FALSE
                                               THEN COALESCE (MILinkObject_Partner.ObjectId, 0)
                                          ELSE 0
                                     END AS PartnerId
                                   , CASE WHEN MIBoolean_Calculated.ValueData = TRUE THEN COALESCE (MIFloat_Summ.ValueData, 0) ELSE MovementItem.Amount END AS OperSumm
                                   , MovementItem.Id AS MovementItemId
                                   , tmpMovement.MovementId
                                   , 0 AS ContainerId                             -- ���������� �����
                                   , 0 AS AccountGroupId, 0 AS AccountDirectionId -- ���������� �����, ��� ...
                                   , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ���������
                                               -- MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502()) -- ������ �� ��������� + ������ �� ������ �����
                                               THEN tmpMovement.AccountId
                                          ELSE tmpMovement.AccountId -- 0
                                     END AS AccountId
                                   , tmpMovement.AccountId AS AccountId_main
                                     -- ������ ����
                                   , 0 AS ProfitLossGroupId
                                     -- ��������� ���� - �����������
                                   , 0 AS ProfitLossDirectionId
                                   -- �������������� ������ ����������
                                   , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                                   -- �������������� ����������
                                   , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                                   -- �������������� ������ ����������
                                   , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                                     -- ������: ���
                                   , 0  AS BusinessId
                                     -- ������� ��.����: ������ �� ��������
                                   , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, zc_Juridical_Basis()) AS JuridicalId_Basis
                                     -- ������������� (�������): ���
                                   , 0 AS UnitId
                                     -- ��� ���� ��������� ��� 2-�� ����� � �� ���� ��������
                                   , CASE WHEN MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                                           AND View_Constant_isCorporate.InfoMoneyId IS NULL
                                           AND COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = FALSE
                                               THEN COALESCE (MILinkObject_Branch.ObjectId, 0) -- !!! zc_Branch_Basis
                                          ELSE 0
                                     END AS BranchId
                                   , COALESCE (MILinkObject_Contract.ObjectId, 0)  AS ContractId
                                   , COALESCE (MILinkObject_PaidKind.ObjectId, 0)  AS PaidKindId
                                   , lpInsertFind_Object_PartionMovement (COALESCE (MIFloat_MovementId.ValueData, 0), NULL) AS PartionMovementId
                                   , MIBoolean_Calculated.ValueData AS isCalculated
                              FROM tmpMovement
                                   JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                   LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                               ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                               ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                              AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                                    ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                    ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                    ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                                    ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                                    ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                   LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                                 ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                                AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                   LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                                             AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
                                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                                           ON ObjectBoolean_isCorporate.ObjectId = MovementItem.ObjectId
                                                          AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
                                   LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                                        ON ObjectLink_Juridical_InfoMoney.ObjectId = MovementItem.ObjectId
                                                       AND ObjectLink_Juridical_InfoMoney.DescId   = zc_ObjectLink_Juridical_InfoMoney()
                                   LEFT JOIN Constant_InfoMoney_isCorporate_View AS View_Constant_isCorporate ON View_Constant_isCorporate.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
                             )
        , tmpListContainer AS (-- ��� ���������� - �� ������� ���� ���� ����� + ���� � ��������� + ��� ����� ������
                               SELECT Container.Id                               AS ContainerId
                                    , Container.Amount
                                    , tmpMovementItem.JuridicalId
                                    , COALESCE (ContainerLO_Partner.ObjectId, 0) AS PartnerId
                                    -- , COALESCE (ContainerLO_Branch.ObjectId, 0)  AS BranchId
                                    , tmpMovementItem.BranchId
                                    , tmpMovementItem.InfoMoneyId
                                    , tmpMovementItem.PaidKindId
                                    , tmpMovementItem.JuridicalId_Basis
                                    , tmpMovementItem.PartionMovementId
                                    , tmpMovementItem.BusinessId
                               FROM (SELECT ObjectId AS JuridicalId, InfoMoneyId, PaidKindId, JuridicalId_Basis, BranchId, BusinessId, PartionMovementId, AccountId FROM tmpMovementItem WHERE isCalculated = TRUE GROUP BY ObjectId, InfoMoneyId, PaidKindId, JuridicalId_Basis, BranchId, BusinessId, PartionMovementId, AccountId
                                    ) AS tmpMovementItem
                                    JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND ContainerLO_Juridical.ObjectId = tmpMovementItem.JuridicalId
                                    JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                             ON ContainerLO_InfoMoney.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                            AND ContainerLO_InfoMoney.ObjectId = tmpMovementItem.InfoMoneyId
                                    JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                             ON ContainerLO_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                            AND ContainerLO_PaidKind.ObjectId = tmpMovementItem.PaidKindId
                                    JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                             ON ContainerLO_JuridicalBasis.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                            AND ContainerLO_JuridicalBasis.ObjectId = tmpMovementItem.JuridicalId_Basis
                                    JOIN ContainerLinkObject AS ContainerLO_Business
                                                             ON ContainerLO_Business.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                            AND ContainerLO_Business.ObjectId = tmpMovementItem.BusinessId
                                    JOIN ContainerLinkObject AS ContainerLO_Branch
                                                             ON ContainerLO_Branch.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                                            AND (ContainerLO_Branch.ObjectId = tmpMovementItem.BranchId
                                                              OR tmpMovementItem.BranchId = 0)
                                    JOIN ContainerLinkObject AS ContainerLO_PartionMovement
                                                             ON ContainerLO_PartionMovement.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                                                            AND ContainerLO_PartionMovement.ObjectId = tmpMovementItem.PartionMovementId
                                    JOIN Container ON Container.Id = ContainerLO_Juridical.ContainerId
                                                  AND Container.DescId = zc_Container_Summ()
                                                  AND (Container.ObjectId = tmpMovementItem.AccountId
                                                    OR (tmpMovementItem.AccountId = 0 AND Container.ObjectId <> zc_Enum_Account_50401()) -- ������� ������� �������� - ���������
                                                      )
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                                                  ON ContainerLO_Partner.ContainerId = ContainerLO_Juridical.ContainerId
                                                                 AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                               WHERE vbIsLossOnly = FALSE -- !!!������ ���� �� ��������!!!
                                 /*AND ((ContainerLO_Branch.ObjectId IN (zc_Branch_Basis(), 0)
                                       AND tmpMovement.MovementId = 1110118  -- � 27 �� 31.12.2014
                                      ) OR tmpMovement.MovementId <> 1110118) -- � 27 �� 31.12.2014*/
                              UNION
                               -- ��� ���������� - �� ����� � ��������� + ��� ����� ������
                               SELECT Container.Id                               AS ContainerId
                                    , Container.Amount
                                    , ContainerLO_Juridical.ObjectId             AS JuridicalId
                                    , COALESCE (ContainerLO_Partner.ObjectId, 0) AS PartnerId
                                    , COALESCE (ContainerLO_Branch.ObjectId, 0)  AS BranchId
                                    , ContainerLO_InfoMoney.ObjectId             AS InfoMoneyId
                                    , ContainerLO_PaidKind.ObjectId              AS PaidKindId
                                    , ContainerLO_JuridicalBasis.ObjectId        AS JuridicalId_Basis
                                    , ContainerLO_PartionMovement.ObjectId       AS PartionMovementId
                                    , ContainerLO_Business.ObjectId              AS BusinessId
                               FROM tmpMovement
                                    JOIN Object_Account_View AS View_Account ON View_Account.AccountId = tmpMovement.AccountId
                                    -- JOIN Object_Account_View AS View_Account_find ON View_Account_find.AccountDirectionId = View_Account.AccountDirectionId
                                    JOIN Object_Account_View AS View_Account_find ON View_Account_find.AccountId = View_Account.AccountId
                                    JOIN Container ON Container.ObjectId = View_Account_find.AccountId
                                                  AND Container.DescId = zc_Container_Summ()
                                    JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                             ON ContainerLO_PaidKind.ContainerId = Container.Id
                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                            AND ContainerLO_PaidKind.ObjectId = tmpMovement.PaidKindId
                                    JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.ContainerId = Container.Id
                                                            AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                    JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                             ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                            AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                    JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                             ON ContainerLO_JuridicalBasis.ContainerId = Container.Id
                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                    JOIN ContainerLinkObject AS ContainerLO_Business
                                                             ON ContainerLO_Business.ContainerId = Container.Id
                                                            AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                                                  ON ContainerLO_Partner.ContainerId = Container.Id
                                                                 AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                                  ON ContainerLO_Branch.ContainerId = ContainerLO_Juridical.ContainerId
                                                                 AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionMovement
                                                                  ON ContainerLO_PartionMovement.ContainerId = Container.Id
                                                                 AND ContainerLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                               WHERE tmpMovement.AccountId <> 0
                                 AND vbIsLossOnly = FALSE -- !!!������ ���� �� ��������!!!
                                 AND ((ContainerLO_Branch.ObjectId IN (zc_Branch_Basis(), 0)
                                       AND tmpMovement.MovementId = 1110118  -- � 27 �� 31.12.2014
                                      )
                                   OR (ContainerLO_Branch.ObjectId IN (8378) -- ������
                                       AND tmpMovement.MovementId = 1374968 -- � 36 �� 31.12.2014
                                      )
                                   OR tmpMovement.MovementId NOT IN (1110118, 1374968) -- � 27 �� 31.12.2014 + � 36 �� 31.12.2014
                                     )
                              UNION
                               -- ��� ���������� - ��� ��� ����� ������, ���� ������ ����
                               SELECT Container.Id                               AS ContainerId
                                    , Container.Amount
                                    , ContainerLO_Juridical.ObjectId             AS JuridicalId
                                    , COALESCE (ContainerLO_Partner.ObjectId, 0) AS PartnerId
                                    , COALESCE (ContainerLO_Branch.ObjectId, 0)  AS BranchId
                                    , ContainerLO_InfoMoney.ObjectId             AS InfoMoneyId
                                    , ContainerLO_PaidKind.ObjectId              AS PaidKindId
                                    , ContainerLO_JuridicalBasis.ObjectId        AS JuridicalId_Basis
                                    , ContainerLO_PartionMovement.ObjectId       AS PartionMovementId
                                    , ContainerLO_Business.ObjectId              AS BusinessId
                               FROM (SELECT tmpMovement.PaidKindId
                                          , Object_Account_View.AccountId
                                     FROM tmpMovement
                                          INNER JOIN Object_Account_View ON Object_Account_View.AccountDirectionId NOT IN (zc_Enum_AccountDirection_30300() -- �������� �� �������
                                                                                                                         , zc_Enum_AccountDirection_70200() -- ��������� �� �������
                                                                                                                         , zc_Enum_AccountDirection_70300() -- ��������� �� ����������
                                                                                                                         , zc_Enum_AccountDirection_70400() -- ������������ ������
                                                                                                                          )
                                                                        AND Object_Account_View.AccountGroupId IN (zc_Enum_AccountGroup_30000() -- ��������
                                                                                                                 , zc_Enum_AccountGroup_70000() -- ���������
                                                                                                                 , zc_Enum_AccountGroup_80000() -- ������������
                                                                                                                 , zc_Enum_AccountGroup_90000() -- ������� � ��������
                                                                                                                  )
                                     WHERE tmpMovement.AccountId = 0
                                       AND tmpMovement.MovementId <> 123096  -- � 15 �� 31.12.2013
                                       AND tmpMovement.MovementId <> 1110118 -- � 27 �� 31.12.2014
                                       AND tmpMovement.MovementId <> 1374968 -- � 36 �� 31.12.2014
                                    ) AS tmpMovement
                                    JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                             ON ContainerLO_PaidKind.ObjectId = tmpMovement.PaidKindId
                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                    JOIN Container ON Container.Id = ContainerLO_PaidKind.ContainerId
                                                  AND Container.ObjectId = tmpMovement.AccountId
                                                  AND Container.DescId = zc_Container_Summ()

                                    JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.ContainerId = Container.Id
                                                            AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                    JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                             ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                            AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                    JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                             ON ContainerLO_JuridicalBasis.ContainerId = Container.Id
                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                    JOIN ContainerLinkObject AS ContainerLO_Business
                                                             ON ContainerLO_Business.ContainerId = Container.Id
                                                            AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                                                  ON ContainerLO_Partner.ContainerId = Container.Id
                                                                 AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                                  ON ContainerLO_Branch.ContainerId = ContainerLO_Juridical.ContainerId
                                                                 AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionMovement
                                                                  ON ContainerLO_PartionMovement.ContainerId = Container.Id
                                                                 AND ContainerLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                               WHERE vbIsLossOnly = FALSE -- !!!������ ���� �� ��������!!!
                              )
        , tmpContainerSumm AS (SELECT tmpListContainer.ContainerId
                                    , tmpListContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummRemainsEnd
                                    , tmpListContainer.JuridicalId
                                    , tmpListContainer.PartnerId
                                    , tmpListContainer.BranchId
                                    , tmpListContainer.InfoMoneyId
                                    , tmpListContainer.PaidKindId
                                    , tmpListContainer.JuridicalId_Basis
                                    , tmpListContainer.PartionMovementId
                                    , tmpListContainer.BusinessId
                               FROM tmpListContainer
                                    LEFT JOIN tmpMovement ON 1 = 1
                                    LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpListContainer.ContainerId
                                                                                  AND MIContainer.OperDate > tmpMovement.OperDate
                               GROUP BY tmpListContainer.ContainerId
                                      , tmpListContainer.Amount
                                      , tmpListContainer.JuridicalId
                                      , tmpListContainer.PartnerId
                                      , tmpListContainer.BranchId
                                      , tmpListContainer.InfoMoneyId
                                      , tmpListContainer.PaidKindId
                                      , tmpListContainer.JuridicalId_Basis
                                      , tmpListContainer.PartionMovementId
                                      , tmpListContainer.BusinessId
                               HAVING tmpListContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)  <> 0
                              )
        , tmpResult AS (SELECT tmpMovementItem.OperDate
                             , tmpMovementItem.ObjectId
                             , tmpMovementItem.PartnerId
                             , tmpMovementItem.BranchId
                             , CASE WHEN tmpMovementItem.isCalculated = TRUE
                                         THEN tmpMovementItem.OperSumm - COALESCE (tmpContainerSumm.SummRemainsEnd, 0)
                                    ELSE tmpMovementItem.OperSumm
                               END AS OperSumm
                             , tmpMovementItem.MovementItemId
                             , COALESCE (tmpContainerSumm.ContainerId, tmpMovementItem.ContainerId) AS ContainerId
                             , tmpMovementItem.AccountGroupId, tmpMovementItem.AccountDirectionId, tmpMovementItem.AccountId

                             , tmpMovementItem.ProfitLossGroupId
                             , tmpMovementItem.ProfitLossDirectionId
                             , tmpMovementItem.InfoMoneyGroupId
                             , tmpMovementItem.InfoMoneyDestinationId
                             , tmpMovementItem.InfoMoneyId
                             , tmpMovementItem.BusinessId
                             , tmpMovementItem.JuridicalId_Basis
                             , tmpMovementItem.UnitId
                             , tmpMovementItem.ContractId
                             , tmpMovementItem.PaidKindId
                             , tmpMovementItem.PartionMovementId
                        FROM tmpMovementItem
                             LEFT JOIN (SELECT tmpContainerSumm.*, ContainerLO_Contract.ObjectId AS ContractId
                                        FROM tmpContainerSumm
                                             JOIN ContainerLinkObject AS ContainerLO_Contract
                                                                      ON ContainerLO_Contract.ContainerId = tmpContainerSumm.ContainerId
                                                                     AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                       ) AS tmpContainerSumm ON tmpContainerSumm.JuridicalId       = tmpMovementItem.ObjectId
                                                            AND tmpContainerSumm.PartnerId         = tmpMovementItem.PartnerId
                                                            AND tmpContainerSumm.BranchId          = tmpMovementItem.BranchId
                                                            AND tmpContainerSumm.InfoMoneyId       = tmpMovementItem.InfoMoneyId
                                                            AND tmpContainerSumm.PaidKindId        = tmpMovementItem.PaidKindId
                                                            AND tmpContainerSumm.JuridicalId_Basis = tmpMovementItem.JuridicalId_Basis
                                                            AND tmpContainerSumm.BusinessId        = tmpMovementItem.BusinessId
                                                            AND tmpContainerSumm.ContractId        = tmpMovementItem.ContractId
                                                            AND tmpContainerSumm.PartionMovementId = tmpMovementItem.PartionMovementId
                      UNION ALL
                        SELECT tmpMovement.OperDate
                             , tmpContainerSumm.JuridicalId AS ObjectId
                             , tmpContainerSumm.PartnerId
                             , tmpContainerSumm.BranchId
                             , -1 * tmpContainerSumm.SummRemainsEnd AS OperSumm
                             , lpInsertUpdate_MovementItem_LossDebt (ioId                 := 0
                                                                   , inMovementId         := tmpMovement.MovementId
                                                                   , inJuridicalId        := tmpContainerSumm.JuridicalId
                                                                   , inPartnerId          := tmpContainerSumm.PartnerId
                                                                   , inBranchId           := tmpContainerSumm.BranchId
                                                                   , inAmount             := 0
                                                                   , inSumm               := 0
                                                                   , inIsCalculated       := TRUE
                                                                   , inContractId         := ContainerLO_Contract.ObjectId
                                                                   , inPaidKindId         := tmpContainerSumm.PaidKindId
                                                                   , inInfoMoneyId        := tmpContainerSumm.InfoMoneyId
                                                                   , inUnitId             := NULL
                                                                   , inUserId             := inUserId
                                                                    ) AS MovementItemId
                             , tmpContainerSumm.ContainerId
                             , 0 AS AccountGroupId, 0 AS AccountDirectionId -- ���������� �����, ��� ...
                             , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- ���������
                                         -- tmpContainerSumm.InfoMoneyId IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502()) -- ������ �� ��������� + ������ �� ������ �����
                                         THEN tmpMovement.AccountId
                                    ELSE tmpMovement.AccountId -- 0
                               END AS AccountId 

                               -- ������ ����
                             , 0 AS ProfitLossGroupId
                               -- ��������� ���� - �����������
                             , 0 AS ProfitLossDirectionId
                               -- �������������� ������ ����������
                             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                               -- �������������� ����������
                             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                               -- �������������� ������ ����������
                             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                               -- ������: ���
                             , 0  AS BusinessId
                             , tmpContainerSumm.JuridicalId_Basis
                               -- ������������� (�������): ���
                             , 0 AS UnitId
                             , ContainerLO_Contract.ObjectId AS ContractId
                             , tmpContainerSumm.PaidKindId
                             , tmpContainerSumm.PartionMovementId
                        FROM tmpContainerSumm
                             JOIN ContainerLinkObject AS ContainerLO_Contract
                                                      ON ContainerLO_Contract.ContainerId = tmpContainerSumm.ContainerId
                                                     AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                                     -- AND ContainerLO_Contract.ObjectId > 0
                             LEFT JOIN tmpMovement ON 1 = 1
                             LEFT JOIN tmpMovementItem
                                    ON tmpMovementItem.ObjectId          = tmpContainerSumm.JuridicalId
                                   AND tmpMovementItem.PartnerId         = tmpContainerSumm.PartnerId
                                   AND tmpMovementItem.BranchId          = tmpContainerSumm.BranchId
                                   AND tmpMovementItem.InfoMoneyId       = tmpContainerSumm.InfoMoneyId
                                   AND tmpMovementItem.PaidKindId        = tmpContainerSumm.PaidKindId 
                                   AND tmpMovementItem.JuridicalId_Basis = tmpContainerSumm.JuridicalId_Basis
                                   AND tmpMovementItem.BusinessId        = tmpContainerSumm.BusinessId
                                   AND tmpMovementItem.ContractId        = COALESCE (ContainerLO_Contract.ObjectId, 0) -- !!!�����, �.�. ����� ���� NULL!!!
                                   AND tmpMovementItem.PartionMovementId = tmpContainerSumm.PartionMovementId
                             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpContainerSumm.InfoMoneyId
                        WHERE tmpContainerSumm.SummRemainsEnd <> 0
                          AND tmpMovementItem.ObjectId IS NULL
                       )
     -- ������
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId
                         , IsActive, IsMaster
                          )
        SELECT zc_Movement_LossDebt() AS MovementDescId
             , tmpResult.OperDate
               -- "�������" ����� ��� ���������� ��� ��.����
             , CASE WHEN tmpResult.PartnerId <> 0
                         THEN tmpResult.PartnerId
                    ELSE tmpResult.ObjectId
               END AS ObjectId
             , CASE WHEN tmpResult.PartnerId <> 0
                         THEN zc_Object_Partner()
                    ELSE zc_Object_Juridical()
               END AS ObjectDescId
             , tmpResult.OperSumm
             , tmpResult.MovementItemId

             , tmpResult.ContainerId
             , tmpResult.AccountGroupId, tmpResult.AccountDirectionId, tmpResult.AccountId

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId -- �� ������������

             , tmpResult.InfoMoneyGroupId
             , tmpResult.InfoMoneyDestinationId
             , tmpResult.InfoMoneyId

               -- ������ ������
             , tmpResult.BusinessId AS BusinessId_Balance
               -- ������ ����: �� ������������
             , 0 AS BusinessId_ProfitLoss

               -- ������� ��.����
             , tmpResult.JuridicalId_Basis

             , 0 AS UnitId     -- �� ������������
             , 0 AS PositionId -- �� ������������

               -- ������ ������: (����� ��� ��� ������)
             , tmpResult.BranchId AS BranchId_Balance
               -- ������ ����: �� ������������
             , 0 AS BranchId_ProfitLoss

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , tmpResult.ContractId
             , tmpResult.PaidKindId

             , tmpResult.PartionMovementId

             , CASE WHEN tmpResult.OperSumm >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM tmpResult
        WHERE tmpResult.OperSumm <> 0
       UNION ALL
        SELECT zc_Movement_LossDebt() AS MovementDescId
             , tmpResult.OperDate
             -- , CASE WHEN tmpResult.OperDate < '01.06.2014' THEN zc_Enum_ProfitLoss_80301() ELSE 0 END AS ObjectId -- ������� � ������� + �������� ����������� ������������� + ���������
             , CASE WHEN tmpResult.OperDate < '01.01.2015' THEN zc_Enum_ProfitLoss_80301() ELSE 0 END AS ObjectId -- ������� � ������� + �������� ����������� ������������� + ���������
             , 0 AS ObjectDescId
             , -1 * tmpResult.OperSumm
             , tmpResult.MovementItemId

             , 0 AS ContainerId                                                     -- ���������� �����
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- ���������� �����, ��� ...

               -- ������ ���� (��� ������)
             , tmpResult.ProfitLossGroupId
               -- ��������� ���� - ����������� (��� ������)
             , CASE WHEN tmpResult.OperDate < '01.06.2014' THEN tmpResult.ProfitLossDirectionId ELSE zc_Enum_ProfitLossDirection_80300() END AS ProfitLossDirectionId -- �������� ����������� �������������

             , tmpResult.InfoMoneyGroupId
             , tmpResult.InfoMoneyDestinationId
             , tmpResult.InfoMoneyId

               -- ������ ������: �� ������������
             , 0 AS BusinessId_Balance
               -- ������ ����:
             , tmpResult.BusinessId

               -- ������� ��.����
             , tmpResult.JuridicalId_Basis

             , tmpResult.UnitId
             , 0 AS PositionId -- �� ������������

               -- ������ ������: �� ������������
             , 0 AS BranchId_Balance
               -- ������ ����:
             , tmpResult.BranchId

               -- ����� ����������: �� ������������
             , 0 AS ServiceDateId

             , 0 AS ContractId -- �� ������������
             , 0 AS PaidKindId -- �� ������������

             , 0 AS PartionMovementId -- �� ������������

             , CASE WHEN tmpResult.OperSumm >= 0 THEN FALSE ELSE TRUE END AS IsActive
             , FALSE AS IsMaster
        FROM tmpResult
        WHERE tmpResult.OperSumm <> 0
       ;

     -- ��������
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <����������� ����>.���������� ����������.';
     END IF;
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0 AND _tmpItem.IsMaster = TRUE AND 1=0)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� <� ���.>.���������� ����������.';
     END IF;
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <����� ������>.���������� ����������.';
     END IF;
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION '������.� ��������� �� ���������� <�� ������ ����������>.���������� ����������.';
     END IF;
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION '������.� <��������> �� ����������� <������� ����������� ����>.���������� ����������.<%><%>', lfGet_Object_ValueData ((SELECT MAX (ObjectId) FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = TRUE)), (SELECT MAX (ContractId) FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = TRUE);
     END IF;


     -- !!!5.0. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     UPDATE MovementItem SET Amount =  _tmpItem.OperSumm
     FROM _tmpItem
          JOIN MovementItemBoolean AS MIBoolean_Calculated
                                   ON MIBoolean_Calculated.MovementItemId = _tmpItem.MovementItemId
                                  AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                  AND MIBoolean_Calculated.ValueData = TRUE
     WHERE MovementItem.Id = _tmpItem.MovementItemId
       AND _tmpItem.IsMaster = TRUE
    ;

     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);


     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_LossDebt()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 07.09.14                                        * add BranchId
 31.08.14                                        * add PartnerId
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 20.04.14                                        * add HAVING ...
 20.03.14                                        * add !!!���������� �������!!!
 19.03.14                                        * add View_Account_find
 10.03.14                                        * add zc_Enum_Account_50401
 30.01.14                                        * all
 27.01.14         * 
*/
/*
SELECT Movement.Id, Movement.InvNumber, Movement.OperDate
     , COALESCE (MovementItem.ObjectId, 0) AS JuridicalId
     , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
     , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
     , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId
     , COALESCE (MILinkObject_Partner.ObjectId, 0) AS PartnerId
     , COALESCE (MILinkObject_Branch.ObjectId, 0) AS BranchId
     , min (MovementItem.Amount), max (MovementItem.Amount)
     , min (COALESCE (MIFloat_Summ.ValueData, 0))
     , max (COALESCE (MIFloat_Summ.ValueData, 0))
FROM Movement
     inner join MovementItem on MovementId = Movement.Id
                      AND MovementItem.isErased = FALSE
     left JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                     AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
     left JOIN MovementItemLinkObject AS MILinkObject_Contract
                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
     left JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                      ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                     AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
     left JOIN MovementItemLinkObject AS MILinkObject_Partner
                                      ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
     left JOIN MovementItemLinkObject AS MILinkObject_Branch
                                      ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
     LEFT JOIN MovementItemFloat AS MIFloat_Summ 
                                 ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
WHERE Movement.DescId = zc_Movement_LossDebt()
group by Movement.Id, Movement.InvNumber, Movement.OperDate
       , COALESCE (MovementItem.ObjectId, 0)
       , COALESCE (MILinkObject_InfoMoney.ObjectId, 0)
       , COALESCE (MILinkObject_Contract.ObjectId, 0)
       , COALESCE (MILinkObject_PaidKind.ObjectId, 0)
       , COALESCE (MILinkObject_Partner.ObjectId, 0)
       , COALESCE (MILinkObject_Branch.ObjectId, 0)
having count(*) >1
order by 3, 2
*/
-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_LossDebt (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
