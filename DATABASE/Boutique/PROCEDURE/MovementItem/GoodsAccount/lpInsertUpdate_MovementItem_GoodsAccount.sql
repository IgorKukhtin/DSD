-- Function: lpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer
                                                                , TFloat, TFloat, TFloat
                                                                , Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer
                                                                , TFloat, TFloat
                                                                , Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inPartionId             Integer   , -- ������
    IN inPartionMI_Id          Integer   , -- ������ �������� �������/�������
    IN inSaleMI_Id             Integer   , -- ������ ���. �������
    IN inAmount                TFloat    , -- ����������
    IN inSummChangePercent     TFloat    , -- 
 --   IN inTotalPay              TFloat    , -- 
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� - ��������� ��������� �������� ������
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= '���������');


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, CASE WHEN inPartionId > 0 THEN inPartionId ELSE NULL END, inMovementId, inAmount, NULL);
   
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, inSummChangePercent);
     -- ��������� �������� <>
     --PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, inTotalPay);
    
     IF COALESCE (inPartionMI_Id) = 0 
        THEN 
            inPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);
     END IF;
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionMI(), ioId, inPartionMI_Id);


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
 18.05.17         *
*/

-- ����
-- 