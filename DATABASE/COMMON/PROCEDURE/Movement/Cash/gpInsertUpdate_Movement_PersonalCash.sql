-- Function: gpInsertUpdate_Movement_PersonalCash()


DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalCash (integer, tvarchar, tdatetime, Integer, Integer, tfloat, TVarChar, integer, integer, integer, TDateTime, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalCash(
 INOUT ioMovementId          Integer   , -- 
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inCashId              Integer   , -- �����
    IN inPersonalId          Integer   , -- ���������
    IN inAmount              TFloat    , -- ����� �������� 
    IN inComment             TVarChar  , -- �����������
    IN inInfoMoneyId         Integer   , -- ������ ���������� 
    IN inUnitId              Integer   , -- ������������� 	
    IN inPositionId          Integer   , -- ���������
    IN inServiceDate         TDateTime , -- ���� ����������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemIdMaster Integer;
   DECLARE vbMovementItemIdChild Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());
     vbUserId := inSession;
     IF inInvNumber = '' THEN
        inInvNumber := (NEXTVAL ('Movement_Cash_seq'))::TVarChar;
     END IF;

     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- ��������� <��������>
     ioMovementId := lpInsertUpdate_Movement (ioMovementId, zc_Movement_Cash(), inInvNumber, inOperDate, NULL);

     -- ���������� <������� ������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemIdMaster FROM MovementItem WHERE MovementItem.MovementId = ioMovementId AND MovementItem.DescId = zc_MI_Master();
     -- ��������� <������� ���������>
     vbMovementItemIdMaster:= lpInsertUpdate_MovementItem (vbMovementItemIdMaster, zc_MI_Master(), inCashId, ioMovementId, inAmount, NULL);

     -- ���������� <����������� ������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemIdChild FROM MovementItem WHERE MovementItem.MovementId = ioMovementId AND MovementItem.DescId = zc_MI_Child();
     -- ��������� <������� ���������>
     vbMovementItemIdChild:= lpInsertUpdate_MovementItem (vbMovementItemIdChild, zc_MI_Child(), inPersonalId, ioMovementId, inAmount, NULL);


     -- �����������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemIdChild, inComment);

     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemIdChild, inInfoMoneyId);
     -- ��������� ����� � <��������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(),vbMovementItemIdChild, inUnitId);
     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), vbMovementItemIdChild, inPositionId);

     -- ��������� ����� � <���� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), vbMovementItemIdChild, inServiceDate);

     -- ��������� ��������
     --PERFORM lpInsert_MovementProtocol (ioMovementId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.09.14         *


*/

--select * from Object where descid = zc_Object_Position()

-- ����
--SELECT * FROM gpInsertUpdate_Movement_PersonalCash (ioMovementId:= 0, inInvNumber:= '', inOperDate:= '01.09.2014', inCashId := 14462, inPersonalId:= 8469, inAmount:= 99, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8386, inPositionId:= 12428, inPaidKindId:= 4, inServiceDate:= '01.01.2013', inSession:= '2')
