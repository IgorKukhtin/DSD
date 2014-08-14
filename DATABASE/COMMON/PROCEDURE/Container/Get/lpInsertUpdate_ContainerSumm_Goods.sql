-- Function: lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerSumm_Goods (
    IN inOperDate               TDateTime, 
    IN inUnitId                 Integer , 
    IN inCarId                  Integer , 
    IN inMemberId               Integer , 
    IN inBranchId               Integer , 
    IN inJuridicalId_basis      Integer , 
    IN inBusinessId             Integer , 
    IN inAccountId              Integer , 
    IN inInfoMoneyDestinationId Integer , 
    IN inInfoMoneyId            Integer , 
    IN inInfoMoneyId_Detail     Integer , 
    IN inContainerId_Goods      Integer , 
    IN inGoodsId                Integer , 
    IN inGoodsKindId            Integer , 
    IN inIsPartionSumm          Boolean , 
    IN inPartionGoodsId         Integer , 
    IN inAssetId                Integer
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     -- 10100 ������ �����
     IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)����� 3)!������ ������! 4)������ ���������� 5)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)��������� (��) 2)����� 3)!������ ������! 4)������ ���������� 5)������ ����������(����������� �/�)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inMemberId <> 0 THEN inMemberId ELSE inUnitId END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_5 := CASE WHEN inIsPartionSumm THEN inPartionGoodsId ELSE 0 END
                                                  );
                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)!�������������! 5)����� 6)!������ ������! 7)������ ���������� 8)������ ����������(����������� �/�)
                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)��������� (��) 5)����� 6)!������ ������! 7)������ ���������� 8)������ ����������(����������� �/�)
          /*PERFORM lpInsertFind_ObjectCost (inContainerId     := vbContainerId
                                         , inObjectCostDescId:= zc_ObjectCost_Basis()
                                         , inDescId_1   := zc_ObjectCostLink_Goods()
                                         , inObjectId_1 := inGoodsId
                                         , inDescId_2   := zc_ObjectCostLink_PartionGoods()
                                         , inObjectId_2 := CASE WHEN inIsPartionSumm THEN inPartionGoodsId ELSE 0 END
                                         , inDescId_3   := CASE WHEN inMemberId <> 0 THEN zc_ObjectCostLink_Member() ELSE zc_ObjectCostLink_Unit() END
                                         , inObjectId_3 := CASE WHEN inMemberId <> 0 AND inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inMemberId WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inUnitId ELSE 0 END
                                         , inDescId_4   := zc_ObjectCostLink_InfoMoneyDetail()
                                         , inObjectId_4 := inInfoMoneyId_Detail
                                         , inDescId_5   := zc_ObjectCostLink_InfoMoney()
                                         , inObjectId_5 := inInfoMoneyId
                                         , inDescId_6   := zc_ObjectCostLink_Account()
                                         , inObjectId_6 := inAccountId
                                         , inDescId_7   := zc_ObjectCostLink_JuridicalBasis()
                                         , inObjectId_7 := inJuridicalId_basis
                                         , inDescId_8   := zc_ObjectCostLink_Business()
                                         , inObjectId_8 := inBusinessId
                                         , inDescId_9   := zc_ObjectCostLink_Branch()
                                         , inObjectId_9 := inBranchId
                                          );*/
     ELSE
     -- 20100 �������� � ������� + 20400 ���
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20400())
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)����� 3)�������� ��������(��� �������� ��������� ���) 4)������ ���������� 5)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)��������� (��) 2)����� 3)�������� ��������(��� �������� ��������� ���) 4)������ ���������� 5)������ ����������(����������� �/�)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId WHEN inMemberId <> 0 THEN inMemberId ELSE inUnitId END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_5 := inAssetId
                                                  );
                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)!�������������! 5)����� 6)�������� ��������(��� �������� ��������� ���) 7)������ ���������� 8)������ ����������(����������� �/�)
                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)��������� (��) 5)����� 6)�������� ��������(��� �������� ��������� ���) 7)������ ���������� 8)������ ����������(����������� �/�)
          /*PERFORM lpInsertFind_ObjectCost (inContainerId     := vbContainerId
                                         , inObjectCostDescId:= zc_ObjectCost_Basis()
                                         , inDescId_1   := zc_ObjectCostLink_Goods()
                                         , inObjectId_1 := inGoodsId
                                         , inDescId_2   := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ObjectCostLink_Member() ELSE zc_ObjectCostLink_Unit() END
                                         , inObjectId_2 := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId WHEN inMemberId <> 0 AND inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inMemberId WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inUnitId ELSE 0 END
                                         , inDescId_3   := zc_ObjectCostLink_InfoMoneyDetail()
                                         , inObjectId_3 := inInfoMoneyId_Detail
                                         , inDescId_4   := zc_ObjectCostLink_InfoMoney()
                                         , inObjectId_4 := inInfoMoneyId
                                         , inDescId_5   := zc_ObjectCostLink_Account()
                                         , inObjectId_5 := inAccountId
                                         , inDescId_6   := zc_ObjectCostLink_JuridicalBasis()
                                         , inObjectId_6 := inJuridicalId_basis
                                         , inDescId_7   := zc_ObjectCostLink_Business()
                                         , inObjectId_7 := inBusinessId
                                         , inDescId_8   := zc_ObjectCostLink_Branch()
                                         , inObjectId_8 := inBranchId
                                         , inDescId_9   := zc_ObjectCostLink_AssetTo()
                                         , inObjectId_9 := inAssetId
                                          );*/
     ELSE
     -- 20200 ������ ��� + 20300 ����
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300())
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)��������� (��) 3)����� 4)!������ ������! 5)������ ���������� 6)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���������� 2)��������� (��) 3)����� 4)!������ ������! 5)������ ���������� 6)������ ����������(����������� �/�)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() ELSE zc_ObjectCostLink_Unit() END
                                                 , inObjectId_2 := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inUnitId ELSE 0 END
                                                 , inDescId_3   := zc_ObjectCostLink_Member()
                                                 , inObjectId_3 := CASE WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inMemberId ELSE 0 END
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_4 := inInfoMoneyId_Detail
                                                 , inDescId_5   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_5 := inInfoMoneyId
                                                 , inDescId_6   := zc_ObjectCostLink_PartionGoods()
                                                 , inObjectId_6 := inPartionGoodsId
                                                  );
                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)!�������������! 5)����� 6)�������� ��������(��� �������� ��������� ���) 7)������ ���������� 8)������ ����������(����������� �/�)
                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)��������� (��) 5)����� 6)�������� ��������(��� �������� ��������� ���) 7)������ ���������� 8)������ ����������(����������� �/�)
          /*PERFORM lpInsertFind_ObjectCost (inContainerId     := vbContainerId
                                         , inObjectCostDescId:= zc_ObjectCost_Basis()
                                         , inDescId_1   := zc_ObjectCostLink_Goods()
                                         , inObjectId_1 := inGoodsId
                                         , inDescId_2   := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() ELSE zc_ObjectCostLink_Unit() END
                                         , inObjectId_2 := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inUnitId ELSE 0 END
                                         , inDescId_3   := zc_ObjectCostLink_Member()
                                         , inObjectId_3 := CASE WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inMemberId ELSE 0 END
                                         , inDescId_4   := zc_ObjectCostLink_InfoMoneyDetail()
                                         , inObjectId_4 := inInfoMoneyId_Detail
                                         , inDescId_5   := zc_ObjectCostLink_InfoMoney()
                                         , inObjectId_5 := inInfoMoneyId
                                         , inDescId_6   := zc_ObjectCostLink_Account()
                                         , inObjectId_6 := inAccountId
                                         , inDescId_7   := zc_ObjectCostLink_JuridicalBasis()
                                         , inObjectId_7 := inJuridicalId_basis
                                         , inDescId_8   := zc_ObjectCostLink_Business()
                                         , inObjectId_8 := inBusinessId
                                         , inDescId_9   := zc_ObjectCostLink_Branch()
                                         , inObjectId_9 := inBranchId
                                         , inDescId_10  := zc_ObjectCostLink_PartionGoods()
                                         , inObjectId_10:= inPartionGoodsId
                                          );*/
     ELSE
     -- 20700 ������ + 20900 ���� + 30100 ��������� + 30200 ������ �����
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200())
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)����� 3)!!!������ ������!!! 4)���� ������� 5)������ ���������� 6)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)��������� (��) 2)����� 3)!!!������ ������!!! 4)���� ������� 5)������ ���������� 6)������ ����������(����������� �/�)
     THEN vbContainerId := CASE WHEN inPartionGoodsId <> 0
                                     THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                , inParentId          := inContainerId_Goods
                                                                , inObjectId          := inAccountId
                                                                , inJuridicalId_basis := inJuridicalId_basis
                                                                , inBusinessId        := inBusinessId
                                                                , inObjectCostDescId  := NULL
                                                                , inObjectCostId      := NULL
                                                                , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                                , inObjectId_1 := inGoodsId
                                                                , inDescId_2   := zc_ContainerLinkObject_PartionGoods()
                                                                , inObjectId_2 := inPartionGoodsId
                                                                , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                , inObjectId_3 := inInfoMoneyId_Detail
                                                                , inDescId_4   := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                                , inObjectId_4 := CASE WHEN inMemberId <> 0 THEN inMemberId ELSE inUnitId END
                                                                , inDescId_5   := zc_ContainerLinkObject_GoodsKind()
                                                                , inObjectId_5 := CASE WHEN inBranchId IN (0, zc_Branch_Basis()) THEN inGoodsKindId ELSE 0 END
                                                                , inDescId_6   := zc_ContainerLinkObject_InfoMoney()
                                                                , inObjectId_6 := inInfoMoneyId
                                                                 )
                                ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                           , inParentId          := inContainerId_Goods
                                                           , inObjectId          := inAccountId
                                                           , inJuridicalId_basis := inJuridicalId_basis
                                                           , inBusinessId        := inBusinessId
                                                           , inObjectCostDescId  := NULL
                                                           , inObjectCostId      := NULL
                                                           , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                           , inObjectId_1 := inGoodsId
                                                           , inDescId_2   := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                           , inObjectId_2 := CASE WHEN inMemberId <> 0 THEN inMemberId ELSE inUnitId END
                                                           , inDescId_3   := zc_ContainerLinkObject_GoodsKind()
                                                           , inObjectId_3 := CASE WHEN inBranchId IN (0, zc_Branch_Basis()) THEN inGoodsKindId ELSE 0 END
                                                           , inDescId_4   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                           , inObjectId_4 := inInfoMoneyId_Detail
                                                           , inDescId_5   := zc_ContainerLinkObject_InfoMoney()
                                                           , inObjectId_5 := inInfoMoneyId
                                                            )
                           END;
         /*IF inPartionGoodsId <> 0
         THEN         -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)������������� 5)����� 6)!!!������ ������!!! 7)���� ������� 8)������ ���������� 9)������ ����������(����������� �/�)
                      -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)��������� (��) 5)����� 6)!!!������ ������!!! 7)���� ������� 8)������ ���������� 9)������ ����������(����������� �/�)
              PERFORM lpInsertFind_ObjectCost (inContainerId     := vbContainerId
                                             , inObjectCostDescId:= zc_ObjectCost_Basis()
                                             , inDescId_1   := zc_ObjectCostLink_Goods()
                                             , inObjectId_1 := inGoodsId
                                             , inDescId_2   := zc_ObjectCostLink_PartionGoods()
                                             , inObjectId_2 := inPartionGoodsId
                                             , inDescId_3   := zc_ObjectCostLink_InfoMoneyDetail()
                                             , inObjectId_3 := inInfoMoneyId_Detail
                                             , inDescId_4   := CASE WHEN inMemberId <> 0 THEN zc_ObjectCostLink_Member() ELSE zc_ObjectCostLink_Unit() END
                                             , inObjectId_4 := CASE WHEN inMemberId <> 0 THEN inMemberId ELSE inUnitId END
                                             , inDescId_5   := zc_ObjectCostLink_GoodsKind()
                                             , inObjectId_5 := CASE WHEN inBranchId IN (0, zc_Branch_Basis()) THEN inGoodsKindId ELSE 0 END
                                             , inDescId_6   := zc_ObjectCostLink_InfoMoney()
                                             , inObjectId_6 := inInfoMoneyId
                                             , inDescId_7   := zc_ObjectCostLink_Account()
                                             , inObjectId_7 := inAccountId
                                             , inDescId_8   := zc_ObjectCostLink_JuridicalBasis()
                                             , inObjectId_8 := inJuridicalId_basis
                                             , inDescId_9   := zc_ObjectCostLink_Business()
                                             , inObjectId_9 := inBusinessId
                                             , inDescId_10  := zc_ObjectCostLink_Branch()
                                             , inObjectId_10:= inBranchId
                                              );
         ELSE         -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)������������� 5)����� 6)!!!������ ������!!! 7)���� ������� 8)������ ���������� 9)������ ����������(����������� �/�)
                      -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)��������� (��) 5)����� 6)!!!������ ������!!! 7)���� ������� 8)������ ���������� 9)������ ����������(����������� �/�)
              PERFORM lpInsertFind_ObjectCost (inContainerId     := vbContainerId
                                             , inObjectCostDescId:= zc_ObjectCost_Basis()
                                             , inDescId_1   := zc_ObjectCostLink_Goods()
                                             , inObjectId_1 := inGoodsId
                                             , inDescId_2   := CASE WHEN inMemberId <> 0 THEN zc_ObjectCostLink_Member() ELSE zc_ObjectCostLink_Unit() END
                                             , inObjectId_2 := CASE WHEN inMemberId <> 0 THEN inMemberId ELSE inUnitId END
                                             , inDescId_3   := zc_ObjectCostLink_GoodsKind()
                                             , inObjectId_3 := CASE WHEN inBranchId IN (0, zc_Branch_Basis()) THEN inGoodsKindId ELSE 0 END
                                             , inDescId_4   := zc_ObjectCostLink_InfoMoneyDetail()
                                             , inObjectId_4 := inInfoMoneyId_Detail
                                             , inDescId_5   := zc_ObjectCostLink_InfoMoney()
                                             , inObjectId_5 := inInfoMoneyId
                                             , inDescId_6   := zc_ObjectCostLink_Account()
                                             , inObjectId_6 := inAccountId
                                             , inDescId_7   := zc_ObjectCostLink_JuridicalBasis()
                                             , inObjectId_7 := inJuridicalId_basis
                                             , inDescId_8   := zc_ObjectCostLink_Business()
                                             , inObjectId_8 := inBusinessId
                                             , inDescId_9   := zc_ObjectCostLink_Branch()
                                             , inObjectId_9 := inBranchId
                                              );
         END IF;*/

     ELSE
     -- 20500 ��������� ����
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500())
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����� 2)������ ���������� 3)������ ����������(����������� �/�)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := NULL -- !!!�������� �������� �� ������� � ��������������!!!
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_2 := inInfoMoneyId_Detail
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_3 := inInfoMoneyId
                                                 , inDescId_4   := zc_ContainerLinkObject_Unit()
                                                 , inObjectId_4 := 0
                                                  );

                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)����� 4)������ ���������� 5)������ ����������(����������� �/�)
          /*PERFORM lpInsertFind_ObjectCost (inContainerId     := vbContainerId
                                         , inObjectCostDescId:= zc_ObjectCost_Basis()
                                         , inDescId_1   := zc_ObjectCostLink_Goods()
                                         , inObjectId_1 := inGoodsId
                                         , inDescId_2   := zc_ObjectCostLink_InfoMoneyDetail()
                                         , inObjectId_2 := inInfoMoneyId_Detail
                                         , inDescId_3   := zc_ObjectCostLink_InfoMoney()
                                         , inObjectId_3 := inInfoMoneyId
                                         , inDescId_4   := zc_ObjectCostLink_Account()
                                         , inObjectId_4 := inAccountId
                                         , inDescId_5   := zc_ObjectCostLink_JuridicalBasis()
                                         , inObjectId_5 := inJuridicalId_basis
                                         , inDescId_6   := zc_ObjectCostLink_Business()
                                         , inObjectId_6 := inBusinessId
                                         , inDescId_7   := zc_ObjectCostLink_Unit()
                                         , inObjectId_7 := 0
                                         , inDescId_8   := zc_ObjectCostLink_Branch()
                                         , inObjectId_8 := 0
                                          );*/

     -- !!!Other!!!
     ELSE                  -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)����� 3)������ ���������� 4)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)��������� (��) 2)����� 3)������ ���������� 4)������ ����������(����������� �/�)
          vbContainerId := lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inMemberId <> 0 THEN inMemberId ELSE inUnitId END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                  );
                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)!�������������! 5)����� 6)������ ���������� 7)������ ����������(����������� �/�)
                  -- <������� �/�>: 1.)������� �� ���� 2.)������ 3)������ 4)��������� (��) 5)����� 6)������ ���������� 7)������ ����������(����������� �/�)
          /*PERFORM lpInsertFind_ObjectCost (inContainerId     := vbContainerId
                                         , inObjectCostDescId:= zc_ObjectCost_Basis()
                                         , inDescId_1   := zc_ObjectCostLink_Goods()
                                         , inObjectId_1 := inGoodsId
                                         , inDescId_2   := CASE WHEN inMemberId <> 0 THEN zc_ObjectCostLink_Member() ELSE zc_ObjectCostLink_Unit() END
                                         , inObjectId_2 := CASE WHEN inMemberId <> 0 AND inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inMemberId WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inUnitId ELSE 0 END
                                         , inDescId_3   := zc_ObjectCostLink_InfoMoneyDetail()
                                         , inObjectId_3 := inInfoMoneyId_Detail
                                         , inDescId_4   := zc_ObjectCostLink_InfoMoney()
                                         , inObjectId_4 := inInfoMoneyId
                                         , inDescId_5   := zc_ObjectCostLink_Account()
                                         , inObjectId_5 := inAccountId
                                         , inDescId_6   := zc_ObjectCostLink_JuridicalBasis()
                                         , inObjectId_6 := inJuridicalId_basis
                                         , inDescId_7   := zc_ObjectCostLink_Business()
                                         , inObjectId_7 := inBusinessId
                                         , inDescId_8   := zc_ObjectCostLink_Branch()
                                         , inObjectId_8 := inBranchId
                                          );*/
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;

     -- ���������� ��������
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.08.14                                        * DELETE lpInsertFind_ObjectCost
 27.07.14                                        * add ����
 05.04.14                                        * ������� �������� ��� �����������
 18.03.14                                        * add zc_Enum_InfoMoneyDestination_30200
 21.12.13                                        * Personal -> Member
 11.10.13                                        * add zc_Enum_InfoMoneyDestination_20400
 30.09.13                                        * add inCarId
 20.09.13                                        * add zc_ObjectCostLink_Account
 19.09.13                                        * sort by optimize
 17.09.13                                        * CASE -> IF
 16.09.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_ContainerSumm_Goods ()