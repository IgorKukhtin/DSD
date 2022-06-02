-- Function: gpInsertUpdate_Movement_CashSend()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_CashSend (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_CashSend(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inCurrencyValue        TFloat    , -- ����
    IN inParValue             TFloat    , -- �������
    IN inAmountOut            TFloat    , -- ����� (������)
    IN inAmountIn             TFloat    , -- ����� (������)
    IN inCashId_from          Integer   , -- ����� 
    IN inCashId_to            Integer   , -- ����� 
    IN inCommentMoveMoneyId   Integer   , -- ����������
    IN inUserId               Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementItemId Integer;
BEGIN

     -- !������!
     IF inAmountIn = 0 THEN inAmountIn:= inAmountOut; END IF;

    -- ��������
     IF COALESCE (inCashId_from, 0) = 0
     THEN
        RAISE EXCEPTION '������.<����� ������> �� �������.';
     END IF;
    -- ��������
     IF COALESCE (inCashId_to, 0) = 0
     THEN
        RAISE EXCEPTION '������.<����� ������> �� �������.';
     END IF;
    -- ��������
     IF COALESCE (inAmountOut, 0) <= 0
     THEN
        RAISE EXCEPTION '������.<����� ������> �� �������.';
     END IF;
    -- ��������
     IF COALESCE (inAmountIn, 0) <= 0
     THEN
        RAISE EXCEPTION '������.<����� ������> �� �������.';
     END IF;
    -- ��������
     IF NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inCashId_from AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Cash_Currency())
     THEN
        RAISE EXCEPTION '������.<������ ����� ������> �� ������� = %.', lfGet_Object_ValueData_sh (inCashId_from);
     END IF;
    -- ��������
     IF NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inCashId_to AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Cash_Currency())
     THEN
        RAISE EXCEPTION '������.<������ ����� ������> �� ������� = %.', lfGet_Object_ValueData_sh (inCashId_to);
     END IF;
     -- ��������
     IF  (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inCashId_from AND OL.DescId = zc_ObjectLink_Cash_Currency())
       = (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inCashId_to   AND OL.DescId = zc_ObjectLink_Cash_Currency())
       AND COALESCE (inAmountOut, 0) <> COALESCE (inAmountIn, 0)
     THEN
        RAISE EXCEPTION '������.����� ������ = <%> � ����� ������ = <%> �� ����� ����������.', zfConvert_FloatToString (inAmountOut), zfConvert_FloatToString (inAmountIn);
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_CashSend(), inInvNumber, inOperDate, NULL, inUserId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), ioId, inCurrencyValue);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), ioId, inParValue);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������> - ����� (������)
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inCashId_from, ioId, inAmountOut, NULL);

     -- ��������� - ����� (������)
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Amount(), vbMovementItemId, inAmountIn);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Cash(), vbMovementItemId, inCashId_to);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentMoveMoney(), vbMovementItemId, inCommentMoveMoneyId);


 
      -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.01.22         *
 14.01.22         *
 */

-- ����
--