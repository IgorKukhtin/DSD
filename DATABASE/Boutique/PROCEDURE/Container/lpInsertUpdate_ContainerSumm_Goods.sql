-- Function: lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerSumm_Goods (
    IN inOperDate                TDateTime, 
    IN inUnitId                  Integer  , 
    IN inMemberId                Integer  , 
    IN inJuridicalId_basis       Integer  , 
    IN inBusinessId              Integer  , 
    IN inAccountId               Integer  , 
    IN inInfoMoneyDestinationId  Integer  , 
    IN inInfoMoneyId             Integer  , 
    IN inContainerId_Goods       Integer  , 
    IN inGoodsId                 Integer  , 
    IN inGoodsSizeId             Integer  ,
    IN inPartionId               Integer    -- ������ � Object_PartionGoods.MovementItemId
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
                                                 , inDescId_2          := zc_ContainerLinkObject_GoodsSize()
                                                 , inObjectId_2        := inGoodsSizeId
                                                 , inDescId_3          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_3        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
                                                 , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4        := inInfoMoneyId
                                                  );


     -- ���������� ��������
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.06.17                                        * all
*/

-- ����
-- SELECT * FROM lpInsertUpdate_ContainerSumm_Goods ()
