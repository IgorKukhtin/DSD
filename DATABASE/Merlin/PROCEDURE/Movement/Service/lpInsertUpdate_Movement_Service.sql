-- Function: gpInsertUpdate_Movement_Service()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Service (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Service(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inServiceDate          TDateTime , -- ���� ����������
    IN inAmount               TFloat    , -- �����
    IN inUnitId               Integer   , -- �����
    IN inInfoMoneyId          Integer   , -- ������ 
    IN inCommentInfoMoneyId   Integer   , -- ����������
    IN inUserId               Integer     -- ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementItemId Integer;
BEGIN

     if COALESCE (ioId, 0) = 0 then RAISE EXCEPTION '������.insert. <%> <%> <%>', lfGet_Object_ValueData_sh (inUnitId), lfGet_Object_ValueData_sh (inInfoMoneyId), zfConvert_DateToString (inOperDate); END IF;
     if inOperDate <> (select OperDate from Movement where Id = ioId) then RAISE EXCEPTION '������.OperDate. <%> <%> <%>  old = <%>', lfGet_Object_ValueData_sh (inUnitId), lfGet_Object_ValueData_sh (inInfoMoneyId), zfConvert_DateToString (inOperDate), zfConvert_DateToString ((select OperDate from Movement where Id = ioId)); END IF;

    -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION '������.<������> �� �������.';
     END IF;

     -- ������ - 1-�� ����� ������
     -- inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- !!!������!!!
     inServiceDate:= DATE_TRUNC ('MONTH', inOperDate);
     

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Service(), inInvNumber, inOperDate, NULL, inUserId);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inUnitId, ioId, inAmount, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, inCommentInfoMoneyId);

     -- ��������� �������� <���� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemId, inServiceDate);

 
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
 14.01.22         *
 */

-- ����
--