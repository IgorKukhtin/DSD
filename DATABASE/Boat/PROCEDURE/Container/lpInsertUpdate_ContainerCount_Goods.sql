-- Function: lpInsertUpdate_ContainerCount_Goods

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Goods (
    IN inOperDate                TDateTime,
    IN inUnitId                  Integer  ,
    IN inMemberId                Integer  ,
    IN inInfoMoneyDestinationId  Integer  ,
    IN inGoodsId                 Integer  ,
    IN inPartionId               Integer  ,              -- ������ � Object_PartionGoods.MovementItemId
    IN inMovementId_order        Integer  DEFAULT 0,     -- 
    IN inIsReserve               Boolean  DEFAULT FALSE, -- ������� ��� ��� ������
    IN inAccountId               Integer  DEFAULT 0      -- ��� ��������� ����� ��� "����� � ���� / ����������� �����"
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     -- �������� �� inUnitId

                      -- 0)����� ��� �� 1)�������������  3)PartionMovement
                      -- 0)����� ��� �� 1)���. ���� (��) 3)PartionMovement
     vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                            , inParentId          := NULL
                                            , inObjectId          := inGoodsId
                                            , inPartionId         := inPartionId
                                            , inIsReserve         := inIsReserve
                                            , inJuridicalId_basis := NULL
                                            , inBusinessId        := NULL
                                            , inDescId_1          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                            , inObjectId_1        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
                                            , inDescId_2          := zc_ContainerLinkObject_PartionMovement()
                                            , inObjectId_2        := lpInsertFind_Object_PartionMovement (inMovementId_order)
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
-- SELECT * FROM lpInsertUpdate_ContainerCount_Goods ()
