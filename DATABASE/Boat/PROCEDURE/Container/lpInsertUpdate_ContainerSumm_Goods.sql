-- Function: lpInsertUpdate_ContainerSumm_Goods

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean);

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
    IN inPartionId               Integer  ,              -- ������ � Object_PartionGoods.MovementItemId
    IN inMovementId_order        Integer  DEFAULT 0,     -- 
    IN inIsReserve               Boolean  DEFAULT FALSE  -- ������� ��� ��� ������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
   DECLARE vbPartionId   Integer;
BEGIN

     -- �������� �� inUnitId
     -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1+2)����� 3)�������������  4)������ ���������� 5)PartionMovement
     -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1+2)����� 3)���. ���� (��) 4)������ ���������� 5)PartionMovement
     vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                            , inParentId          := inContainerId_Goods
                                            , inObjectId          := inAccountId
                                            , inPartionId         := inPartionId
                                            , inIsReserve         := inIsReserve
                                            , inJuridicalId_basis := inJuridicalId_basis
                                            , inBusinessId        := inBusinessId
                                            , inDescId_1          := zc_ContainerLinkObject_Goods()
                                            , inObjectId_1        := inGoodsId
                                            , inDescId_2          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                            , inObjectId_2        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
                                            , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                            , inObjectId_3        := inInfoMoneyId
                                            , inDescId_4          := zc_ContainerLinkObject_PartionMovement()
                                            , inObjectId_4        := lpInsertFind_Object_PartionMovement (inMovementId_order)
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
