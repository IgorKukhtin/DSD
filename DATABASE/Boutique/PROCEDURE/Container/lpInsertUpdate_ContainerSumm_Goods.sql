-- Function: lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerSumm_Goods (
    IN inOperDate                TDateTime, 
    IN inUnitId                  Integer  , 
    IN inMemberId                Integer  , 
    IN inJuridicalId_basis       Integer  , 
    IN inBusinessId              Integer  , 
    IN inAccountId               Integer  , 
    IN inInfoMoneyDestinationId  Integer  , 
    IN inInfoMoneyId             Integer  , 
    IN inInfoMoneyId_Detail      Integer  , 
    IN inContainerId_Goods       Integer  , 
    IN inGoodsId                 Integer  , 
    IN inPartionId               Integer  , -- ������ � Object_PartionGoods.MovementItemId
    IN inAssetId                 Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

          -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)�������������  2)����� 3)������ ���������� 4)������ ����������(����������� �/�)
          -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���. ���� (��) 2)����� 3)������ ���������� 4)������ ����������(����������� �/�)
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inPartionId         := inPartionId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inDescId_1          := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1        := inGoodsId
                                                 , inDescId_2          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
                                                 , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_3        := inInfoMoneyId
                                                 , inDescId_4          := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_4        := inInfoMoneyId_Detail
                                                  );


     -- ���������� ��������
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.06.17                                        * all
*/

-- ����
-- SELECT * FROM lpInsertUpdate_ContainerSumm_Goods ()
