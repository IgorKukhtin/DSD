-- Function: lpInsertUpdate_MovementItem_SendAsset()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SendAsset(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inContainerId         Integer   , -- ������ �� 
    IN inStorageId           Integer   , -- ����� ��������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- ��������
     IF COALESCE (inContainerId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� �� <%> �� ����������� ������.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;

     -- ��������
     IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
    AND NOT EXISTS (SELECT 1
                    FROM Container
                         INNER JOIN ContainerLinkObject AS CLO_Unit
                                                        ON CLO_Unit.ContainerId = Container.Id
                                                       AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                       AND CLO_Unit.ObjectId > 0
                         LEFT JOIN Object ON Object.Id = Container.ObjectId
                         LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = Container.Id
                                                                     AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                         LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                    WHERE Container.Id = inContainerId
                      AND Container.DescId   IN (zc_Container_Count(), zc_Container_CountAsset())
                      AND COALESCE (Container.Amount, 0) <> 0
                      AND (Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR Object.DescId = zc_Object_Asset())
                   )
     THEN
         RAISE EXCEPTION '������.�������� �� �� ����� ���� ������ (<%>).', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;


      -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, null);

     -- ��������� �������� <������ ��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);

     -- ��������� ����� � <����� ��������> - ��� ������ ������� �� �� 
     IF COALESCE (inStorageId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.23         *
 16.03.20         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_SendAsset(ioId := 0 , inMovementId := 16151863 , inGoodsId := 4071624 , inAmount := 0 , inContainerId := 2682725 ,  inSession := '5');
