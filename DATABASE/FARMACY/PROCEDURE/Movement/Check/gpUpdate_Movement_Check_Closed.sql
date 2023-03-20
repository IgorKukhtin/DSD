-- Function: gpUpdate_Movement_Check_Closed()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Closed (Integer, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Closed(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inisClosed          Boolean   , -- �������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

    -- ���������  <�������>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Closed(), inId, not inisClosed);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.03.23                                                       *
*/
-- ����
-- select * from gpUpdate_Movement_Check_Closed(inId := 7784533 , inisClosed := False ,  inSession := '3');