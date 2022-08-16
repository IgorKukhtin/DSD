-- Function: gpInsertUpdate_Movement_ServiceItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ServiceItem (Integer, TVarChar, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ServiceItem (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ServiceItem(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inUnitId               Integer   , -- �����
    IN inInfoMoneyId          Integer   , --
    IN inCommentInfoMoneyId   Integer   , --
    IN inAmount               TFloat    , --
    IN inPrice                TFloat    , --
    IN inArea                 TFloat    , --
    IN inUserId               Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- if COALESCE (ioId, 0) = 0 then RAISE EXCEPTION '������.insert. <%> <%> <%>', lfGet_Object_ValueData_sh (inUnitId), lfGet_Object_ValueData_sh (inInfoMoneyId), zfConvert_DateToString (inOperDate); END IF;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inUnitId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inInfoMoneyId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ServiceItem(), inInvNumber, inOperDate, NULL, inUserId);

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


     -- ���������� <������� ���������>
     vbMovementItemId:= (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master());

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inUnitId, ioId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, inPrice);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Area(), vbMovementItemId, inArea);


     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), vbMovementItemId, inCommentInfoMoneyId);


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
 31.07.22         *
 31.05.22         *
 */

-- ����
--