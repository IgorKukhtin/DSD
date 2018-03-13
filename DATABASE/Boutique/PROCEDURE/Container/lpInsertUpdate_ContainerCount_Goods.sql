-- Function: lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Goods (
    IN inOperDate                TDateTime,
    IN inUnitId                  Integer  ,
    IN inMemberId                Integer  ,
    IN inClientId                Integer  , -- ***���������� - �.�. ������ ���������� �� ����������, � ����� ������ ������� - �� ����
    IN inInfoMoneyDestinationId  Integer  ,
    IN inGoodsId                 Integer  ,
    IN inPartionId               Integer  , -- ������ � Object_PartionGoods.MovementItemId
    IN inPartionId_MI            Integer  , -- ***������ �������
    IN inGoodsSizeId             Integer  ,
    IN inAccountId               Integer    -- ��� ��������� ����� ��� "����� � ���� / ����������� �����"
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     IF inPartionId_MI > 0 OR inClientId > 0
     THEN
         -- �������� �� inClientId - ����������
                          -- 0)����� ��� �� 2)���������� 3)������������� 4)������ �������
         vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                , inParentId          := NULL
                                                , inObjectId          := inGoodsId
                                                , inPartionId         := inPartionId
                                                , inJuridicalId_basis := NULL
                                                , inBusinessId        := NULL
                                                , inDescId_1          := zc_ContainerLinkObject_GoodsSize()
                                                , inObjectId_1        := inGoodsSizeId
                                                , inDescId_2          := zc_ContainerLinkObject_Client()
                                                , inObjectId_2        := inClientId
                                                , inDescId_3          := zc_ContainerLinkObject_Unit()
                                                , inObjectId_3        := inUnitId
                                                , inDescId_4          := zc_ContainerLinkObject_PartionMI()
                                                , inObjectId_4        := inPartionId_MI
                                                 );
     ELSE
         -- �������� �� inUnitId

                          -- 0)����� ��� �� 1)�������������
                          -- 0)����� ��� �� 1)���. ���� (��)
         vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                , inParentId          := NULL
                                                , inObjectId          := inGoodsId
                                                , inPartionId         := inPartionId
                                                , inJuridicalId_basis := NULL
                                                , inBusinessId        := NULL
                                                , inDescId_1          := zc_ContainerLinkObject_GoodsSize()
                                                , inObjectId_1        := inGoodsSizeId
                                                , inDescId_2          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                , inObjectId_2        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
                                                 );
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
 05.06.17                                        * all
*/

-- ����
-- SELECT * FROM lpInsertUpdate_ContainerCount_Goods ()
