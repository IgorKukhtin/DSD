-- Function: gpInsertUpdate_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpselect_movement_personalservice(tdatetime,tdatetime,tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalService (Integer, TVarChar, TVarChar, TDateTime, Integer, TFloat, TVarChar, Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalService(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
 INOUT ioMovementId          TVarChar  , -- ����� ���������
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPersonalId          Integer   , -- ���������
    IN inAmount              TFloat    , -- ����� �������� 
    IN inComment             TVarChar  , -- �����������
    IN inInfoMoneyId         Integer   , -- ������ ���������� 
    IN inUnitId              Integer   , -- ������������� 	
    IN inPositionId          Integer   , -- ���������
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inServiceDate         TDateTime , -- ���� ����������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalService());
     vbUserId := inSession;

     -- ��������� <��������>
     ioMovementId := lpInsertUpdate_Movement (ioMovementId, zc_Movement_PersonalService(), inInvNumber, inOperDate, NULL);

          -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, ioMovementId, inAmount, NULL);

     -- �����������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <��������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- ��������� ����� � <���� ���� ������ >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioId, inPaidKindId);
     -- ��������� ����� � <���� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MovementItemDate_ServiceDate(), ioId, inServiceDate);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.14                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_PersonalService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
