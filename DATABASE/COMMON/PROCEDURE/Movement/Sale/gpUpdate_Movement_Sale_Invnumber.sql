-- Function: gpUpdate_Movement_Sale_Invnumber()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Invnumber (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Invnumber(
    IN inId                    Integer    , -- ���� ������� <��������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Tax Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_Invnumber());

     -- ��������� <>
     UPDATE Movement SET InvNumber = inInvNumber WHERE Id = inId;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.12.20         *
*/
-- ����
--