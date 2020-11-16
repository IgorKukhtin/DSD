-- Function: gpUpdateMI_OrderInternal_AmountPack()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPack (Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPack (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountPack(
    IN inId                      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inAmountPack              TFloat    , -- ����������
    IN inAmountPackSecond        TFloat    , -- ���������� �������
    IN inAmountPackNext          TFloat    , -- ����������
    IN inAmountPackNextSecond    TFloat    , -- ���������� �������
   OUT outIsCalculated           Boolean   , -- 
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

     -- ��������
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� �� ������.';
     END IF;

     -- ��������� �������� <�������� ���� ��� ���������>
     IF  inAmountPackNext       <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPackNext()), 0)
      OR inAmountPackNextSecond <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inId AND MIF.DescId = zc_MIFloat_AmountPackNextSecond()), 0)
     THEN
         outIsCalculated:= FALSE;
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), inId, FALSE);
     ELSE
         outIsCalculated:= COALESCE ((SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = inId AND MIB.DescId = zc_MIBoolean_Calculated()), TRUE);
     END IF;


     -- ��������� �������� <���������� ����� �� ����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack(), inId, inAmountPack);
     -- ��������� �������� <���������� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond(), inId, inAmountPackSecond);
     
     -- ��������� �������� <���������� ����� �� ���� ����2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNext(), inId, inAmountPackNext);
     -- ��������� �������� <���������� ������� ����2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond(), inId, inAmountPackNextSecond);
     
    
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� �������� !!!����� ���������!!!
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.11.17         *
 16.11.17         *
*/

-- ����
-- 