-- Function: lpInsertUpdate_MovementItem_LossDebt ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_LossDebt(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inJuridicalId         Integer   , -- ��.����
    IN inAmount              TFloat    , -- �����
    IN inSumm                TFloat    , -- ����� ������� (����)
    IN inIsCalculated        Boolean   , -- ����� �������������� �� ������� (��/���)
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inJuridicalId, 0) = 0 
     THEN
         RAISE EXCEPTION '������.�� ����������� <����������� ����>.';
     END IF;

     -- ��������
     IF EXISTS (SELECT MovementItem.Id
                FROM MovementItem
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.ObjectId = inJuridicalId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.Id <> COALESCE (ioId, 0))
     THEN
         RAISE EXCEPTION '������.� ��������� ��� ���������� <%> .������������ ���������.', lfGet_Object_ValueData (inJuridicalId) ;
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- ��������� �������� <����� �������������� �� ������� (��/���)>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), ioId, inIsCalculated);

     -- ��������� �������� <����� ������� (����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.01.15                       * 
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_LossDebt (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
