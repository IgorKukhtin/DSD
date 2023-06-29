-- Function: lpInsertUpdate_MovementItem_LossAsset()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_LossAsset(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inSumm                TFloat    , -- ����� ��-������
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
     IF 1=0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
     THEN
         RAISE EXCEPTION '������.�������� �� �� ����� ���� ������ <%> <%>.', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From()));
     END IF;
     -- ��������
     IF COALESCE (inContainerId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� �� <%> �� ����������� ������.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;

     -- �������� ����� �������� ��� ObjectId = �� ������
     IF COALESCE (inSumm,0) <> 0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Infomoney())
     THEN
         RAISE EXCEPTION '������.����� ����������� ��� �� ������.';
     END IF;
     
      -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, null);

     -- ��������� �������� <����� ��-������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

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
 18.06.20         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_LossAsset(ioId := 0 , inMovementId := 16151863 , inGoodsId := 4071624 , inAmount := 0 , inContainerId := 2682725 ,  inSession := '5');
