-- Function: gpInsertUpdate_MovementItem_LossDebt ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossDebt (Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer, Integer, Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LossDebt(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inJuridicalId         Integer   , -- ��.����
 INOUT ioAmountDebet         TFloat    , -- �����
 INOUT ioAmountKredit        TFloat    , -- �����
 INOUT ioSummDebet           TFloat    , -- ����� ������� (����)
 INOUT ioSummKredit          TFloat    , -- ����� ������� (����)
 INOUT ioIsCalculated        Boolean   , -- ����� �������������� �� ������� (��/���)
    IN inContractId          Integer   , -- �������
    IN inPaidKindId          Integer   , -- ��� ���� ������
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inUnitId              Integer   , -- �������������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbSumm TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossDebt());
     vbUserId:= inSession;

     -- ��������
     IF COALESCE (inJuridicalId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� <��.����>.';
     END IF;

     -- ��������
     IF (COALESCE (ioAmountDebet, 0) <> 0) AND (COALESCE (ioAmountKredit, 0) <> 0) THEN
        RAISE EXCEPTION '������ ���� ������� ������ ���� ����� - ��� ����� ��� ������.';
     END IF;

     -- ��������
     IF (COALESCE (ioSummDebet, 0) <> 0) AND (COALESCE (ioSummKredit, 0) <> 0) THEN
        RAISE EXCEPTION '������ ���� ������� ������ ���� ����� - ��� ���� ����� ���� ������.';
     END IF;

     -- ������
     IF ioAmountDebet <> 0 THEN
        vbAmount := ioAmountDebet;
     ELSE
        vbAmount := -1 * ioAmountKredit;
     END IF;
     -- ������
     IF ioSummDebet <> 0 THEN
        vbSumm := ioSummDebet;
     ELSE
        vbSumm := -1 * ioSummKredit;
     END IF;

     -- ������
     ioIsCalculated:= (vbSumm <> 0 OR vbAmount = 0)
     -- 
     IF vbSumm <> 0 THEN ioAmountDebet: = 0; ioAmountKredit: = 0; END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, vbAmount, NULL);

     -- ��������� �������� <����� �������������� �� ������� (��/���)>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_MasterFuel(), ioId, inIsMasterFuel);

     -- ��������� �������� <����� ������� (����)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, vbSumm);

     -- ��������� �������� < ����� �������������� �� ������� (��/���)>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_MasterFuel(), ioId, inIsMasterFuel);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     -- ��������� ����� � <��� ���� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioId, inPaidKindId);

     -- ��������� ����� � <������ ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- ��������� ����� � <�������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 14.01.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_LossDebt (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
