-- Function: gpInsertUpdate_MovementItem_PersonalAccount ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalAccount (Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalAccount(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inJuridicalId         Integer   , -- ��.����
    IN inAmount              TFloat    , -- �����
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inCarId               Integer   , -- ����������
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalAccount());

     -- ��������
     IF COALESCE (inJuridicalId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� <��.����>.';
     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Route(), ioId, inRouteId);

     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioId, inCarId);

     -- ��������� ����� � <������ ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.09.14                                        * add lpInsert_MovementItemProtocol
 14.01.14                                        *
 19.12.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalAccount (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
