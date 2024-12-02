-- Function: gpInsertUpdate_Movement_CurrencyList()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CurrencyList (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_CurrencyList (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_CurrencyList(
 INOUT ioId                       Integer   , -- ���� ������� <�������� �������� �������>
    IN inInvNumber                TVarChar  , -- ����� ���������
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inAmount                   TFloat    , -- ����
    IN inParValue                 TFloat    , -- ������� ������ ��� ������� �������� ����
    IN inComment                  TVarChar  , -- ����������� 
    IN inSiteTagId                Integer   , -- ��������� �����
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CurrencyList());

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
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_CurrencyList())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_CurrencyList(), inInvNumber, inOperDate, NULL, NULL);

     -- ��������� ����� � <��������� �����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SiteTag(), ioId, inSiteTagId);

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
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_CurrencyList())
     THEN
          PERFORM lpComplete_Movement_CurrencyList (inMovementId := ioId
                                                  , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.12.24         *
 21.02.23         *
*/

-- ����
--