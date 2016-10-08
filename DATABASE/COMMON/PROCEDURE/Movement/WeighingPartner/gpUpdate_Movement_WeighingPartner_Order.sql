-- Function: gpUpdate_Movement_WeighingPartner_Order()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartner_Order (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingPartner_Order(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inInvNumberOrder       TVarChar  , -- ����� ������ �����������
    IN inMovementId_Order     Integer   , -- ���� ��������� ������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inId, 0) = 0
     THEN
          RAISE EXCEPTION '������.�������� �� �������.';
     END IF;


     -- ��������� �������� <����� ������ � �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), inId, inInvNumberOrder);

     -- ��������� ����� � ���������� <������ ���������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), inId, inMovementId_Order);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 06.06.16         *

*/

-- SELECT * FROM gpUpdate_Movement_WeighingPartner_Order (ioId:= 0, inInvNumber:= '-1', inMovementId_Order:= 0, , inSession:= '2')
