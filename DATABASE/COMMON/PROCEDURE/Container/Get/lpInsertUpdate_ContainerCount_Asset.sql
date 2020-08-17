-- Function: lpInsertUpdate_ContainerCount_Asset (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Asset (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Asset (
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
    IN inBranchId               Integer , -- ��� ��������� ����� ��� �������
    IN inAccountId              Integer   -- ��� ��������� ����� ��� "����� � ���� / ����������� �����"
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     -- 70000 ����������: ����������� ���������� + ����������� ������ + ������������ ���������� + ����������� �������������
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_70100(), zc_Enum_InfoMoneyDestination_70200(), zc_Enum_InfoMoneyDestination_70300(), zc_Enum_InfoMoneyDestination_70400()
                                    )
    AND inPartionGoodsId <> 0
     THEN
         -- !!!��������!!!
         inAccountId:= 0;

                           -- 0)����� ��� �� 1)�������������  2)������ ������ 3)�������� �������� (��� �������� ��������� �� ��� ���)
                           -- 0)����� ��� �� 1)���. ���� (��) 2)������ ������ 3)�������� �������� (��� �������� ��������� �� ��� ���)
                           -- 0)����� ��� �� 1)����������     2)������ ������ 3)�������� �������� (��� �������� ��������� �� ��� ���)
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_CountAsset()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_2          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_2        := inPartionGoodsId
                                                 , inDescId_3          := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_3        := inAssetId
                                                  );

     ELSE
         RAISE EXCEPTION '������.������������ ���� �� ������������ ��� <%>', lfGet_Object_ValueData (inInfoMoneyDestinationId);
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
 05.08.20                                        *

*/

-- ����
-- SELECT * FROM lpInsertUpdate_ContainerCount_Asset ()
