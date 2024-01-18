-- Function: lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerSumm_Goods (
    IN inOperDate               TDateTime,
    IN inUnitId                 Integer ,
    IN inCarId                  Integer ,
    IN inMemberId               Integer ,
    IN inBranchId               Integer , -- ��� ��������� ����� ��� �������
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

IF inGoodsId = 640655 AND inAccountId = 9091 -- "20202 ������ �����"
THEN inAccountId:= 9095; -- 20206 ������ ���������
     inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_20600();
     inInfoMoneyId            := 8926; -- 20601;"������ ���������"

END IF;
IF inGoodsId = 640655 AND inAccountId = 9099 -- 20402;"������ �����"
THEN inAccountId:= 9100; -- 20403;"������ ���������"
     inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_20600();
     inInfoMoneyId            := 8926; -- 20601;"������ ���������"

END IF;



     -- 1.0. - 70000 ����������: ����������� ���������� + ����������� ������ + ������������ ���������� + ����������� �������������
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_70100(), zc_Enum_InfoMoneyDestination_70200(), zc_Enum_InfoMoneyDestination_70300(), zc_Enum_InfoMoneyDestination_70400()
                                    )
    AND inPartionGoodsId <> 0
     THEN
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)�������������  2)����� ��� �� 3)������ ������ 4)�������� �������� (��� �������� ��������� �� ��� ���) 5)������ ���������� 6)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���. ���� (��) 2)����� ��� �� 3)������ ������ 4)�������� �������� (��� �������� ��������� �� ��� ���) 5)������ ���������� 6)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������     2)����� ��� �� 3)������ ������ 4)�������� �������� (��� �������� ��������� �� ��� ���) 5)������ ���������� 6)������ ����������(����������� �/�)
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_5 := inPartionGoodsId
                                                 , inDescId_6   := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_6 := inAssetId
                                                  );

     ELSE
     -- 1.1. - 10100 ������ �����
     IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
     THEN 
          -- IF 1=1 THEN inGoodsKindId:= 0; END IF;

          -- ������ ��� ��� ��������� + ��� �/� + ��� ����������� + ��� ������� + ���� ������ �������� + ���� ��� ���������
          IF inOperDate < '01.01.2024' AND inUnitId IN (8447    -- ��� ��������� ������
                                                      , 8449    -- ��� ������������ ������
                                                      , 8448    -- ĳ������ ���������
                                                      , 2790412 -- ��� �������
                                                        --
                                                      , 8020711 -- ��� ��������� (����)
                                                      , 8020708 -- ����� ��������� (����)
                                                      , 8020709 -- ����� ���������� (����)
                                                      , 8020710 -- ������� ������� ����� (����)
                                                       )
          THEN inGoodsKindId:= 0;
          END IF;

          -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)�������������  2)����� 3)!������ ������! 4)������ ���������� 5)������ ����������(����������� �/�) 6)��� ������ - �� ������
          -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���. ���� (��) 2)����� 3)!������ ������! 4)������ ���������� 5)������ ����������(����������� �/�) 6)��� ������ - �� ������
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_5 := inPartionGoodsId -- CASE WHEN inIsPartionSumm THEN inPartionGoodsId ELSE 0 END
                                                 , inDescId_6   := CASE WHEN COALESCE (inGoodsKindId, 0) IN (0, zc_GoodsKind_Basis()) THEN NULL ELSE zc_ContainerLinkObject_GoodsKind() END
                                                 , inObjectId_6 := CASE WHEN COALESCE (inGoodsKindId, 0) IN (0, zc_GoodsKind_Basis()) THEN NULL ELSE inGoodsKindId END
                                                  );

     ELSE
     -- 1.2. - 20400 ��� + 70000 ����������: ����������� ���������� + ����������� ������ + ������������ ���������� + ����������� �������������
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20400()
                                   , zc_Enum_InfoMoneyDestination_70100(), zc_Enum_InfoMoneyDestination_70200(), zc_Enum_InfoMoneyDestination_70300(), zc_Enum_InfoMoneyDestination_70400()
                                    )
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���������� / ���.����(��) / ������������� 2)����� 3)�������� ��������(��� �������� ��������� ���) 4)������ ���������� 5)������ ����������(����������� �/�)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_5 := inAssetId
                                                  );

     ELSE
     -- 1.3. - 20103 �������� � ������� + ����
     IF inInfoMoneyId IN (zc_Enum_InfoMoney_20103())
         AND inPartionGoodsId > 0
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���������� / ���.����(��) / �������������  2)����� 3)�������� ��������(��� �������� ��������� ���) 4)������ ���������� 5)������ ����������(����������� �/�) 6)!������ ������!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_5 := inAssetId
                                                 , inDescId_6   := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_6 := inPartionGoodsId
                                                  );
     ELSE
     -- 1.4. - 20100 �������� � �������
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100())
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���������� / ���.����(��) / �������������  2)����� 3)�������� ��������(��� �������� ��������� ���) 4)������ ���������� 5)������ ����������(����������� �/�) 6)!������ ������!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_5 := inAssetId
                                                 , inDescId_6   := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                 , inObjectId_6 := CASE WHEN inMemberId <> 0 THEN inPartionGoodsId                      ELSE NULL END
                                                  );
     ELSE

     -- 1.5. - 20200 ������ ��� + 20300 ����
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300())
                           -- 0.1)���� 0.2.)������� �� ���� 0.3.)������ 1)���������� / ������������� 2)���. ���� (��) 3)����� 4)!������ ������! 5)������ ���������� 6)������ ����������(����������� �/�)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inCarId <> 0 THEN inCarId                      ELSE COALESCE (inUnitId, 0)        END
                                                 , inDescId_3   := zc_ContainerLinkObject_Member()
                                                 , inObjectId_3 := inMemberId
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_4 := inInfoMoneyId_Detail
                                                 , inDescId_5   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_5 := inInfoMoneyId
                                                 , inDescId_6   := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_6 := inPartionGoodsId
                                                  );
     ELSE
     -- 1.6. - 20700 ������ + 20900 ���� + 30100 ��������� + 30200 ������ �����
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200())
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)�������������  2)����� 3)!!!������ ������!!! 4)���� ������� 5)������ ���������� 6)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���. ���� (��) 2)����� 3)!!!������ ������!!! 4)���� ������� 5)������ ���������� 6)������ ����������(����������� �/�)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                                , inParentId          := inContainerId_Goods
                                                                , inObjectId          := inAccountId
                                                                , inJuridicalId_basis := inJuridicalId_basis
                                                                , inBusinessId        := inBusinessId
                                                                , inObjectCostDescId  := NULL
                                                                , inObjectCostId      := NULL
                                                                , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                                , inObjectId_1 := inGoodsId
                                                                , inDescId_2   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                , inObjectId_2 := inInfoMoneyId_Detail
                                                                , inDescId_3   := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                                , inObjectId_3 := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                                , inDescId_4   := zc_ContainerLinkObject_GoodsKind()
                                                                , inObjectId_4 := CASE WHEN COALESCE (inBranchId, 0) IN (0
                                                                                                                       , zc_Branch_Basis()
                                                                                                                       , 8374   -- !!!+ ������ ������!!!    select * from Object where ObjectCode=4 and DescId = zc_Object_Branch()
                                                                                                                       , 8376   -- !!!+ ������ ����!!!      select * from Object where ObjectCode=6 and DescId = zc_Object_Branch()
                                                                                                                       , 18342  -- !!!+ ������ ��������!!!  select * from Object where ObjectCode=10 and DescId = zc_Object_Branch()
                                                                                                                       , 301310 -- !!!+ ������ ���������!!! select * from Object where ObjectCode=11 and DescId = zc_Object_Branch()
                                                                                                                        )
                                                                                            THEN inGoodsKindId
                                                                                       WHEN inOperDate >= '01.11.2015' AND inBranchId IN (
                                                                                                                         8381 -- ������ �������
                                                                                                                       , 8377 -- ������ ��.���
                                                                                                                       , 8375 -- ������ �������� (����������)
                                                                                                                       , 8373 -- ������ �������� (������)
                                                                                                                       -- , 8379 -- ������ ����
                                                                                                                        )
                                                                                            THEN inGoodsKindId
                                                                                       WHEN inOperDate >= '01.01.2016' AND inBranchId IN (
                                                                                                                        8379 -- ������ ����
                                                                                                                        )
                                                                                           THEN inGoodsKindId
                                                                                       WHEN inOperDate >= '01.01.2017'
                                                                                            THEN inGoodsKindId
                                                                                       ELSE 0
                                                                                  END
                                                                , inDescId_5   := zc_ContainerLinkObject_InfoMoney()
                                                                , inObjectId_5 := inInfoMoneyId
                                                                , inDescId_6   := CASE WHEN inPartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                                , inObjectId_6 := CASE WHEN inPartionGoodsId <> 0 THEN inPartionGoodsId ELSE NULL END
                                                                 );
     ELSE
     -- 1.7. - 20500 ��������� ����
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
     -- 2.1. - !!!Other!!!
     ELSE                  -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)�������������  2)����� 3)������ ���������� 4)������ ����������(����������� �/�)
                           -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���. ���� (��) 2)����� 3)������ ���������� 4)������ ����������(����������� �/�)
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
                                                 , inObjectId_2 := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := CASE WHEN inMemberId <> 0 THEN 0 WHEN inPartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                 , inObjectId_5 := CASE WHEN inMemberId <> 0 THEN 0 WHEN inPartionGoodsId <> 0 THEN inPartionGoodsId ELSE NULL END
                                                  );
     END IF;
     END IF;
     END IF;
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

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.11.14                                        * add !!!+ ������ ���������!!
 05.09.14                                        * !!!del Old Algoritm!!! err - zc_ObjectCostLink_Member() and zc_ObjectCostLink_Unit()
 17.08.14                                        * add inPartionGoodsId always
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