-- Function: lpInsertUpdate_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ServiceItemAdd(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- ����� 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
    IN inDateStart           TDateTime , --
    IN inDateEnd             TDateTime , --
    IN inAmount              TFloat    , -- 
    IN inUserId              Integer    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inUnitId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inInfoMoneyId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;

     -- �������������� ���. ���� ������ 1 ����� ������, ��������  - ���������
     inDateStart := zfCalc_Month_start (inDateStart);
     inDateEnd   := zfCalc_Month_start (inDateEnd);
     
     -- �������� ��� ServiceItemAdd
     IF (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId) = zc_Movement_ServiceItemAdd()
     THEN   
         IF NOT EXISTS (SELECT 1 FROM gpSelect_MovementItem_ServiceItem_onDate (inOperDate   := inDateStart ::TDateTime
                                                                              , inUnitId     := inUnitId
                                                                              , inInfoMoneyId:= inInfoMoneyId
                                                                              , inSession    := inUserId  ::TVarChar
                                                                               ) AS tmpMI_Main 
                        WHERE tmpMI_Main.InfoMoneyId = inInfoMoneyId
                          AND tmpMI_Main.Amount >= 0
                       )
         THEN   
              RAISE EXCEPTION '������.�� ������� �������� ������� ������ ��� <%> <%>'
                            , lfGet_Object_TreeNameFull (inUnitId  ,zc_ObjectLink_Unit_Parent())
                            , lfGet_Object_ValueData (inInfoMoneyId); 
         END IF;
     END IF;
     
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUnitId, inMovementId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_DateStart(), ioId, inDateStart); 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_DateEnd(), ioId, inDateEnd);
     -- ����� ����
     --PERFORM lpInsertUpdate_Movement (inMovementId, zc_Movement_ServiceItem(), (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId), inDateEnd, NULL, inUserId);


     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), ioId, inCommentInfoMoneyId);


     -- !!!�������� ����� �������� ����������� �������!!!
     IF vbIsInsert = FALSE
     THEN
         -- ��������� �������� <���� �������������>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ (�������������)>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- ��������� �������� <���� ��������>
             PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- ��������� �������� <������������ (��������)>
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
*/

-- ����
--