-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Cash (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Cash(
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
   DECLARE vbIsInsert_mi Boolean;
   DECLARE vbMovementItemId Integer;
BEGIN

     -- ��������
     IF inOperDate > CURRENT_DATE
     THEN
        RAISE EXCEPTION '������.���� ��������� = <%> �� ����� ���� ����� <%>.', zfConvert_DateToString (inOperDate), zfConvert_DateToString (CURRENT_DATE);
     END IF;

     -- ��������
     IF COALESCE (inAmount, 0) = 0
     THEN
        RAISE EXCEPTION '������.<�����> �� �������.';
     END IF;
     -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION '������.<������> �� �������.';
     END IF;

     -- ��������
     IF COALESCE (inUnitId, 0) = 0 AND EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = inInfoMoneyId AND OB.DescId = zc_ObjectBoolean_InfoMoney_Service() AND OB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION '������.<�����> �� ������.';
     END IF;


     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Cash(), inInvNumber, inOperDate, Null, inUserId);

     -- ���������� <������� ���������>
     --SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();


     -- ������������ ������� ��������/�������������
     vbIsInsert_mi:= COALESCE (inMI_Id, 0) = 0;

     -- ��������� <������� ���������>
     inMI_Id := lpInsertUpdate_MovementItem (inMI_Id, zc_MI_Master(), inCashId, ioId, inAmount, NULL);

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

      -- !!!�������� ����� ����� �������� ����������� �������!!!
     IF vbIsInsert_mi = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMI_Id, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inMI_Id, inUserId);
     ELSE
         IF vbIsInsert_mi = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), inMI_Id, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), inMI_Id, inUserId);
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
 19.01.22         *
 14.01.22         *
 */

-- ����
--