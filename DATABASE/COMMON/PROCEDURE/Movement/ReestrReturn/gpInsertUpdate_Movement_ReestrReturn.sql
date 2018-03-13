-- Function: gpInsertUpdate_Movement_ReestrReturn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReestrReturn (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReestrReturn(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrReturn());
   --  vbUserId:= lpGetUserBySession (inSession);                                              

     -- ������ � ���� ������ - ������ �� ������, �.�. �� ������ ���������� "������" ���
     IF ioId = 0 AND TRIM (inInvNumber) = ''
     THEN
         RETURN; -- !!!�����!!!
     END IF;

     -- ��������
     IF COALESCE (ioId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;

/*
     -- �������� - ����� ������ ?
     IF COALESCE (inMovementId_Transport, 0) = 0 AND (COALESCE (inCarId ,0) = 0 OR COALESCE (inPersonalDriverId, 0) = 0)
        -- AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         IF COALESCE (inMovementId_Transport, 0) = 0 AND COALESCE (inCarId ,0) = 0 AND COALESCE (inPersonalDriverId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�� ��������� �������� <������� ����>.';
         ELSEIF COALESCE (inCarId ,0) = 0
         THEN
             RAISE EXCEPTION '������.�� ��������� <� ����������>.';
         ELSEIF COALESCE (inPersonalDriverId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�� ���������� <���> ��������.';
         END IF;
     END IF;
*/

     -- �������� - ����� ������ ? - �� �������� �������� ���������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.InvNumber = inInvNumber AND Movement.OperDate = inOperDate AND  Movement.DescId = zc_Movement_ReestrReturn())
        -- AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         RAISE EXCEPTION '������.��� ���� ������ ���� ��������� <%> <%> <%>.', zfConvert_DateToString (inOperDate), inInvNumber, ioId;
     END IF;

     -- �������� - ����� ������ ? - �� �������� ������� ����
 /*    IF NOT EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = ioId AND MLM.DescId = zc_MovementLinkMovement_Transport() AND COALESCE (MLM.MovementChildId, 0) = COALESCE (inMovementId_Transport, 0))
       -- AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         RAISE EXCEPTION '������.��� ���� ������ <������� ����>.';
     END IF;*/

     -- ��������� <��������>,
     ioId:= lpInsertUpdate_Movement_ReestrReturn (ioId               := ioId
                                                , inInvNumber        := inInvNumber
                                                , inOperDate         := inOperDate
                                                , inUserId           := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 12.03.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReestrReturn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')
