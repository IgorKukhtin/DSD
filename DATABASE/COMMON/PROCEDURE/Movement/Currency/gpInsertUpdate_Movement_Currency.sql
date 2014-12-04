-- Function: gpInsertUpdate_Movement_Currency()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Currency (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Currency(
 INOUT ioId                       Integer   , -- ���� ������� <�������� �������� �������>
    IN inInvNumber                TVarChar  , -- ����� ���������
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inAmount                   TFloat    , -- ����
    IN inParValue                 TFloat    , -- ������� ������ ��� ������� �������� ����
    IN inComment                  TVarChar  , -- �����������
    IN inCurrencyFromId           Integer   , -- ������ � ������� �������� ���c
    IN inCurrencyToId             Integer   , -- ������ ��� ������� �������� ����
    IN inPaidKindId               Integer   , -- ���� ���� ������ 
    IN inSession                  TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Currency());

     -- ��������
     IF COALESCE (inPaidKindId, 0) = 0
     THEN
        RAISE EXCEPTION '������.�� ����������� <����� ������>.';
     END IF;
     -- ��������
     IF COALESCE (inCurrencyFromId, 0) = 0
     THEN
        RAISE EXCEPTION '������.�� ����������� <������ (��������)>.';
     END IF;
     -- ��������
     IF COALESCE (inCurrencyToId, 0) = 0
     THEN
        RAISE EXCEPTION '������.�� ����������� <������ (���������)>.';
     END IF;

     -- ��������
     IF inCurrencyFromId <> zc_Enum_Currency_Basis()
     THEN
        RAISE EXCEPTION '������.<������ (��������)> ������ ��������������� <%>.', lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;


     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_Currency())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Currency(), inInvNumber, inOperDate, NULL, NULL);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inCurrencyFromId, ioId, inAmount, NULL);
    
     -- ������� ������ ��� ������� �������� ����
     IF COALESCE (inParValue, 0) = 0 THEN inParValue := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), vbMovementItemId, inParValue);

     -- �����������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency(), vbMovementItemId, inCurrencyToId);

     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), vbMovementItemId, inPaidKindId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);


     -- 5.2. ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Currency())
     THEN
          PERFORM lpComplete_Movement_Currency (inMovementId := ioId
                                              , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.11.14                                        * add inParValue
 28.07.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Currency (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inCurrencyFromId:= 1, inCurrencyFromBasisId:= 1, inBusinessId:= 2, inPaidKindId:= 1,  inInfoMoneyId:= 0, inCurrencyFromId:= 0, inSession:= '2')
