-- Function: gpInsertUpdate_MovementItem_PersonalAccount ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalAccount (Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalAccount (Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalAccount(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inJuridicalId         Integer   , -- ��.����
    IN inAmount              TFloat    , -- �����
    IN inOperDate            TDateTime , -- ���� ������
    IN inContractId          Integer   , -- ��������
    IN inRouteId             Integer   , -- �������
    IN inCarId               Integer   , -- ����������
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalAccount());
     vbUserId := inSession;

     -- ��������
     IF COALESCE (inJuridicalId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� <��.����>.';
     END IF;
     -- ��������
     IF EXISTS (SELECT MovementItem.ObjectId
                FROM MovementItem 
                     JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.ObjectId = inJuridicalId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.Id <> COALESCE (ioId, 0)
               )
     THEN
         -- RAISE EXCEPTION '������ ��� ����������.��������� <%> <%> <%> ��� ���� � ���������.', inMovementId, inPersonalId, inInfoMoneyId;
         RAISE EXCEPTION '������ ��� ����������.��������� <%> ��� ���� � ���������.', (SELECT ValueData FROM Object where descid = zc_Object_Juridical() and Id = inJuridicalId);
     END IF;


     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inJuridicalId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���� ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), ioId, inOperDate);

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
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.12.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_PersonalAccount (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
