-- Function: gpInsertUpdate_MovementItem_SendDebt ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendDebt (Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendDebt(
-- INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
 INOUT ioMasterId            Integer   , -- ���� ������� <������� ���������>
 INOUT ioChildId             Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inAmount              TFloat    , -- �����  
    
    IN inJuridicalFromId     Integer   , -- ��.����
    IN inContractFromId      Integer   , -- �������
    IN inPaidKindFromId      Integer   , -- ��� ���� ������
    IN inInfoMoneyFromId     Integer   , -- ������ ����������

    IN inJuridicalToId       Integer   , -- ��.����
    IN inContractToId        Integer   , -- �������
    IN inPaidKindToId        Integer   , -- ��� ���� ������
    IN inInfoMoneyToId       Integer   , -- ������ ����������

    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendDebt());
     vbUserId:= inSession;

     -- ��������
     IF (COALESCE (inJuridicalFromId, 0) = 0) OR (COALESCE (inJuridicalToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <��.����>.';
     END IF;

     -- ��������� <������� ������� ���������>
     ioMasterId := lpInsertUpdate_MovementItem (ioMasterId, zc_MI_Master(), inJuridicalFromId, inMovementId, inAmount, NULL);

     -- ��������� <������ ������� ���������>
     ioChildId := lpInsertUpdate_MovementItem (ioChildId, zc_MI_Child(), inJuridicalToId, ioMasterId, inAmount, NULL);

     -- ��������� ����� � <������� �� >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioMasterId, inContractFromId);

     -- ��������� ����� � <��� ���� ������ ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioMasterId, inPaidKindFromId);

     -- ��������� ����� � <������ ���������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMasterId, inInfoMoneyFromId);


     -- ��������� ����� � <������� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioChildId, inContractToId);

     -- ��������� ����� � <��� ���� ������ ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioChildId, inPaidKindToId);

     -- ��������� ����� � <������ ���������� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioChildId, inInfoMoneyToId);



     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioMasterId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 24.01.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SendDebt (ioMasterId:= 0, inMovementId:= 10, inAmount:= 0, , inSession:= '2')
