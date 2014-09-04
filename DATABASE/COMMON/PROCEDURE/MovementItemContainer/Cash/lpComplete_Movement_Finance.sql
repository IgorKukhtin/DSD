-- Function: lpComplete_Movement_Finance (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Finance (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Finance(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS void
AS
$BODY$
BEGIN

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1 ������������ AccountDirectionId ��� �������� ��������� �����
     UPDATE _tmpItem SET AccountDirectionId =    CASE WHEN _tmpItem.AccountId <> 0
                                                           THEN _tmpItem.AccountDirectionId

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Founder()
                                                           THEN zc_Enum_AccountDirection_100400() -- ������� � �����������

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_BankAccount()
                                                           THEN zc_Enum_AccountDirection_40300() -- ���������� ����
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND ObjectLink_Cash_Branch.ChildObjectId IS NOT NULL
                                                           THEN zc_Enum_AccountDirection_40200() -- ����� ��������
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Cash() AND ObjectLink_Cash_Branch.ChildObjectId IS NULL
                                                           THEN zc_Enum_AccountDirection_40100() -- �����

                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Member()
                                                           THEN zc_Enum_AccountDirection_30500() -- ���������� (����������� ����)
                                                      WHEN _tmpItem.ObjectDescId = zc_Object_Personal()
                                                           THEN zc_Enum_AccountDirection_70500() -- ���������� �����

                                                      WHEN COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = TRUE
                                                           THEN zc_Enum_AccountDirection_30200() -- ���� ��������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                                                           THEN zc_Enum_AccountDirection_30200() -- ���� ��������

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30400() -- ������ ���������������
                                                           THEN zc_Enum_AccountDirection_30300() -- �������� �� �������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40700() -- ����
                                                           THEN zc_Enum_AccountDirection_30400() -- ������ ��������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- ������
                                                           THEN zc_Enum_AccountDirection_30100() -- ����������

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21400() -- ������ ����������
                                                           THEN zc_Enum_AccountDirection_70200() -- ������ ����������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- ���������
                                                           THEN zc_Enum_AccountDirection_70300() -- ���������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21600() -- ������������ ������
                                                           THEN zc_Enum_AccountDirection_70400() -- ������������ ������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000(), zc_Enum_InfoMoneyGroup_20000()) -- �������� �����; �������������
                                                           THEN zc_Enum_AccountDirection_70100() -- ����������

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70500() -- ���
                                                           THEN zc_Enum_AccountDirection_70900() -- ���
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000() -- ����������
                                                           THEN zc_Enum_AccountDirection_70800() -- ���������������� ��

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40100() -- ������� ������
                                                           THEN zc_Enum_AccountDirection_80100() -- ������� ������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40200() -- ������ �������
                                                           THEN zc_Enum_AccountDirection_80200() -- ������ �������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40400() -- �������� �� ��������
                                                           THEN zc_Enum_AccountDirection_80400() -- �������� �� ��������

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_40000() -- ���������� ������������
                                                           THEN zc_Enum_AccountDirection_30400() -- ������ ��������

                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50200() -- ��������� �������
                                                           THEN zc_Enum_AccountDirection_90100() -- ��������� �������
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50300() -- ��������� ������� (������)
                                                           THEN zc_Enum_AccountDirection_90200() -- ��������� ������� (������)
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50100() -- ��������� ������� �� ��
                                                           THEN zc_Enum_AccountDirection_90300() -- ��������� ������� �� ��
                                                      WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50400() -- ������ � ������*
                                                          THEN zc_Enum_AccountDirection_90400() -- ������ � ������*

                                                      -- WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner()) AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_80300() -- ������� � �����������
                                                      --     THEN zc_Enum_AccountDirection_100400() -- ������� � �����������
                                                 END
     FROM Object
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                               ON ObjectLink_Cash_Branch.ObjectId = Object.Id
                              AND ObjectLink_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
                              AND ObjectLink_Cash_Branch.ChildObjectId <> zc_Branch_Basis()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object.Id)
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object.Id)
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
          -- LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
     WHERE Object.Id = _tmpItem.ObjectId;

     -- 1.1.2. ������������ AccountGroupId ��� �������� ��������� �����
     UPDATE _tmpItem SET AccountGroupId = View_AccountDirection.AccountGroupId
     FROM Object_AccountDirection_View AS View_AccountDirection
     WHERE View_AccountDirection.AccountDirectionId = _tmpItem.AccountDirectionId;


     -- 1.1.3. ������������ ���� ��� �������� ��������� �����
     UPDATE _tmpItem SET AccountId = CASE WHEN _tmpItem.AccountId <> 0
                                               THEN _tmpItem.AccountId
                                          WHEN _tmpItem.ObjectDescId = 0
                                               THEN zc_Enum_Account_100301() -- ������� �������� �������
                                          WHEN _tmpItem.ObjectDescId IN (zc_Object_BankAccount(), zc_Object_Cash()) AND IsMaster = FALSE
                                               THEN zc_Enum_Account_110301() -- ������� + ��������� ���� + �����

                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_100400() -- ������� � �����������
                                               THEN zc_Enum_Account_100401() -- ������� � �����������

                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_30200() -- ���� ��������
                                               THEN CASE (SELECT ObjectLink.ChildObjectId AS InfoMoneyId
                                                          FROM ObjectLink
                                                          WHERE ObjectLink.ObjectId = (SELECT ObjectLink.ChildObjectId AS JuridicalId FROM ObjectLink WHERE ObjectLink.ObjectId = (SELECT Object.Id FROM Object WHERE Object.Id = _tmpItem.ObjectId AND Object.DescId = zc_Object_Partner())
                                                                                                                                                        AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                      UNION
                                                                                       SELECT Object.Id AS JuridicalId FROM Object WHERE Object.Id = _tmpItem.ObjectId AND Object.DescId = zc_Object_Juridical()
                                                                                      )
                                                            AND ObjectLink.DescId = zc_ObjectLink_Juridical_InfoMoney()
                                                         )
                                                         WHEN zc_Enum_InfoMoney_20801()
                                                              THEN zc_Enum_Account_30201() -- ����
                                                         WHEN zc_Enum_InfoMoney_20901()
                                                              THEN zc_Enum_Account_30202() -- ����
                                                         WHEN zc_Enum_InfoMoney_21001()
                                                              THEN zc_Enum_Account_30203() -- �����
                                                         WHEN zc_Enum_InfoMoney_21101()
                                                              THEN zc_Enum_Account_30204() -- �������
                                                         WHEN zc_Enum_InfoMoney_21151()
                                                              THEN zc_Enum_Account_30205() -- �������-���������
                                                    END
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40300() AND _tmpItem.ObjectId = 76977 -- ���������� ���� AND 26009000250571 ���� "Բ������"
                                               THEN zc_Enum_Account_40302() -- ���������� ���������
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40300() -- ���������� ����
                                               THEN zc_Enum_Account_40301() -- ���������� ����
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40200() -- ����� ��������
                                               THEN zc_Enum_Account_40201() -- ����� ��������
                                          WHEN _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_40100() -- �����
                                               THEN zc_Enum_Account_40101() -- �����

                                          ELSE lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem.AccountGroupId
                                                                          , inAccountDirectionId     := _tmpItem.AccountDirectionId
                                                                          , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                          , inInfoMoneyId            := NULL
                                                                          , inInsert                 := CASE WHEN 1=0
                                                                                                              AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40700() -- ����
                                                                                                              AND _tmpItem.AccountDirectionId = zc_Enum_AccountDirection_30400() -- ������ ��������
                                                                                                                 THEN TRUE
                                                                                                             ELSE FALSE
                                                                                                        END
                                                                          , inUserId                 := inUserId
                                                                           )
                                     END;

     IF EXISTS (SELECT AccountId FROM _tmpItem WHERE COALESCE (AccountId, 0) = 0)
     THEN
         RAISE EXCEPTION '������.���� �� ���������.�������� � <%> (%)', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), inMovementId;
     END IF;

     -- 1.2.1. ������������ ProfitLossDirectionId ��� �������� ��������� ����� �� ����� �������
     UPDATE _tmpItem SET ProfitLossDirectionId = CASE WHEN _tmpItem.ProfitLossDirectionId <> 0
                                                           THEN _tmpItem.ProfitLossDirectionId -- ���� ��� ��� ���������

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- ���������
                                                       AND _tmpItem.UnitId = 0
                                                           THEN zc_Enum_ProfitLossDirection_11100() -- ��������� �������� ������������ + ���������

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30400() -- ������ ���������������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40500() -- �����
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40600() -- ��������
                                                           THEN zc_Enum_ProfitLossDirection_70200() -- �������������� ������� + ������

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40400() -- �������� �� ��������
                                                        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40700() -- ����
                                                           THEN zc_Enum_ProfitLossDirection_80100() -- ������� � ������� + ���������� ������������

                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50100() -- ��������� ������� �� ��
                                                           THEN zc_Enum_ProfitLossDirection_50400() -- ��������� ������� �� ��
                                                      WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50201() -- ����� �� �������
                                                           THEN zc_Enum_ProfitLossDirection_50100() -- ����� �� �������
                                                      WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50202() -- ���
                                                           THEN zc_Enum_ProfitLossDirection_50200() -- ���
                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50300() -- ��������� ������� (������)
                                                           THEN zc_Enum_ProfitLossDirection_50300() -- ��������� ������� (������)
                                                      WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_50400() -- ������ � ������
                                                           THEN zc_Enum_ProfitLossDirection_50500() -- ������ � ������

                                                      ELSE _tmpItem.ProfitLossDirectionId
                                                 END
                       , ObjectId = CASE WHEN _tmpItem.ObjectId <> 0 
                                              THEN _tmpItem.ObjectId -- ���� ��� ��� ���������

                                         WHEN _tmpItem.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- ������
                                              THEN zc_Enum_ProfitLoss_10301() -- ��������� �������� ������������ + ������ �������������� + ���������

                                         WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21500() -- ���������
                                          AND _tmpItem.UnitId = 0
                                              THEN zc_Enum_ProfitLoss_11101() -- ��������� �������� ������������ + ��������� + ���������

                                         WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50201() -- ����� �� �������
                                              THEN zc_Enum_ProfitLoss_50101() -- ������ + ����� �� ������� + ����� �� �������

                                         WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_50202() -- ���
                                              THEN zc_Enum_ProfitLoss_50201() -- ������ + ��� + ���

                                         ELSE _tmpItem.ObjectId
                                    END
                      , IsActive = FALSE -- !!!������ �� �������!!!
     WHERE _tmpItem.AccountId = zc_Enum_Account_100301(); -- ������� �������� �������

     -- 1.2.2. ������������ ProfitLossGroupId ��� �������� ��������� ����� �� ����� �������
     UPDATE _tmpItem SET ProfitLossGroupId = View_ProfitLossDirection.ProfitLossGroupId
     FROM Object_ProfitLossDirection_View AS View_ProfitLossDirection
     WHERE View_ProfitLossDirection.ProfitLossDirectionId = _tmpItem.ProfitLossDirectionId;

     -- ��� �����
     -- return;

     -- 1.2.3. ������������ ObjectId ��� �������� ��������� ����� �� ����� �������
     UPDATE _tmpItem SET ObjectId = lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem.ProfitLossGroupId
                                                                  , inProfitLossDirectionId  := _tmpItem.ProfitLossDirectionId
                                                                  , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                  , inInfoMoneyId            := NULL
                                                                  , inInsert                 := FALSE
                                                                  , inUserId                 := inUserId
                                                                   )
     WHERE _tmpItem.AccountId = zc_Enum_Account_100301() -- ������� �������� �������
       AND _tmpItem.ObjectId = 0
    ;

     -- 2. ������������ ContainerId ��� �������� ��������� �����
     UPDATE _tmpItem SET ContainerId = CASE WHEN _tmpItem.ContainerId <> 0
                                                 THEN _tmpItem.ContainerId
                                            WHEN _tmpItem.AccountId = zc_Enum_Account_110301() -- ������� + ��������� ���� + �����
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_InfoMoney() -- CASE WHEN _tmpItem.ObjectDescId = zc_Object_BankAccount() THEN zc_ContainerLinkObject_BankAccount() WHEN _tmpItem.ObjectDescId = zc_Object_Cash() THEN zc_ContainerLinkObject_Cash() ELSE -1 END
                                                                            , inObjectId_1        := _tmpItem.InfoMoneyId -- _tmpItem.ObjectId
                                                                             )
                                            WHEN _tmpItem.AccountGroupId = zc_Enum_AccountGroup_40000() -- �������� ��������
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := CASE WHEN _tmpItem.AccountDirectionId IN (zc_Enum_AccountDirection_40100(), zc_Enum_AccountDirection_40200()) THEN zc_ContainerLinkObject_Cash() ELSE zc_ContainerLinkObject_BankAccount() END
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                             )
                                            WHEN _tmpItem.AccountId = zc_Enum_Account_100301() -- ������� �������� �������
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                             )
                                            WHEN _tmpItem.ObjectDescId = zc_Object_Founder() -- ����������
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Founder()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                             )
                                            WHEN _tmpItem.ObjectDescId = zc_Object_Member() -- ��������
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Member()
                                                                            , inObjectId_1        := _tmpItem.ObjectId
                                                                            , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_2        := _tmpItem.InfoMoneyId
                                                                            , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                                            , inObjectId_3        := CASE WHEN _tmpItem.BranchId <> 0 THEN _tmpItem.BranchId ELSE zc_Branch_Basis() END
                                                                            , inDescId_4          := zc_ContainerLinkObject_Car()
                                                                            , inObjectId_4        := 0 -- ��� ���.���� (����������� ����) !!!������ ����� ��������� ��������� ������ �������� = 0!!!
                                                                             )
                                            WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner())
                                             AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- ������ �����
                                                      -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ���������� 5)������ ���������
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                            , inObjectId_1        := CASE WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() THEN _tmpItem.ObjectId ELSE (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = _tmpItem.ObjectId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()) END
                                                                            , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                            , inObjectId_2        := _tmpItem.ContractId
                                                                            , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_3        := _tmpItem.InfoMoneyId
                                                                            , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                            , inObjectId_4        := _tmpItem.PaidKindId
                                                                            , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                            , inObjectId_5        := 0 -- !!!�� ���� ��������� ���� ���� �� �����!!!
                                                                            , inDescId_6          := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN zc_ContainerLinkObject_Partner() ELSE NULL END -- and <> ���� ��������
                                                                            , inObjectId_6        := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN _tmpItem.ObjectId ELSE NULL END -- and <> ���� ��������
                                                                             )
                                            WHEN _tmpItem.ObjectDescId IN (zc_Object_Juridical(), zc_Object_Partner())
                                                      -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                                                 THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := _tmpItem.AccountId
                                                                            , inJuridicalId_basis := _tmpItem.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpItem.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                            , inObjectId_1        := CASE WHEN _tmpItem.ObjectDescId = zc_Object_Juridical() THEN _tmpItem.ObjectId ELSE (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = _tmpItem.ObjectId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()) END
                                                                            , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                            , inObjectId_2        := _tmpItem.ContractId
                                                                            , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_3        := _tmpItem.InfoMoneyId
                                                                            , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                            , inObjectId_4        := _tmpItem.PaidKindId
                                                                            , inDescId_6          := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN zc_ContainerLinkObject_Partner() ELSE NULL END -- and <> ���� ��������
                                                                            , inObjectId_6        := CASE WHEN _tmpItem.PaidKindId = zc_Enum_PaidKind_SecondForm() AND _tmpItem.AccountDirectionId <> zc_Enum_AccountDirection_30200() THEN _tmpItem.ObjectId ELSE NULL END -- and <> ���� ��������
                                                                             )
                                       END;


     -- 3. ����������� �������� 
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, _tmpItem.MovementDescId, inMovementId, _tmpItem.MovementItemId, _tmpItem.ContainerId, 0 AS ParentId
            , _tmpItem.OperSumm
            , _tmpItem.OperDate
            , _tmpItem.IsActive
       FROM _tmpItem;


     -- 4. ����������� �������� ��� ������
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := _tmpItem.MovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem.MovementItemId
                                              , inActiveContainerId  := _tmpItem.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem.PassiveAccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                              )
                                              , inAmount   := _tmpItem.OperSumm
                                              , inOperDate := _tmpItem.OperDate
                                               )
     FROM (SELECT _tmpItem_Active.MovementDescId
                , _tmpItem_Active.MovementItemId
                , _tmpItem_Active.OperSumm, _tmpItem_Active.OperDate
                , _tmpItem_Active.ContainerId AS ActiveContainerId
                , _tmpItem_Active.AccountId AS ActiveAccountId
                , COALESCE (_tmpItem_Passive_SendDebt.ContainerId, _tmpItem_Passive.ContainerId) AS PassiveContainerId
                , COALESCE (_tmpItem_Passive_SendDebt.AccountId, _tmpItem_Passive.AccountId) AS PassiveAccountId
           FROM _tmpItem AS _tmpItem_Active
                LEFT JOIN _tmpItem AS _tmpItem_Passive ON _tmpItem_Passive.OperSumm < 0 AND _tmpItem_Passive.MovementItemId = _tmpItem_Active.MovementItemId
                LEFT JOIN Movement ON Movement.Id = inMovementId
                LEFT JOIN _tmpItem AS _tmpItem_Passive_SendDebt ON _tmpItem_Passive_SendDebt.OperSumm < 0 AND Movement.DescId = zc_Movement_SendDebt()
           WHERE _tmpItem_Active.OperSumm > 0
          ) AS _tmpItem
    ;


     -- !!!5. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, tmp.BranchId)
     FROM (SELECT _tmpItem.MovementItemId, _tmpItem.BranchId
           FROM _tmpItem
           WHERE AccountId = zc_Enum_Account_100301() -- 100301; "������� �������� �������"
          ) AS tmp;


     -- 6. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.09.14                                        * add zc_ContainerLinkObject_Branch
 03.09.14                                        * add zc_Object_Founder
 30.08.14                                        * add zc_ContainerLinkObject_Partner
 17.08.14                                        * add MovementDescId
 19.07.14                                        * modify zc_Enum_Account_40302
 11.05.14                                        * set zc_ContainerLinkObject_PaidKind is last
 04.05.14                                        * add zc_Enum_Account_40302
 04.05.14                                        * change zc_Enum_AccountDirection_30100
 19.04.14                                        * del zc_Enum_InfoMoneyDestination_40900
 04.04.14                                        * add �������-���������
 10.03.14                                        * add no calc AccountId
 28.01.14                                        * add zc_Movement_SendDebt
 24.01.14                                        * add zc_Enum_InfoMoneyDestination_40900
 22.01.14                                        * add IsMaster
 29.12.13                                        *
 26.12.13                                        *
*/

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_Cash (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
