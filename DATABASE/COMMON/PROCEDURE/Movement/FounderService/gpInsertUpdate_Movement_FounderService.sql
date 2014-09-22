-- Function: gpInsertUpdate_Movement_FounderService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_FounderService (integer, Tvarchar, TDateTime, Integer , Tfloat, Tvarchar, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_FounderService(
 INOUT ioId                       Integer   , -- ���� ������� <��������>
    IN inInvNumber                TVarChar  , -- ����� ���������
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inFounderId                Integer   , --
    IN inAmount                   TFloat    , -- ����� �������� 
    IN inComment                  TVarChar  , -- �����������
    IN inSession                  TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_FounderService());
     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_FounderService());

     -- ��������
     IF (COALESCE(inAmount, 0) = 0) THEN
        RAISE EXCEPTION '������� �����.';
     END IF;

     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_FounderService())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_FounderService(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inFounderId, ioId, inAmount, NULL);
    
     -- �����������
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

     -- 5.1. ������� - ��������
  
     -- 5.2. ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
  
     -- 5.3. �������� ��������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 03.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_FounderService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, ininComment:= 0, inSession:= '2')
