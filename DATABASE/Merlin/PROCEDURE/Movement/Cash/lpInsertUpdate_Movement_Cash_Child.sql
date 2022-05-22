-- Function: gpInsertUpdate_Movement_Cash_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash_Child (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash_Child(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inMI_Id                Integer   , -- ������������� ������
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inServiceDate          TDateTime , -- ���� ����������
    IN inAmount               TFloat    , -- �����
    IN inCashId               Integer   , -- ����� 
    IN inUnitId               Integer   , -- �����
    IN inInfoMoneyId          Integer   , -- ������
    IN inInfoMoneyDetailId    Integer   , -- ������
    IN inCommentInfoMoneyId   Integer   , -- ����������
    IN inUserId               Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementItemId Integer;
BEGIN

     -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION '������.<������> �� �������.';
     END IF;

     -- ��������
     IF COALESCE (ioId, 0) = 0
     THEN
        RAISE EXCEPTION '������.MovementId = 0.';
     END IF;

     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- ��������� <��������>
     -- ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Cash(), inInvNumber, inOperDate, Null, inUserId);

     -- ���������� <������� ���������>
     --SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Child();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (inMI_Id, 0) = 0;

     -- ��������� <������� ���������>
     inMI_Id := lpInsertUpdate_MovementItem (inMI_Id, zc_MI_Child(), inCashId, ioId, inAmount, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), inMI_Id, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), inMI_Id, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoneyDetail(), inMI_Id, inInfoMoneyDetailId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), inMI_Id, inCommentInfoMoneyId);

     -- ��������� �������� <���� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), inMI_Id, inServiceDate);

 
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
     PERFORM lpInsert_MovementItemProtocol (inMI_Id, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.01.22         *
 */

-- ����
--