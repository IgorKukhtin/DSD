-- Function: gpInsertUpdate_Movement_PersonalCash()


DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalCash (integer, tvarchar, tdatetime, Integer, Integer, tfloat, TVarChar, integer, integer, integer, TDateTime, tvarchar);

DROP FUNCTION IF EXISTS 
   gpInsertUpdate_Movement_PersonalCash (integer, tvarchar, tdatetime, Integer, TVarChar, TDateTime, tvarchar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalCash(
 INOUT ioMovementId          Integer   , -- 
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inParentId            Integer   , -- �������� ����=������� ��
    IN inCashId              Integer   , -- �����
    IN inComment             TVarChar  , -- �����������
    IN inServiceDate         TDateTime , -- ���� ����������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMIMasterId Integer;
   
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
     ioMovementId := lpInsertUpdate_Movement (ioMovementId, zc_Movement_Cash(), inInvNumber, inOperDate, inParentId);

     -- ���������� <������� ������� ���������>
     SELECT MovementItem.Id INTO vbMIMasterId FROM MovementItem WHERE MovementItem.MovementId = ioMovementId AND MovementItem.DescId = zc_MI_Master();
     -- ��������� <������� ���������>
     vbMIMasterId:= lpInsertUpdate_MovementItem (vbMIMasterId, zc_MI_Master(), inCashId, ioMovementId, 0, NULL);

     -- ���������� <����������� ������� ���������>
     --SELECT MovementItem.Id INTO vbMovementItemIdChild FROM MovementItem WHERE MovementItem.MovementId = ioMovementId AND MovementItem.DescId = zc_MI_Child();
     -- ��������� <������� ���������>
     --vbMovementItemIdChild:= lpInsertUpdate_MovementItem (vbMovementItemIdChild, zc_MI_Child(), inPersonalId, ioMovementId, inAmount, NULL);


     -- �����������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMIMasterId, inComment);

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
 16.09.14         *


*/

--select * from Object where descid = zc_Object_Position()

-- ����
--SELECT * FROM gpInsertUpdate_Movement_PersonalCash (ioMovementId:= 0, inInvNumber:= '', inOperDate:= '01.09.2014', inCashId := 14462, inPersonalId:= 8469, inAmount:= 99, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8386, inPositionId:= 12428, inPaidKindId:= 4, inServiceDate:= '01.01.2013', inSession:= '2')
