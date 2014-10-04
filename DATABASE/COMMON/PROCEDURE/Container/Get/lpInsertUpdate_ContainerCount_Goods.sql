-- Function: lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Goods (
    IN inOperDate               TDateTime, 
    IN inUnitId                 Integer , 
    IN inCarId                  Integer , 
    IN inMemberId               Integer , 
    IN inInfoMoneyDestinationId Integer , 
    IN inGoodsId                Integer , 
    IN inGoodsKindId            Integer , 
    IN inIsPartionCount         Boolean , 
    IN inPartionGoodsId         Integer , 
    IN inAssetId                Integer , 
    IN inBranchId               Integer   -- ��� ��������� ����� ��� �������
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     -- 10100 ������ �����
     IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
          -- 0)����� 1)������������� 2)!������ ������!
          -- 0)����� 1)��������� (��) 2)!������ ������!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_1        := inPartionGoodsId -- CASE WHEN inIsPartionCount THEN inPartionGoodsId ELSE 0 END
                                                 , inDescId_2          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId ELSE COALESCE (inUnitId, 0) END
                                                  );
     ELSE
     -- 20100 �������� � ������� + 20400 ���
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20400())
          -- 0)����� 1)������������� 2)�������� ��������(��� �������� ��������� ���)
          -- 0)����� 1)��������� (��) 2)�������� ��������(��� �������� ��������� ���)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId ELSE COALESCE (inUnitId, 0) END
                                                 , inDescId_2          := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_2        := inAssetId
                                                  );
     ELSE
     -- 20200 ������ ��� + 20300 ����
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300())
          -- 0)����� 1)������������� 2)��������� (��) 3)!������ ������!
          -- 0)����� 1)���������� 2)��������� (��) 3)!������ ������!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId ELSE inUnitId END
                                                 , inDescId_2          := zc_ContainerLinkObject_Member()
                                                 , inObjectId_2        := inMemberId
                                                 , inDescId_3          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_3        := inPartionGoodsId
                                                  );
     ELSE
     -- 20700 ������ + 20900 ���� + 30100 ��������� + 30200 ������ �����
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200())
          -- 0)����� 1)������������� 2)��� ������ 3)!!!������ ������!!!
          -- 0)����� 1)��������� (��) 2)��� ������ 3)!!!������ ������!!!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId ELSE COALESCE (inUnitId, 0) END
                                                 , inDescId_2          := zc_ContainerLinkObject_GoodsKind()
                                                 , inObjectId_2        := CASE WHEN COALESCE (inBranchId, 0) IN (0, zc_Branch_Basis()) THEN inGoodsKindId ELSE 0 END
                                                 , inDescId_3          := CASE WHEN inPartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                 , inObjectId_3        := CASE WHEN inPartionGoodsId <> 0 THEN inPartionGoodsId ELSE NULL END
                                                  );
     -- !!!Other!!!
          -- 0)����� 1)�������������
          -- 0)����� 1)��������� (��)
     ELSE vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId ELSE COALESCE (inUnitId, 0) END
                                                   );
     END IF;
     END IF;
     END IF;
     END IF;

     -- ���������� ��������
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.08.14                                        * add inPartionGoodsId always
 27.07.14                                        * add ����
 18.03.14                                        * add zc_Enum_InfoMoneyDestination_30200
 21.12.13                                        * Personal -> Member
 11.10.13                                        * add zc_Enum_InfoMoneyDestination_20400
 30.09.13                                        * add inCarId
 19.09.13                                        * sort by optimize
 17.09.13                                        * CASE -> IF
 16.09.13                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_ContainerCount_Goods ()