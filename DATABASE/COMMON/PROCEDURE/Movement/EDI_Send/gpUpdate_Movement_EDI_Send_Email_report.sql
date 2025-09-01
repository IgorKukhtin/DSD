-- Function: gpUpdate_Movement_EDI_Send_Email_report()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_Send_Email_report (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_Send_Email_report(
    IN inMovementId            Integer    , -- ���� ������� <�������� ��� �������� � EDI>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Send_Email_report());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �������� <����/����� ����� ��������� ������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, CURRENT_TIMESTAMP);


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 01.08.25                                        *

*/
-- ����
-- SELECT * FROM gpUpdate_Movement_EDI_Send_Email_report (inId:= 0, inSession:= '2')
