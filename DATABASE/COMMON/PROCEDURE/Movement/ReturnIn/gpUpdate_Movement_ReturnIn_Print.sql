-- Function: gpUpdate_Movement_ReturnIn_Print()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_Print(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
    IN inNewPrinted          Boolean   , --
   OUT outPrinted            Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� �������
     outPrinted := inNewPrinted;

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Print(), inId, inNewPrinted);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.05.18          *
*/

-- ����
--  