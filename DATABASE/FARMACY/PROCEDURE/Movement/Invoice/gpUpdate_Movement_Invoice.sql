-- Function: gpUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Invoice (Integer, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Invoice(
    IN inId                    Integer,    -- ���� ������
    IN inDateRegistered        TDateTime,  -- ���� ��������
    IN inInvNumberRegistered   TVarChar ,  -- ����� ��������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Invoice());
    vbUserId := inSession;

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), inId, inDateRegistered);    

    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberRegistered(), inId, inInvNumberRegistered);
  
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 22.03.17         *
*/